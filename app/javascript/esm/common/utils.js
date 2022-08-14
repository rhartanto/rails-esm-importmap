import { v4 as uuidv4 } from 'uuid'; // this is from vendors/es6/uuid.js

export default function uuid() {
  //
  const uuid = uuidv4();
  console.log('bar');
  console.log(`uuid from ES6 ${uuid}`)
  return uuid;
}

export const CountTableRows = (tableId) => {
  const table = document.getElementById(tableId);
  return table?.tBodies[0]?.rows?.length || 0;
};

export const sum = (a, b) => {
  return a + b;
}
