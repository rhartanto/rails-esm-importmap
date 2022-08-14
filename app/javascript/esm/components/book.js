import axios from 'axios';
import ButtonCounter from 'esm/components/button_counter';
import Todos from 'esm/components/todos';

const Book = {
  template: `
    <div>
      <ButtonCounter />
      
      <div data-test="app-message">{{ message }} - IP: {{ ip }}</div>

      <Todos />
    </div>
  `,
  data() {
    return {
      message: 'Hello Vue!',
      ip: '-',
    }
  },
  mounted () {
    axios
      .get('https://api.ipify.org?format=json')
      .then(res => (this.ip = res.data.ip))
  },
  components: {
    ButtonCounter,
    Todos,
  }
};

export default Book;