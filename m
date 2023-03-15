From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] sched/cpuset: Keep track of SCHED_DEADLINE tasks
 in cpusets
Date: Wed, 15 Mar 2023 19:27:40 -0400
Message-ID: <379691d7-6926-55aa-5c6e-c6e38002164e@redhat.com>
References: <20230315121812.206079-1-juri.lelli@redhat.com>
 <20230315121812.206079-3-juri.lelli@redhat.com>
 <7a3b31bf-4f6a-6525-9c6a-2bae44d7b0af@redhat.com>
 <ZBH9E7lCEXcFDBG4@localhost.localdomain>
 <2739c3ec-1e97-fc4d-8001-50283c94f4ff@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678922866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aLYdfmD7uUlzqBMDh+BqCtiyVRmjFzYdxVqjv+siHvY=;
        b=WhsDN8yBjGKeBpIYQBQ33jwtckxWIESrAkFhVmK4I2mHzvAkUBZ286WD/LgEaJn9qzpIh0
        ISvS5EmMrPCC8bNfkVbtw1RCm/GbwU8DIUf9PO8mxQWfUD20+F3UoapvqHImJYE2lvCzgH
        z/ffkuiCI1EjS8XX7IZu7g8jHDPOqH4=
Content-Language: en-US
In-Reply-To: <2739c3ec-1e97-fc4d-8001-50283c94f4ff-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7BfmgfxC/sS/w@public.gmane.org>

On 3/15/23 14:01, Waiman Long wrote:
>
> On 3/15/23 13:14, Juri Lelli wrote:
>> On 15/03/23 11:46, Waiman Long wrote:
>>> On 3/15/23 08:18, Juri Lelli wrote:
>>>> Qais reported that iterating over all tasks when rebuilding root 
>>>> domains
>>>> for finding out which ones are DEADLINE and need their bandwidth
>>>> correctly restored on such root domains can be a costly operation (10+
>>>> ms delays on suspend-resume).
>>>>
>>>> To fix the problem keep track of the number of DEADLINE tasks 
>>>> belonging
>>>> to each cpuset and then use this information (followup patch) to only
>>>> perform the above iteration if DEADLINE tasks are actually present in
>>>> the cpuset for which a corresponding root domain is being rebuilt.
>>>>
>>>> Reported-by: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
>>>> Signed-off-by: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>>    include/linux/cpuset.h |  4 ++++
>>>>    kernel/cgroup/cgroup.c |  4 ++++
>>>>    kernel/cgroup/cpuset.c | 25 +++++++++++++++++++++++++
>>>>    kernel/sched/core.c    | 10 ++++++++++
>>>>    4 files changed, 43 insertions(+)
>>>>
>>>> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
>>>> index 355f796c5f07..0348dba5680e 100644
>>>> --- a/include/linux/cpuset.h
>>>> +++ b/include/linux/cpuset.h
>>>> @@ -71,6 +71,8 @@ extern void cpuset_init_smp(void);
>>>>    extern void cpuset_force_rebuild(void);
>>>>    extern void cpuset_update_active_cpus(void);
>>>>    extern void cpuset_wait_for_hotplug(void);
>>>> +extern void inc_dl_tasks_cs(struct task_struct *task);
>>>> +extern void dec_dl_tasks_cs(struct task_struct *task);
>>>>    extern void cpuset_lock(void);
>>>>    extern void cpuset_unlock(void);
>>>>    extern void cpuset_cpus_allowed(struct task_struct *p, struct 
>>>> cpumask *mask);
>>>> @@ -196,6 +198,8 @@ static inline void cpuset_update_active_cpus(void)
>>>>    static inline void cpuset_wait_for_hotplug(void) { }
>>>> +static inline void inc_dl_tasks_cs(struct task_struct *task) { }
>>>> +static inline void dec_dl_tasks_cs(struct task_struct *task) { }
>>>>    static inline void cpuset_lock(void) { }
>>>>    static inline void cpuset_unlock(void) { }
>>>> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>>>> index c099cf3fa02d..357925e1e4af 100644
>>>> --- a/kernel/cgroup/cgroup.c
>>>> +++ b/kernel/cgroup/cgroup.c
>>>> @@ -57,6 +57,7 @@
>>>>    #include <linux/file.h>
>>>>    #include <linux/fs_parser.h>
>>>>    #include <linux/sched/cputime.h>
>>>> +#include <linux/sched/deadline.h>
>>>>    #include <linux/psi.h>
>>>>    #include <net/sock.h>
>>>> @@ -6673,6 +6674,9 @@ void cgroup_exit(struct task_struct *tsk)
>>>>        list_add_tail(&tsk->cg_list, &cset->dying_tasks);
>>>>        cset->nr_tasks--;
>>>> +    if (dl_task(tsk))
>>>> +        dec_dl_tasks_cs(tsk);
>>>> +
>>>>        WARN_ON_ONCE(cgroup_task_frozen(tsk));
>>>>        if (unlikely(!(tsk->flags & PF_KTHREAD) &&
>>>>                 test_bit(CGRP_FREEZE, &task_dfl_cgroup(tsk)->flags)))
>>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>>> index 8d82d66d432b..57bc60112618 100644
>>>> --- a/kernel/cgroup/cpuset.c
>>>> +++ b/kernel/cgroup/cpuset.c
>>>> @@ -193,6 +193,12 @@ struct cpuset {
>>>>        int use_parent_ecpus;
>>>>        int child_ecpus_count;
>>>> +    /*
>>>> +     * number of SCHED_DEADLINE tasks attached to this cpuset, so 
>>>> that we
>>>> +     * know when to rebuild associated root domain bandwidth 
>>>> information.
>>>> +     */
>>>> +    int nr_deadline_tasks;
>>>> +
>>>>        /* Invalid partition error code, not lock protected */
>>>>        enum prs_errcode prs_err;
>>>> @@ -245,6 +251,20 @@ static inline struct cpuset *parent_cs(struct 
>>>> cpuset *cs)
>>>>        return css_cs(cs->css.parent);
>>>>    }
>>>> +void inc_dl_tasks_cs(struct task_struct *p)
>>>> +{
>>>> +    struct cpuset *cs = task_cs(p);
>>>> +
>>>> +    cs->nr_deadline_tasks++;
>>>> +}
>>>> +
>>>> +void dec_dl_tasks_cs(struct task_struct *p)
>>>> +{
>>>> +    struct cpuset *cs = task_cs(p);
>>>> +
>>>> +    cs->nr_deadline_tasks--;
>>>> +}
>>>> +
>>>>    /* bits in struct cpuset flags field */
>>>>    typedef enum {
>>>>        CS_ONLINE,
>>>> @@ -2472,6 +2492,11 @@ static int cpuset_can_attach(struct 
>>>> cgroup_taskset *tset)
>>>>            ret = security_task_setscheduler(task);
>>>>            if (ret)
>>>>                goto out_unlock;
>>>> +
>>>> +        if (dl_task(task)) {
>>>> +            cs->nr_deadline_tasks++;
>>>> +            cpuset_attach_old_cs->nr_deadline_tasks--;
>>>> +        }
>>>>        }
>>> Any one of the tasks in the cpuset can cause the test to fail and 
>>> abort the
>>> attachment. I would suggest that you keep a deadline task transfer 
>>> count in
>>> the loop and then update cs and cpouset_attach_old_cs only after all 
>>> the
>>> tasks have been iterated successfully.
>> Right, Dietmar I think commented pointing out something along these
>> lines. Think though we already have this problem with current
>> task_can_attach -> dl_cpu_busy which reserves bandwidth for each tasks
>> in the destination cs. Will need to look into that. Do you know which
>> sort of operation would move multiple tasks at once?
>
> Actually, what I said previously may not be enough. There can be 
> multiple controllers attached to a cgroup. If any of thier 
> can_attach() calls fails, the whole transaction is aborted and 
> cancel_attach() will be called. My new suggestion is to add a new 
> deadline task transfer count into the cpuset structure and store the 
> information there temporarily. If cpuset_attach() is called, it means 
> all the can_attach calls succeed. You can then update the dl task 
> count accordingly and clear the temporary transfer count.
>
> I guess you may have to do something similar with dl_cpu_busy().

Another possibility is that you may record the cpu where the new DL 
bandwidth is allocated from in the task_struct. Then in 
cpuset_cancel_attach(), you can revert the dl_cpu_busy() change if DL 
tasks are in the css_set to be transferred. That will likely require 
having a DL task transfer count in the cpuset and iterating all the 
tasks to look for ones with a previously recorded cpu # if the transfer 
count is non-zero.

Cheers,
Longman

