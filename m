From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH] mm: memcontrol: eliminate root memory.current
Date: Wed, 21 Oct 2015 14:49:54 -0400
Message-ID: <1445453394-15156-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

memory.current on the root level doesn't add anything that wouldn't be
more accurate and detailed using system statistics. It already doesn't
include slabs, and it'll be a pain to keep in sync when further memory
types are accounted in the memory controller. Remove it.

Note that this applies to the new unified hierarchy interface only.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Tejun, we should probably do this with the other controllers too.
I don't think it makes sense anywhere to shoddily duplicate the
system statistics on the controller root levels.

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4f04510..c71fe40 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5022,7 +5022,7 @@ static void mem_cgroup_bind(struct cgroup_subsys_state *root_css)
 static u64 memory_current_read(struct cgroup_subsys_state *css,
 			       struct cftype *cft)
 {
-	return mem_cgroup_usage(mem_cgroup_from_css(css), false);
+	return page_counter_read(&mem_cgroup_from_css(css)->memory);
 }
 
 static int memory_low_show(struct seq_file *m, void *v)
@@ -5134,6 +5134,7 @@ static int memory_events_show(struct seq_file *m, void *v)
 static struct cftype memory_files[] = {
 	{
 		.name = "current",
+		.flags = CFTYPE_NOT_ON_ROOT,
 		.read_u64 = memory_current_read,
 	},
 	{
-- 
2.6.1
