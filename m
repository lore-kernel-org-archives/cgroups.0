From: Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v9 07/20] mm/lru: introduce TestClearPageLRU
Date: Wed, 4 Mar 2020 17:03:01 +0800
Message-ID: <20200304090301.GB5972@shao2-debian>
References: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
 <1583146830-169516-8-git-send-email-alex.shi@linux.alibaba.com>
 <20200302141144.b30abe0d89306fd387e13a92@linux-foundation.org>
 <9cacdc21-9c1f-2a17-05cb-e9cf2959cef5@linux.alibaba.com>
 <20200303164659.b3a30ab9d68c9ed82299a29c@linux-foundation.org>
 <6d155f79-8ba2-b322-4e92-311e7be98f79@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6d155f79-8ba2-b322-4e92-311e7be98f79-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Mar 04, 2020 at 03:06:48PM +0800, Alex Shi wrote:
> 
> 
> 在 2020/3/4 上午8:46, Andrew Morton 写道:
> > 
> > Well, any difference would be small and the numbers did get a bit
> > lower, albeit probably within the margin of error.
> > 
> > But you know, if someone were to send a patch which micro-optimized
> > some code by replacing 'TestClearXXX()' with `if PageXXX()
> > ClearPageXXX()', I would happily merge it!
> > 
> > Is this change essential to the overall patchset?  If not, I'd be
> > inclined to skip it?
> > 
> 
> Hi Andrew,
> 
> Thanks a lot for comments!
> Yes, this patch is essential for all next.
> 
> Consider the normal memory testing would focus on user page, that probabably with PageLRU. 
> 
> Fengguang's vm-scalibicase-small-allocs which used a lots vm_area_struct slab, which may
> got some impact. 0day/Cheng Rong is working on the test. In my roughly testing, it may drop 5% on my
> 96threads/394GB machine.
> 
> Thanks
> Alex

Hi,

We only tested one case and found a slight regression of vm-scalability.median from this patch set:

Test case: small allocs
=========================================================================================
compiler/cpufreq_governor/kconfig/rootfs/runtime/tbox_group/test/testcase/ucode:
  gcc-7/performance/x86_64-rhel-7.6/debian-x86_64-20191114.cgz/300s/lkp-ivb-d02/small-allocs/vm-scalability/0x21

commit: 
  v5.6-rc4
  f71ed0f653e9dbd57347f6321e36556004a17b52

        v5.6-rc4 f71ed0f653e9dbd57347f6321e3 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    998930            -1.4%     984729        vm-scalability.median

=========================================================================================
compiler/cpufreq_governor/kconfig/rootfs/runtime/tbox_group/test/testcase/ucode:
  gcc-7/performance/x86_64-rhel-7.6/debian-x86_64-20191114.cgz/300s/lkp-csl-2ap4/small-allocs/vm-scalability/0x500002c

commit: 
  v5.6-rc4
  f71ed0f653e9dbd57347f6321e36556004a17b52

        v5.6-rc4 f71ed0f653e9dbd57347f6321e3 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     64040            -2.2%      62641        vm-scalability.median
  12294118            -2.2%   12027483        vm-scalability.throughput
 3.695e+09            -2.2%  3.614e+09        vm-scalability.workload


$ git log --oneline v5.6-rc4..f71ed0f653e9dbd57347f6321e36556004a17b52
f71ed0f653e9d mm/memcg: add debug checking in lock_page_memcg
c56d782a737a5 mm/lru: add debug checking for page memcg moving
40f9438e4f7a9 mm/lru: revise the comments of lru_lock
cf4d433ab1f59 mm/pgdat: remove pgdat lru_lock
8b45216bf602c mm/swap: only change the lru_lock iff page's lruvec is different
9aeff27f856c4 mm/mlock: optimize munlock_pagevec by relocking
0fd16f50f4260 mm/lru: introduce the relock_page_lruvec function
e8bcc2440b133 mm/lru: replace pgdat lru_lock with lruvec lock
88013de2d9cfa mm/mlock: clean up __munlock_isolate_lru_page
037f0e01cc3a3 mm/memcg: move SetPageLRU out of lru_lock in commit_charge
5f889edacd91d mm/lru: take PageLRU first in moving page between lru lists
06998f054a82b mm/mlock: ClearPageLRU before get lru lock in munlock page isolation
5212e3636eed6 mm/lru: add page isolation precondition in __isolate_lru_page
a7b8b29f36b13 mm/lru: introduce TestClearPageLRU
f27e8da1e2fa1 mm/thp: narrow lru locking
2deca0177d843 mm/thp: clean up lru_add_page_tail
afbe030c47e06 mm/thp: move lru_add_page_tail func to huge_memory.c
9bee24913b538 mm/page_idle: no unlikely double check for idle page counting
40def76b96d7b mm/memcg: fold lock_page_lru into commit_charge
c1199696673c2 mm/vmscan: remove unnecessary lruvec adding

Best Regards,
Rong Chen
