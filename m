From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: page_cgroup_ino() get memcg from the page's folio
Date: Wed, 12 Apr 2023 00:34:51 +0000
Message-ID: <20230412003451.4018887-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681259695; x=1683851695;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yIObXy3lJVLQ0GKopS+iRwrSvJGFvWWAFvhX3UspfPI=;
        b=DWINJdlLfA7bsA3GGGY3QqMkyHn4mFlvS/JIo4iW0TMLRVhU/gf7C1saDLJbgiMhyg
         1THSZqOvBE7mYalurr5DpB+0FcS448x6UlzZq4LCxUvT+p2BGmyTy5YgE1NSEM0zIhIU
         6wS+/+aKooKm7FQuVCzrBtZANDFi3UgfGVf65QRiGlph2U7sNmmMEdxB2T5rc3YOUyH9
         a1aiSVB8pFxOvsKL9KHKoN8NmzVNyhvUSpVMDYIvCLA0wxF0ldBH57sG0T1+qRafWsYh
         RbheDirj59ekdDNu91/r2Fz5vIwhgUWTsLc5GdFJJ3XkuToj6EsUXeRczct0dZdBnYn6
         +2ww==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Naoya Horiguchi <naoya.horiguchi-YMj9X0ASwKA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

In a kernel with added WARN_ON_ONCE(PageTail) in page_memcg_check(), we
observed a warning from page_cgroup_ino() when reading
/proc/kpagecgroup. This warning was added to catch fragile reads of
a page memcg. Make page_cgroup_ino() get memcg from the page's folio
using folio_memcg_check(): that gives it the correct memcg for each page
of a folio, so is the right fix.

Note that page_folio() is racy, the page's folio can change from under
us, but the entire function is racy and documented as such.

I dithered between the right fix and the safer "fix": it's unlikely but
conceivable that some userspace has learnt that /proc/kpagecgroup gives
no memcg on tail pages, and compensates for that in some (racy) way: so
continuing to give no memcg on tails, without warning, might be safer.

But hwpoison_filter_task(), the only other user of page_cgroup_ino(),
persuaded me. It looks as if it currently leaves out tail pages of the
selected memcg, by mistake: whereas hwpoison_inject() uses compound_head()
and expects the tails to be included. So hwpoison testing coverage has
probably been restricted by the wrong output from page_cgroup_ino() (if
that memcg filter is used at all): in the short term, it might be safer
not to enable wider coverage there, but long term we would regret that.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---

This is based on a patch originally written by Hugh Dickins and retains
most of the original commit log:
https://lore.kernel.org/linux-mm/20230313083452.1319968-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/

The patch was changed to use folio_memcg_check(page_folio(page)) instead
of page_memcg_check(compound_head(page)) based on discussions with
Matthew Wilcox; where he stated that callers of page_memcg_check()
should stop using it due to the ambiguity around tail pages -- instead
they should use folio_memcg_check() and handle tail pages themselves.

I dropped Michal's Ack as the only line in the patch was changed, but
the patch should be functionally the same.

---
 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5abffe6f8389..fec3c4fd9c1c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -395,7 +395,8 @@ ino_t page_cgroup_ino(struct page *page)
 	unsigned long ino = 0;
 
 	rcu_read_lock();
-	memcg = page_memcg_check(page);
+	/* page_folio() is racy here, but the entire function is racy anyway */
+	memcg = folio_memcg_check(page_folio(page));
 
 	while (memcg && !(memcg->css.flags & CSS_ONLINE))
 		memcg = parent_mem_cgroup(memcg);
-- 
2.40.0.577.gac1e443424-goog

