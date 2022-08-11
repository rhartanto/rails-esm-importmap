import { createApp } from 'vue'
import ButtonCounter from 'esm/components/button_counter'
import Todos from 'esm/components/todos'

console.log("loading vue 3");

const app = createApp({
  template: `
    <div>
      <ButtonCounter />
      
      <div data-test="app-message">{{ message }}</div>

      <Todos />
    </div>
  `,
  data() {
    return {
      message: 'Hello Vue!',
    }
  },
  components: {
    ButtonCounter,
    Todos,
  }
})


app.mount('#app');
