From: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] sched/cpuset: Keep track of SCHED_DEADLINE tasks
 in cpusets
Date: Wed, 22 Mar 2023 15:05:25 +0100
Message-ID: <848c4fb3-d3c4-a7f0-9df8-9b25c537f42c@arm.com>
References: <20230315121812.206079-1-juri.lelli@redhat.com>
 <20230315121812.206079-3-juri.lelli@redhat.com>
 <7a3b31bf-4f6a-6525-9c6a-2bae44d7b0af@redhat.com>
 <ZBH9E7lCEXcFDBG4@localhost.localdomain>
 <2739c3ec-1e97-fc4d-8001-50283c94f4ff@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <2739c3ec-1e97-fc4d-8001-50283c94f4ff-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>

On 15/03/2023 19:01, Waiman Long wrote:
> 
> On 3/15/23 13:14, Juri Lelli wrote:
>> On 15/03/23 11:46, Waiman Long wrote:
>>> On 3/15/23 08:18, Juri Lelli wrote:

[...]

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
>>> the loop and then update cs and cpouset_attach_old_cs only after all the
>>> tasks have been iterated successfully.
>> Right, Dietmar I think commented pointing out something along these
>> lines. Think though we already have this problem with current
>> task_can_attach -> dl_cpu_busy which reserves bandwidth for each tasks
>> in the destination cs. Will need to look into that. Do you know which
>> sort of operation would move multiple tasks at once?
> 
> Actually, what I said previously may not be enough. There can be
> multiple controllers attached to a cgroup. If any of thier can_attach()
> calls fails, the whole transaction is aborted and cancel_attach() will
> be called. My new suggestion is to add a new deadline task transfer
> count into the cpuset structure and store the information there
> temporarily. If cpuset_attach() is called, it means all the can_attach
> calls succeed. You can then update the dl task count accordingly and
> clear the temporary transfer count.
> 
> I guess you may have to do something similar with dl_cpu_busy().

I gave it a shot:

https://lkml.kernel.org/r/20230322135959.1998790-1-dietmar.eggemann-5wv7dgnIgG8@public.gmane.org
