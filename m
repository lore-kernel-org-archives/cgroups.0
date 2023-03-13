From: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3] sched: cpuset: Don't rebuild root domains on
 suspend-resume
Date: Mon, 13 Mar 2023 18:10:49 +0100
Message-ID: <7070da53-a5a7-6965-5604-abee3cae9d46@arm.com>
References: <20230228174627.vja5aejq27dsta2u@airbuntu>
 <Y/7/SLzvK8LfB29z@localhost.localdomain>
 <20230301122852.zgzreby42lh2zf6w@airbuntu>
 <Y/9gmDRlGOChIwpf@localhost.localdomain>
 <20230301170322.xthlso7jfkixlyex@airbuntu>
 <ZAhhGi55BkYkc3ss@localhost.localdomain>
 <CA+khW7hmE0tECG2qfKW1HN9yLVOLUn5Zzx4Rz-wHYDtSUPYotw@mail.gmail.com>
 <ZAmCzJQZl7j/m2oN@localhost.localdomain>
 <CA+khW7iAeTALH5b6upHXs1RotFBohVeZCcAp5H+r-=L05kqnww@mail.gmail.com>
 <20230311185150.stvtcbdkoofgn3wd@airbuntu>
 <ZA9RZ3VvGXKp+1L6@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <ZA9RZ3VvGXKp+1L6-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
Cc: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On 13/03/2023 17:37, Juri Lelli wrote:
> On 11/03/23 18:51, Qais Yousef wrote:
>> On 03/09/23 14:23, Hao Luo wrote:
>>> On Wed, Mar 8, 2023 at 10:55 PM Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>>>
>>>> On 08/03/23 10:01, Hao Luo wrote:
>>>>> On Wed, Mar 8, 2023 at 2:20 AM Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>>>>>
>>>>>> On 01/03/23 17:03, Qais Yousef wrote:
>>>>>>> On 03/01/23 15:26, Juri Lelli wrote:

[...]

>> Yeah I am working on 5.10 too (this will need to be backported to 5.10 and 5.15
>> ultimately) and had the same crash because task is NULL.
>>
>> Fixed it this way which I think what you intended to do Juri? It moves the
>> check for dl_task(task) inside cgroup_taskset_for_each() loop.
>>
>> 	diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> 	index 83a8943467fb..06d6bb68d86b 100644
>> 	--- a/kernel/cgroup/cpuset.c
>> 	+++ b/kernel/cgroup/cpuset.c
>> 	@@ -2495,11 +2495,11 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>> 			ret = security_task_setscheduler(task);
>> 			if (ret)
>> 				goto out_unlock;
>> 	-       }
>> 	 
>> 	-       if (dl_task(task)) {
>> 	-               cs->deadline_tasks++;
>> 	-               cpuset_attach_old_cs->deadline_tasks--;
>> 	+               if (dl_task(task)) {
>> 	+                       cs->deadline_tasks++;
>> 	+                       cpuset_attach_old_cs->deadline_tasks--;
>> 	+               }
>> 		}
>> 	 
>> 		/*
> 
> Duh, indeed.
> 
>> Like Hao I don't have any deadline tasks in the system. With the fix above
>> I don't notice the delay on suspend resume using your patches.
> 
> OK, cool.
> 
>> If you want any debug; please feel free to add them into your branch so I can
>> run with that and give you the log.
> 
> Will need to find time to run some tests with DEADLINE tasks, yeah.
> Maybe Dietmar, since you reported as well the issue above with your
> testing, you could help with testing DEADLINE?

Ah, now I see! It's the same issue I saw. And it's not specifically
related to DL tasks. Any tasks which you move into a cpuset will trigger
this.
Yeah, can do some DL tests later on this fix.
