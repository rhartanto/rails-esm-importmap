import { sum, CountTableRows } from '../../../app/javascript/esm/common/utils';
import uuid from '../../../app/javascript/esm/common/utils';


beforeEach(() => {
  document.body.innerHTML = ``;
});

describe('sum', () => {
  test('should adds 1 + 2 to equal 3', () => {
    expect(sum(1, 2)).toBe(3);
  });
})


describe('default', () => {
  test('should return uuid', () => {
    expect(typeof uuid()).toBe('string');
  });
})

describe('CountTableRows', () => {
  test('should count rows correctly', () => {
    document.body.innerHTML = `
     <table id="books-table">
      <thead>
        <tr>
          <th>Title</th><th>Author</th>
        </tr>
      </thead>
      <tbody>
          <tr>
            <td>Business Stories</td><td>Bloomberg</td>
          </tr>
          <tr>
            <td>Programming Python</td><td>Guido Van Rossum</td>
          </tr>
      </tbody>
    </table>
  `;
    expect(CountTableRows('books-table')).toBe(2);
  });

  test('should work with empty rows', () => {
    expect(CountTableRows('books-table')).toBe(0);
  });
})


