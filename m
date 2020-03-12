From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: [PATCH 1/6] mm, memcg: Prevent memory.high load/store tearing
Date: Thu, 12 Mar 2020 17:32:51 +0000
Message-ID: <2f66f7038ed1d4688e59de72b627ae0ea52efa83.1584034301.git.chris@chrisdown.name>
References: <cover.1584034301.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CcUuUlC43ZZSpfh7MoEkxpHRz/YQaDQ0sa4yKp/08VA=;
        b=LB2RpnhyFSTH3hVgjWSNFLifh6wVwkygWTfWLNDnxQPIIBKr4BpapuRzF1lJYa0M15
         UbSB1s+QSe7P8Bx+GLZMQ+cV7gO4cfbRWGjeLOLvLCaijAjS6Lpr8ZOYSHWG8HOqN/hu
         kT1oLw9Sjvc/qjL4Kh04/aFvpCsvKUXlmqg/Y=
Content-Disposition: inline
In-Reply-To: <cover.1584034301.git.chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

A mem_cgroup's high attribute can be concurrently set at the same time
as we are trying to read it -- for example, if we are in
memory_high_write at the same time as we are trying to do high reclaim.

Signed-off-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kernel-team-b10kYP2dOMg@public.gmane.org
---
 mm/memcontrol.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 63bb6a2aab81..d32d3c0a16d4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2228,7 +2228,7 @@ static void reclaim_high(struct mem_cgroup *memcg,
 			 gfp_t gfp_mask)
 {
 	do {
-		if (page_counter_read(&memcg->memory) <= memcg->high)
+		if (page_counter_read(&memcg->memory) <= READ_ONCE(memcg->high))
 			continue;
 		memcg_memory_event(memcg, MEMCG_HIGH);
 		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
@@ -2545,7 +2545,7 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * reclaim, the cost of mismatch is negligible.
 	 */
 	do {
-		if (page_counter_read(&memcg->memory) > memcg->high) {
+		if (page_counter_read(&memcg->memory) > READ_ONCE(memcg->high)) {
 			/* Don't bother a random interrupted task */
 			if (in_interrupt()) {
 				schedule_work(&memcg->high_work);
@@ -4257,7 +4257,8 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
 	*pheadroom = PAGE_COUNTER_MAX;
 
 	while ((parent = parent_mem_cgroup(memcg))) {
-		unsigned long ceiling = min(memcg->memory.max, memcg->high);
+		unsigned long ceiling = min(memcg->memory.max,
+					    READ_ONCE(memcg->high));
 		unsigned long used = page_counter_read(&memcg->memory);
 
 		*pheadroom = min(*pheadroom, ceiling - min(ceiling, used));
@@ -4978,7 +4979,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	if (!memcg)
 		return ERR_PTR(error);
 
-	memcg->high = PAGE_COUNTER_MAX;
+	WRITE_ONCE(memcg->high, PAGE_COUNTER_MAX);
 	memcg->soft_limit = PAGE_COUNTER_MAX;
 	if (parent) {
 		memcg->swappiness = mem_cgroup_swappiness(parent);
@@ -5131,7 +5132,7 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
-	memcg->high = PAGE_COUNTER_MAX;
+	WRITE_ONCE(memcg->high, PAGE_COUNTER_MAX);
 	memcg->soft_limit = PAGE_COUNTER_MAX;
 	memcg_wb_domain_size_changed(memcg);
 }
@@ -5947,7 +5948,7 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 	if (err)
 		return err;
 
-	memcg->high = high;
+	WRITE_ONCE(memcg->high, high);
 
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
-- 
2.25.1

