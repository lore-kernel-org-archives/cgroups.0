From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [RFC PATCH] mm: memcontrol: don't account swap failures not due to cgroup limits
Date: Thu,  2 Feb 2023 10:56:26 -0500
Message-ID: <20230202155626.1829121-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IcK2j7GaecPZ1Vx44z6AigZg/DHMEIHlEpQ2CSXmGNM=;
        b=0/2QcsVnBHC20DmS2GdpIB11iAxP9z1WAI7Y8vitVSx3DLYzJM2Yap61ooPAdTvQ4q
         6zU45QD9XPGJ9qh9EXvxA0vwy6ap0T+oeZtY4OHAkqmn7NF5bF+ci2FkIN57tcMuT8Cj
         qdmgblY3QKvKhbbDgPQhgpoIWKPDxp3A1mA/1WXAhGY+Jbzhq0TNnLoK1kYzgyfE6gvs
         B6ZDalOl0eVh2kgFGsonC2DbI9vwH4laWAp2OkcqNZbB5BKsiJ/uHHgxcuuyL/CDAKRo
         U/Iw2hQ+ONWFW22h4t20EWnb/CLcg4oCnPZyaQC//Z12zJBJkX4sd9HWdXQnJM7+Ldjv
         Vr/g==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Christian reports the following situation in a cgroup that doesn't
have memory.swap.max configured:

  $ cat memory.swap.events
  high 0
  max 0
  fail 6218

Upon closer examination, this is an ARM64 machine that doesn't support
swapping out THPs. In that case, the first get_swap_page() fails, and
the kernel falls back to splitting the THP and swapping the 4k
constituents one by one. /proc/vmstat confirms this with a high rate
of thp_swpout_fallback events.

While the behavior can ultimately be explained, it's unexpected and
confusing. I see three choices how to address this:

a) Specifically exlude THP fallbacks from being counted, as the
   failure is transient and the memory is ultimately swapped.

   Arguably, though, the user would like to know if their cgroup's
   swap limit is causing high rates of THP splitting during swapout.

b) Only count cgroup swap events when they are actually due to a
   cgroup's own limit. Exclude failures that are due to physical swap
   shortage or other system-level conditions (like !THP_SWAP). Also
   count them at the level where the limit is configured, which may be
   above the local cgroup that holds the page-to-be-swapped.

   This is in line with how memory.swap.high, memory.high and
   memory.max events are counted.

   However, it's a change in documented behavior.

c) Leave it as is. The documentation says system-level events are
   counted, so stick to that.

   This is the conservative option, but isn't very user friendly.
   Cgroup events are usually due to a local control choice made by the
   user. Mixing in events that are beyond the user's control makes it
   difficult to id root causes and configure the system properly.

Implement option b).

Reported-by: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst |  6 +++---
 mm/memcontrol.c                         | 12 +++++-------
 mm/swap_slots.c                         |  2 +-
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index c8ae7c897f14..a8ffb89a4169 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1605,9 +1605,9 @@ PAGE_SIZE multiple when read back.
 		failed.
 
 	  fail
-		The number of times swap allocation failed either
-		because of running out of swap system-wide or max
-		limit.
+
+		The number of times swap allocation failed because of
+		the max limit.
 
 	When reduced under the current usage, the existing swap
 	entries are reclaimed gradually and the swap usage may stay
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ab457f0394ab..c2a6206ce84b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7470,17 +7470,15 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 	if (!memcg)
 		return 0;
 
-	if (!entry.val) {
-		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		return 0;
-	}
-
 	memcg = mem_cgroup_id_get_online(memcg);
 
 	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
-		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
-		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
+		struct mem_cgroup *swap_over_limit;
+
+		swap_over_limit = mem_cgroup_from_counter(counter, swap);
+		memcg_memory_event(swap_over_limit, MEMCG_SWAP_MAX);
+		memcg_memory_event(swap_over_limit, MEMCG_SWAP_FAIL);
 		mem_cgroup_id_put(memcg);
 		return -ENOMEM;
 	}
diff --git a/mm/swap_slots.c b/mm/swap_slots.c
index 0bec1f705f8e..66076bd60e2b 100644
--- a/mm/swap_slots.c
+++ b/mm/swap_slots.c
@@ -342,7 +342,7 @@ swp_entry_t folio_alloc_swap(struct folio *folio)
 
 	get_swap_pages(1, &entry, 1);
 out:
-	if (mem_cgroup_try_charge_swap(folio, entry)) {
+	if (entry.val && mem_cgroup_try_charge_swap(folio, entry) < 0) {
 		put_swap_folio(folio, entry);
 		entry.val = 0;
 	}
-- 
2.39.1

