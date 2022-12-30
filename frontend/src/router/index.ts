import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";
import DetailProducts from "../views/DetailProductView.vue";
import BackofficeView from "../views/BackOfficeView.vue";
import { storeAccount } from '../stores/store';

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      name: "home",
      component: HomeView,
    },
    {
      path: "/detail-product/:info",
      name: "detail-product",
      component: DetailProducts,
      props: true
    },
    {
      path: "/backoffice",
      name: "backoffice",
      component : BackofficeView
    },
    {
      path: "/about",
      name: "about",
      // route level code-splitting
      // this generates a separate chunk (About.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import("../views/AboutView.vue"),
    },
  ],
});

router.beforeEach((to, from, next) => {
  const store = storeAccount()
  console.log("test",to.name == 'backoffice',store.isAdmin())
  if (to.name == 'backoffice' && !store.isAdmin()) next({ name: 'backoffice' })
  else next()
})

export default router;
