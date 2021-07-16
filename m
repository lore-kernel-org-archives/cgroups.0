From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/6] cgroup/cpuset: Clarify the use of invalid
 partition root
Date: Fri, 16 Jul 2021 16:08:15 -0400
Message-ID: <8c44b659-3fe4-b14f-fac1-cbd5b23010c3@redhat.com>
References: <20210621184924.27493-1-longman@redhat.com>
 <20210621184924.27493-3-longman@redhat.com>
 <YNcHOe3o//pIiByh@mtj.duckdns.org>
 <6ea1ac38-73e1-3f78-a5d2-a4c23bcd8dd1@redhat.com>
 <YONGk3iw/zrNzwLK@mtj.duckdns.org>
 <c6ae2d9b-ad6e-9bbd-b25c-f52b0ff6fb9b@redhat.com>
 <1bb119a1-d94a-6707-beac-e3ae5c03fae5@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626466099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Da3jrWfUyIbwMDM6l84hMp2rVe+fWjtYvte2/A1hNbI=;
        b=bS2NzdLUhkSK8oiL167ZoMmCXNJIk84wccwJ4Q9f5OWcu3h9BymiH8Y2LQLjq1vk4rEYts
        JTrM/H3LI0yXszSklG4OMHcuwU7YjWpWGm3FuLQFzrsVg17u2WhVeGk8jBKsdLBRU9NN4W
        UdkYMHXAUjZpQ6PWtv07KRjfy97cMcQ=
In-Reply-To: <1bb119a1-d94a-6707-beac-e3ae5c03fae5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 7/16/21 2:59 PM, Waiman Long wrote:
> On 7/16/21 2:44 PM, Waiman Long wrote:
>> On 7/5/21 1:51 PM, Tejun Heo wrote:
>>> Hello, Waiman.
>>>
>>> On Mon, Jun 28, 2021 at 09:06:50AM -0400, Waiman Long wrote:
>>>> The main reason for doing this is because normal cpuset control=20
>>>> file actions
>>>> are under the direct control of the cpuset code. So it is up to us=20
>>>> to decide
>>>> whether to grant it or deny it. Hotplug, on the other hand, is not=20
>>>> under the
>>>> control of cpuset code. It can't deny a hotplug operation. This is=20
>>>> the main
>>>> reason why the partition root error state was added in the first=20
>>>> place.
>>> I have a difficult time convincing myself that this difference=20
>>> justifies the
>>> behavior difference and it keeps bothering me that there is a state=20
>>> which
>>> can be reached through one path but rejected by the other. I'll=20
>>> continue
>>> below.
>>>
>>>> Normally, users can set cpuset.cpus to whatever value they want=20
>>>> even though
>>>> they are not actually granted. However, turning on partition root=20
>>>> is under
>>>> more strict control. You can't turn on partition root if the CPUs=20
>>>> requested
>>>> cannot actually be granted. The problem with setting the state to just
>>>> partition error is that users may not be aware that the partition=20
>>>> creation
>>>> operation fails.=C2=A0 We can't assume all users will do the proper er=
ror
>>>> checking. I would rather let them know the operation fails rather than
>>>> relying on them doing the proper check afterward.
>>>>
>>>> Yes, I agree that it is a different philosophy than the original=20
>>>> cpuset
>>>> code, but I thought one reason of doing cgroup v2 is to simplify the
>>>> interface and make it a bit more erorr-proof. Since partition root=20
>>>> creation
>>>> is a relatively rare operation, we can afford to make it more=20
>>>> strict than
>>>> the other operations.
>>> So, IMO, one of the reasons why cgroup1 interface was such a mess was
>>> because each piece of interaction was designed ad-hoc without regard=20
>>> to the
>>> overall consistency. One person feels a particular way of=20
>>> interacting with
>>> the interface is "correct" and does it that way and another person does
>>> another part in a different way. In the end, we ended up with a messy
>>> patchwork.
>>>
>>> One problematic aspect of cpuset in cgroup1 was the handling of failure
>>> modes, which was caused by the same exact approach - we wanted the=20
>>> interface
>>> to reject invalid configurations outright even though we didn't have=20
>>> the
>>> ability to prevent those configurations from occurring through other=20
>>> paths,
>>> which makes the failure mode more subtle by further obscuring them.
>>>
>>> I think a better approach would be having a clear signal and=20
>>> mechanism to
>>> watch the state and explicitly requiring users to verify and monitor=20
>>> the
>>> state transitions.
>>
>> Sorry for the late reply as I was busy with other works.
>>
>> I agree with you on principle. However, the reason why there are more=20
>> restrictions on enabling partition is because I want to avoid forcing=20
>> the users to always read back cpuset.partition.type to see if the=20
>> operation succeeds instead of just getting an error from the=20
>> operation. The former approach is more error prone. If you don't want=20
>> changes in existing behavior, I can relax the checking and allow them=20
>> to become an invalid partition if an illegal operation happens.
>>
>> Also there is now another cpuset patch to extend cpu isolation to=20
>> cgroup v1 [1]. I think it is better suit to the cgroup v2 partition=20
>> scheme, but cgroup v1 is still quite heavily out there.
>>
>> Please let me know what you want me to do and I will send out a v3=20
>> version.=20
>
> Note that the current cpuset partition implementation have implemented=20
> some restrictions on when a partition can be enabled. However, I=20
> missed some corner cases in the original implementation that allow=20
> certain cpuset operations to make a partition invalid. I tried to plug=20
> those holes in this patchset. However, if maintaining backward=20
> compatibility is more important, I can leave those holes and update=20
> the documentation to make sure that people check cpuset.partition.type=20
> to confirm if their operation succeeds.=20

I just realize that partition root set the CPU_EXCLUSIVE bit. So changes=20
to cpuset.cpus that break exclusivity rule is not allowed anyway. This=20
patchset is just adding additional checks so that cpuset.cpus changes=20
that break the partition root rules will not be allowed. I can remove=20
those additional checks for this patchset and allow cpuset.cpus changes=20
that break the partition root rules to make it invalid instead. However,=20
I still want invalid changes to cpuset.partition.type to be disallowed.

Cheers,
Longman

