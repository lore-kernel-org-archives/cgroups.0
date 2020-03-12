From: Chris Down <chris@chrisdown.name>
Subject: [PATCH 4/6] mm, memcg: Prevent memory.min load/store tearing
Date: Thu, 12 Mar 2020 17:33:07 +0000
Message-ID: <e809b4e6b0c1626dac6945970de06409a180ee65.1584034301.git.chris@chrisdown.name>
References: <cover.1584034301.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XlHPYdHYVGL+ZH9Fy2ExhyAo23ZIkMLKS1ZUcqxxQY0=;
        b=up0/TKVQ7COgyqEd0H7isdZkegQuEbx6al4+9E95wP3QiMQsdxvH9836eQ+LluSIC5
         RrbHhXsGGbJAFQXjNgehCBmeLiF93Sg8ahlpsQiK3ct/C8obWCIZR0CUU9z9GnAc5QUt
         /KMm82i4Ln7WBp4XE3Bm+5wpBL7eIdIAKbhSk=
Content-Disposition: inline
In-Reply-To: <cover.1584034301.git.chris@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

This can be set concurrently with reads, which may cause the wrong value
to be propagated.

Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org
Cc: cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kernel-team@fb.com
---
 mm/memcontrol.c   |  4 ++--
 mm/page_counter.c | 10 ++++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c85a304fa4a1..e0ed790a2a8c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6261,7 +6261,7 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
 	if (!usage)
 		return MEMCG_PROT_NONE;
 
-	emin = memcg->memory.min;
+	emin = READ_ONCE(memcg->memory.min);
 	elow = READ_ONCE(memcg->memory.low);
 
 	parent = parent_mem_cgroup(memcg);
@@ -6277,7 +6277,7 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
 	if (emin && parent_emin) {
 		unsigned long min_usage, siblings_min_usage;
 
-		min_usage = min(usage, memcg->memory.min);
+		min_usage = min(usage, READ_ONCE(memcg->memory.min));
 		siblings_min_usage = atomic_long_read(
 			&parent->memory.children_min_usage);
 
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 18b7f779f2e2..ae471c7d255f 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -17,14 +17,16 @@ static void propagate_protected_usage(struct page_counter *c,
 				      unsigned long usage)
 {
 	unsigned long protected, old_protected;
-	unsigned long low;
+	unsigned long low, min;
 	long delta;
 
 	if (!c->parent)
 		return;
 
-	if (c->min || atomic_long_read(&c->min_usage)) {
-		if (usage <= c->min)
+	min = READ_ONCE(c->min);
+
+	if (min || atomic_long_read(&c->min_usage)) {
+		if (usage <= min)
 			protected = usage;
 		else
 			protected = 0;
@@ -217,7 +219,7 @@ void page_counter_set_min(struct page_counter *counter, unsigned long nr_pages)
 {
 	struct page_counter *c;
 
-	counter->min = nr_pages;
+	WRITE_ONCE(counter->min, nr_pages);
 
 	for (c = counter; c; c = c->parent)
 		propagate_protected_usage(c, atomic_long_read(&c->usage));
-- 
2.25.1

