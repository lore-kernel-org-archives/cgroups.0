From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: BUG: HANG_DETECT waiting for migration_cpu_stop() complete
Date: Tue, 6 Sep 2022 17:02:20 -0400
Message-ID: <879886ba-7d77-11fc-5357-b21e141637ef@redhat.com>
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
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662498145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wOjFY7tNKFL7dFNVA6yx/TeGWvfp5wOKn+I8yQQqSS4=;
        b=Ju1onuYKug+swmkdBSR2v9LEcsyecazwiRANYZ+KIu+KoHu6PWTbDpqtyuxhN05GZ9v+8L
        13I/ulcBuKPc5Lk+yG/+l8MbFAbHj6oopJ3q/DZ4KhH3wjohejS6VB/V48CeyOpVsCLI9I
        8gBMWMaF0AY/0KNEyOGFqYstH12kp1M=
Content-Language: en-US
In-Reply-To: <YxeylMvgc/wKcJqk-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jing-Ting Wu <jing-ting.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jonathan.JMChen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, "chris.redpath-5wv7dgnIgG8@public.gmane.org" <chris.redpath-5wv7dgnIgG8@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Vincent Donnefort <vdonnefort-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lixiong.liu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, wenju.xu


On 9/6/22 16:50, Peter Zijlstra wrote:
> On Tue, Sep 06, 2022 at 04:40:03PM -0400, Waiman Long wrote:
>
> I've not followed the earlier stuff due to being unreadable; just
> reacting to this..
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
> This cannot be right. There might be previous set_cpus_allowed_ptr()
> callers that are blocked and waiting for the task to land on a valid
> CPU.

You are probably right. I haven't fully understand all the migration 
disable code yet. However, if migration is disabled, there are some 
corner cases we need to handle properly.

Cheers,
Longman

