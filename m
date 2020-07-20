From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v16 00/22] per memcg lru_lock
Date: Mon, 20 Jul 2020 15:30:14 +0800
Message-ID: <04a2ad99-5d88-a300-6430-7a8da0946f04@linux.alibaba.com>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1594429136-20002-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org


I am preparing/testing the patch v17 according comments from Hugh Dickins
and Alexander Duyck. 
Many thanks for line by line review and patient suggestion!

Please drop me any more comments or concern of any patches!

Thanks a lot!
Alex

在 2020/7/11 上午8:58, Alex Shi 写道:
> The new version which bases on v5.8-rc4. Add 2 more patchs:
> 'mm/thp: remove code path which never got into'
> 'mm/thp: add tail pages into lru anyway in split_huge_page()'
> and modified 'mm/mlock: reorder isolation sequence during munlock'
> 
> Current lru_lock is one for each of node, pgdat->lru_lock, that guard for
> lru lists, but now we had moved the lru lists into memcg for long time. Still
> using per node lru_lock is clearly unscalable, pages on each of memcgs have
> to compete each others for a whole lru_lock. This patchset try to use per
> lruvec/memcg lru_lock to repleace per node lru lock to guard lru lists, make
> it scalable for memcgs and get performance gain.
> 
> Currently lru_lock still guards both lru list and page's lru bit, that's ok.
> but if we want to use specific lruvec lock on the page, we need to pin down
> the page's lruvec/memcg during locking. Just taking lruvec lock first may be
> undermined by the page's memcg charge/migration. To fix this problem, we could
> take out the page's lru bit clear and use it as pin down action to block the
> memcg changes. That's the reason for new atomic func TestClearPageLRU.
> So now isolating a page need both actions: TestClearPageLRU and hold the
> lru_lock.
> 
> The typical usage of this is isolate_migratepages_block() in compaction.c
> we have to take lru bit before lru lock, that serialized the page isolation
> in memcg page charge/migration which will change page's lruvec and new 
> lru_lock in it.
> 
> The above solution suggested by Johannes Weiner, and based on his new memcg 
> charge path, then have this patchset. (Hugh Dickins tested and contributed much
> code from compaction fix to general code polish, thanks a lot!).
> 
> The patchset includes 3 parts:
> 1, some code cleanup and minimum optimization as a preparation.
> 2, use TestCleanPageLRU as page isolation's precondition
> 3, replace per node lru_lock with per memcg per node lru_lock
> 
> Following Daniel Jordan's suggestion, I have run 208 'dd' with on 104
> containers on a 2s * 26cores * HT box with a modefied case:
> https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/tree/case-lru-file-readtwice
> With this patchset, the readtwice performance increased about 80%
> in concurrent containers.
> 
> Thanks Hugh Dickins and Konstantin Khlebnikov, they both brought this
> idea 8 years ago, and others who give comments as well: Daniel Jordan, 
> Mel Gorman, Shakeel Butt, Matthew Wilcox etc.
> 
> Thanks for Testing support from Intel 0day and Rong Chen, Fengguang Wu,
> and Yun Wang. Hugh Dickins also shared his kbuild-swap case. Thanks!
