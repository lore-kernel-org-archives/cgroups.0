From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Improve cpuset_css_alloc() description
Date: Wed, 16 Nov 2022 12:20:39 -0500
Message-ID: <4691d845-ae91-0cff-e66f-2662188b50b6@redhat.com>
References: <20221116054415.79157-1-kamalesh.babulal@oracle.com>
 <7eb8d6f9-b54c-aedc-982b-8ed2bddb948b@redhat.com>
 <c1c5910c-8f5d-1eea-8bd7-7d79f5b5ee87@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668619247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fWWN9OGwNuMYO3D60HWCUrbCelzJvBP0Z8bqEe/19V0=;
        b=ANmQ9Ud3bpYhax6bhGsUFWHFeNILbayneenYnS/Uks6+xwi7XfYr3wmcTZBlJQtV3mPwxw
        ARzwMI4/iS2lkLSoD7USeV3jM5TXbfp4kDB5q+prDP55a3/kgqK1iKSb3J6knukwt66oVw
        osrJM39gclK6HTOF5JWVK0YYqzHddK8=
Content-Language: en-US
In-Reply-To: <c1c5910c-8f5d-1eea-8bd7-7d79f5b5ee87-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

On 11/16/22 10:40, Kamalesh Babulal wrote:
>
> On 11/16/22 20:06, Waiman Long wrote:
>> On 11/16/22 00:44, Kamalesh Babulal wrote:
>>> Change the function argument in the description of cpuset_css_alloc()
>>> from 'struct cgroup' -> 'struct cgroup_subsys_state'.  The change to the
>>> argument type was introduced by commit eb95419b023a ("cgroup: pass
>>> around cgroup_subsys_state instead of cgroup in subsystem methods").
>>> Also, add more information to its description.
>>>
>>> Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>    kernel/cgroup/cpuset.c | 11 ++++++++---
>>>    1 file changed, 8 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>> index b474289c15b8..aac790462e74 100644
>>> --- a/kernel/cgroup/cpuset.c
>>> +++ b/kernel/cgroup/cpuset.c
>>> @@ -3046,9 +3046,14 @@ static struct cftype dfl_files[] = {
>>>    };
>>>      -/*
>>> - *    cpuset_css_alloc - allocate a cpuset css
>>> - *    cgrp:    control group that the new cpuset will be part of
>>> +/**
>>> + * cpuset_css_alloc - Allocate a cpuset css
>>> + * @parent_css: Parent css of the control group that the new cpuset will be
>>> + *              part of
>>> + * Return: cpuset css on success, -ENOMEM on failure.
>>> + *
>>> + * Allocate and initialize a new cpuset css, for non-root cpuset or return the
>>> + * top cpuset css for root cpuset.
>> Strictly speaking, it returns the css of top cpuset set for NULL input parameter.
> Thank you for reviewing the patch. Does the following, rephrase, sound right:
>
> Allocate and initialize a new cpuset css, for non-NULL @parent_css, return
> top cpuset css otherwise.

That looks fine to me.

Cheers,
Longman

>>>     */
>>>      static struct cgroup_subsys_state *
>> While at it, could you also remove the blank line between the comment and the function body.
> Sure, will remove it.
>

