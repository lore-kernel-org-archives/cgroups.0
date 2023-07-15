From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mm/memcg: use get_page() for device private pages in mc_handle_swap_pte()
Date: Sat, 15 Jul 2023 11:28:02 +0800
Message-ID: <20230715032802.2508163-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

When page table locked is held, the page can't be freed from under us.
So use get_page() to get the extra page reference to simplify the code.
No functional change intended.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 93e3cc581b51..4ca382efb1ca 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5670,8 +5670,9 @@ static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
 	 */
 	if (is_device_private_entry(ent)) {
 		page = pfn_swap_entry_to_page(ent);
-		if (!get_page_unless_zero(page))
-			return NULL;
+		/* Get a page reference while we know the page can't be freed. */
+		get_page(page);
+
 		return page;
 	}
 
-- 
2.33.0

