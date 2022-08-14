// This doesn't need javascript tests since it is only mounting the component to DOM
// so instead we should be testing the components
import { createApp } from 'vue'
import Book from 'esm/components/book'

console.log("loading vue 3");
createApp(Book).mount('#app');

export default Book;