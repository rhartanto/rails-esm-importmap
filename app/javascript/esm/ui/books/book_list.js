import { CountTableRows } from 'esm/common/utils';


const rowsTotal = CountTableRows("books-table");
console.log(`rowsTotal ${rowsTotal}`);
const totalLabel = document.getElementById('rows-total');
totalLabel.innerHTML = `${rowsTotal}`;
