From: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3] sched: cpuset: Don't rebuild root domains on
 suspend-resume
Date: Mon, 13 Mar 2023 13:37:48 +0100
Message-ID: <e81ffc13-a89e-d43e-18d1-10d9e0161638@arm.com>
References: <20230206221428.2125324-1-qyousef@layalina.io>
 <20230223153859.37tqoqk33oc6tv7o@airbuntu>
 <5f087dd8-3e39-ce83-fe24-afa5179c05d9@arm.com>
 <20230227205725.dipvh3i7dvyrv4tv@airbuntu>
 <5a1e58bf-7eb2-bd7a-7e19-7864428a2b83@arm.com>
 <20230228174627.vja5aejq27dsta2u@airbuntu>
 <Y/7/SLzvK8LfB29z@localhost.localdomain>
 <20230301122852.zgzreby42lh2zf6w@airbuntu>
 <Y/9gmDRlGOChIwpf@localhost.localdomain>
 <20230301170322.xthlso7jfkixlyex@airbuntu>
 <ZAhhGi55BkYkc3ss@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <ZAhhGi55BkYkc3ss-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On 08/03/2023 11:19, Juri Lelli wrote:
> On 01/03/23 17:03, Qais Yousef wrote:
>> On 03/01/23 15:26, Juri Lelli wrote:
>>> On 01/03/23 12:28, Qais Yousef wrote:
>>>> On 03/01/23 08:31, Juri Lelli wrote:
>>>
>>> ...
>>>
>>>>> Not ignoring you guys here, but it turns out I'm quite bogged down with
>>>>> other stuff at the moment. :/ So, apologies and I'll try to get to this
>>>>> asap. Thanks a lot for all your efforts and time reviewing so far!
>>>>
>>>> Np, I can feel you :-)
>>>
>>> Eh. :/
>>
>> I hope I did not offend. That was meant as no pressure, I understand.
> 
> No offence at all! I meant "we are all on the same boat it seems". :)
> 
>>> BTW, do you have a repro script of some sort handy I might play with?
>>
>> Sorry no. You'll just need to suspend to ram. I had a simple patch to measure
>> the time around the call and trace_printk'ed the result.
>>
>> I was working on a android phone which just suspends to ram if you turn the
>> screen off and disconnect the usb.
> 
> Looks like I could come up with the following
> 
> https://github.com/jlelli/linux.git deadline/rework-cpusets
> https://github.com/jlelli/linux/tree/deadline/rework-cpusets
> 
> which I don't think it's at a point that I feel comfortable to propose
> as an RFC (not even sure if it actually makes sense), but it survived my
> very light testing.
> 
> Could you please take a look and, if it makes some sense in theory, give
> it a try on your end?

sched/cpuset: Keep track of SCHED_DEADLINE task in cpusets

@@ -2474,6 +2494,11 @@ static int cpuset_can_attach(struct
cgroup_taskset *tset)
                        goto out_unlock;
        }

+       if (dl_task(task)) {
+               cs->deadline_tasks++;
+               cpuset_attach_old_cs->deadline_tasks--;
+       }
+

This one looks odd. task is NULL here ?

If you move a DL task from one cpuset to another this happens now:

root@juno:~# ps2 | grep DLN
   82    82 140      0   - DLN sugov:0
   83    83 140      0   - DLN sugov:1
 1615  1616 140      0   - DLN thread0-0
 1615  1617 140      0   - DLN thread0-1
 1615  1618 140      0   - DLN thread0-2
 1615  1619 140      0   - DLN thread0-3
 1615  1620 140      0   - DLN thread0-4
 1615  1621 140      0   - DLN thread0-5
 1615  1622 140      0   - DLN thread0-6
 1615  1623 140      0   - DLN thread0-7
 1615  1624 140      0   - DLN thread0-8
 1615  1625 140      0   - DLN thread0-9
 1615  1626 140      0   - DLN thread0-10
 1615  1627 140      0   - DLN thread0-11 <--

root@juno:~# cd /sys/fs/cgroup/cpuset
root@juno:~# mkdir cs1
root@juno:~# echo 0 > cs1/cpuset.mems
root@juno:~# echo 0,3-5 > cs1/cpuset.cpus

root@juno:~# echo 1627 > cs1/tasks

root@juno:~# [  154.968900] *** task=0000000000000000

[...]
