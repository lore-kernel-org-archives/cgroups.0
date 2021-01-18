From: Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 6/6] sched/deadline: Fixes cpu/rd/dl_bw references for
 suspended tasks
Date: Mon, 18 Jan 2021 14:17:43 +0100
Message-ID: <40b1f087-2411-8fb3-4aad-20791e63d940@redhat.com>
References: <cover.1610463999.git.bristot@redhat.com>
 <8c1cb0c850e2f3ab1d7a533aa4b33a30f9dbeda5.1610463999.git.bristot@redhat.com>
 <97875017-a6bb-98ea-83f9-82e95db58aca@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610975868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qskwrs9PcUI54IS2EGGfpMU4PDXQfqH5PObQuPS3H0M=;
        b=VjVw97lQqbybL65fIAWJPJc0X1JgSgA2kyo8p0Itbe+XfK2zPnlQnDzWfY0iH4mU0mIn8k
        VXfGdDHig7FENUQQ5ZwMTEPB3avAwE4kPVix6yVJf+NuND6gdtEiRU0mf8zk/iBDrxiasS
        hqjB6RX1ZdykjwQkYDBpUYAPCdO1yI8=
In-Reply-To: <97875017-a6bb-98ea-83f9-82e95db58aca-5wv7dgnIgG8@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Marco Perronet <perronet-41PbBDiSz5tAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 1/15/21 3:36 PM, Dietmar Eggemann wrote:
> On 12/01/2021 16:53, Daniel Bristot de Oliveira wrote:
> 
> [...]
> 
>> ----- %< -----
>>   #!/bin/bash
>>   # Enter on the cgroup directory
>>   cd /sys/fs/cgroup/
>>
>>   # Check it if is cgroup v2 and enable cpuset
>>   if [ -e cgroup.subtree_control ]; then
>>   	# Enable cpuset controller on cgroup v2
>>   	echo +cpuset > cgroup.subtree_control
>>   fi
>>
>>   echo LOG: create an exclusive cpuset and assigned the CPU 0 to it
>>   # Create cpuset groups
>>   rmdir dl-group &> /dev/null
>>   mkdir dl-group
>>
>>   # Restrict the task to the CPU 0
>>   echo 0 > dl-group/cpuset.mems
>>   echo 0 > dl-group/cpuset.cpus
>>   echo root >  dl-group/cpuset.cpus.partition
>>
>>   echo LOG: dispatching a regular task
>>   sleep 100 &
>>   CPUSET_PID="$!"
>>
>>   # let it settle down
>>   sleep 1
>>
>>   # Assign the second task to the cgroup
> 
> There is only one task 'CPUSET_PID' involved here?

Ooops, yep, I will remove the "second" part.

>>   echo LOG: moving the second DL task to the cpuset
>>   echo "$CPUSET_PID" > dl-group/cgroup.procs 2> /dev/null
>>
>>   CPUSET_ALLOWED=`cat /proc/$CPUSET_PID/status | grep Cpus_allowed_list | awk '{print $2}'`
>>
>>   chrt -p -d --sched-period 1000000000 --sched-runtime 100000000 0 $CPUSET_PID
>>   ACCEPTED=$?
>>
>>   if [ $ACCEPTED == 0 ]; then
>>   	echo PASS: the task became DL
>>   else
>>   	echo FAIL: the task was rejected as DL
>>   fi
> 
> [...]
> 
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 5961a97541c2..3c2775e6869f 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -5905,15 +5905,15 @@ static int __sched_setscheduler(struct task_struct *p,
>>  #ifdef CONFIG_SMP
>>  		if (dl_bandwidth_enabled() && dl_policy(policy) &&
>>  				!(attr->sched_flags & SCHED_FLAG_SUGOV)) {
>> -			cpumask_t *span = rq->rd->span;
>> +			struct root_domain *rd = dl_task_rd(p);
>>  
>>  			/*
>>  			 * Don't allow tasks with an affinity mask smaller than
>>  			 * the entire root_domain to become SCHED_DEADLINE. We
>>  			 * will also fail if there's no bandwidth available.
>>  			 */
>> -			if (!cpumask_subset(span, p->cpus_ptr) ||
>> -			    rq->rd->dl_bw.bw == 0) {
>> +			if (!cpumask_subset(rd->span, p->cpus_ptr) ||
>> +			    rd->dl_bw.bw == 0) {
>>  				retval = -EPERM;
>>  				goto unlock;
>>  			}
>> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
>> index c221e14d5b86..1f6264cb8867 100644
>> --- a/kernel/sched/deadline.c
>> +++ b/kernel/sched/deadline.c
>> @@ -2678,8 +2678,8 @@ int sched_dl_overflow(struct task_struct *p, int policy,
>>  	u64 period = attr->sched_period ?: attr->sched_deadline;
>>  	u64 runtime = attr->sched_runtime;
>>  	u64 new_bw = dl_policy(policy) ? to_ratio(period, runtime) : 0;
>> -	int cpus, err = -1, cpu = task_cpu(p);
>> -	struct dl_bw *dl_b = dl_bw_of(cpu);
>> +	int cpus, err = -1, cpu = dl_task_cpu(p);
>> +	struct dl_bw *dl_b = dl_task_root_bw(p);
>>  	unsigned long cap;
>>  
>>  	if (attr->sched_flags & SCHED_FLAG_SUGOV)
>>
> 
> Wouldn't it be sufficient to just introduce dl_task_cpu() and use the
> correct cpu to get rd->span or struct dl_bw in __sched_setscheduler()
> -> sched_dl_overflow()?

While I think that having the dl_task_rd() makes the code more intuitive, I have
no problem on not adding it...

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 5961a97541c2..0573f676696a 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5905,7 +5905,8 @@ static int __sched_setscheduler(struct task_struct *p,
>  #ifdef CONFIG_SMP
>                 if (dl_bandwidth_enabled() && dl_policy(policy) &&
>                                 !(attr->sched_flags & SCHED_FLAG_SUGOV)) {
> -                       cpumask_t *span = rq->rd->span;
> +                       int cpu = dl_task_cpu(p);
> +                       cpumask_t *span = cpu_rq(cpu)->rd->span;
>  
>                         /*
>                          * Don't allow tasks with an affinity mask smaller than
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index c221e14d5b86..308ecaaf3d28 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -2678,7 +2678,7 @@ int sched_dl_overflow(struct task_struct *p, int policy,
>         u64 period = attr->sched_period ?: attr->sched_deadline;
>         u64 runtime = attr->sched_runtime;
>         u64 new_bw = dl_policy(policy) ? to_ratio(period, runtime) : 0;
> -       int cpus, err = -1, cpu = task_cpu(p);
> +       int cpus, err = -1, cpu = dl_task_cpu(p);
>         struct dl_bw *dl_b = dl_bw_of(cpu);
>         unsigned long cap;
> 

This way works for me too.

Thanks!

-- Daniel

