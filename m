From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 3/3] cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB should
 be atomic flags
Date: Wed, 24 Sep 2014 11:15:36 +0800
Message-ID: <54223758.4070300@huawei.com>
References: <542124D3.9000007@huawei.com> <54212509.1030809@huawei.com> <alpine.DEB.2.02.1409231508590.22630@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1409231508590.22630-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Miao Xie <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

=E4=BA=8E 2014/9/24 6:10, David Rientjes wrote:
> On Tue, 23 Sep 2014, Zefan Li wrote:
>=20
>> When we change cpuset.memory_spread_{page,slab}, cpuset will flip
>> PF_SPREAD_{PAGE,SLAB} bit of tsk->flags for each task in that cpuset=
=2E
>> This should be done using atomic bitops, but currently we don't,
>> which is broken.
>>
>> Tetsuo reported a hard-to-reproduce kernel crash on RHEL6, which hap=
pend
>> when one thread tried to clear PF_USED_MATH while at the same time a=
nother
>> thread tried to flip PF_SPREAD_PAGE/PF_SPREAD_SLAB. They both operat=
e on
>> the same task.
>>
>> Here's the full report:
>> https://lkml.org/lkml/2014/9/19/230
>>
>> To fix this, we make PF_SPREAD_PAGE and PF_SPARED_SLAB atomic flags.
>>
>=20
> s/SPARED/SPREAD/
>=20
>> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>> Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Cc: Miao Xie <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
>> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> Fixes: 950592f7b991 ("cpusets: update tasks' page/slab spread flags =
in time")
>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 2.6.31+
>> Reported-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
>> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>  include/linux/cpuset.h |  4 ++--
>>  include/linux/sched.h  | 13 +++++++++++--
>>  kernel/cpuset.c        |  9 +++++----
>>  3 files changed, 18 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
>> index 0d4e067..2f073db 100644
>> --- a/include/linux/cpuset.h
>> +++ b/include/linux/cpuset.h
>> @@ -94,12 +94,12 @@ extern int cpuset_slab_spread_node(void);
>> =20
>>  static inline int cpuset_do_page_mem_spread(void)
>>  {
>> -	return current->flags & PF_SPREAD_PAGE;
>> +	return task_spread_page(current);
>>  }
>> =20
>>  static inline int cpuset_do_slab_mem_spread(void)
>>  {
>> -	return current->flags & PF_SPREAD_SLAB;
>> +	return task_spread_slab(current);
>>  }
>> =20
>>  extern int current_cpuset_is_being_rebound(void);
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 5630763..7b1cafe 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1903,8 +1903,6 @@ extern void thread_group_cputime_adjusted(stru=
ct task_struct *p, cputime_t *ut,
>>  #define PF_KTHREAD	0x00200000	/* I am a kernel thread */
>>  #define PF_RANDOMIZE	0x00400000	/* randomize virtual address space =
*/
>>  #define PF_SWAPWRITE	0x00800000	/* Allowed to write to swap */
>> -#define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset =
*/
>> -#define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over c=
puset */
>>  #define PF_NO_SETAFFINITY 0x04000000	/* Userland is not allowed to =
meddle with cpus_allowed */
>>  #define PF_MCE_EARLY    0x08000000      /* Early kill for mce proce=
ss policy */
>>  #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mute=
x tester */
>> @@ -1958,6 +1956,9 @@ static inline void memalloc_noio_restore(unsig=
ned int flags)
>> =20
>>  /* Per-process atomic flags. */
>>  #define PFA_NO_NEW_PRIVS 0	/* May not gain new privileges. */
>> +#define PFA_SPREAD_PAGE  1      /* Spread page cache over cpuset */
>> +#define PFA_SPREAD_SLAB  2      /* Spread some slab caches over cpu=
set */
>> +
>> =20
>>  #define TASK_PFA_TEST(name, func)					\
>>  	static inline bool task_##func(struct task_struct *p)		\
>> @@ -1972,6 +1973,14 @@ static inline void memalloc_noio_restore(unsi=
gned int flags)
>>  TASK_PFA_TEST(NO_NEW_PRIVS, no_new_privs)
>>  TASK_PFA_SET(NO_NEW_PRIVS, no_new_privs)
>> =20
>> +TASK_PFA_TEST(SPREAD_PAGE, spread_page)
>> +TASK_PFA_SET(SPREAD_PAGE, spread_page)
>> +TASK_PFA_CLEAR(SPREAD_PAGE, spread_page)
>> +
>> +TASK_PFA_TEST(SPREAD_SLAB, spread_slab)
>> +TASK_PFA_SET(SPREAD_SLAB, spread_slab)
>> +TASK_PFA_CLEAR(SPREAD_SLAB, spread_slab)
>> +
>>  /*
>>   * task->jobctl flags
>>   */
>> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>> index a37f4ed..1f107c7 100644
>> --- a/kernel/cpuset.c
>> +++ b/kernel/cpuset.c
>> @@ -365,13 +365,14 @@ static void cpuset_update_task_spread_flag(str=
uct cpuset *cs,
>>  					struct task_struct *tsk)
>>  {
>>  	if (is_spread_page(cs))
>> -		tsk->flags |=3D PF_SPREAD_PAGE;
>> +		task_set_spread_page(tsk);
>>  	else
>> -		tsk->flags &=3D ~PF_SPREAD_PAGE;
>> +		task_clear_spread_page(tsk);
>> +
>>  	if (is_spread_slab(cs))
>> -		tsk->flags |=3D PF_SPREAD_SLAB;
>> +		task_set_spread_slab(tsk);
>>  	else
>> -		tsk->flags &=3D ~PF_SPREAD_SLAB;
>> +		task_clear_spread_slab(tsk);
>>  }
>> =20
>>  /*
>=20
> This most certainly needs commentary to specify why these have to be=20
> atomic ops.
> .

It won't hurt to add more comment, but I don't think it's necessary, be=
cause
the reason to use atomic bitops seems obvious to me. Besides there's no=
 such
comment for no_new_privs, which was tsk->atomic_flags introduced for.

