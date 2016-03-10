From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH] mm: memcontrol: reclaim when shrinking memory.high below usage
Date: Thu, 10 Mar 2016 15:50:13 -0500
Message-ID: <1457643015-8828-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

When setting memory.high below usage, nothing happens until the next
charge comes along, and then it will only reclaim its own charge and
not the now potentially huge excess of the new memory.high. This can
cause groups to stay in excess of their memory.high indefinitely.

To fix that, when shrinking memory.high, kick off a reclaim cycle that
goes after the delta.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8615b066b642..f7c9b4cbdf01 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4992,6 +4992,7 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 				 char *buf, size_t nbytes, loff_t off)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	unsigned long nr_pages;
 	unsigned long high;
 	int err;
 
@@ -5002,6 +5003,11 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 
 	memcg->high = high;
 
+	nr_pages = page_counter_read(&memcg->memory);
+	if (nr_pages > high)
+		try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
+					     GFP_KERNEL, true);
+
 	memcg_wb_domain_size_changed(memcg);
 	return nbytes;
 }
-- 
2.7.2
