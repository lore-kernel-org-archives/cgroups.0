From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup/cpuset: Keep current cpus list if cpus
 affinity was explicitly set
Date: Fri, 29 Jul 2022 14:31:00 -0400
Message-ID: <c9d82d78-b47d-0f4a-f1ca-81df78e1baa6@redhat.com>
References: <20220728005815.1715522-1-longman@redhat.com>
 <YuLF+xXaCzwWi2BR@slm.duckdns.org>
 <1ae1cc6c-dca9-4958-6b22-24a5777c5e8d@redhat.com>
 <YuLdX7BYGvo57LNU@slm.duckdns.org>
 <606ed69e-8ad0-45d5-9de7-48739df7f48d@redhat.com>
 <YuL1NijxSEv2xadk@slm.duckdns.org>
 <c470d3f7-f0f8-b8e6-4a95-7b334f0a824b@redhat.com>
 <YuMCB86fH2K3NcqM@slm.duckdns.org> <xhsmhy1wcc8dq.mognet@vschneid.remote.csb>
 <92f68392-12d2-f64a-9bb9-1a3a15f99d02@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659119466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aWKVK6OoM1bKr67knlvEgc7AaGfjBxkEmDKqD2fNc5c=;
        b=Wh5qmbewGcqCiYMrQARW1kBIi6g9bmakX+CqLkz68N62F8Ud0XtIucy6z+0xtTjL+NzdET
        BjeTOdYPRW2U+sI4ivTZybz51VcAyTrSV4Sld5TkNpP7gMEAkCfoNPo/3pXsJHgHyPK5s+
        Cim0Sl5/ZwYxbuqky4XC10QdcZyZOwY=
Content-Language: en-US
In-Reply-To: <92f68392-12d2-f64a-9bb9-1a3a15f99d02-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 7/29/22 10:50, Waiman Long wrote:
> On 7/29/22 10:15, Valentin Schneider wrote:
>> On 28/07/22 11:39, Tejun Heo wrote:
>>> Hello, Waiman.
>>>
>>> On Thu, Jul 28, 2022 at 05:04:19PM -0400, Waiman Long wrote:
>>>>> So, the patch you proposed is making the code remember one special=20
>>>>> aspect of
>>>>> user requested configuration - whether it configured it or not,=20
>>>>> and trying
>>>>> to preserve that particular state as cpuset state changes. It=20
>>>>> addresses the
>>>>> immediate problem but it is a very partial approach. Let's say a=20
>>>>> task wanna
>>>>> be affined to one logical thread of each core and set its mask to=20
>>>>> 0x5555.
>>>>> Now, let's say cpuset got enabled and enforced 0xff and affined=20
>>>>> the task to
>>>>> 0xff. After a while, the cgroup got more cpus allocated and its=20
>>>>> cpuset now
>>>>> has 0xfff. Ideally, what should happen is the task now having the=20
>>>>> effective
>>>>> mask of 0x555. In practice, tho, it either would get 0xf55 or 0x55=20
>>>>> depending
>>>>> on which way we decide to misbehave.
>>>> OK, I see what you want to accomplish. To fully address this issue,=20
>>>> we will
>>>> need to have a new cpumask variable in the the task structure which=20
>>>> will be
>>>> allocated if sched_setaffinity() is ever called. I can rework my=20
>>>> patch to
>>>> use this approach.
>>> Yeah, we'd need to track what user requested separately from the=20
>>> currently
>>> effective cpumask. Let's make sure that the scheduler folks are on=20
>>> board
>>> before committing to the idea tho. Peter, Ingo, what do you guys think?
>>>
>> FWIW on a runtime overhead side of things I think it'll be OK as that
>> should be just an extra mask copy=C2=A0 in sched_setaffinity() and a sub=
set
>> check / cpumask_and() in set_cpus_allowed_ptr(). The policy side is a=20
>> bit
>> less clear (when, if ever, do we clear the user-defined mask? Will it=20
>> keep
>> haunting us even after moving a task to a disjoint cpuset partition?).
>
> The runtime overhead should be minimal. It is the behavioral side that=20
> we should be careful about. It is a change in existing behavior and we=20
> don't want to cause surprise to the users. Currently, a task that set=20
> its cpu affinity explicitly will have its affinity reset whenever=20
> there is any change to the cpuset it belongs to or a hotplug event=20
> touch any cpu in the current cpuset. The new behavior we are proposing=20
> here is that it will try its best to keep the cpu affinity that the=20
> user requested within the constraint of the current cpuset as well as=20
> the cpu hotplug state.
>
>
>>
>> There's also if/how that new mask should be exposed, because attaching a
>> task to a cpuset will now yield a not-necessarily-obvious affinity -
>> e.g. in the thread affinity example above, if the initial affinity=20
>> setting
>> was done ages ago by some system tool, IMO the user needs a way to be=20
>> able
>> to expect/understand the result of 0x555 rather than 0xfff.
>
> Users can use sched_getaffinity(2) to retrieve the current cpu=20
> affinity. It is up to users to set another one if they don't like the=20
> current one. I don't think we need to return what the previous=20
> requested cpu affinity is. They are suppose to know that or they can=20
> set their own if they don't like it. \

Looking at Will's series that introduced user_cpus_ptr, I think we can=20
overlay our proposal on top of that. So calling sched_setaffinity() will=20
also update user_cpus_ptr. We may still need a flag to indicate whether=20
user_cpus_ptr is set up because of sched_setaffinity() or due to a call=20
to force_compatible_cpus_allowed_ptr() from arm64 arch code. That will=20
make our work easier as some of the infrastructure is already there. I=20
am looking forward for your feedback.

Thanks,
Longman

