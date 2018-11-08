From: Waiman Long <longman9394@gmail.com>
Subject: Re: [PATCH v5 4/5] sched/core: Prevent race condition between cpuset
 and __sched_setscheduler()
Date: Thu, 8 Nov 2018 10:49:49 -0500
Message-ID: <16587a21-ed6e-809d-78a8-5f76d1787665@gmail.com>
References: <20180903142801.20046-1-juri.lelli@redhat.com>
 <20180903142801.20046-5-juri.lelli@redhat.com>
 <20181003154230.4b8792fb@gandalf.local.home>
 <20181004090401.GB12774@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=qvsywnKTaNkmTB5rK94X0i85wh7E+KsvzX9QsXg834g=;
        b=ebmciQoQkGdGUTjpM0HKjGqvQz7TYlh1MmnHBssylBwHMPV5jpNj1MKFrnjwqFRfkR
         3vurzsyQj3K0ALEMU9uh3k2UNDeT9sfitNRVVtmlrLHsL5Dhw2JhdRGshrRN9W1imaFS
         RG8BwUnMCrmxAsWGHvFeZjE5Q3aF1C2u8Bp674uWkh5k+hBgo1MOrYrO02kOVP8VNlHc
         cbacdwhrMKkHcnvmjbdcorM4atEf70fV86B05OSp/pDvykmy+sVgOg/ft7W+HPQ1zB+7
         cZBrcE0RcrSv5ZiX1rcO43bHuUSZZSIJEiowUBFFCEYWS1KjwgJZSSJ3v7w3z94ZLRFp
         nB7g==
In-Reply-To: <20181004090401.GB12774@localhost.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On 10/04/2018 05:04 AM, Juri Lelli wrote:
> On 03/10/18 15:42, Steven Rostedt wrote:
>> On Mon,  3 Sep 2018 16:28:00 +0200
>> Juri Lelli <juri.lelli@redhat.com> wrote:
>>
>>
>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>> index 5b43f482fa0f..8dc26005bb1e 100644
>>> --- a/kernel/cgroup/cpuset.c
>>> +++ b/kernel/cgroup/cpuset.c
>>> @@ -2410,6 +2410,24 @@ void __init cpuset_init_smp(void)
>>>  	BUG_ON(!cpuset_migrate_mm_wq);
>>>  }
>>>  
>>> +/**
>>> + * cpuset_read_only_lock - Grab the callback_lock from another subsysytem
>>> + *
>>> + * Description: Gives the holder read-only access to cpusets.
>>> + */
>>> +void cpuset_read_only_lock(void)
>>> +{
>>> +	raw_spin_lock(&callback_lock);
>> This was confusing to figure out why grabbing a spinlock gives read
>> only access. So I read the long comment above the definition of
>> callback_lock. A couple of notes.
>>
>> 1) The above description needs to go into more detail as to why
>> grabbing a spinlock is "read only".
>>
>> 2) The comment above the callback_lock needs to incorporate this, as
>> reading that comment alone will not give anyone an idea that this
>> exists.
> Right, does the updated version below look any better?
>
> Thanks for reviewing!
>
> Best,
>
> - Juri
>
> --->8---
> From d704536ba80a01116007024ec055efcc4a9ee558 Mon Sep 17 00:00:00 2001
> From: Mathieu Poirier <mathieu.poirier@linaro.org>
> Date: Thu, 23 Aug 2018 14:52:13 +0200
> Subject: [PATCH v5 4/5] sched/core: Prevent race condition between cpuset and
>  __sched_setscheduler()
>
> No synchronisation mechanism exists between the cpuset subsystem and calls
> to function __sched_setscheduler(). As such, it is possible that new root
> domains are created on the cpuset side while a deadline acceptance test
> is carried out in __sched_setscheduler(), leading to a potential oversell
> of CPU bandwidth.
>
> Grab callback_lock from core scheduler, so to prevent situations such as
> the one described above from happening.
>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
>
> ---
>
> v4->v5: grab callback_lock instead of cpuset_mutex, as callback_lock is
> enough to get read-only access to cpusets [1] and it can be easily
> converted to be a raw_spinlock (done in previous - new - patch).
>
> [1] https://elixir.bootlin.com/linux/latest/source/kernel/cgroup/cpuset.c#L275
> ---
>  include/linux/cpuset.h |  6 ++++++
>  kernel/cgroup/cpuset.c | 25 ++++++++++++++++++++++++-
>  kernel/sched/core.c    | 10 ++++++++++
>  3 files changed, 40 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index 934633a05d20..8e5a8dd0622b 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -55,6 +55,8 @@ extern void cpuset_init_smp(void);
>  extern void cpuset_force_rebuild(void);
>  extern void cpuset_update_active_cpus(void);
>  extern void cpuset_wait_for_hotplug(void);
> +extern void cpuset_read_only_lock(void);
> +extern void cpuset_read_only_unlock(void);
>  extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
>  extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
>  extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
> @@ -176,6 +178,10 @@ static inline void cpuset_update_active_cpus(void)
>  
>  static inline void cpuset_wait_for_hotplug(void) { }
>  
> +static inline void cpuset_read_only_lock(void) { }
> +
> +static inline void cpuset_read_only_unlock(void) { }
> +
>  static inline void cpuset_cpus_allowed(struct task_struct *p,
>  				       struct cpumask *mask)
>  {
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 5b43f482fa0f..bff72b920624 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -273,7 +273,8 @@ static struct cpuset top_cpuset = {
>   * __alloc_pages().
>   *
>   * If a task is only holding callback_lock, then it has read-only
> - * access to cpusets.
> + * access to cpusets. Mind that callback_lock might be grabbed from other
> + * subsystems as well (via cpuset_read_only_lock()).
>   *
>   * Now, the task_struct fields mems_allowed and mempolicy may be changed
>   * by other task, we use alloc_lock in the task_struct fields to protect
> @@ -2410,6 +2411,28 @@ void __init cpuset_init_smp(void)
>  	BUG_ON(!cpuset_migrate_mm_wq);
>  }
>  
> +/**
> + * cpuset_read_only_lock - Grab the callback_lock from cpuset subsystem.
> + *
> + * Description: As described in full details the comment above cpuset_mutex
> + * and callback_lock definitions, holding callback_lock gives the holder
> + * read-only access to cpusets. Even though it might look counter-intuitive
> + * (as callback_lock is a spinlock), in fact a task must hold both
> + * callback_lock _and_ cpuset_mutex to modify cpusets (write access).
> + */
> +void cpuset_read_only_lock(void)
> +{
> +	raw_spin_lock(&callback_lock);
> +}
> +
> +/**
> + * cpuset_read_only_unlock - Release the callback_lock from cpuset subsystem.
> + */
> +void cpuset_read_only_unlock(void)
> +{
> +	raw_spin_unlock(&callback_lock);
> +}
> +

Maybe you can drop the "_only" part to be consistent with the rwlock
APIs (read_lock/write_lock).

Cheers,
Longman

