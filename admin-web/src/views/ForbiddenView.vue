<template>
  <div class="forbidden">
    <h2>403</h2>
    <p>无访问权限</p>
    <el-button type="primary" @click="$router.push('/')">返回首页</el-button>
  </div>
</template>

<style scoped>
.forbidden {
  text-align: center;
  padding: 80px 0;
}
</style>
