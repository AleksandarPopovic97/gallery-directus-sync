<template>
	<private-view title="My Custom Module">
		<button @click="handlePrint">PrintSYNC</button>
		<div ref="componentRef">
			<h1>Hello, world SYNC!</h1>
		</div>
	</private-view>
</template>

<script setup lang="ts">
import { defineComponent, ref } from 'vue';
import { useVueToPrint } from "vue-to-print";

const componentRef = ref();
const { handlePrint } = useVueToPrint({
  content: componentRef,
  documentTitle: "AwesomeFileName",
});


</script>
