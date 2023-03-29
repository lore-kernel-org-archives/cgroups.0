From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/6] cgroup/cpuset: Free DL BW in case can_attach() fails
Date: Wed, 29 Mar 2023 10:31:15 -0400
Message-ID: <f8baea06-eeda-439a-3699-1cad7cde659e@redhat.com>
References: <20230329125558.255239-1-juri.lelli@redhat.com>
 <20230329125558.255239-6-juri.lelli@redhat.com>
 <f8dfc30b-5079-2f44-7ab1-42ac25bd48b7@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680100477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rg0hjjPhbd8bR4OyWVmG4r7qsayd0ZEyOdGiFaBs47s=;
        b=Nmphvaagz89Cdp6BCLC4igWdJMeDLqJl44XRVzJrCY5Nrv9oACwp73LeC/ACducgkxSmFE
        wsgI2URzlk5kPrjy7NmAB2GGHwPY1K2QSTsrbwtx1keybe6UjssZV9wVFzgcf8uY9mT0ye
        yWO4ptQkHKbneKundcqkHU1aeJDn+HQ=
Content-Language: en-US
In-Reply-To: <f8dfc30b-5079-2f44-7ab1-42ac25bd48b7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>

On 3/29/23 10:25, Waiman Long wrote:
>
> On 3/29/23 08:55, Juri Lelli wrote:
>> From: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
>>
>> cpuset_can_attach() can fail. Postpone DL BW allocation until all tasks
>> have been checked. DL BW is not allocated per-task but as a sum over
>> all DL tasks migrating.
>>
>> If multiple controllers are attached to the cgroup next to the cuset
> Typo: : "cuset" => "cpuset"
>> controller a non-cpuset can_attach() can fail. In this case free DL BW
>> in cpuset_cancel_attach().
>>
>> Finally, update cpuset DL task count (nr_deadline_tasks) only in
>> cpuset_attach().
>>
>> Suggested-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
>> Signed-off-by: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>   include/linux/sched.h  |  2 +-
>>   kernel/cgroup/cpuset.c | 55 ++++++++++++++++++++++++++++++++++++++----
>>   kernel/sched/core.c    | 17 ++-----------
>>   3 files changed, 53 insertions(+), 21 deletions(-)
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 6f3d84e0ed08..50cbbfefbe11 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1847,7 +1847,7 @@ current_restore_flags(unsigned long orig_flags, 
>> unsigned long flags)
>>   }
>>     extern int cpuset_cpumask_can_shrink(const struct cpumask *cur, 
>> const struct cpumask *trial);
>> -extern int task_can_attach(struct task_struct *p, const struct 
>> cpumask *cs_effective_cpus);
>> +extern int task_can_attach(struct task_struct *p);
>>   extern int dl_bw_alloc(int cpu, u64 dl_bw);
>>   extern void dl_bw_free(int cpu, u64 dl_bw);
>>   #ifdef CONFIG_SMP
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index eb0854ef9757..f8ebec66da51 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -198,6 +198,8 @@ struct cpuset {
>>        * know when to rebuild associated root domain bandwidth 
>> information.
>>        */
>>       int nr_deadline_tasks;
>> +    int nr_migrate_dl_tasks;
>> +    u64 sum_migrate_dl_bw;
>>         /* Invalid partition error code, not lock protected */
>>       enum prs_errcode prs_err;
>> @@ -2464,16 +2466,23 @@ static int fmeter_getrate(struct fmeter *fmp)
>>     static struct cpuset *cpuset_attach_old_cs;
>>   +static void reset_migrate_dl_data(struct cpuset *cs)
>> +{
>> +    cs->nr_migrate_dl_tasks = 0;
>> +    cs->sum_migrate_dl_bw = 0;
>> +}
>> +
>>   /* Called by cgroups to determine if a cpuset is usable; 
>> cpuset_mutex held */
>>   static int cpuset_can_attach(struct cgroup_taskset *tset)
>>   {
>>       struct cgroup_subsys_state *css;
>> -    struct cpuset *cs;
>> +    struct cpuset *cs, *oldcs;
>>       struct task_struct *task;
>>       int ret;
>>         /* used later by cpuset_attach() */
>>       cpuset_attach_old_cs = task_cs(cgroup_taskset_first(tset, &css));
>> +    oldcs = cpuset_attach_old_cs;
>>       cs = css_cs(css);
>>         mutex_lock(&cpuset_mutex);
>> @@ -2491,7 +2500,7 @@ static int cpuset_can_attach(struct 
>> cgroup_taskset *tset)
>>           goto out_unlock;
>>         cgroup_taskset_for_each(task, css, tset) {
>> -        ret = task_can_attach(task, cs->effective_cpus);
>> +        ret = task_can_attach(task);
>>           if (ret)
>>               goto out_unlock;
>>           ret = security_task_setscheduler(task);
>> @@ -2499,11 +2508,31 @@ static int cpuset_can_attach(struct 
>> cgroup_taskset *tset)
>>               goto out_unlock;
>>             if (dl_task(task)) {
>> -            cs->nr_deadline_tasks++;
>> -            cpuset_attach_old_cs->nr_deadline_tasks--;
>> +            cs->nr_migrate_dl_tasks++;
>> +            cs->sum_migrate_dl_bw += task->dl.dl_bw;
>> +        }
>> +    }
>> +
>> +    if (!cs->nr_migrate_dl_tasks)
>> +        goto out_succes;
>> +
>> +    if (!cpumask_intersects(oldcs->effective_cpus, 
>> cs->effective_cpus)) {
>> +        int cpu = cpumask_any_and(cpu_active_mask, cs->effective_cpus);
>> +
>> +        if (unlikely(cpu >= nr_cpu_ids)) {
>> +            reset_migrate_dl_data(cs);
>> +            ret = -EINVAL;
>> +            goto out_unlock;
>> +        }
>> +
>> +        ret = dl_bw_alloc(cpu, cs->sum_migrate_dl_bw);
>> +        if (ret) {
>> +            reset_migrate_dl_data(cs);
>> +            goto out_unlock;
>>           }
>>       }
>>   +out_succes:
>>       /*
>>        * Mark attach is in progress.  This makes validate_change() fail
>>        * changes which zero cpus/mems_allowed.
>> @@ -2518,11 +2547,21 @@ static int cpuset_can_attach(struct 
>> cgroup_taskset *tset)
>>   static void cpuset_cancel_attach(struct cgroup_taskset *tset)
>>   {
>>       struct cgroup_subsys_state *css;
>> +    struct cpuset *cs;
>>         cgroup_taskset_first(tset, &css);
>> +    cs = css_cs(css);
>>         mutex_lock(&cpuset_mutex);
>> -    css_cs(css)->attach_in_progress--;
>> +    cs->attach_in_progress--;
>> +
>> +    if (cs->nr_migrate_dl_tasks) {
>> +        int cpu = cpumask_any(cs->effective_cpus);
>> +
>> +        dl_bw_free(cpu, cs->sum_migrate_dl_bw);
>> +        reset_migrate_dl_data(cs);
>> +    }
>> +

Another nit that I have is that you may have to record also the cpu 
where the DL bandwidth is allocated in cpuset_can_attach() and free the 
bandwidth back into that cpu or there can be an underflow if another cpu 
is chosen.

Cheers,
Longman

