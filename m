From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH 8/9] sched/psi: add kernel cmdline parameter
 psi_inner_cgroup
Date: Wed, 3 Aug 2022 20:17:22 +0800
Message-ID: <5a3410d6-428d-9ad1-3e5a-01ca805ceeeb@bytedance.com>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-9-zhouchengming@bytedance.com>
 <Yt7KQc0nnOypB2b2@cmpxchg.org> <YuAqWprKd6NsWs7C@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=x4/SZID/1XNhMOqSKnwdkmMau4H8OofmRy/FbmoxvEg=;
        b=Qxzz3XQYiaXJalf/es7ikBYZATLndo+CihdM+270E6X3mVgzGHjCbX2gbmb16gI/Ov
         rSvkxx6lRoeo0n2OX5ZnfuAy8nbvYly0hxZzmx4jRrMK3YAojWRnz9b/UBXXdof2JCyx
         MvxcEmgyVsGeFiHOJm57LKUERvfEZrlKvzFZlFtQC7MQx7qVLmttFCceB2hpMNmhF0H3
         WG3yWnPUiGHHvyWe6AFqcmygCvj6+OGKU14bNnYcfbJUgjyynfru3pUhW0UfZCn33pBG
         xE434cPgQOYCKWyhFTYcYMhdWG+uYLoohGsHSPlyIgsQAgra2xR93ptHB+/TGhmMCmBo
         sxAw==
Content-Language: en-US
In-Reply-To: <YuAqWprKd6NsWs7C-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2022/7/27 01:54, Tejun Heo wrote:
> Hello,
> 
> On Mon, Jul 25, 2022 at 12:52:17PM -0400, Johannes Weiner wrote:
>> On Thu, Jul 21, 2022 at 12:04:38PM +0800, Chengming Zhou wrote:
>>> PSI accounts stalls for each cgroup separately and aggregates it
>>> at each level of the hierarchy. This may case non-negligible overhead
>>> for some workloads when under deep level of the hierarchy.
>>>
>>> commit 3958e2d0c34e ("cgroup: make per-cgroup pressure stall tracking configurable")
>>> make PSI to skip per-cgroup stall accounting, only account system-wide
>>> to avoid this each level overhead.
>>>
>>> For our use case, we also want leaf cgroup PSI accounted for userspace
>>> adjustment on that cgroup, apart from only system-wide management.
>>
>> I hear the overhead argument. But skipping accounting in intermediate
>> levels is a bit odd and unprecedented in the cgroup interface. Once we
>> do this, it's conceivable people would like to do the same thing for
>> other stats and accounting, like for instance memory.stat.
>>
>> Tejun, what are your thoughts on this?
> 
> Given that PSI requires on-the-spot recursive accumulation unlike other
> stats, it can add quite a bit of overhead, so I'm sympathetic to the
> argument because PSI can't be made cheaper by kernel being better (or at
> least we don't know how to yet).
> 
> That said, "leaf-only" feels really hacky to me. My memory is hazy but
> there's nothing preventing any cgroup from being skipped over when updating
> PSI states, right? The state count propagation is recursive but it's each
> task's state being propagated upwards not the child cgroup's, so we can skip
> over any cgroup arbitrarily. ie. we can at least turn off PSI reporting on
> any given cgroup without worrying about affecting others. Am I correct?

Yes, I think it's correct.

> 
> Assuming the above isn't wrong, if we can figure out how we can re-enable
> it, which is more difficult as the counters need to be resynchronized with
> the current state, that'd be ideal. Then, we can just allow each cgroup to
> enable / disable PSI reporting dynamically as they see fit.

This method is more fine-grained but more difficult like you said above.
I think it may meet most needs to disable PSI stats in intermediate cgroups?

Thanks!

> 
> Thanks.
> 
