From: James Morse <james.morse@arm.com>
Subject: [PATCH] mm: memcontrol: Make the walk_page_range() limit obvious
Date: Wed, 31 Aug 2016 16:04:57 +0100
Message-ID: <1472655897-22532-1-git-send-email-james.morse@arm.com>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, James Morse <james.morse@arm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Trying to walk all of virtual memory requires architecture specific
knowledge. On x86_64, addresses must be sign extended from bit 48,
whereas on arm64 the top VA_BITS of address space have their own set
of page tables.

mem_cgroup_count_precharge() and mem_cgroup_move_charge() both call
walk_page_range() on the range 0 to ~0UL, neither provide a pte_hole
callback, which causes the current implementation to skip non-vma regions.

As this call only expects to walk user address space, make it walk
0 to  'highest_vm_end'.

Signed-off-by: James Morse <james.morse@arm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
This is in preparation for a RFC series that allows walk_page_range() to
walk kernel page tables too.

 mm/memcontrol.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2ff0289ad061..bfd54b43beb9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4712,7 +4712,8 @@ static unsigned long mem_cgroup_count_precharge(struct mm_struct *mm)
 		.mm = mm,
 	};
 	down_read(&mm->mmap_sem);
-	walk_page_range(0, ~0UL, &mem_cgroup_count_precharge_walk);
+	walk_page_range(0, mm->highest_vm_end,
+			&mem_cgroup_count_precharge_walk);
 	up_read(&mm->mmap_sem);
 
 	precharge = mc.precharge;
@@ -5000,7 +5001,8 @@ retry:
 	 * When we have consumed all precharges and failed in doing
 	 * additional charge, the page walk just aborts.
 	 */
-	walk_page_range(0, ~0UL, &mem_cgroup_move_charge_walk);
+	walk_page_range(0, mc.mm->highest_vm_end, &mem_cgroup_move_charge_walk);
+
 	up_read(&mc.mm->mmap_sem);
 	atomic_dec(&mc.from->moving_account);
 }
-- 
2.8.0.rc3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
