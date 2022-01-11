From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/4] mm/memcg: refine mem_cgroup_threshold_ary->current_threshold calculation
Date: Tue, 11 Jan 2022 01:03:02 +0000
Message-ID: <20220111010302.8864-4-richard.weiyang@gmail.com>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GGc1cimFOcena0hJzqhAcjsWeuG9TQ4RXCir27mg2t0=;
        b=jiQ42Y7CHZZtZfr0P6hnQ1aVpXrkyGGjHJiEJOydtLNdPEG98j73wqZIJmQ9nliUJq
         J8LzTE0O/1GYG3WOJELkKIwETtKtExvdajuPIgvNc5VIDMug1EMI2Mbai/e/1+Y4Mqjr
         1GK0ffaC+9QPT+hva3tBcOlyu8XHTaixj6ubnRBdGjpvfqB8sO3SXR0VGS+MUSwuuhFo
         DyYkAWi3xQH/oUUXXZkM1gW8sAycY9KXnLpi0z9UujlQ6QG6xXbQ9i6/lpRiCrDVU+SS
         N6cSB1GWILoSdYPMstvbbLEMY73ykEfolAjOkGoiKBqqtXJGeuMNGd1oLCbJi6kWtEVH
         iQAw==
In-Reply-To: <20220111010302.8864-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

mem_cgroup_threshold_ary->current_threshold points to the last entry
who's threshold is less or equal to usage.

Instead of iterating entries to get the correct index, we can leverage
primary->current_threshold to get it. If the threshold added is less or
equal to usage, current_threshold should increase by one. Otherwise, it
doesn't change.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a504616f904a..ce7060907df2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4161,7 +4161,7 @@ static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
 	struct mem_cgroup_threshold_ary *new;
 	unsigned long threshold;
 	unsigned long usage;
-	int i, size, ret;
+	int size, ret;
 
 	ret = page_counter_memparse(args, "-1", &threshold);
 	if (ret)
@@ -4193,9 +4193,13 @@ static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
 	new->size = size;
 
 	/* Copy thresholds (if any) to new array */
-	if (thresholds->primary)
+	if (thresholds->primary) {
 		memcpy(new->entries, thresholds->primary->entries,
 		       flex_array_size(new, entries, size - 1));
+		new->current_threshold = thresholds->primary->current_threshold;
+	} else {
+		new->current_threshold = -1;
+	}
 
 	/* Add new threshold */
 	new->entries[size - 1].eventfd = eventfd;
@@ -4205,18 +4209,17 @@ static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
 	sort(new->entries, size, sizeof(*new->entries),
 			compare_thresholds, NULL);
 
-	/* Find current threshold */
-	new->current_threshold = -1;
-	for (i = 0; i < size; i++) {
-		if (new->entries[i].threshold <= usage) {
-			/*
-			 * new->current_threshold will not be used until
-			 * rcu_assign_pointer(), so it's safe to increment
-			 * it here.
-			 */
-			++new->current_threshold;
-		} else
-			break;
+	/*
+	 * If the threshold added here is less or equal to usage, this means
+	 * current_threshold need to increase by one.
+	 */
+	if (threshold <= usage) {
+		/*
+		 * new->current_threshold will not be used until
+		 * rcu_assign_pointer(), so it's safe to increment
+		 * it here.
+		 */
+		new->current_threshold++;
 	}
 
 	/* Free old spare buffer and save old primary buffer as spare */
-- 
2.33.1

