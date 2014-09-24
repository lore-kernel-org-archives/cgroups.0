From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/3] cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB should
 beatomic flags
Date: Wed, 24 Sep 2014 11:01:04 +0800
Message-ID: <542233F0.1080402@huawei.com>
References: <54210D3F.2090409@huawei.com> <54210DA5.4040606@huawei.com> <201409231955.FDB73406.FOOJLOVQMHFSFt@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201409231955.FDB73406.FOOJLOVQMHFSFt-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org

On 2014/9/23 18:55, Tetsuo Handa wrote:
> Zefan Li wrote:
>> Tetsuo reported a hard-to-reproduce kernel crash on RHEL6, which happend
> 
> s/happend/happened/
> 
>> @@ -1972,6 +1973,14 @@ static inline void memalloc_noio_restore(unsigned int flags)
>>  TASK_PFA_TEST(NO_NEW_PRIVS, no_new_privs)
>>  TASK_PFA_SET(NO_NEW_PRIVS, no_new_privs)
>>  
>> +TASK_PFA_TEST(SPREAD_PAGE, spread_page)
>> +TASK_PFA_SET(SPREAD_PAGE, spread_page)
>> +TASK_PFA_CLEAR(SPREAD_PAGE, spread_page)
>> +
>> +TASK_PFA_TEST(SPREAD_SLAB, spread_slab)
>> +TASK_PFA_SET(SPREAD_SLAB, spread_slab)
>> +TASK_PFA_CLEAR(SPREAD_SLAB, spread_slab)
>> +
> 
> I wonder how adding 3 macro lines differs from 3 inlined functions.
> Personally, from LXR (source code browser) point of view, inlined functions
> are more friendly than macros. Also, I wonder about the cost of extracting
> macros in a file which is likely included by every file but referenced
> by few files. Speak of SPREAD_PAGE and SPREAD_SLAB, they should be defined
> as inlined functions in include/linux/cpuset.h rather than as macros in
> include/linux/sched.h ?
> .

Though tsk->atomic_flags were newly introduced in 3.17 merge window, we
already have 3 flags, and we may see more flags added.

Those macros make the code easier to read, and emacs and cscope can also
understand them.

I'd vote for this:

TASK_PFA_TEST(NO_NEW_PRIVS, no_new_privs)
TASK_PFA_SET(NO_NEW_PRIVS, no_new_privs)

TASK_PFA_TEST(SPREAD_PAGE, spread_page)
TASK_PFA_SET(SPREAD_PAGE, spread_page)
TASK_PFA_CLEAR(SPREAD_PAGE, spread_page)

TASK_PFA_TEST(SPREAD_SLAB, spread_slab)
TASK_PFA_SET(SPREAD_SLAB, spread_slab)
TASK_PFA_CLEAR(SPREAD_SLAB, spread_slab)

over this:

static inline bool task_no_new_privs(struct task_struct *p)
{
	return test_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
}
static inline void task_set_new_privs(struct task_struct *p)
{
	set_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
}

static inline bool task_spread_page(struct task_struct *p)
{
	return test_bit(PFA_SPREAD_PAGE, &p->atomic_flags);
}
static inline void task_set_spread_page(struct task_struct *p)
{
	set_bit(PFA_SPREAD_PAGE, &p->atomic_flags);
}
static inline void task_clear_spread_page(struct task_struct *p)
{
	clear_bit(PFA_SPREAD_PAGE, &p->atomic_flags);
}

static inline bool task_spread_slab(struct task_struct *p)
{
	return test_bit(PFA_SPREAD_SLAB, &p->atomic_flags);
}
static inline void task_set_spread_slab(struct task_struct *p)
{
	set_bit(PFA_SPREAD_SLAB, &p->atomic_flags);
}
static inline void task_clear_spread_slab(struct task_struct *p)
{
	clear_bit(PFA_SPREAD_SLAB, &p->atomic_flags);
}

