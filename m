From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH for 3.2.34] memcg: do not trigger OOM from
 add_to_page_cache_locked
Date: Wed, 5 Dec 2012 15:17:22 +0100
Message-ID: <20121205141722.GA9714@dhcp22.suse.cz>
References: <20121130032918.59B3F780@pobox.sk>
 <20121130124506.GH29317@dhcp22.suse.cz>
 <20121130144427.51A09169@pobox.sk>
 <20121130144431.GI29317@dhcp22.suse.cz>
 <20121130160811.6BB25BDD@pobox.sk>
 <20121130153942.GL29317@dhcp22.suse.cz>
 <20121130165937.F9564EBE@pobox.sk>
 <20121130161923.GN29317@dhcp22.suse.cz>
 <20121203151601.GA17093@dhcp22.suse.cz>
 <20121205023644.18C3006B@pobox.sk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121205023644.18C3006B-Rm0zKEqwvD4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Wed 05-12-12 02:36:44, azurIt wrote:
> >The following should print the traces when we hand over ENOMEM to the
> >caller. It should catch all charge paths (migration is not covered but
> >that one is not important here). If we don't see any traces from here
> >and there is still global OOM striking then there must be something else
> >to trigger this.
> >Could you test this with the patch which aims at fixing your deadlock,
> >please? I realise that this is a production environment but I do not see
> >anything relevant in the code.
> 
> 
> Michal,
> 
> i think/hope this is what you wanted:
> http://www.watchdog.sk/lkml/oom_mysqld2

Dec  5 02:20:48 server01 kernel: [  380.995947] WARNING: at mm/memcontrol.c:2400 T.1146+0x2c1/0x5d0()
Dec  5 02:20:48 server01 kernel: [  380.995950] Hardware name: S5000VSA
Dec  5 02:20:48 server01 kernel: [  380.995952] Pid: 5351, comm: apache2 Not tainted 3.2.34-grsec #1
Dec  5 02:20:48 server01 kernel: [  380.995954] Call Trace:
Dec  5 02:20:48 server01 kernel: [  380.995960]  [<ffffffff81054eaa>] warn_slowpath_common+0x7a/0xb0
Dec  5 02:20:48 server01 kernel: [  380.995963]  [<ffffffff81054efa>] warn_slowpath_null+0x1a/0x20
Dec  5 02:20:48 server01 kernel: [  380.995965]  [<ffffffff8110b2e1>] T.1146+0x2c1/0x5d0
Dec  5 02:20:48 server01 kernel: [  380.995967]  [<ffffffff8110ba83>] mem_cgroup_charge_common+0x53/0x90
Dec  5 02:20:48 server01 kernel: [  380.995970]  [<ffffffff8110bb05>] mem_cgroup_newpage_charge+0x45/0x50
Dec  5 02:20:48 server01 kernel: [  380.995974]  [<ffffffff810eddf9>] handle_pte_fault+0x609/0x940
Dec  5 02:20:48 server01 kernel: [  380.995978]  [<ffffffff8102aa8f>] ? pte_alloc_one+0x3f/0x50
Dec  5 02:20:48 server01 kernel: [  380.995981]  [<ffffffff810ee268>] handle_mm_fault+0x138/0x260
Dec  5 02:20:48 server01 kernel: [  380.995983]  [<ffffffff810270ed>] do_page_fault+0x13d/0x460
Dec  5 02:20:48 server01 kernel: [  380.995986]  [<ffffffff810f429c>] ? do_mmap_pgoff+0x3dc/0x430
Dec  5 02:20:48 server01 kernel: [  380.995988]  [<ffffffff810f197d>] ? remove_vma+0x5d/0x80
Dec  5 02:20:48 server01 kernel: [  380.995992]  [<ffffffff815b54ff>] page_fault+0x1f/0x30
Dec  5 02:20:48 server01 kernel: [  380.995994] ---[ end trace 25bbb3e634c25b7f ]---
Dec  5 02:20:48 server01 kernel: [  380.996373] apache2 invoked oom-killer: gfp_mask=0x0, order=0, oom_adj=0, oom_score_adj=0
Dec  5 02:20:48 server01 kernel: [  380.996377] apache2 cpuset=uid mems_allowed=0
Dec  5 02:20:48 server01 kernel: [  380.996379] Pid: 5351, comm: apache2 Tainted: G        W    3.2.34-grsec #1
Dec  5 02:20:48 server01 kernel: [  380.996380] Call Trace:
Dec  5 02:20:48 server01 kernel: [  380.996384]  [<ffffffff810cc91e>] dump_header+0x7e/0x1e0
Dec  5 02:20:48 server01 kernel: [  380.996387]  [<ffffffff810cc81f>] ? find_lock_task_mm+0x2f/0x70
Dec  5 02:20:48 server01 kernel: [  380.996389]  [<ffffffff810ccde5>] oom_kill_process+0x85/0x2a0
Dec  5 02:20:48 server01 kernel: [  380.996392]  [<ffffffff810cd495>] out_of_memory+0xe5/0x200
Dec  5 02:20:48 server01 kernel: [  380.996394]  [<ffffffff8102aa8f>] ? pte_alloc_one+0x3f/0x50
Dec  5 02:20:48 server01 kernel: [  380.996397]  [<ffffffff810cd66d>] pagefault_out_of_memory+0xbd/0x110
Dec  5 02:20:48 server01 kernel: [  380.996399]  [<ffffffff81026ec6>] mm_fault_error+0xb6/0x1a0
Dec  5 02:20:48 server01 kernel: [  380.996401]  [<ffffffff8102739e>] do_page_fault+0x3ee/0x460
Dec  5 02:20:48 server01 kernel: [  380.996403]  [<ffffffff810f429c>] ? do_mmap_pgoff+0x3dc/0x430
Dec  5 02:20:48 server01 kernel: [  380.996405]  [<ffffffff810f197d>] ? remove_vma+0x5d/0x80
Dec  5 02:20:48 server01 kernel: [  380.996408]  [<ffffffff815b54ff>] page_fault+0x1f/0x30

OK, so the ENOMEM seems to be leaking from mem_cgroup_newpage_charge.
This can only happen if this was an atomic allocation request
(!__GFP_WAIT) or if oom is not allowed which is the case only for
transparent huge page allocation.
The first case can be excluded (in the clean 3.2 stable kernel) because
all callers of mem_cgroup_newpage_charge use GFP_KERNEL. The later one
should be OK because the page fault should fallback to a regular page if
THP allocation/charge fails.
[/me goes to double check]
Hmm do_huge_pmd_wp_page seems to charge a huge page and fails with
VM_FAULT_OOM without any fallback. We should do_huge_pmd_wp_page_fallback
instead. This has been fixed in 3.5-rc1 by 1f1d06c3 (thp, memcg: split
hugepage for memcg oom on cow) but it hasn't been backported to 3.2. The
patch applies to 3.2 without any further modifications. I didn't have
time to test it but if it helps you we should push this to the stable
tree.
---
From 765f5e0121c4410faa19c088e9ada75976bde178 Mon Sep 17 00:00:00 2001
From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Date: Tue, 29 May 2012 15:06:23 -0700
Subject: [PATCH] thp, memcg: split hugepage for memcg oom on cow

On COW, a new hugepage is allocated and charged to the memcg.  If the
system is oom or the charge to the memcg fails, however, the fault
handler will return VM_FAULT_OOM which results in an oom kill.

Instead, it's possible to fallback to splitting the hugepage so that the
COW results only in an order-0 page being allocated and charged to the
memcg which has a higher liklihood to succeed.  This is expensive
because the hugepage must be split in the page fault handler, but it is
much better than unnecessarily oom killing a process.

Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Signed-off-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
(cherry picked from commit 1f1d06c34f7675026326cd9f39ff91e4555cf355)
---
 mm/huge_memory.c |    3 +++
 mm/memory.c      |   18 +++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8f005e9..470cbb4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -921,6 +921,8 @@ int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		count_vm_event(THP_FAULT_FALLBACK);
 		ret = do_huge_pmd_wp_page_fallback(mm, vma, address,
 						   pmd, orig_pmd, page, haddr);
+		if (ret & VM_FAULT_OOM)
+			split_huge_page(page);
 		put_page(page);
 		goto out;
 	}
@@ -928,6 +930,7 @@ int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
 		put_page(new_page);
+		split_huge_page(page);
 		put_page(page);
 		ret |= VM_FAULT_OOM;
 		goto out;
diff --git a/mm/memory.c b/mm/memory.c
index 70f5daf..15e686a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3469,6 +3469,7 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (unlikely(is_vm_hugetlb_page(vma)))
 		return hugetlb_fault(mm, vma, address, flags);
 
+retry:
 	pgd = pgd_offset(mm, address);
 	pud = pud_alloc(mm, pgd, address);
 	if (!pud)
@@ -3482,13 +3483,24 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 							  pmd, flags);
 	} else {
 		pmd_t orig_pmd = *pmd;
+		int ret;
+
 		barrier();
 		if (pmd_trans_huge(orig_pmd)) {
 			if (flags & FAULT_FLAG_WRITE &&
 			    !pmd_write(orig_pmd) &&
-			    !pmd_trans_splitting(orig_pmd))
-				return do_huge_pmd_wp_page(mm, vma, address,
-							   pmd, orig_pmd);
+			    !pmd_trans_splitting(orig_pmd)) {
+				ret = do_huge_pmd_wp_page(mm, vma, address, pmd,
+							  orig_pmd);
+				/*
+				 * If COW results in an oom, the huge pmd will
+				 * have been split, so retry the fault on the
+				 * pte for a smaller charge.
+				 */
+				if (unlikely(ret & VM_FAULT_OOM))
+					goto retry;
+				return ret;
+			}
 			return 0;
 		}
 	}
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
