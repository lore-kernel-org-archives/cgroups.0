From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/6] cgroup/cpuset: Free DL BW in case can_attach() fails
Date: Thu, 30 Mar 2023 12:13:02 -0400
Message-ID: <3268bedc-ee36-519a-de37-3c366129baae@redhat.com>
References: <20230329125558.255239-1-juri.lelli@redhat.com>
 <20230329125558.255239-6-juri.lelli@redhat.com>
 <f8dfc30b-5079-2f44-7ab1-42ac25bd48b7@redhat.com>
 <f8baea06-eeda-439a-3699-1cad7cde659e@redhat.com>
 <cdede77a-5dc5-8933-a444-a2046b074b12@arm.com>
 <b7ad39b1-c615-3ebc-6980-d9db0f2ab0a0@redhat.com>
 <5ff103f9-1366-0a9b-bd97-419ced1de07f@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680192796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i+HJ4WLfm8Z01D2cI/A0RfbJSBHfv/6mLfrOQoLhihI=;
        b=co7ujp5qUL/OpZZaSoZ6+Dx7Tcxuhv27nma2OYyKSZKHxTZDWicCEkcpMX/2QsVDfcvpZ1
        72Q63JbZ6o/UEXSbpTgBsjzkpgyPk8f0MhK9kMdoCC8YFiGn7Cys+wpazleH3lok4D8KU6
        LYnLALnlx65YEs496mkG7nihTPMyyTk=
Content-Language: en-US
In-Reply-To: <5ff103f9-1366-0a9b-bd97-419ced1de07f-5wv7dgnIgG8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>

On 3/30/23 11:14, Dietmar Eggemann wrote:
> On 29/03/2023 20:09, Waiman Long wrote:
>> On 3/29/23 12:39, Dietmar Eggemann wrote:
>>> On 29/03/2023 16:31, Waiman Long wrote:
>>>> On 3/29/23 10:25, Waiman Long wrote:
>>>>> On 3/29/23 08:55, Juri Lelli wrote:
>>>>>> From: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
>>> [...]
>>>
>>>>>> @@ -2518,11 +2547,21 @@ static int cpuset_can_attach(struct
>>>>>> cgroup_taskset *tset)
>>>>>>     static void cpuset_cancel_attach(struct cgroup_taskset *tset)
>>>>>>     {
>>>>>>         struct cgroup_subsys_state *css;
>>>>>> +    struct cpuset *cs;
>>>>>>           cgroup_taskset_first(tset, &css);
>>>>>> +    cs = css_cs(css);
>>>>>>           mutex_lock(&cpuset_mutex);
>>>>>> -    css_cs(css)->attach_in_progress--;
>>>>>> +    cs->attach_in_progress--;
>>>>>> +
>>>>>> +    if (cs->nr_migrate_dl_tasks) {
>>>>>> +        int cpu = cpumask_any(cs->effective_cpus);
>>>>>> +
>>>>>> +        dl_bw_free(cpu, cs->sum_migrate_dl_bw);
>>>>>> +        reset_migrate_dl_data(cs);
>>>>>> +    }
>>>>>> +
>>>> Another nit that I have is that you may have to record also the cpu
>>>> where the DL bandwidth is allocated in cpuset_can_attach() and free the
>>>> bandwidth back into that cpu or there can be an underflow if another cpu
>>>> is chosen.
>>> Many thanks for the review!
>>>
>>> But isn't the DL BW control `struct dl_bw` per `struct root_domain`
>>> which is per exclusive cpuset. So as long cpu is from
>>> `cs->effective_cpus` shouldn't this be fine?
>> Sorry for my ignorance on how the deadline bandwidth operation work. I
>> check the bandwidth code and find that we are storing the bandwidth
>> information in the root domain, not on the cpu. That shouldn't be a
>> concern then.
>>
>> However, I still have some question on how that works when dealing with
>> cpuset. First of all, not all the CPUs in a given root domains are in
>> the cpuset. So there may be enough bandwidth on the root domain, but it
>> doesn't mean there will be enough bandwidth in the set of CPUs in a
>> particular cpuset. Secondly, how do you deal with isolated CPUs that do
>> not have a corresponding root domain? It is now possible to create a
>> cpuset with isolated CPUs.
> Sorry, I overlooked this email somehow.
>
> IMHO, this is only done for exclusive cpusets:
>
>    cpuset_can_attach()
>
>      if (!cpumask_intersects(oldcs->effective_cpus, cs->effective_cpus))
>
> So they should have their own root_domain congruent to their cpumask.

I am sorry that I missed that check.

Parallel attach is actually an existing problem in cpuset as there is a 
shared cpuset_attach_old_cs variable being used by cpuset between 
cpuset_can_attach() and cpuset_attach(). So any parallel attach can lead 
to corruption of this common data causing incorrect result. So this 
problem is not specific to this patch series. So please ignore this 
patch for now. It has to be addressed separately.

Cheers,
Longman

