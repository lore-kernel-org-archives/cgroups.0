From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: fix unsafe page -> lruvec lookups with cgroup charge
 migration
Date: Wed, 20 Nov 2019 16:39:31 -0500
Message-ID: <20191120213931.GB428283@cmpxchg.org>
References: <20191120165847.423540-1-hannes@cmpxchg.org>
 <CALvZod50AanTCNkTVSptU+Hg--69j6OuKdc04UPs4Vf64DkGiw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F4UOOlylYKA4x5XwS/IcSHBpAnEOvDZz0DmXXFZBpcA=;
        b=HWlZvj1c8bNqbGRODv0AgUEGYJvuTzXv3y+PxWcWyLnvLfcKURUZIzxXfU266k3473
         zbm+2dXSBVQG2y2z1Oz1GVrmV3K4GqVzfEG7zivXUO+Tam1zvCqDHyjQpjdWw5WCQwLm
         lzbmvkCSZzNFsiSddiHgU/kP3GzsDD8kMA6FBzb/GPXKxoZTvK43OXZwWhrLYABsdeLv
         GZzAl8OT/xf1vbkEt4gyPza/zcf80oiyWvZOoFYYtZA3z2QPhwDT+f6UtVa8Ol7zZ6Xd
         Z9ETSaZqziR1SUsWpnqyTYIPJuX9pTSwaZV0jCr+JJoXoHoF6WNgYWqzHywVVMTJWeDm
         6YrQ==
Content-Disposition: inline
In-Reply-To: <CALvZod50AanTCNkTVSptU+Hg--69j6OuKdc04UPs4Vf64DkGiw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, Alex Shi <alex.shi@linux.alibaba.com>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Wed, Nov 20, 2019 at 12:31:06PM -0800, Shakeel Butt wrote:
> On Wed, Nov 20, 2019 at 8:58 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > While reviewing the "per lruvec lru_lock for memcg" series, Hugh and I
> > noticed two places in the existing code where the page -> memcg ->
> > lruvec lookup can result in a use-after-free bug. This affects cgroup1
> > setups that have charge migration enabled.
> >
> > To pin page->mem_cgroup, callers need to either have the page locked,
> > an exclusive refcount (0), or hold the lru_lock and "own" PageLRU
> > (either ensure it's set, or be the one to hold the page in isolation)
> > to make cgroup migration fail the isolation step.
> 
> I think we should add the above para in the comments for better visibility.

Good idea. I'm attaching a delta patch below.

> > Reported-by: Hugh Dickins <hughd@google.com>
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Reviewed-by: Shakeel Butt <shakeelb@google.com>

Thanks!

---
From 73b58ce09009cce668ea97d9e047611c60e95bd6 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Wed, 20 Nov 2019 16:36:03 -0500
Subject: [PATCH] mm: fix unsafe page -> lruvec lookups with cgroup charge
 migration fix

Better document the mem_cgroup_page_lruvec() caller requirements.

Suggested-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 50f5bc55fcec..2d700fa0d7f4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1202,9 +1202,18 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
  * @page: the page
  * @pgdat: pgdat of the page
  *
- * This function is only safe when following the LRU page isolation
- * and putback protocol: the LRU lock must be held, and the page must
- * either be PageLRU() or the caller must have isolated/allocated it.
+ * NOTE: The returned lruvec is only stable if the calling context has
+ * the page->mem_cgroup pinned! This is accomplished by satisfying one
+ * of the following criteria:
+ *
+ *    a) have the @page locked
+ *    b) have an exclusive reference to @page (e.g. refcount 0)
+ *    c) hold the lru_lock and "own" the PageLRU (meaning either ensure
+ *       it's set, or be the one to hold the page in isolation)
+ *
+ * Otherwise, the page could be freed or moved out of the memcg,
+ * thereby releasing its reference on the memcg and potentially
+ * freeing it and its lruvecs in the process.
  */
 struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgdat)
 {
-- 
2.24.0

