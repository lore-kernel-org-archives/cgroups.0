From: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Subject: Re: BUG: HANG_DETECT waiting for migration_cpu_stop() complete
Date: Fri, 23 Sep 2022 19:50:04 +0530
Message-ID: <e6153b89-1f41-3fff-241b-a767e41a1e7e@quicinc.com>
References: <88b2910181bda955ac46011b695c53f7da39ac47.camel@mediatek.com>
 <b605c3ec-94ab-a55f-5825-9b370d77ecf3@quicinc.com>
 <203d4614c1b2a498a240ace287156e9f401d5395.camel@mediatek.com>
 <YxeR0RoiTdm8sWCJ@slm.duckdns.org>
 <02b8e7b3-941d-8bb9-cd0e-992738893ba3@redhat.com>
 <36a73401-7011-834a-7949-c65a2f66246c@redhat.com>
 <YxeylMvgc/wKcJqk@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=Amh2W25vG622JwDCDmZuOupC0Zg1Foj/eEoyphdMAS8=;
 b=ZDQ0t2RdHHOc4K74nEIKRrclnpRoQIPoDvtRY6RsiNluzgAwDRT97zKmuaj+brDB4iJk
 TSZK5woDXrUMYWdGcgy6RQMuicy4qzguj/E2SUyPWvSav1KYPNcgVtAZUu8JQGIrHiiM
 xijtdqdeFn4++LpPiTQzqiKJ3/FbjEwp7icbAtuYLGCmGpGhDdEYMLB5sLOPEth2dK3j
 MUboDEuKZgDDcx3w8l8rYSdjnvUB0F8XZZCsNCora26Kesu/KEiz0lYnZqpJGNJuB6vR
 QXEcVjD+qVYo9NtecmpjeGtlCDJBkm61wnc7x9NenNEp33cJY7kDqjbJhCZVfXAR4DRX 5g== 
Content-Language: en-US
In-Reply-To: <YxeylMvgc/wKcJqk-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jing-Ting Wu <jing-ting.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jonathan.JMChen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, "chris.redpath-5wv7dgnIgG8@public.gmane.org" <chris.redpath-5wv7dgnIgG8@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Vincent Donnefort <vdonnefort-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lixiong.liu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, wenju.xu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org

Hi Peter,


On 9/7/2022 2:20 AM, Peter Zijlstra wrote:
> On Tue, Sep 06, 2022 at 04:40:03PM -0400, Waiman Long wrote:
> 
> I've not followed the earlier stuff due to being unreadable; just
> reacting to this..

We are able to reproduce this issue explained at this link

https://lore.kernel.org/lkml/88b2910181bda955ac46011b695c53f7da39ac47.camel-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org/


> 
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 838623b68031..5d9ea1553ec0 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -2794,9 +2794,9 @@ static int __set_cpus_allowed_ptr_locked(struct
>> task_struct *p,
>>                  if (cpumask_equal(&p->cpus_mask, new_mask))
>>                          goto out;
>>
>> -               if (WARN_ON_ONCE(p == current &&
>> -                                is_migration_disabled(p) &&
>> -                                !cpumask_test_cpu(task_cpu(p), new_mask)))
>> {
>> +               if (is_migration_disabled(p) &&
>> +                   !cpumask_test_cpu(task_cpu(p), new_mask)) {
>> +                       WARN_ON_ONCE(p == current);
>>                          ret = -EBUSY;
>>                          goto out;
>>                  }
>> @@ -2818,7 +2818,11 @@ static int __set_cpus_allowed_ptr_locked(struct
>> task_struct *p,
>>          if (flags & SCA_USER)
>>                  user_mask = clear_user_cpus_ptr(p);
>>
>> -       ret = affine_move_task(rq, p, rf, dest_cpu, flags);
>> +       if (!is_migration_disabled(p) || (flags & SCA_MIGRATE_ENABLE)) {
>> +               ret = affine_move_task(rq, p, rf, dest_cpu, flags);
>> +       } else {
>> +               task_rq_unlock(rq, p, rf);
>> +       }
> 
> This cannot be right. There might be previous set_cpus_allowed_ptr()
> callers that are blocked and waiting for the task to land on a valid
> CPU.
> 

Was thinking if just skipping as below will help here, well i am not sure .

But thinking what if we keep the task as it is on the same cpu and let's 
wait for migration to be enabled for the task to take care of it later.

------------------->O------------------------------------------

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d90d37c..7717733 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2390,8 +2390,10 @@ static int migration_cpu_stop(void *data)
          * we're holding p->pi_lock.
          */
         if (task_rq(p) == rq) {
-               if (is_migration_disabled(p))
+               if (is_migration_disabled(p)) {
+                       complete = true;
                         goto out;
+               }

                 if (pending) {


-Mukesh
