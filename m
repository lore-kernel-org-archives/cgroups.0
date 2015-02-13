From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch] mm: memcontrol: use "max" instead of "infinity" in control knobs
Date: Fri, 13 Feb 2015 11:37:40 -0500
Message-ID: <1423845460-14673-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The memcg control knobs indicate the highest possible value using the
symbolic name "infinity", which is long and awkward to type.

Switch to the string "max", which is just as descriptive but shorter
and sweeter.

This changes a user interface, so do it before the release and before
the development flag is dropped from the default hierarchy.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 Documentation/cgroups/unified-hierarchy.txt |  4 ++--
 mm/memcontrol.c                             | 12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/cgroups/unified-hierarchy.txt b/Documentation/cgroups/unified-hierarchy.txt
index 71daa35ec2d9..eb102fb72213 100644
--- a/Documentation/cgroups/unified-hierarchy.txt
+++ b/Documentation/cgroups/unified-hierarchy.txt
@@ -404,8 +404,8 @@ supported and the interface files "release_agent" and
   be understood as an underflow into the highest possible value, -2 or
   -10M etc. do not work, so it's not consistent.
 
-  memory.low, memory.high, and memory.max will use the string
-  "infinity" to indicate and set the highest possible value.
+  memory.low, memory.high, and memory.max will use the string "max" to
+  indicate and set the highest possible value.
 
 5. Planned Changes
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d18d3a6e7337..ef1b0be6f8e1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5247,7 +5247,7 @@ static int memory_low_show(struct seq_file *m, void *v)
 	unsigned long low = ACCESS_ONCE(memcg->low);
 
 	if (low == PAGE_COUNTER_MAX)
-		seq_puts(m, "infinity\n");
+		seq_puts(m, "max\n");
 	else
 		seq_printf(m, "%llu\n", (u64)low * PAGE_SIZE);
 
@@ -5262,7 +5262,7 @@ static ssize_t memory_low_write(struct kernfs_open_file *of,
 	int err;
 
 	buf = strstrip(buf);
-	err = page_counter_memparse(buf, "infinity", &low);
+	err = page_counter_memparse(buf, "max", &low);
 	if (err)
 		return err;
 
@@ -5277,7 +5277,7 @@ static int memory_high_show(struct seq_file *m, void *v)
 	unsigned long high = ACCESS_ONCE(memcg->high);
 
 	if (high == PAGE_COUNTER_MAX)
-		seq_puts(m, "infinity\n");
+		seq_puts(m, "max\n");
 	else
 		seq_printf(m, "%llu\n", (u64)high * PAGE_SIZE);
 
@@ -5292,7 +5292,7 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 	int err;
 
 	buf = strstrip(buf);
-	err = page_counter_memparse(buf, "infinity", &high);
+	err = page_counter_memparse(buf, "max", &high);
 	if (err)
 		return err;
 
@@ -5307,7 +5307,7 @@ static int memory_max_show(struct seq_file *m, void *v)
 	unsigned long max = ACCESS_ONCE(memcg->memory.limit);
 
 	if (max == PAGE_COUNTER_MAX)
-		seq_puts(m, "infinity\n");
+		seq_puts(m, "max\n");
 	else
 		seq_printf(m, "%llu\n", (u64)max * PAGE_SIZE);
 
@@ -5322,7 +5322,7 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 	int err;
 
 	buf = strstrip(buf);
-	err = page_counter_memparse(buf, "infinity", &max);
+	err = page_counter_memparse(buf, "max", &max);
 	if (err)
 		return err;
 
-- 
2.3.0
