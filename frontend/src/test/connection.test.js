import { mount } from "@vue/test-utils";
import { store } from '../stores/store.js';
import { account } from "../components/account.vue";
import { describe, it, expect } from "vitest";
// import axios from "axios";
import { createApp } from 'vue';
import { setActivePinia, createPinia } from 'pinia';
vi.mock('axios')

const app = createApp({})
beforeEach(() => {
  const pinia = createPinia().use(store)
  app.use(pinia)
  setActivePinia(pinia)
})

test("account.vue", () => {
    it("test password empty on connextion", () => {
        const login = {
            username: "adressmail@email.com",
            password: "",
        }
        const wrapper = mount(account,
        {
            data() {
                return {
                    login: login,
                };
            },
        });
    
        expect(wrapper.v$.$errors.lenght).toBe(1);
      });
});


test("account.vue", () => {
    it("test email and password empty on connextion", () => {
        const login = {
            username: "",
            password: "",
        }
        const wrapper = mount(account,
        {
            data() {
                return {
                    login: login,
                };
            },
        });
    
        // expect(wrapper.v$.$errors.lenght).toBe(2);
        print(wrapper.v$.$errors[0].field)
        expect(wrapper.v$.$errors[0].field).toBe("username");
      });
});

test("account.vue", () => {
    it("email good format", () => {
        const login = {
            username: "",
            password: "",
        }
        const wrapper = mount(account,
        {
            data() {
                return {
                    login: login,
                };
            },
        });
    
        // expect(wrapper.v$.$errors.lenght).toBe(2);
        print(wrapper.v$.$errors[0].field)
        expect(wrapper.text).contains("format de l\'email est incorrect");
      });
});

test("account.vue", () => {
    it("connection", () => {
        const store = store()

        const login = {
            username: "adressmail@email.com",
            password: "password",
        }
        
        store.loginAccount(login);

        expect(store.userInfo).toBe(login);
      });
});