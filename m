From: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: remove circular dependency deadlock
Date: Wed, 25 Oct 2017 14:09:54 +0530
Message-ID: <00043e79-3647-3979-07bb-27039921efb4@codeaurora.org>
References: <1504792583-10424-1-git-send-email-prsood@codeaurora.org>
 <20170907175107.GG17526@worktop.programming.kicks-ass.net>
 <4668d1ec-dc43-8a9c-4f94-a421683d3c17@codeaurora.org>
 <20171011094833.pdp4torvotvjdmkt@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1508920800;
        bh=/IsLUDljkxqni1zpo8mUasK7JmT4Vf3sZyDBFtKqdbE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=WIOd7DHEkSa4mAP3Ilx6HOgzOfqEGdB7al7d7xk/QVSYLH0ak/OT9nWVoMnjcIYIn
         RTIBUdm+fFsaDUO6QReKI4BCDN13CxCWpDI3iBqgmOYb6Pbx9cq3ctV+Nmtu9W1GkO
         rxWd7oP+RNO+KXa78iTwGJkjOIdMAnumBiR9eqBY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1508920799;
        bh=/IsLUDljkxqni1zpo8mUasK7JmT4Vf3sZyDBFtKqdbE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=mHlhHb98KxS/9RMpz6fMTY7eJidyb3GXyzyG1rxJ9rHGfpJUPnxydVEl3JDiPnrQp
         SLAJq9wsqMLuAIYALUbx61EFKPM9KqQrkZHqZJrufCP4By5O84D7/CZCL2sfNj9B7r
         n5rMyv7rKfa28BgyqS7i5PjmTlleik0eKidDGPQQ=
In-Reply-To: <20171011094833.pdp4torvotvjdmkt-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

On 10/11/2017 03:18 PM, Peter Zijlstra wrote:
> On Mon, Oct 09, 2017 at 06:57:46PM +0530, Prateek Sood wrote:
>> On 09/07/2017 11:21 PM, Peter Zijlstra wrote:
> 
>>> But if you invert these locks, the need for cpuset_hotplug_workfn() goes
>>> away, at least for the CPU part, and we can make in synchronous again.
>>> Yay!!
> 
>> The callback making a call to cpuset_hotplug_workfn()in hotplug path are
>>         [CPUHP_AP_ACTIVE] = {
>>                 .name                   = "sched:active",
>>                 .startup.single         = sched_cpu_activate,
>>                 .teardown.single        = sched_cpu_deactivate,
>>         },
>>
>> if we make cpuset_hotplug_workfn() synchronous, deadlock might happen:
>> _cpu_down()
>>    cpus_write_lock()  //held
>>       cpuhp_kick_ap_work()
>>         cpuhp_kick_ap()
>>            __cpuhp_kick_ap()
>>               wake_up_process() //cpuhp_thread_fun
>>                 wait_for_ap_thread() //wait for complete from cpuhp_thread_fun()
>>
>> cpuhp_thread_fun()
>>    cpuhp_invoke_callback()
>>      sched_cpu_deactivate()
>>        cpuset_cpu_inactive()
>>           cpuset_update_active_cpus()
>>              cpuset_hotplug_work()
>>                 rebuild_sched_domains()
>>                    cpus_read_lock() //waiting as acquired in _cpu_down()
> 
> Well, duh, don't use rebuild_sched_domains() 'obviously' :-) use
> rebuild_sched_domains_cpuslocked() instead and it works just fine.
> 
> After applying your patch, the below boots and survives a hotplug.
> 
> ---
>  include/linux/cpuset.h |    6 ------
>  kernel/cgroup/cpuset.c |   30 +++++++++---------------------
>  kernel/power/process.c |    2 --
>  kernel/sched/core.c    |    1 -
>  4 files changed, 9 insertions(+), 30 deletions(-)
> 
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -51,9 +51,7 @@ static inline void cpuset_dec(void)
>  
>  extern int cpuset_init(void);
>  extern void cpuset_init_smp(void);
> -extern void cpuset_force_rebuild(void);
>  extern void cpuset_update_active_cpus(void);
> -extern void cpuset_wait_for_hotplug(void);
>  extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
>  extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
>  extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
> @@ -166,15 +164,11 @@ static inline bool cpusets_enabled(void)
>  static inline int cpuset_init(void) { return 0; }
>  static inline void cpuset_init_smp(void) {}
>  
> -static inline void cpuset_force_rebuild(void) { }
> -
>  static inline void cpuset_update_active_cpus(void)
>  {
>  	partition_sched_domains(1, NULL, NULL);
>  }
>  
> -static inline void cpuset_wait_for_hotplug(void) { }
> -
>  static inline void cpuset_cpus_allowed(struct task_struct *p,
>  				       struct cpumask *mask)
>  {
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -833,7 +833,12 @@ static void rebuild_sched_domains_cpuslo
>  	cpumask_var_t *doms;
>  	int ndoms;
>  
> +	/*
> +	 * When called during hotplug, this lock is held by the calling
> +	 * thread, not cpuhp_thread_fun :/
> +	 *
>  	lockdep_assert_cpus_held();
> +	 */
>  	lockdep_assert_held(&cpuset_mutex);
>  
>  	/*
> @@ -2281,13 +2286,6 @@ static void cpuset_hotplug_update_tasks(
>  	mutex_unlock(&cpuset_mutex);
>  }
>  
> -static bool force_rebuild;
> -
> -void cpuset_force_rebuild(void)
> -{
> -	force_rebuild = true;
> -}
> -
>  /**
>   * cpuset_hotplug_workfn - handle CPU/memory hotunplug for a cpuset
>   *
> @@ -2362,25 +2360,15 @@ static void cpuset_hotplug_workfn(struct
>  	}
>  
>  	/* rebuild sched domains if cpus_allowed has changed */
> -	if (cpus_updated || force_rebuild) {
> -		force_rebuild = false;
> +	if (cpus_updated)
>  		rebuild_sched_domains();
> -	}
>  }
>  
>  void cpuset_update_active_cpus(void)
>  {
> -	/*
> -	 * We're inside cpu hotplug critical region which usually nests
> -	 * inside cgroup synchronization.  Bounce actual hotplug processing
> -	 * to a work item to avoid reverse locking order.
> -	 */
> -	schedule_work(&cpuset_hotplug_work);
> -}
> -
> -void cpuset_wait_for_hotplug(void)
> -{
> -	flush_work(&cpuset_hotplug_work);
> +	mutex_lock(&cpuset_mutex);
> +	rebuild_sched_domains_cpuslocked();
> +	mutex_unlock(&cpuset_mutex);
>  }
>  
>  /*
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -203,8 +203,6 @@ void thaw_processes(void)
>  	__usermodehelper_set_disable_depth(UMH_FREEZING);
>  	thaw_workqueues();
>  
> -	cpuset_wait_for_hotplug();
> -
>  	read_lock(&tasklist_lock);
>  	for_each_process_thread(g, p) {
>  		/* No other threads should have PF_SUSPEND_TASK set */
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5598,7 +5598,6 @@ static void cpuset_cpu_active(void)
>  		 * restore the original sched domains by considering the
>  		 * cpuset configurations.
>  		 */
> -		cpuset_force_rebuild();
>  	}
>  	cpuset_update_active_cpus();
>  }
> 


Thanks Peter for sharing the patch and test results.

>  void cpuset_update_active_cpus(void)
>  {
> -	/*
> -	 * We're inside cpu hotplug critical region which usually nests
> -	 * inside cgroup synchronization.  Bounce actual hotplug processing
> -	 * to a work item to avoid reverse locking order.
> -	 */
> -	schedule_work(&cpuset_hotplug_work);
> -}
> -
> -void cpuset_wait_for_hotplug(void)
> -{
> -	flush_work(&cpuset_hotplug_work);
> +	mutex_lock(&cpuset_mutex);
> +	rebuild_sched_domains_cpuslocked();
> +	mutex_unlock(&cpuset_mutex);
>  }

In the above patch rebuild_sched_domains_cpuslocked() has been
used directly. Earlier cpuset_hotplug_update_tasks() was also
called from cpuset_hotplug_workfn(). So migration of tasks
related to cgroup which has empty cpuset would not happen
during cpu hotplug.


Could you please help in understanding more on this.



-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
