From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 1/3] sched: Use user_cpus_ptr for saving user provided
 cpumask in sched_setaffinity()
Date: Thu, 18 Aug 2022 08:31:24 -0700
Message-ID: <81f06470-ad5b-2b92-86d6-dc2ca5d21d53@redhat.com>
References: <20220816192734.67115-1-longman@redhat.com>
 <20220816192734.67115-2-longman@redhat.com>
 <Yvyp02LLIQQPs5d6@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660836702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eTTQvzeO8NbT9iEosZSAoBf5nEuQJaIJbAqJp7WZFCk=;
        b=NpsWZm1Kmfu4yey6P3UXOxN19DlKzdvFKtVal361vZulW30i3P6nTbgj1xHHARzsljid2t
        gdLiCblqRrUIVk+SYAvNtBdQdSADpXpWAcohB+9MGtgoMdcirtvgDTElSRTMLRM35FW7id
        CXznb7195JFVJAa+X5QOHjD+nFHEHbs=
Content-Language: en-US
In-Reply-To: <Yvyp02LLIQQPs5d6-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 8/17/22 04:41, Peter Zijlstra wrote:
> On Tue, Aug 16, 2022 at 03:27:32PM -0400, Waiman Long wrote:
>> @@ -2981,25 +2969,21 @@ static int restrict_cpus_allowed_ptr(struct task_struct *p,
>>   		goto err_unlock;
>>   	}
>>   
>> -	if (!cpumask_and(new_mask, &p->cpus_mask, subset_mask)) {
>> +
>> +	if (p->user_cpus_ptr)
>> +		not_empty = cpumask_and(new_mask, p->user_cpus_ptr, subset_mask);
>> +	else
>> +		not_empty = cpumask_and(new_mask, cpu_online_mask, subset_mask);
>> +
>> +	if (!not_empty) {
>>   		err = -EINVAL;
>>   		goto err_unlock;
>>   	}
>>   
>> -	/*
>> -	 * We're about to butcher the task affinity, so keep track of what
>> -	 * the user asked for in case we're able to restore it later on.
>> -	 */
>> -	if (user_mask) {
>> -		cpumask_copy(user_mask, p->cpus_ptr);
>> -		p->user_cpus_ptr = user_mask;
>> -	}
>> -
>>   	return __set_cpus_allowed_ptr_locked(p, new_mask, 0, rq, &rf);
>>   
>>   err_unlock:
>>   	task_rq_unlock(rq, p, &rf);
>> -	kfree(user_mask);
>>   	return err;
>>   }
>>   
>> @@ -3049,34 +3033,27 @@ void force_compatible_cpus_allowed_ptr(struct task_struct *p)
>>   }
>>   
>>   static int
>> -__sched_setaffinity(struct task_struct *p, const struct cpumask *mask);
>> +__sched_setaffinity(struct task_struct *p, const struct cpumask *mask, bool save_mask);
>>   
>>   /*
>>    * Restore the affinity of a task @p which was previously restricted by a
>> - * call to force_compatible_cpus_allowed_ptr(). This will clear (and free)
>> - * @p->user_cpus_ptr.
>> + * call to force_compatible_cpus_allowed_ptr().
>>    *
>>    * It is the caller's responsibility to serialise this with any calls to
>>    * force_compatible_cpus_allowed_ptr(@p).
>>    */
>>   void relax_compatible_cpus_allowed_ptr(struct task_struct *p)
>>   {
>> -	struct cpumask *user_mask = p->user_cpus_ptr;
>> -	unsigned long flags;
>> +	const struct cpumask *user_mask = p->user_cpus_ptr;
>> +
>> +	if (!user_mask)
>> +		user_mask = cpu_online_mask;
>>   
>>   	/*
>> -	 * Try to restore the old affinity mask. If this fails, then
>> -	 * we free the mask explicitly to avoid it being inherited across
>> -	 * a subsequent fork().
>> +	 * Try to restore the old affinity mask with __sched_setaffinity().
>> +	 * Cpuset masking will be done there too.
>>   	 */
>> -	if (!user_mask || !__sched_setaffinity(p, user_mask))
>> -		return;
>> -
>> -	raw_spin_lock_irqsave(&p->pi_lock, flags);
>> -	user_mask = clear_user_cpus_ptr(p);
>> -	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
>> -
>> -	kfree(user_mask);
>> +	__sched_setaffinity(p, user_mask, false);
>>   }
>>   
>>   void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
>
> Would it not be simpler to write it something like so?
>
> ---
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 03053eebb22e..cdae4d50a588 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2955,7 +2955,6 @@ static int restrict_cpus_allowed_ptr(struct task_struct *p,
>   	struct rq_flags rf;
>   	struct rq *rq;
>   	int err;
> -	bool not_empty;
>   
>   	rq = task_rq_lock(p, &rf);
>   
> @@ -2969,13 +2968,7 @@ static int restrict_cpus_allowed_ptr(struct task_struct *p,
>   		goto err_unlock;
>   	}
>   
> -
> -	if (p->user_cpus_ptr)
> -		not_empty = cpumask_and(new_mask, p->user_cpus_ptr, subset_mask);
> -	else
> -		not_empty = cpumask_and(new_mask, cpu_online_mask, subset_mask);
> -
> -	if (!not_empty) {
> +	if (!cpumask_and(new_mask, task_user_cpus(p), subset_mask)) {
>   		err = -EINVAL;
>   		goto err_unlock;
>   	}
> @@ -3044,16 +3037,11 @@ __sched_setaffinity(struct task_struct *p, const struct cpumask *mask, bool save
>    */
>   void relax_compatible_cpus_allowed_ptr(struct task_struct *p)
>   {
> -	const struct cpumask *user_mask = p->user_cpus_ptr;
> -
> -	if (!user_mask)
> -		user_mask = cpu_online_mask;
> -
>   	/*
>   	 * Try to restore the old affinity mask with __sched_setaffinity().
>   	 * Cpuset masking will be done there too.
>   	 */
> -	__sched_setaffinity(p, user_mask, false);
> +	__sched_setaffinity(p, task_user_cpus(p), false);
>   }
>   
>   void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 15eefcd65faa..426e9b64b587 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -1881,6 +1881,13 @@ static inline void dirty_sched_domain_sysctl(int cpu)
>   #endif
>   
>   extern int sched_update_scaling(void);
> +
> +static inline const struct cpumask *task_user_cpus(struct task_struct *p)
> +{
> +	if (!p->user_cpus_ptr)
> +		return cpus_possible_mask; /* &init_task.cpus_mask */
> +	return p->user_cpus_ptr;
> +}
>   #endif /* CONFIG_SMP */
>   
>   #include "stats.h"
>
Thanks for the good suggestions, will make the changes.

Cheers,
Longman

