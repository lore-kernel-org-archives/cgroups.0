From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: BUG: HANG_DETECT waiting for migration_cpu_stop() complete
Date: Tue, 6 Sep 2022 16:40:03 -0400
Message-ID: <36a73401-7011-834a-7949-c65a2f66246c@redhat.com>
References: <88b2910181bda955ac46011b695c53f7da39ac47.camel@mediatek.com>
 <b605c3ec-94ab-a55f-5825-9b370d77ecf3@quicinc.com>
 <203d4614c1b2a498a240ace287156e9f401d5395.camel@mediatek.com>
 <YxeR0RoiTdm8sWCJ@slm.duckdns.org>
 <02b8e7b3-941d-8bb9-cd0e-992738893ba3@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662496811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FoDl8tkSYZjmN99yvp637ONt03t0JNDcmlNuO4E1yLY=;
        b=d3t7gED5Whg++DhojDYyRsc6HwT99iYwAC2PhWxuEyzUMOVugUa0Kcl4YSKVwfmiWfJvRk
        8S0G8SRFV+sQBL/X8g+tUmGtmdPePrmnSbW1M1t5MppfEbqSz/bHUdwX/8DLCeLgnRw4ab
        NyX+HCmI1alNL7FSzprGNxwBtb+6YnE=
Content-Language: en-US
In-Reply-To: <02b8e7b3-941d-8bb9-cd0e-992738893ba3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jing-Ting Wu <jing-ting.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Cc: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jonathan.JMChen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, "chris.redpath-5wv7dgnIgG8@public.gmane.org" <chris.redpath-5wv7dgnIgG8@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Vincent Donnefort <vdonnefort-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lixiong.liu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, wenju.xu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org


On 9/6/22 16:01, Waiman Long wrote:
> On 9/6/22 14:30, Tejun Heo wrote:
>> Hello,
>>
>> (cc'ing Waiman in case he has a better idea)
>>
>> On Mon, Sep 05, 2022 at 04:22:29PM +0800, Jing-Ting Wu wrote:
>>> https://lore.kernel.org/lkml/YvrWaml3F+x9Dk+T-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org/ is for
>>> fix cgroup_threadgroup_rwsem <-> cpus_read_lock() deadlock.
>>> But this issue is cgroup_threadgroup_rwsem <-> cpuset_rwsem deadlock.
>> If I'm understanding what you're writing correctly, this isn't a 
>> deadlock.
>> The cpuset_hotplug_workfn simply isn't being woken up while holding
>> cpuset_rwsem and others are just waiting for that lock to be released.
>
> I believe it is probably a bug in the scheduler core code. 
> __set_cpus_allowed_ptr_locked() calls affine_move_task() to move to a 
> random cpu within the new set allowable CPUs. However, if migration is 
> disabled, it shouldn't call affine_move_task() at all. Instead, I 
> would suggest that if the current cpu is within the new allowable 
> cpus, it should just skip doing affine_move_task(). Otherwise, it 
> should fail __set_cpus_allowed_ptr_locked().

Maybe like

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 838623b68031..5d9ea1553ec0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2794,9 +2794,9 @@ static int __set_cpus_allowed_ptr_locked(struct 
task_struct *p,
                 if (cpumask_equal(&p->cpus_mask, new_mask))
                         goto out;

-               if (WARN_ON_ONCE(p == current &&
-                                is_migration_disabled(p) &&
-                                !cpumask_test_cpu(task_cpu(p), 
new_mask))) {
+               if (is_migration_disabled(p) &&
+                   !cpumask_test_cpu(task_cpu(p), new_mask)) {
+                       WARN_ON_ONCE(p == current);
                         ret = -EBUSY;
                         goto out;
                 }
@@ -2818,7 +2818,11 @@ static int __set_cpus_allowed_ptr_locked(struct 
task_struct *p,
         if (flags & SCA_USER)
                 user_mask = clear_user_cpus_ptr(p);

-       ret = affine_move_task(rq, p, rf, dest_cpu, flags);
+       if (!is_migration_disabled(p) || (flags & SCA_MIGRATE_ENABLE)) {
+               ret = affine_move_task(rq, p, rf, dest_cpu, flags);
+       } else {
+               task_rq_unlock(rq, p, rf);
+       }

         kfree(user_mask);

I haven't tested it myself, though.

Cheers,
Longman

