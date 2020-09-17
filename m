From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock: reviews
Date: Thu, 17 Sep 2020 10:37:45 +0800
Message-ID: <c3362c0a-3707-3a3d-9955-960d95f3ad8c@linux.alibaba.com>
References: <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org>
 <alpine.LSU.2.11.2008241231460.1065@eggly.anvils>
 <alpine.LSU.2.11.2008262301240.4405@eggly.anvils>
 <alpine.LSU.2.11.2009081640070.7256@eggly.anvils>
 <61a42a87-eec9-e300-f710-992756f70de6@linux.alibaba.com>
 <alpine.LSU.2.11.2009091524260.10087@eggly.anvils>
 <855ad6ee-dba4-9729-78bd-23e392905cf6@linux.alibaba.com>
 <alpine.LSU.2.11.2009111634020.22739@eggly.anvils>
 <5cfc6142-752d-26e6-0108-38d13009268b@linux.alibaba.com>
 <alpine.LSU.2.11.2009150112130.1550@eggly.anvils>
 <20200915165807.kpp7uhiw7l3loofu@ca-dmjordan1.us.oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200915165807.kpp7uhiw7l3loofu-S51bK0XF4qpuJJETbFA3a0B3C2bhBk7L0E9HWUfgJXw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cai-J5quhbR+WMc@public.gmane.org



在 2020/9/16 上午12:58, Daniel Jordan 写道:
> On Tue, Sep 15, 2020 at 01:21:56AM -0700, Hugh Dickins wrote:
>> On Sun, 13 Sep 2020, Alex Shi wrote:
>>> Uh, I updated the testing with some new results here:
>>> https://lkml.org/lkml/2020/8/26/212
>> Right, I missed that, that's better, thanks.  Any other test results?
> Alex, you were doing some will-it-scale runs earlier.  Are you planning to do
> more of those?  Otherwise I can add them in.

Hi Daniel,

Does compaction perf scalable, like thpscale, I except they could get some benefit.

Thanks
Alex
