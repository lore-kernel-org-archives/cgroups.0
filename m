From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] sched: add a macro to define bitops for task atomic
 flags
Date: Tue, 23 Sep 2014 14:52:50 +0800
Message-ID: <542118C2.6030302@huawei.com>
References: <54210D3F.2090409@huawei.com> <54210D7B.8030103@huawei.com> <CAGXu5jJKNJ=PsTtkPaoMyCNf2fK07szP-hv4NdaiDVx4tHacQw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jJKNJ=PsTtkPaoMyCNf2fK07szP-hv4NdaiDVx4tHacQw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Miao Xie <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

>> -static inline bool task_no_new_privs(struct task_struct *p)
>> -{
>> -       return test_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
>> -}
>> -
>> -static inline void task_set_no_new_privs(struct task_struct *p)
>> -{
>> -       set_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
>> -}
>> +#define TASK_PFA_BITOPS(name, func)                            \
>> +static inline bool task_##func(struct task_struct *p)          \
>> +{ return test_bit(PFA_##name, &p->atomic_flags); }             \
>> +                                                               \
>> +static inline void task_set_##func(struct task_struct *p)      \
>> +{ set_bit(PFA_##name, &p->atomic_flags); }                     \
>> +                                                               \
>> +static inline void task_clear_##func(struct task_struct *p)    \
>> +{ clear_bit(PFA_##name, &p->atomic_flags); }
>> +
>> +TASK_PFA_BITOPS(NO_NEW_PRIVS, no_new_privs)
> 
> One thing I don't like about this is that task_clear_no_new_privs()
> ends up getting defined, and it should absolutely never be used. NNP
> should never be cleared or there could be security issues. I realize
> this isn't a very useful nit-pick, but I'd rather the function wasn't
> even available for someone to accidentally use. Maybe break up the
> macro with some kind of "write only" version like:
> 
> #define TASK_PFA_BITOPS_WO(name, func)                            \
> static inline bool task_##func(struct task_struct *p)          \
> { return test_bit(PFA_##name, &p->atomic_flags); }             \
> static inline void task_set_##func(struct task_struct *p)      \
> { set_bit(PFA_##name, &p->atomic_flags); }
> 
> #define TASK_PFA_BITOPS(name, func)                            \
> TASK_PFA_BITOPS_WO(name, func);          \
> static inline void task_clear_##func(struct task_struct *p)    \
> { clear_bit(PFA_##name, &p->atomic_flags); }
> 
> TASK_PFA_BITOPS_WO(NO_NEW_PRIVS, no_new_privs)
> 
> And then all the new users can use TASK_PFA_BITOPS() normally since
> they expect to use "clear"?
> 

Now I'm inclined to do this:

+#define TASK_PFA_TEST(name, func)					\
+	static inline bool task_##func(struct task_struct *p)		\
+	{ return test_bit(PFA_##name, &p->atomic_flags); }
+#define TASK_PFA_SET(name, func)					\
+	static inline void task_set_##func(struct task_struct *p)	\
+	{ set_bit(PFA_##name, &p->atomic_flags); }
+#define TASK_PFA_CLEAR(name, func)					\
+	static inline void task_clear_##func(struct task_struct *p)	\
+	{ clear_bit(PFA_##name, &p->atomic_flags); }
+
+TASK_PFA_TEST(NO_NEW_PRIVS, no_new_privs)
+TASK_PFA_SET(NO_NEW_PRIVS, no_new_privs)
