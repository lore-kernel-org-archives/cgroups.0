From: Michal Hocko <mhocko@kernel.org>
Subject: Re: mm: mkfs.ext4 invoked oom-killer on i386 - pagecache_get_page
Date: Thu, 21 May 2020 18:34:50 +0200
Message-ID: <20200521163450.GV6462@dhcp22.suse.cz>
References: <CA+G9fYu2ruH-8uxBHE0pdE6RgRTSx4QuQPAN=Nv3BCdRd2ouYA@mail.gmail.com>
 <20200501135806.4eebf0b92f84ab60bba3e1e7@linux-foundation.org>
 <CA+G9fYsiZ81pmawUY62K30B6ue+RXYod854RS91R2+F8ZO7Xvw@mail.gmail.com>
 <20200519075213.GF32497@dhcp22.suse.cz>
 <CAK8P3a2T_j-Ynvhsqe_FCqS2-ZdLbo0oMbHhHChzMbryE0izAQ@mail.gmail.com>
 <20200519084535.GG32497@dhcp22.suse.cz>
 <CA+G9fYvzLm7n1BE7AJXd8_49fOgPgWWTiQ7sXkVre_zoERjQKg@mail.gmail.com>
 <CA+G9fYsXnwyGetj-vztAKPt8=jXrkY8QWe74u5EEA3XPW7aikQ@mail.gmail.com>
 <20200520190906.GA558281@chrisdown.name>
 <20200521095515.GK6462@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200521095515.GK6462@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Naresh Kamboju <naresh.kamboju@linaro.org>, Chris Down <chris@chrisdown.name>
Cc: Yafang Shao <laoar.shao@gmail.com>, Anders Roxell <anders.roxell@linaro.org>, "Linux F2FS DEV, Mailing List" <linux-f2fs-devel@lists.sourceforge.net>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, open list <linux-kernel@vger.kernel.org>, Linux-Next Mailing List <linux-next@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Chao Yu <chao@kernel.org>, Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Matthew Wilcox <willy@infradead.org>, Chao Yu <yuchao0@huawei.com>, lkft-triage@lists.linaro.org, Johannes Weiner <>

On Thu 21-05-20 11:55:16, Michal Hocko wrote:
> On Wed 20-05-20 20:09:06, Chris Down wrote:
> > Hi Naresh,
> > 
> > Naresh Kamboju writes:
> > > As a part of investigation on this issue LKFT teammate Anders Roxell
> > > git bisected the problem and found bad commit(s) which caused this problem.
> > > 
> > > The following two patches have been reverted on next-20200519 and retested the
> > > reproducible steps and confirmed the test case mkfs -t ext4 got PASS.
> > > ( invoked oom-killer is gone now)
> > > 
> > > Revert "mm, memcg: avoid stale protection values when cgroup is above
> > > protection"
> > >    This reverts commit 23a53e1c02006120f89383270d46cbd040a70bc6.
> > > 
> > > Revert "mm, memcg: decouple e{low,min} state mutations from protection
> > > checks"
> > >    This reverts commit 7b88906ab7399b58bb088c28befe50bcce076d82.
> > 
> > Thanks Anders and Naresh for tracking this down and reverting.
> > 
> > I'll take a look tomorrow. I don't see anything immediately obviously wrong
> > in either of those commits from a (very) cursory glance, but they should
> > only be taking effect if protections are set.
> 
> Agreed. If memory.{low,min} is not used then the patch should be
> effectively a nop.

I was staring into the code and do not see anything.  Could you give the
following debugging patch a try and see whether it triggers?

diff --git a/mm/vmscan.c b/mm/vmscan.c
index cc555903a332..df2e8df0eb71 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2404,6 +2404,8 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 			 * sc->priority further than desirable.
 			 */
 			scan = max(scan, SWAP_CLUSTER_MAX);
+
+			trace_printk("scan:%lu protection:%lu\n", scan, protection);
 		} else {
 			scan = lruvec_size;
 		}
@@ -2648,6 +2650,7 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 		mem_cgroup_calculate_protection(target_memcg, memcg);
 
 		if (mem_cgroup_below_min(memcg)) {
+			trace_printk("under min:%lu emin:%lu\n", memcg->memory.min, memcg->memory.emin);
 			/*
 			 * Hard protection.
 			 * If there is no reclaimable memory, OOM.
@@ -2660,6 +2663,7 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 			 * there is an unprotected supply
 			 * of reclaimable memory from other cgroups.
 			 */
+			trace_printk("under low:%lu elow:%lu\n", memcg->memory.low, memcg->memory.elow);
 			if (!sc->memcg_low_reclaim) {
 				sc->memcg_low_skipped = 1;
 				continue;
-- 
Michal Hocko
SUSE Labs
