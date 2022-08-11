export default {
  template: `
    <div class="button-counter-component">
      <button @click="count++">
        Count is: {{ count }}
      </button>
    </div>
  `,
  data() {
    return {
      count: 0,
    }
  },
}
