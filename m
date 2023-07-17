From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mm/memcg: minor cleanup for mc_handle_present_pte()
Date: Mon, 17 Jul 2023 19:36:44 +0800
Message-ID: <20230717113644.3026478-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

When pagetable lock is held, the page will always be page_mapped(). So
remove unneeded page_mapped() check. Also the page can't be freed from
under us in this case. So use get_page() to get extra page reference to
simplify the code. No functional change intended.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 284396ea8a33..60b5ff3b4a52 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5649,7 +5649,7 @@ static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
 {
 	struct page *page = vm_normal_page(vma, addr, ptent);
 
-	if (!page || !page_mapped(page))
+	if (!page)
 		return NULL;
 	if (PageAnon(page)) {
 		if (!(mc.flags & MOVE_ANON))
@@ -5658,8 +5658,7 @@ static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
 		if (!(mc.flags & MOVE_FILE))
 			return NULL;
 	}
-	if (!get_page_unless_zero(page))
-		return NULL;
+	get_page(page);
 
 	return page;
 }
-- 
2.33.0

