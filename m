From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: [PATCH -trivial 3/4] mm: memcontrol: Spelling s/invlidate/invalidate/, s/trucate/truncate/
Date: Sun, 29 Jun 2014 12:21:38 +0200
Message-ID: <1404037299-31570-3-git-send-email-geert@linux-m68k.org>
References: <1404037299-31570-1-git-send-email-geert@linux-m68k.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8zbYFMLurMnTHRc6RNzwrifOZ/rQzbeeq/Rtiet34+8=;
        b=B+y52n/P95OxDFsYzTGNKI1r4zNzkMXBK/RPPWqMKdrijIhfM0zci2s8iSBz4DvqIx
         UrjfSJeEWWktlKJn9cdWE+zJO0WovOf3+dw2anR/Qv9MJAbfyCmL/dLNCCekknf+hEiL
         cbqA3WtITWBwM6eAA9D4LzandPd0tT3MLCSseXLAdKdIIbAk2PH1CxrIhwn7lVTZWF1O
         SeGIy1gRD5MI3TxP/Bcy5Jo6hD6CPQYcghwPOUvmI6ZKlTB8xVlqyckhYMuG4UySrPNZ
         DD/dILHdER9m6aBQigFYa1sPYgey1sxboh0zrgprk4N3HZ0SeHV6VlQV/eg3MZmgSO57
         HHdw==
In-Reply-To: <1404037299-31570-1-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiri Kosina <trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a2c7bcb0e6eb..2c010573668e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4034,7 +4034,7 @@ void mem_cgroup_uncharge_cache_page(struct page *page)
 }
 
 /*
- * Batch_start/batch_end is called in unmap_page_range/invlidate/trucate.
+ * Batch_start/batch_end is called in unmap_page_range/invalidate/truncate.
  * In that cases, pages are freed continuously and we can expect pages
  * are in the same memcg. All these calls itself limits the number of
  * pages freed at once, then uncharge_start/end() is called properly.
-- 
1.9.1
