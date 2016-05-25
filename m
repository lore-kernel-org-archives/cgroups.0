From: roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] mm: memcontrol: remove the useless parameter for mc_handle_swap_pte
Date: Wed, 25 May 2016 10:57:06 +0800
Message-ID: <1464145026-26693-1-git-send-email-roy.qing.li@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org

From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 36b7ecf..c628c90 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4386,7 +4386,7 @@ static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
 
 #ifdef CONFIG_SWAP
 static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
-			unsigned long addr, pte_t ptent, swp_entry_t *entry)
+			pte_t ptent, swp_entry_t *entry)
 {
 	struct page *page = NULL;
 	swp_entry_t ent = pte_to_swp_entry(ptent);
@@ -4405,7 +4405,7 @@ static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
 }
 #else
 static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
-			unsigned long addr, pte_t ptent, swp_entry_t *entry)
+			pte_t ptent, swp_entry_t *entry)
 {
 	return NULL;
 }
@@ -4570,7 +4570,7 @@ static enum mc_target_type get_mctgt_type(struct vm_area_struct *vma,
 	if (pte_present(ptent))
 		page = mc_handle_present_pte(vma, addr, ptent);
 	else if (is_swap_pte(ptent))
-		page = mc_handle_swap_pte(vma, addr, ptent, &ent);
+		page = mc_handle_swap_pte(vma, ptent, &ent);
 	else if (pte_none(ptent))
 		page = mc_handle_file_pte(vma, addr, ptent, &ent);
 
-- 
2.1.4
