module ApplicationHelper

  #-------------------------------------------------
  # register file as page specific scripts
  #-------------------------------------------------
  def javascript(*files)
    content_for(:page_script) { javascript_include_tag(*files) }
  end

  #-------------------------------------------------
  # register file as page specific stylesheet
  #-------------------------------------------------
  def stylesheet(*files)
    content_for(:page_stylesheet) { stylesheet_link_tag(*files) }
  end

  #-------------------------------------------------
  # sets page title
  #-------------------------------------------------
  def title(page_title)
    content_for :title, page_title.to_s
  end

  #-------------------------------------------------
  # Is google analytics enabled?
  #-------------------------------------------------
  def google_analytics_enabled?
    # disable for now
    false
  end

  #-------------------------------------------------
  # Is Pingdom RUM enabled?
  #-------------------------------------------------
  def pingdom_rum_enabled?
    # disabled since our pingdom account hits limits after 1 day of monitoring
    # currently jan-2019, our daily pageviews is 70K, and account limit is 100K pageviews.
    # But we leave this code so we can enable again when needed to troubleshoot
    # Rails.env.production?
    false
  end

  #-------------------------------------------------
  # Is JIRA service desk enabled?
  #-------------------------------------------------
  def jira_service_desk_enabled?
    # Just show on "landing" pages, instead all pages, to avoid interfering with contents
    # Rails.env.production? && (request.path == '/dashboard' || request.path.starts_with?('/welcome'))

    # DISABLED FOR NOW, JIRA WIDGET HAS BUGS
    #   calling POST <turboly-host>/gateway/api/gasv3/api/v1/batch
    #   instead of POST <atlassian-host>/gateway/api/gasv3/api/v1/batch
    false
  end

  #-------------------------------------------------
  # Check if user has just logged in
  # (example: when we only need to display something once)
  #-------------------------------------------------
  def just_after_login?(user)
    (user.current_sign_in_at || Time.zone.now) > (Time.zone.now - 10.seconds)
  end

  #-------------------------------------------------
  # Create request uuid for resource updates
  #-------------------------------------------------
  def request_uuid_for_update(resource)
    ParamsService.request_uuid_for_update(resource)
  end

  #-------------------------------------------------
  # Current User theme (cached)
  #-------------------------------------------------
  def current_user_theme

    # First check cached value from session
    if session[:theme].nil?

      if current_user.company.nil?
        session[:theme] = 'theme1'
      else
        session[:theme] = current_user.company.theme
      end

    end
    session[:theme]

  end

  #-------------------------------------------------
  # Return 'active' when path matches current page
  # (for navigation styling)
  #-------------------------------------------------
  def klass_active(arg, arg_except = nil)

    klass = ''
    return klass if arg.nil?

    if arg.kind_of? Array

      # Array of paths
      for path in arg

        if request.path.try(:starts_with?, path)
          klass = 'active'
          break
        end

      end

    elsif arg.kind_of? String

      # Single path
      if request.path.try(:starts_with?, arg)
        klass = 'active'
      end

    else
      # Assume arg is model instance

      if request.path.try(:starts_with?, Rails.application.routes.url_helpers.send("#{arg.class.table_name}_path"))
        klass = 'active'
      end
    end

    match_except_path = false
    if klass == 'active'
      if arg_except.kind_of? Array

        # Array of paths
        for path in arg_except

          if request.path.try(:starts_with?, path)
            match_except_path = true
            break
          end

        end

      elsif arg_except.kind_of? String

        # Single path
        if request.path.try(:starts_with?, arg_except)
          match_except_path = true
        end
      end

      if match_except_path
        klass = ''
      end
    end

    return klass
  end

  #-------------------------------------------------
  # Return 'active' when path matches current page
  # (for navigation styling)
  #-------------------------------------------------
  def klass_active_full_match(arg)

    return '' if arg.nil?

    if arg.kind_of? Array

      # Array of paths
      for path in arg
        #if current_page?(path)
        if current_page?(path)
          return 'active'
        end

      end

    elsif arg.kind_of? String

      # Single path
      #if current_page?(arg)
      if current_page?(arg)
        return 'active'
      end

    else
      # Assume arg is model instance
      if current_page?(Rails.application.routes.url_helpers.send("#{arg.class.table_name}_path"))
        return 'active'
      end
    end
    return ''
  end

  #-------------------------------------------------
  # Combine all arguments into single array
  #-------------------------------------------------
  def as_array(*args)
    result = []
    for arg in args
      if arg.kind_of? Array
        result.concat arg
      else
        result.push arg
      end
    end
    result.reject {|item| item.nil? }
  end

  # for example
  #
  #   objects = [store1]
  #
  #   join_names(objects)
  #   => store1.name
  #
  #   join_names(objects, 1)
  #   => store1.name
  #
  #   join_names(objects, 1, 'multiple stores')
  #   => store1.name
  #
  #
  #   objects = [store1, store2, store3]
  #
  #   join_names(objects)
  #   => store1.name, store2.name, store3.name
  #
  #   join_names(objects, 1)
  #   => store1.name,...
  #
  #   join_names(objects, 1, 'multiple stores')
  #   => 'multiple stores'
  #
  def join_names(objects, max_objects_to_show = nil, overlimit_label = nil)
    return '' if objects.nil?
    if max_objects_to_show.to_i > 0 && objects.length > max_objects_to_show.to_i
      if overlimit_label.nil?
        objects.map{ |t| t.name}[0..show_max-1].join(', ') + '...'
      else
        overlimit_label
      end
    else
      objects.map{ |t| t.name}.join(', ')
    end
  end

  def join_full_names(objects)
    return '' if objects.nil?
    objects.map{ |t| t.full_name}.join(', ')
  end

  def format_as_currency(amount, currency_code = nil, with_symbol = true, options = {})
    UtilService.format_as_currency(current_user, amount, currency_code, with_symbol, options)
  end

  def format_as_currency_cent(amount, currency_code = nil, with_symbol = true)
    UtilService.format_as_currency_cent(current_user, amount, currency_code, with_symbol)
  end

  def format_as_amount_cent(amount, currency_code = nil, with_symbol = false)
    UtilService.format_as_amount_cent(current_user, amount, currency_code, with_symbol)
  end

  def format_as_amount(amount, currency_code = nil, with_cent = false, override_precission = false, number_of_precission = nil)
    UtilService.format_as_amount(current_user, amount, currency_code, with_cent, override_precission, number_of_precission)
  end

  def format_as_decimal(number, precision = 4, strip_insignificant_zeros = true)
    UtilService.format_as_decimal(current_user, number, precision, strip_insignificant_zeros)
  end

  def format_as_number(number)
    UtilService.format_as_number(number, current_user_currency)
  end

  def format_as_quantity(quantity, options = {})
    UtilService.format_as_quantity(current_user, quantity, options)
  end

  def format_as_point(point, options = {})
    UtilService.format_as_point(current_user, point, options)
  end

  def format_as_iso_date(datetime)
    UtilService.format_as_iso_date(datetime)
  end

  def format_period_string(period_string)
    UtilService.format_period_string(period_string)
  end

  def format_period_short_string(period_string)
    UtilService.format_period_short_string(period_string)
  end

  def format_as_date(datetime, format = '%d-%b-%Y')
    UtilService.format_as_date(datetime, format)
  end

  def format_as_date_dd_mm_yyyy(datetime)
    UtilService.format_as_date_dd_mm_yyyy(datetime)
  end

  def format_as_date_dd_mm_yy(datetime)
    UtilService.format_as_date_dd_mm_yy(datetime)
  end

  def format_as_date_short(datetime)
    UtilService.format_as_date_short(datetime)
  end

  def format_as_day_date(datetime)
    UtilService.format_as_day_date(datetime)
  end

  def format_as_date_and_time(datetime)
    UtilService.format_as_date_and_time(datetime)
  end

  def format_as_date_and_time_short(datetime)
    UtilService.format_as_date_and_time_short(datetime)
  end

  def format_as_day_date_and_time(datetime)
    UtilService.format_as_day_date_and_time(datetime)
  end

  def format_as_str_date(datetime)
    UtilService.format_as_str_date(datetime)
  end

  def round_as_amount(amount, currency_code = 'IDR')
    UtilService.round_as_amount(amount, currency_code)
  end

  #---------------------------------------------------------------------------------------------------------
  # Warning!
  #---------------------------------------------------------------------------------------------------------
  #
  # If you need these in UtilService, DON'T copy paste and create duplicates.
  # Instead move the function there and call from here (see format_as_amount above..)
  #
  #---------------------------------------------------------------------------------------------------------

  def now_in_user_time
    current_user.now_in_user_time
  end

  def currency_symbol(currency_code = nil)
    UtilService.currency_symbol(current_user_currency, currency_code)
  end

  def resource_source(source)
    return '' if source.nil?
    if source == Lookup::SOURCE_TYPE_WEB_APP
      return 'Web'
    elsif source == Lookup::SOURCE_TYPE_API_POS
      return 'App'
    elsif source == Lookup::SOURCE_TYPE_API
      return 'API'
    elsif source == Lookup::SOURCE_TYPE_IMPORT
      return 'Import'
    else
      return ''
    end
  end

  def currency_info(currency_code = nil)
    UtilService.currency_info(current_user, currency_code)
  end

  def truncate_text(text, maxlength)
    if text.nil?
      return ''
    end
    if text.length > maxlength
      text[0..maxlength] + '...'
    else
      text
    end
  end

  def report_business_entity_name(store_id)
    UtilService.report_business_entity_name(current_user, store_id)
  end

  def linkable_stock_transaction(transaction_type)
    if Lookup::UNLINKABLE_TRANSACTIONS_TYPES.include? transaction_type
      false
    else
      true
    end
  end

  def turboly_button_print(link, options = {})

    options = {label: ' Print'}.merge(options)
    link_class = 'btn'
    link_class += ' btn-print' if !is_mobile_device
    link_class += " #{options[:btn_class_name]}" if !options[:btn_class_name].nil?
    link_id = options[:id] unless options[:id].blank?
    data = options[:data] unless options[:data].blank?
    approval_print_params = options[:approval_print_params]

    printed_count = nil
    if CompanyAuthorization.setting_is_enable?('config_enable_printing_histories', current_user.company) && options.has_key?(:printed_count)
      printed_count = options[:printed_count].to_i
    end

    icon_class = 'icon-print'
    icon_class = "#{options[:icon_class_name]}" if !options[:icon_class_name].nil?

    if is_mobile_device
      content_tag(:a, :href => link, :class => link_class, :style => options[:style], :target => '_blank', :id => link_id, :data => data) do
        content_tag('i', '', :class => icon_class) +
          content_tag('span', " #{options[:label]}") +
          if printed_count.nil?
            ''
          else
            content_tag('span', " #{printed_count}", :class => 'badge badge-doc-count')
          end
      end
    else
      button_attr = { href: link, class: link_class, style: options[:style], id: link_id, data: data }

      if !approval_print_params.blank?
        initialize_approval_print_options = {
          require_approval: approval_print_params[:require_approval].to_bool,
          print_button_id: approval_print_params[:print_button_id],
          approval_path: approval_print_params[:approval_path],
          print_path: link,
          params: approval_print_params[:params]
        }

        button_attr[:onClick] = "turboly.initializeApprovalPrintModal(#{initialize_approval_print_options.to_json})"
        button_attr[:href] = "javascript:void(0)"
        button_attr[:class] = link_class.to_s.gsub("btn-print", "")
      end

      content_tag(:a, button_attr) do
        content_tag('i', '', :class => icon_class) +
          content_tag('span', " #{options[:label]}") +
          if printed_count.nil?
            ''
          else
            content_tag('span', " #{printed_count}", :class => 'badge badge-doc-count')
          end
      end
    end
  end


  def turboly_dropdown_button_print(link, options = {})

    options = {label: 'Document (default)'}.merge(options)
    link_class = options[:link_class].blank? ? 'btn' : ('btn ' + options[:link_class])

    icon_class = 'icon-print'
    icon_class = "#{options[:icon_class_name]}" if !options[:icon_class_name].nil?

    if is_mobile_device
      content_tag(:a, :href => link, :class => link_class, :target => '_blank', id: options[:id]) do
        content_tag('i', '', :class => icon_class) +
          content_tag('span', " #{options[:label]}")
      end
    else
      content_tag('li', :class => 'align-left') do
        content_tag(:a, :href => link, :class => link_class, :style => 'border: 0px; text-align: left;', id: options[:id]) do
          content_tag('span', " #{options[:label]} ") +
            if !options[:printed_count].blank?
              content_tag('span', "#{options[:printed_count]}", :class => 'badge badge-doc-count')
            end
        end
      end
    end
  end

  def is_saved_draft(doc)
    doc.draft? && !doc.new_record?
  end

  def in_words(int, locale = 'id')
    if locale == 'id'
      numbers_to_name = {
        1000000 => "juta",
        1000 => "ribu",
        100 => "ratus",
        90 => "sembilan puluh",
        80 => "delapan puluh",
        70 => "tujuh puluh",
        60 => "enam puluh",
        50 => "lima puluh",
        40 => "empat puluh",
        30 => "tiga puluh",
        20 => "dua puluh",
        19 => "sembilan belas",
        18 => "delapan belas",
        17 => "tujuh belas",
        16 => "enam belas",
        15 => "lima belas",
        14 => "empat belas",
        13 => "tiga belas",
        12 => "dua belas",
        11 => "sebelas",
        10 => "sepuluh",
        9  => "sembilan",
        8  => "delapan",
        7  => "tujuh",
        6  => "enam",
        5  => "lima",
        4  => "empat",
        3  => "tiga",
        2  => "dua",
        1  => "satu"
      }
    else
      numbers_to_name = {
        1000000 => "million",
        1000 => "thousand",
        100 => "hundred",
        90 => "ninety",
        80 => "eighty",
        70 => "seventy",
        60 => "sixty",
        50 => "fifty",
        40 => "forty",
        30 => "thirty",
        20 => "twenty",
        19 => "nineteen",
        18 => "eighteen",
        17 => "seventeen",
        16 => "sixteen",
        15 => "fifteen",
        14 => "fourteen",
        13 => "thirteen",
        12 => "twelve",
        11 => "eleven",
        10 => "ten",
        9  => "nine",
        8  => "eight",
        7  => "seven",
        6  => "six",
        5  => "five",
        4  => "four",
        3  => "three",
        2  => "two",
        1  => "one"
      }
    end

    str = ""

    numbers_to_name.each do |num, name|
      if int == 0
        return str
      elsif locale == 'id' && int == 100
        return str + "seratus"
      elsif locale == 'id' && int == 1000
        return str + "seribu"
      elsif int.to_s.length == 1 && int/num > 0
        return str + "#{name}"
      elsif int < 100 && int/num > 0
        return str + "#{name}" if int%num == 0
        return str + "#{name} " + in_words(int%num, locale)
      elsif int/num > 0
        if locale == 'id' && ((int > 99 && int < 200) || (int > 999 && int < 2000))
          return str + " se#{name} " + in_words(int%num, locale)
        end
        return str + in_words(int/num, locale) + " #{name} " + in_words(int%num, locale)
      end
    end
  end

  def split_sentences(str, max_sentence_length)
    # https://stackoverflow.com/questions/15401326/split-a-string-into-chunks-of-specified-size-without-breaking-words
    # add dot so regex always works as it match ending with \W
    "#{str}.".scan(/.{1,#{max_sentence_length}}\W/).map(&:strip)
  end

  def axlsx_types(col_length, type)
    (1..col_length).map{ |i| type}
  end

  def axlsx_col(col_pos = 1)
    UtilService.axlsx_col(col_pos)
  end

  def axlsx_merge_last_row(sheet, col_from, number_of_cols_to_merge)
    col_to = col_from + number_of_cols_to_merge - 1
    if col_to > col_from && col_to > 0
      sheet.merge_cells("#{axlsx_col(col_from)}#{sheet.rows.length}:#{axlsx_col(col_to)}#{sheet.rows.length}")
    end
    return col_to
  end

  def axlsx_add_row(sheet, max_cols = 10, row_count = 1)
    (1..row_count).each do |i|
      sheet.add_row (1..max_cols).to_a.map{ |i| ''}, :height => 14
    end
  end

  def axlsx_default_sheet_options_for_print_layout
    page_margins = {
      left: 0.4,
      right: 0.4,
      top: 0.1,
      bottom: 0.1,
      header: 0,
      footer: 0
    }
    page_setup = {
      orientation: :portrait,
      paper_size: 9, # A4
      fit_to_width: 1
    }
    return {name: 'Data', page_margins: page_margins, page_setup: page_setup, :show_gridlines => false}
  end

  AXLSX_PRINT_LAYOUT_OPTIONS = {
    max_chars_header_left: 50,
    max_chars_header_right: 25,
    max_chars_address_header: 75,
    max_chars_after_line_items_row_text: 100,
    signature_label_font_size: 9,
    title_font_size: 12,
    family: 'monospace',
    font_name: 'Arial',
    content_font_size: 9,
    address_font_size: 8
  }

  def axlsx_print_layout_options
    AXLSX_PRINT_LAYOUT_OPTIONS
  end

  def axlsx_add_logo_to_print_layout(sheet, max_cols, logo_image)
    sheet.add_image(:image_src => logo_image.path) do |image|
      image.width = 150
      image.height = 75
      image.start_at 0, 0
    end
  end

  def axlsx_add_box_signature_to_print_layout(sheet, start_from, col_off = nil)
    sheet.add_image(:image_src => "#{Rails.root}/app/assets/images/box_signature.png") do |image|
      image.width = 150
      image.height = 65
      image.start_at start_from, sheet.rows.length
      image.anchor.from.rowOff = 20000
      if col_off
        image.anchor.from.colOff = col_off
      end
    end
  end

  def axlsx_set_title_style(sheet, col_count, use_template_1)
    options = AXLSX_PRINT_LAYOUT_OPTIONS

    if use_template_1
      first_row = "A1:#{axlsx_col(col_count)}1"
    else
      first_row = "C1:#{axlsx_col(col_count - 2)}1"
    end

    sheet.merge_cells first_row
    sheet.add_style first_row,
                    :font_name => options[:font_name], :b => true, :sz => options[:title_font_size],
                    :alignment => {:horizontal => :center, :vertical => :top}

    unless use_template_1
      row = "#{axlsx_col(col_count - 1)}1:#{axlsx_col(col_count)}1"
      sheet.merge_cells row
      sheet.add_style row,
                      :font_name => options[:font_name], :b => true, :sz => options[:title_font_size],
                      :alignment => {:horizontal => :right, :vertical => :top}
    end
  end

  def axlsx_set_address_style(sheet, col_count, row_start, row_end)
    options = AXLSX_PRINT_LAYOUT_OPTIONS

    row = "A#{row_start}:#{axlsx_col(col_count)}#{row_end}"
    sheet.merge_cells row
    sheet.add_style row,
                    :font_name => options[:font_name], :sz => options[:address_font_size],
                    :alignment => {:horizontal => :center, :vertical => :center}
  end

  def axlsx_set_content_style(sheet, row_start, col_count)
    options = AXLSX_PRINT_LAYOUT_OPTIONS

    sheet.add_style "A#{row_start}:#{axlsx_col(col_count)}#{sheet.rows.length}",
                    :font_name => options[:font_name], :sz => options[:content_font_size],
                    :alignment => {:horizontal => :left, :vertical => :center}
  end

  def axlsx_setup_common_style(sheet, header_row_start, table_header, line_items_row_start, line_items_row_end, use_template_1 = true)
    axlsx_set_title_style sheet, table_header.length, use_template_1
    axlsx_set_content_style sheet, header_row_start, table_header.length
    axlsx_set_line_items_table_border sheet, table_header, line_items_row_start, line_items_row_end
  end

  def axlsx_set_matching_row_bold(sheet, col_pos, row_start, text_rows, text_to_match)
    matching_row = text_rows.each_index.detect{|i| text_rows[i] == text_to_match}.to_i
    sheet.add_style "#{axlsx_col(col_pos)}#{row_start + matching_row}", :b => true
  end

  def axlsx_set_bold(sheet, col_pos, row_start, row_end)
    sheet.add_style "#{axlsx_col(col_pos)}#{row_start}:#{axlsx_col(col_pos)}#{row_end}", :b => true
  end

  def axlsx_set_row_bold(sheet, row, col_start, col_end)
    sheet.add_style "#{axlsx_col(col_start)}#{row}:#{axlsx_col(col_end)}#{row}", :b => true
  end

  def axlsx_set_line_items_table_border(sheet, table_header, line_items_row_start, line_items_row_end)
    outer_border_style = {style: :thin, color: '00', edges: [:left, :top, :right, :bottom]}
    columns_count = table_header.length
    (1..columns_count).each do |col_pos|
      # table header
      sheet.add_border "#{axlsx_col(col_pos)}#{line_items_row_start}:#{axlsx_col(col_pos)}#{line_items_row_start}",
                       outer_border_style
      # table content
      sheet.add_border "#{axlsx_col(col_pos)}#{line_items_row_start + 1}:#{axlsx_col(col_pos)}#{line_items_row_end}",
                       outer_border_style
    end

  end

  def axlsx_add_signature_section(sheet, max_cols, table_col_count, signature_label, horizontal_alignment = :center)
    options = AXLSX_PRINT_LAYOUT_OPTIONS

    # padding row
    axlsx_add_row sheet, max_cols, row_count = 1

    # signature row
    axlsx_add_row sheet, max_cols

    last_row_first_col = sheet.rows[sheet.rows.length - 1].cells[0]
    last_row_first_col.value = signature_label
    last_row = "A#{sheet.rows.length}:#{axlsx_col(table_col_count)}#{sheet.rows.length}"
    sheet.merge_cells last_row
    sheet.add_style last_row, :font_name => options[:font_name], :b => true, :sz => options[:signature_label_font_size],
                    :alignment => {:horizontal => horizontal_alignment, :vertical => :bottom}
  end

  def axlsx_set_receipt_company_header_style(sheet, max_cols)
    options = AXLSX_PRINT_LAYOUT_OPTIONS

    row = "A#{sheet.rows.length}:#{axlsx_col(max_cols)}#{sheet.rows.length}"
    sheet.merge_cells row
    sheet.add_style row, :font_name => options[:font_name], :b => true, :sz => options[:title_font_size]
  end

  def axlsx_set_receipt_title_style(sheet, max_cols)
    options = AXLSX_PRINT_LAYOUT_OPTIONS

    row = "A#{sheet.rows.length}:#{axlsx_col(max_cols)}#{sheet.rows.length}"
    sheet.merge_cells row
    sheet.add_style row,
                    :font_name => options[:font_name], :b => true, :sz => options[:title_font_size],
                    :alignment => {:horizontal => :center, :vertical => :top}
  end

  def axlsx_set_receipt_content_style(sheet, max_cols)
    options = AXLSX_PRINT_LAYOUT_OPTIONS

    row = "A#{sheet.rows.length}:D#{sheet.rows.length}"
    sheet.merge_cells row
    sheet.add_style row,
                    :font_name => options[:font_name], :sz => options[:title_font_size]

    row = "E#{sheet.rows.length}:#{axlsx_col(max_cols)}#{sheet.rows.length}"
    sheet.merge_cells row
    sheet.add_style row,
                    :font_name => options[:font_name], :sz => options[:title_font_size]
  end

  def axlsx_coa_label_with_padding(level, label)
    UtilService.axlsx_coa_label_with_padding(level, label)
  end

  def get_tax_lines_detail(tax_lines, currency = 'IDR')
    details = []
    details << '<ul>'
    tax_lines.each do |tax_line|
      details << "<li>#{tax_line.tax_name} (#{tax_line.coa.name}) : #{format_as_amount(tax_line.tax_amount, currency)} (#{currency})</li>"
    end
    details << '</ul>'

    details.join('')
  end

  #-----------------------------------------------------
  # current_user_store_id
  #-----------------------------------------------------
  def current_user_store_id
    store_id = current_user.store_id
    if current_user.has_company_wide_role && store_id.nil?
      store = Lookup.available_stores(current_user).limit(1)[0]
      if store.nil?
        store_id = 0
      else
        store_id = store.id
      end
    end
    store_id
  end

  def calc_line_number(index, rows_per_page)
    page = params[:page].to_i < 1 ? 1 : params[:page].to_i
    ((page - 1) * rows_per_page) + (index + 1)
  end

  def line_number(index, rows_per_page = config_rows_per_page)
    calc_line_number(index, rows_per_page)
  end

  def line_number_document(index, rows_per_page = config_rows_per_document)
    calc_line_number(index, rows_per_page)
  end

  def line_number_report(index, rows_per_page = config_rows_per_report)
    calc_line_number(index, rows_per_page)
  end

  def render_print_text(doc, text)
    matchers = {
      '{{customer_name}}' => !doc.customer.nil? ? strip_tags(doc.customer.name) : '',
      '{{due_date}}' => !doc.due_at.nil? ? format_as_date(doc.due_at) : '',
      '{{customer_credit_term}}' => !doc.customer.nil? ? doc.customer.credit_term_days : '',
    }
    return text.gsub(/{{customer_name}}|{{due_date}}|{{customer_credit_term}}/) { |match| matchers[match] }.html_safe
  end

  #-----------------------------------------------------
  # For new template only
  #-----------------------------------------------------
  def check_params_layout(layout)
    if request.query_parameters.blank?
      "#{request.fullpath}?layout=#{LookupManager::LAYOUT_TOPBAR}"
    else
      query_parameters = request.query_parameters.deep_dup
      query_parameters.delete('layout')
      "#{request.path}?#{query_parameters.to_query}&layout=#{layout}"
    end
  end

  def check_params_color_theme(color_theme)
    if request.query_parameters.blank?
      "#{request.fullpath}?color_theme=#{color_theme}"
    else
      query_parameters = request.query_parameters.deep_dup
      query_parameters.delete('color_theme')
      "#{request.path}?#{query_parameters.to_query}&color_theme=#{color_theme}"
    end
  end

  def payment_type_label_array
    ['Bank', 'Installment', 'Type', 'Card No.', 'Approval Code', 'MID', 'TID', 'Notes', 'Other']
  end

  def payment_type_label_name_array
    label_names = current_user_company.company_setting&.extra_info_payment_type_settings&.values || []
    # -3, EDC .. Notes
    label_names[0..-3]
  end

  def report_sort_link(column_name)
    report_params = request.params || {}
    report_params["#{column_name.parameterize.underscore}_sort"]

    sorter_param = report_params["#{column_name.parameterize.underscore}_sort"].to_s.strip.downcase

    if %w[asc desc].include?(sorter_param)
      if sorter_param == 'asc'
        report_params["#{column_name.parameterize.underscore}_sort"] = 'desc'
        link = link_to "#{column_name} &#9650;".html_safe, url_for(report_params)
      elsif sorter_param == 'desc'
        report_params["#{column_name.parameterize.underscore}_sort"] = 'asc'
        link = link_to "#{column_name} &#9660;".html_safe, url_for(report_params)
      end
    else
      report_params["#{column_name.parameterize.underscore}_sort"] = 'asc'
      link = link_to column_name.to_s.html_safe, url_for(report_params)
    end

    link
  end

  def turboly_pagination(total_rows_current_page, with_go_to_page, options = {})
    if request.params.has_key?(:q)
      filter = {q: request.params[:q].clone, page: params[:page]}
    else
      filter = request.params.clone
      filter.delete('action')
      filter.delete('controller')
    end

    current_page = [filter[:page].to_i, 1].max
    prev_page    = current_page.to_i - 1
    next_page    = current_page.to_i + 1
    current_path = request.path

    max_rows_per_page = (options[:rows_per_page] || current_user.company.config_default_rows_per_page).to_i

    filter[:page] = prev_page
    enable_prev_page = prev_page > 0
    link_prev_page = content_tag('li', class: (enable_prev_page ? 'prev' : 'active')) do
      url = enable_prev_page ? "#{current_path}?#{filter.to_query}" : 'javascript:void(0);'
      content_tag('a', href: url) do
        content_tag('span', "‹ Prev")
      end
    end

    filter[:page] = next_page
    filter.merge!(options[:additional_next_params] || {})
    enable_next_page = total_rows_current_page >= max_rows_per_page
    link_next_page = content_tag('li', class: (enable_next_page ? 'next' : 'active')) do
      url = enable_next_page ? "#{current_path}?#{filter.to_query}" : 'javascript:void(0);'
      content_tag('a', href: url) do
        content_tag('span', "Next ›")
      end
    end

    if with_go_to_page
      go_to_page = content_tag('li') do
        filter.delete(:page)
        url = "#{current_path}?#{filter.to_query}"
        content_tag('input', nil, class: 'go-to-page-input align-right', value: current_page, type: 'text', style: 'width: 75px;') +
          button_tag('Go To Page', class: 'btn btn-primary btn-sm go-to-page', style: 'position: absolute;', data: {url: url})
      end
    else
      go_to_page = ''
    end

    content_tag('div', class: 'pagination') do
      content_tag('ul') do
        link_prev_page + link_next_page + go_to_page
      end
    end
  end

end
