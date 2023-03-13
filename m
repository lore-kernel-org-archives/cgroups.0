From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: page_cgroup_ino() get memcg from compound_head(page)
Date: Mon, 13 Mar 2023 08:34:52 +0000
Message-ID: <20230313083452.1319968-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678696495;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zeDiTo83CJOPfROIycQGpKJpY/woSMBEn4wJ2l9Oc3A=;
        b=VJLAMhtXlqTwGgXDKCTVn6HNH8J7Yb49JpBXa71bKEU+b8UV7Pfw4XnV3NJlgObfWR
         dsMVPpiYzyL+5/bmZeKIlzocq5lZDLUEIdEzYQ+l+SjF9mGT9Pqh276648bG03w2Bf4L
         zwYel8rQA26f0lY3rYcJALEiOuEu8HsNuNgUPyCu7rrMjImD34V9QNoVfiGc4Pn4ZgnY
         BHyEoGPJcoEqbfOwQd0dGFuvXoVeikT40ffzVLYSDDPFqOOfwnu2rb9l7QedPR2tVVK9
         JpY7HwxqXLi30xpw6Hyawjr8gHfVwVGmTu5K+o7/00SdSoYGb9i2i2o+s3cx6qjv9IAS
         Xcfw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Naoya Horiguchi <naoya.horiguchi-YMj9X0ASwKA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

In a kernel with added WARN_ON_ONCE(PageTail) in page_memcg_check(), we
observed a warning from page_cgroup_ino() when reading
/proc/kpagecgroup. This warning was added to catch fragile reads of
a page memcg. Make page_cgroup_ino() get memcg from compound_head(page):
that gives it the correct memcg for each subpage of a compound page,
so is the right fix.

I dithered between the right fix and the safer "fix": it's unlikely but
conceivable that some userspace has learnt that /proc/kpagecgroup gives
no memcg on tail pages, and compensates for that in some (racy) way: so
continuing to give no memcg on tails, without warning, might be safer.

But hwpoison_filter_task(), the only other user of page_cgroup_ino(),
persuaded me.  It looks as if it currently leaves out tail pages of the
selected memcg, by mistake: whereas hwpoison_inject() uses compound_head()
and expects the tails to be included.  So hwpoison testing coverage has
probably been restricted by the wrong output from page_cgroup_ino() (if
that memcg filter is used at all): in the short term, it might be safer
not to enable wider coverage there, but long term we would regret that.

Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---

(Yosry: Alternatively, we could modify page_memcg_check() to do
 page_folio() like its sibling page_memcg(), as page_cgroup_ino() is the
 only remaining caller other than print_page_owner_memcg(); and it already
 excludes pages that have page->memcg_data = 0)

---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5abffe6f8389..e3a55295725e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -395,7 +395,7 @@ ino_t page_cgroup_ino(struct page *page)
 	unsigned long ino = 0;
 
 	rcu_read_lock();
-	memcg = page_memcg_check(page);
+	memcg = page_memcg_check(compound_head(page));
 
 	while (memcg && !(memcg->css.flags & CSS_ONLINE))
 		memcg = parent_mem_cgroup(memcg);
-- 
2.40.0.rc1.284.g88254d51c5-goog

