From: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 2/4] mm: Fix get_mctgt_type() kernel-doc
Date: Fri, 18 Aug 2023 21:06:28 +0100
Message-ID: <20230818200630.2719595-3-willy@infradead.org>
References: <20230818200630.2719595-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=H22wfoU9WmEkYEOI01RrpJTB8uzVeuDiXA5dlaT4Dc0=; b=DtFJI03cyruQ7/gwxPDSCMj7Mt
        P7ih/uMjbC/Hacz5WgyFcuMutT4pErsivhRTYQEcszmURU+a9Y575Pn7GK61xVl5JRekPeoM89EVX
        ZoP1r+vGiVM1o3Yd71Zr+SowTe+QhoRKq6QridfZAiz2n1aXhpZ0Ny31IQVbh7NUlF/bxVDWiLhN+
        /hsHBY5hsZ/kkSh0S1MTJJXm+CnVRW8d8B/yOBOPvVua6tf9awy+XGYc0GMzJTUej9x7JAz4+lbPQ
        O34tQw0e2/7/EDgYoKrsvSRiHAUmoGY2PoF+R50Ie/03rQ+AYed5NnsHzh3enTnSwUNnxNyUVafeP
        dg+Tw5yQ==;
In-Reply-To: <20230818200630.2719595-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Convert the return values to an ReST list and tidy up the wording while
I'm touching it.

Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 mm/memcontrol.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e041ba827e59..cd8b3ae6b8d9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5850,25 +5850,20 @@ static int mem_cgroup_move_account(struct page *page,
  * @ptent: the pte to be checked
  * @target: the pointer the target page or swap ent will be stored(can be NULL)
  *
- * Returns
- *   0(MC_TARGET_NONE): if the pte is not a target for move charge.
- *   1(MC_TARGET_PAGE): if the page corresponding to this pte is a target for
- *     move charge. if @target is not NULL, the page is stored in target->page
- *     with extra refcnt got(Callers should handle it).
- *   2(MC_TARGET_SWAP): if the swap entry corresponding to this pte is a
- *     target for charge migration. if @target is not NULL, the entry is stored
- *     in target->ent.
- *   3(MC_TARGET_DEVICE): like MC_TARGET_PAGE  but page is device memory and
- *   thus not on the lru.
- *     For now we such page is charge like a regular page would be as for all
- *     intent and purposes it is just special memory taking the place of a
- *     regular page.
- *
- *     See Documentations/vm/hmm.txt and include/linux/hmm.h
- *
- * Called with pte lock held.
+ * Context: Called with pte lock held.
+ * Return:
+ * * MC_TARGET_NONE - If the pte is not a target for move charge.
+ * * MC_TARGET_PAGE - If the page corresponding to this pte is a target for
+ *   move charge. If @target is not NULL, the page is stored in target->page
+ *   with extra refcnt got (Callers should handle it).
+ * * MC_TARGET_SWAP - If the swap entry corresponding to this pte is a
+ *   target for charge migration. if @target is not NULL, the entry is stored
+ *   in target->ent.
+ * * MC_TARGET_DEVICE - Like MC_TARGET_PAGE but page is device memory and
+ *   thus not on the lru.  For now such page is charged like a regular page
+ *   would be as it is just special memory taking the place of a regular page.
+ *   See Documentations/vm/hmm.txt and include/linux/hmm.h
  */
-
 static enum mc_target_type get_mctgt_type(struct vm_area_struct *vma,
 		unsigned long addr, pte_t ptent, union mc_target *target)
 {
-- 
2.40.1

