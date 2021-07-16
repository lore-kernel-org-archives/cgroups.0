From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/6] cgroup/cpuset: Clarify the use of invalid
 partition root
Date: Fri, 16 Jul 2021 17:12:17 -0400
Message-ID: <e8c538a8-bf5c-b04c-1b21-ac22cd158dd1@redhat.com>
References: <20210621184924.27493-1-longman@redhat.com>
 <20210621184924.27493-3-longman@redhat.com>
 <YNcHOe3o//pIiByh@mtj.duckdns.org>
 <6ea1ac38-73e1-3f78-a5d2-a4c23bcd8dd1@redhat.com>
 <YONGk3iw/zrNzwLK@mtj.duckdns.org>
 <c6ae2d9b-ad6e-9bbd-b25c-f52b0ff6fb9b@redhat.com>
 <1bb119a1-d94a-6707-beac-e3ae5c03fae5@redhat.com>
 <8c44b659-3fe4-b14f-fac1-cbd5b23010c3@redhat.com>
 <YPHwG61qGDa3h6Wg@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626469941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rtZkPkL5ifGn/qh+FLZXpXfgaKHtHcJkyP1xEcuftv4=;
        b=WszPjFD71SjhDDskK8JsnI+gGp5Hiung2ko2vbyqc1FIpT+r34vD/VVRnr4eDbDxoKWLk6
        XHzuTEX/vkAomrobyo5wsyPrxNJhr1Ur2cnUnIpIhK0pzJK+ZzgSfS4Kdt6sxRZDSBxDs5
        catWfdZTPMb4lNp6rI2fnbiKUxYX/ic=
In-Reply-To: <YPHwG61qGDa3h6Wg-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 7/16/21 4:46 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Fri, Jul 16, 2021 at 04:08:15PM -0400, Waiman Long wrote:
>>>> I agree with you on principle. However, the reason why there are
>>>> more restrictions on enabling partition is because I want to avoid
>>>> forcing the users to always read back cpuset.partition.type to see
>>>> if the operation succeeds instead of just getting an error from the
>>>> operation. The former approach is more error prone. If you don't
>>>> want changes in existing behavior, I can relax the checking and
>>>> allow them to become an invalid partition if an illegal operation
>>>> happens.
>>>>
>>>> Also there is now another cpuset patch to extend cpu isolation to
>>>> cgroup v1 [1]. I think it is better suit to the cgroup v2 partition
>>>> scheme, but cgroup v1 is still quite heavily out there.
>>>>
>>>> Please let me know what you want me to do and I will send out a v3
>>>> version.
>>> Note that the current cpuset partition implementation have implemented
>>> some restrictions on when a partition can be enabled. However, I missed
>>> some corner cases in the original implementation that allow certain
>>> cpuset operations to make a partition invalid. I tried to plug those
>>> holes in this patchset. However, if maintaining backward compatibility
>>> is more important, I can leave those holes and update the documentation
>>> to make sure that people check cpuset.partition.type to confirm if their
>>> operation succeeds.
>> I just realize that partition root set the CPU_EXCLUSIVE bit. So changes to
>> cpuset.cpus that break exclusivity rule is not allowed anyway. This patchset
>> is just adding additional checks so that cpuset.cpus changes that break the
>> partition root rules will not be allowed. I can remove those additional
>> checks for this patchset and allow cpuset.cpus changes that break the
>> partition root rules to make it invalid instead. However, I still want
>> invalid changes to cpuset.partition.type to be disallowed.
> So, I get the instinct to disallow these operations and it'd make sense if
> the conditions aren't reachable otherwise. However, I'm afraid what users
> eventually get is false sense of security rather than any actual guarantee.
>
> Inconsistencies like this cause actual usability hazards - e.g. imagine a
> system config script whic sets up exclusive cpuset and let's say that the
> use case is fine with degraded operation when the target cores are offline
> (e.g. energy save mode w/ only low power cores online). Let's say this
> script runs in late stages during boot and has been reliable. However, at
> some point, there are changes in boot sequence and now there's low but
> non-trivial chance that the system would already be in low power state when
> the script runs. Now the script will fail sporadically and the whole thing
> would be pretty awkward to debug.
>
> I'd much prefer to have an explicit interface to confirm the eventual state
> and a way to monitor state transitions (without polling). An invalid state
> is an inherent part of cpuset configuration. I'd much rather have that
> really explicit in the interface even if that means a bit of extra work at
> configuration time.

Are you suggesting that we add a cpuset.cpus.events file that allows 
processes to be notified if an event (e.g. hotplug) that changes a 
partition root to invalid partition happens or when explicit change to a 
partition root fails? Will that be enough to satisfy your requirement?

Cheers,
Longman

