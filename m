From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] sched: cpuset: Don't rebuild sched domains on
 suspend-resume
Date: Tue, 31 Jan 2023 14:33:40 -0500
Message-ID: <6587af4f-5012-ef33-8e0e-d6c43d662e43@redhat.com>
References: <20230120194822.962958-1-qyousef@layalina.io>
 <c4c2dec6-a72b-d675-fb42-be40e384ea2c@redhat.com>
 <20230125163546.pspvigh4groiwjy7@airbuntu>
 <45e0f8ea-d229-1ae7-5c12-7f0a64c6767a@redhat.com>
 <20230130130038.2qx3pkzut6ypqdub@airbuntu>
 <253ced33-c3a8-269f-90cc-b69e66b10370@redhat.com>
 <20230130194826.rxwk4ryvpyxemflm@airbuntu>
 <17537d7f-8734-2186-b27c-f39f3110ffe5@redhat.com>
 <20230131192223.jf3aydhafpmjg5z4@airbuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675193628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eK2YYGBTOGyQmg247Ozw7C64TaiZCT3FrZlIk4YE0l4=;
        b=Zm/9jE1EXcu6K7pyIbCkq9bW7Jvt0x4DWnTYGUFPt3I9dtif7j9c1gyvVGhl3TIf6gITHO
        6DPt5XVVh8ypSWug8taGJzy2n/hNDPNBBwg2gpNXPXiAEnWX7OMWhDV6e9MZvKvRpTITAo
        zc/WraYftqYj4fU6IfQ2mZYtuP40CP0=
Content-Language: en-US
In-Reply-To: <20230131192223.jf3aydhafpmjg5z4@airbuntu>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>


On 1/31/23 14:22, Qais Yousef wrote:
> On 01/30/23 14:57, Waiman Long wrote:
>> On 1/30/23 14:48, Qais Yousef wrote:
>>> On 01/30/23 11:29, Waiman Long wrote:
>>>> On 1/30/23 08:00, Qais Yousef wrote:
>>>>
>>>>           just skip the call here if the condition is right? Like
>>>>
>>>>                   /* rebuild sched domains if cpus_allowed has changed */
>>>>                   if (cpus_updated || (force_rebuild && !cpuhp_tasks_frozen)) {
>>>>                           force_rebuild = false;
>>>>                           rebuild_sched_domains();
>>>>                   }
>>>>
>>>>           Still, we will need to confirm that cpuhp_tasks_frozen will be cleared
>>>>           outside of the suspend/resume cycle.
>>>>
>>>>       I think it's fine to use this variable from the cpuhp callback context only.
>>>>       Which I think this cpuset workfn is considered an extension of.
>>>>
>>>>       But you're right, I can't use cpuhp_tasks_frozen directly in
>>>>       rebuild_root_domains() as I did in v1 because it doesn't get cleared after
>>>>       calling the last _cpu_up().
>>>>
>>>> That is what I suspect. So we can't use that cpuhp_tasks_frozen variable here
>>>> in cpuset.
>>>>
>>>>        force_rebuild will only be set after the last cpu
>>>>       is brought online though - so this should happen once at the end.
>>>>
>>>> Perhaps you can add another tracking variable for detecting if suspend/resume
>>>> is in progress.
>>> I think cpuhp_tasks_frozen is meant for that. All users who cared so far
>>> belonged to the cpuhp callback. I think reading it from cpuset_hotplug_workfn()
>>> is fine too as this function will only run as a consequence of the cpuhp
>>> callback AFAICS. cpuset_cpu_active() takes care of not forcing a rebuild of
>>> sched_domains until the last cpu becomes active - so the part of it being done
>>> once at the end at resume is handled too.
>> Well we will have to add code to clear cpuhp_tasks_frozen at the end of
>> resume then. We don't want to affect other callers unless we are sure that
>> it won't affect them.
> Actually I think since the cpuset_hotplug_workfn() is called later, there's
> a chance to race with another cpuhp operation just after resume.
>
> Anyway. I think we don't have to use this flag. But we'd have to better distill
> the reasons of why we force_rebuild.
>
> Your 2 new users are tripping me so far - do they handle errors where the shape
> of cpuset changes? If yes, then we must take dl accounting update into
> consideration for these errors.
The 2 new users is for the cpuset cpu partition which is used to create 
a secondary scheduling domain and hence have to call 
rebuilds_sched_domains() to set it up. Those should not be used that 
frequently.

>
> Juri, I'd still would appreciate a confirmation from you that I'm not
> understanding things completely wrong.
>
>>> It's just rebuild_sched_domains() will always assume it needs to clear and
>>> rebuild deadline accounting - which is not true for suspend/resume case. But
>>> now looking at other users of rebuild_sched_domains(), others might be getting
>>> the hit too. For example rebuild_sched_domains_locked() is called on
>>> update_relax_domain_level() which AFAIU should not impact dl accounting.
>>>
>>> FWIW, I did capture a worst case scenario of 21ms because of
>>> rebuild_root_domains().
>>>
>>> /me thinks rebuild_root_domains() is a misleading name too as it just fixes
>>> dl accounting but not rebuild the rd itself.
>>>
>>> What makes sense to me now is to pass whether dl accounting requires updating
>>> to rebuild_sched_domains() as an arg so that the caller can decide whether the
>>> reason can affect dl accounting.
>>>
>>> Or maybe pull rebuild_root_domains() out of the chain and let the caller call
>>> it directly. And probably rename it to update_do_rd_accounting() or something.
>>>
>>> I'll continue to dig more..
>> Looking forward to see that.
> Another thought I had is maybe worth trying to optimize the rebuild root domain
> process. Interestingly in my system there are no dl tasks but
>
> 	rebuilds_sched_domains()
> 	  cpuset_for_each_descendant_pre()
> 	    update_tasks_root_domain()
> 	      css_task_iter_next()
> 	        dl_add_task_root_domain()
>
> seems to be going through every task in the hierarchy anyway which would
> explain the slow down. We can have special variants to iterate through
> hierarchies that ever seen a dl task attached to them and a special variant to
> iterate through dl tasks only in a css - but I'm not sure if I'm brave enough
> to go down this rabbit hole :D

Yes, it seems like we have to check every tasks in the system to see if 
they are dl tasks. It can be expensive if there are a large number of 
tasks. Maybe we should track the # of dl tasks in each cgroup and skip 
this operation if there is none.

Cheers,
Longman

