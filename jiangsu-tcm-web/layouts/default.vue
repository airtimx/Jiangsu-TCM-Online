<template>
  <div class="layout">
    <header class="header">
      <div class="container header-inner">
        <NuxtLink to="/" class="brand">江苏中医在线</NuxtLink>
        <nav class="nav">
          <NuxtLink to="/">首页</NuxtLink>
        </nav>
      </div>
    </header>
    <main class="main container">
      <slot />
    </main>
    <footer class="footer">
      <div class="container footer-inner">
        <p>江苏中医在线 · 模块 00 网页端壳（业务页由模块 16 扩展）</p>
      </div>
    </footer>
  </div>
</template>

<style scoped>
.layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}
.header {
  background: #fff;
  border-bottom: 1px solid #e8e8e8;
}
.header-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 56px;
}
.brand {
  font-weight: 700;
  font-size: 18px;
  color: var(--color-primary);
}
.nav a {
  margin-left: 16px;
  color: var(--color-text);
}
.main {
  flex: 1;
  padding: 32px 16px;
}
.footer {
  background: #fff;
  border-top: 1px solid #e8e8e8;
  padding: 16px 0;
  font-size: 13px;
  color: var(--color-muted);
}
.container {
  max-width: var(--max-width);
  margin: 0 auto;
  padding: 0 16px;
}
</style>
