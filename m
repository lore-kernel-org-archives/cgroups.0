From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Wed, 25 Aug 2021 15:21:59 -0400
Message-ID: <af7ad628-62f4-848b-7eaa-1c9eb62355b6@redhat.com>
References: <20210814205743.3039-1-longman@redhat.com>
 <20210814205743.3039-6-longman@redhat.com> <YRqbj5+ZdS+7k0Fn@slm.duckdns.org>
 <95b72d36-32a9-8356-05b7-2829e4cc29ad@redhat.com>
 <YSVCv0WjTzwPUWUN@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629919327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7z03hZuDBTQ0h38/Oi8p6IqjEpIuhunBdpC+bYuyK4g=;
        b=IAVFLM0a/FgICHYJlrZ559UWshNFTf9WDcxTRcKNHOr5L0KLWvePc2T/TESA/d7dv/lZTx
        hDUYnL4rGRywX/bi66mVSjt6cgneTXiqiieYfUiIubTuuJLJ9neW/M6TJJYxIXEMi60LQ3
        YWl0d+1+tdtRQg5xHsMXqMl8nuRNvGE=
In-Reply-To: <YSVCv0WjTzwPUWUN-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On 8/24/21 3:04 PM, Tejun Heo wrote:
> Hello,
>
> On Tue, Aug 24, 2021 at 01:35:33AM -0400, Waiman Long wrote:
>> Sorry for the late reply as I was on vacation last week.
> No worries. Hope you enjoyed the vacation. :)
>
>>> All the above ultimately says is that "a new task cannot be moved to a
>>> partition root with no effective cpu", but I don't understand why this would
>>> be a separate rule. Shouldn't the partition just stop being a partition when
>>> it doesn't have any exclusive cpu? What's the benefit of having multiple its
>>> own failure mode?
>> A partition with 0 cpu can be considered as a special partition type for
>> spawning child partitions. This can be temporary as the cpus will be given
>> back when a child partition is destroyed.
> But it can also happen by cpus going offline while the partition is
> populated, right? Am I correct in thinking that a partition without cpu is
> valid if its subtree contains cpus and invalid otherwise? If that's the
> case, it looks like the rules can be made significantly simpler. The parent
> cgroups never have processes anyway, so a partition is valid if its subtree
> contains cpus, invalid otherwise.
Yes, that is true. Thanks for the simplification.
>
>>> So, I think this definitely is a step in the right direction but still seems
>>> to be neither here or there. Before, we pretended that we could police the
>>> input when we couldn't. Now, we're changing the interface so that it
>>> includes configuration failures as an integral part; however, we're still
>>> policing some particular inputs while letting other inputs pass through and
>>> trigger failures and why one is handled one way while the other differently
>>> seems rather arbitrary.
>>>
>> The cpu_exclusive and load_balance flags are attributes associated directly
>> with the partition type. They are not affected by cpu availability or
>> changing of cpu list. That is why they are kept even when the partition
>> become invalid. If we have to remove them, it will be equivalent to changing
>> partition back to member and we may not need an invalid partition type at
>> all. Also, we will not be able to revert back to partition again when the
>> cpus becomes available.
> Oh, yeah, I'm not saying to lose those states. What I'm trying to say is
> that the rules and failure modes seem a lot more complicated than they need
> to be. If the configuration becomes invalid for whatever reason, transition
> the partition into invalid state and report why. If the situation resolves
> for whatever reason, transition it back to valid state. Shouldn't that work?

I agree that the current description is probably more complicated than 
it should be. I will try to fix that.

Thanks,
Longman


