From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH 8/9] sched/psi: add kernel cmdline
 parameter psi_inner_cgroup
Date: Tue, 26 Jul 2022 21:38:18 +0800
Message-ID: <a2bd997b-fc81-ca1c-3d65-99fbd34cfba7@bytedance.com>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-9-zhouchengming@bytedance.com>
 <Yt7KQc0nnOypB2b2@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tmctZBFguTrS1b7yrub84YkQuENPO2e8gipTSbzISyU=;
        b=fmzUdvxIgopv0HByWJp3GWf71zq/2KhCxgsN7JSU50LfrTaG85+Izym6Tk8RjqUPns
         7y9QLsMx6dZ0PN/ksMUXgLHVdtm9xer5hIMN2AA760oK2BYKVCmjXEt0VTP8UO4wL4ER
         jpUqUvJqt3XBCs9UUjuBd6lR4T6WE0rgM2zD7qH1B7rNnwfKbwnstYSn3Vg1e2QK4XBP
         odPJhd1ETh9sbQm+nRuVeGJ/zPMUdLwL5O3KhETlMrBsxHTf1vEzUgqPBXLE9aEPXStx
         IA6EKzZinS/QP0aFF246XBW0oeybrj69iPq/6mKd8R6ZMUhJe0P3dn4iyjmrLshA4OxB
         Y56g==
Content-Language: en-US
In-Reply-To: <Yt7KQc0nnOypB2b2-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2022/7/26 00:52, Johannes Weiner wrote:
> On Thu, Jul 21, 2022 at 12:04:38PM +0800, Chengming Zhou wrote:
>> PSI accounts stalls for each cgroup separately and aggregates it
>> at each level of the hierarchy. This may case non-negligible overhead
>> for some workloads when under deep level of the hierarchy.
>>
>> commit 3958e2d0c34e ("cgroup: make per-cgroup pressure stall tracking configurable")
>> make PSI to skip per-cgroup stall accounting, only account system-wide
>> to avoid this each level overhead.
>>
>> For our use case, we also want leaf cgroup PSI accounted for userspace
>> adjustment on that cgroup, apart from only system-wide management.
> 
> I hear the overhead argument. But skipping accounting in intermediate
> levels is a bit odd and unprecedented in the cgroup interface. Once we
> do this, it's conceivable people would like to do the same thing for
> other stats and accounting, like for instance memory.stat.

Right, it's a bit odd... We don't use PSI stats in intermediate levels
in our use case, but don't know what other use scenarios are. If they are
useful for other people, this patch can be dropped.

Thanks.

> 
> Tejun, what are your thoughts on this?
