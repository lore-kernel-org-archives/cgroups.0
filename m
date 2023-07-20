From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 5/8] memcg: recharge folios when accessed or dirtied
Date: Thu, 20 Jul 2023 07:08:22 +0000
Message-ID: <20230720070825.992023-6-yosryahmed@google.com>
References: <20230720070825.992023-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689836917; x=1692428917;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OzwAcynUjm4TDDZtYUdTlt8GRef6hCkFmXsjGPYLvQA=;
        b=QdsbdWEvmo4m7dFreE18whaI10HNxA5U6Eq4dlh5z46nHRuNKvgnmtyQrlecaO4sV8
         pWMQ+xztiQx/wc1YGWhMYzOCtuiM6PjW82kZXGkYJ68Xwsx5KrsGhi4OgbRK80gIgcB7
         clLYTavc+M9b93VW/QkD9WL4K9KunD/+0BOFjNktnoseyObLt2ro/bWXeUjfsH//HPvv
         iKo/LdVH7XZs+1rJF1M/AwxhXSl+9z13Axu/a0fHLc9te/mN1I0tCp0Us23Ispa/XUDp
         ufe5XWIgsZtbi6tiF99R36YBIvSUA+Db8luFMXb3WtMXUvnpGh0pFJrrPbseVvr7ZJUC
         YeoA==
In-Reply-To: <20230720070825.992023-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

The previous patch provided support for deferred recharging of folios
when their memcgs go offline. This patch adds recharging hooks to
folio_mark_accessed() and folio_mark_dirty().
This should cover a variety of code paths where folios are accessed by
userspace.

The hook, folio_memcg_deferred_recharge() only checks if the folio is
charged to an offline memcg in the common fast path (i.e checks
folio->memcg_data). If yes, an asynchronous worker is queued to do the
actual work.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/page-writeback.c | 2 ++
 mm/swap.c           | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index d3f42009bb70..a644530d98c7 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2785,6 +2785,8 @@ bool folio_mark_dirty(struct folio *folio)
 {
 	struct address_space *mapping = folio_mapping(folio);
 
+	folio_memcg_deferred_recharge(folio);
+
 	if (likely(mapping)) {
 		/*
 		 * readahead/folio_deactivate could remain
diff --git a/mm/swap.c b/mm/swap.c
index cd8f0150ba3a..296c0b87c967 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -457,6 +457,8 @@ static void folio_inc_refs(struct folio *folio)
  */
 void folio_mark_accessed(struct folio *folio)
 {
+	folio_memcg_deferred_recharge(folio);
+
 	if (lru_gen_enabled()) {
 		folio_inc_refs(folio);
 		return;
-- 
2.41.0.255.g8b1d071c50-goog

