From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH for 5.8] mm: do_swap_page fix up the error code
 instantiation
Date: Wed, 17 Jun 2020 11:02:38 +0200
Message-ID: <20200617090238.GL9499@dhcp22.suse.cz>
References: <20200508183105.225460-1-hannes@cmpxchg.org>
 <20200508183105.225460-17-hannes@cmpxchg.org>
 <20200611093523.GB20450@dhcp22.suse.cz>
 <20200617084927.GK9499@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200617084927.GK9499@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Joonsoo Kim <js1304@gmail.com>, Shakeel Butt <shakeelb@google.com>, Hugh Dickins <hughd@google.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Damn, I forgot to commit my last change (s@err@ret@). Sorry about the
noise.

From 50297dd026ebf71fe901e1945a9ce1e8d8aa083b Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Wed, 17 Jun 2020 10:40:47 +0200
Subject: [PATCH] mm: do_swap_page fix up the error code

do_swap_page returns error codes from the VM_FAULT* space. try_charge
might return -ENOMEM, though, and then do_swap_page simply returns 0
which means a success.

We almost never return ENOMEM for GFP_KERNEL single page charge. Except
for async OOM handling (oom_disabled v1). So this needs translation to
VM_FAULT_OOM otherwise the the page fault path will not notify the
userspace and wait for an action.

Fixes: 4c6355b25e8b ("mm: memcontrol: charge swapin pages on instantiation")
Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 mm/memory.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index dc7f3543b1fd..1c632faa2611 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3140,8 +3140,10 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 				err = mem_cgroup_charge(page, vma->vm_mm,
 							GFP_KERNEL);
 				ClearPageSwapCache(page);
-				if (err)
+				if (err) {
+					ret = VM_FAULT_OOM;
 					goto out_page;
+				}
 
 				lru_cache_add(page);
 				swap_readpage(page, true);
-- 
2.26.2

-- 
Michal Hocko
SUSE Labs
