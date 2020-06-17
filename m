From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for 5.8] mm: do_swap_page fix up the error code instantiation
Date: Wed, 17 Jun 2020 10:49:27 +0200
Message-ID: <20200617084927.GK9499@dhcp22.suse.cz>
References: <20200508183105.225460-1-hannes@cmpxchg.org>
 <20200508183105.225460-17-hannes@cmpxchg.org>
 <20200611093523.GB20450@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200611093523.GB20450-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

I hope I haven't missed anything but the patch should be the following.

From acd488c22b4bb2ee42526be8ca67145d5127b014 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
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
Signed-off-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
---
 mm/memory.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index dc7f3543b1fd..d944b7946b27 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3140,8 +3140,10 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 				err = mem_cgroup_charge(page, vma->vm_mm,
 							GFP_KERNEL);
 				ClearPageSwapCache(page);
-				if (err)
+				if (err) {
+					err = VM_FAULT_OOM;
 					goto out_page;
+				}
 
 				lru_cache_add(page);
 				swap_readpage(page, true);
-- 
2.26.2

-- 
Michal Hocko
SUSE Labs
