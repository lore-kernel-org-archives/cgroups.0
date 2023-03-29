From: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 5/6] cgroup/cpuset: Free DL BW in case can_attach() fails
Date: Wed, 29 Mar 2023 18:39:23 +0200
Message-ID: <cdede77a-5dc5-8933-a444-a2046b074b12@arm.com>
References: <20230329125558.255239-1-juri.lelli@redhat.com>
 <20230329125558.255239-6-juri.lelli@redhat.com>
 <f8dfc30b-5079-2f44-7ab1-42ac25bd48b7@redhat.com>
 <f8baea06-eeda-439a-3699-1cad7cde659e@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <f8baea06-eeda-439a-3699-1cad7cde659e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>

On 29/03/2023 16:31, Waiman Long wrote:
> On 3/29/23 10:25, Waiman Long wrote:
>>
>> On 3/29/23 08:55, Juri Lelli wrote:
>>> From: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>

[...]

>>> @@ -2518,11 +2547,21 @@ static int cpuset_can_attach(struct
>>> cgroup_taskset *tset)
>>>   static void cpuset_cancel_attach(struct cgroup_taskset *tset)
>>>   {
>>>       struct cgroup_subsys_state *css;
>>> +    struct cpuset *cs;
>>>         cgroup_taskset_first(tset, &css);
>>> +    cs = css_cs(css);
>>>         mutex_lock(&cpuset_mutex);
>>> -    css_cs(css)->attach_in_progress--;
>>> +    cs->attach_in_progress--;
>>> +
>>> +    if (cs->nr_migrate_dl_tasks) {
>>> +        int cpu = cpumask_any(cs->effective_cpus);
>>> +
>>> +        dl_bw_free(cpu, cs->sum_migrate_dl_bw);
>>> +        reset_migrate_dl_data(cs);
>>> +    }
>>> +
> 
> Another nit that I have is that you may have to record also the cpu
> where the DL bandwidth is allocated in cpuset_can_attach() and free the
> bandwidth back into that cpu or there can be an underflow if another cpu
> is chosen.

Many thanks for the review!

But isn't the DL BW control `struct dl_bw` per `struct root_domain`
which is per exclusive cpuset. So as long cpu is from
`cs->effective_cpus` shouldn't this be fine?


