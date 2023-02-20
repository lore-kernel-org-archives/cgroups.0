From: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] mm: change memcg->oom_group access with atomic operations
Date: Mon, 20 Feb 2023 23:16:38 +0800
Message-ID: <20230220151638.1371-1-findns94@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cqn4UGJ8kCDms9H9/KZqG5/8iucyQK2p5fp/dnG15U4=;
        b=j6cDxs5wY9U8hZTNmaA5a6G3X37iP6qPEHkLWjF3w7xw24mwLSVZpKI7rxdjw1DpZ1
         yY3HX6QPcbT3Hd/LyxjYTjBA05guiSfsDuxWRGGTd8aownt9eC8n/LdIYeVDC2sgMrqB
         i6d+3SWBGt8xWt6JyP7sZYNA7Tfn5a/IpE3CJdqvtfCEjBFbjA4aEz14bA7gPajX+FsU
         6S4ckl2T5nrl/y6w8/wgrsRceuNbaQXMGH/piHbPKDSHcxmFIqfdN2WMKCsIyshV0bsw
         GuuYFaBlwrGuwVmo907/NUQAabfHJiFSVy4cVLHfx36k014MeW+bYodgSSyeLrJ2wMos
         WIBA==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The knob for cgroup v2 memory controller: memory.oom.group
will be read and written simultaneously by user space
programs, thus we'd better change memcg->oom_group access
with atomic operations to avoid concurrency problems.

Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 73afff8062f9..e4695fb80bda 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2057,7 +2057,7 @@ struct mem_cgroup *mem_cgroup_get_oom_group(struct task_struct *victim,
 	 * highest-level memory cgroup with oom.group set.
 	 */
 	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
-		if (memcg->oom_group)
+		if (READ_ONCE(memcg->oom_group))
 			oom_group = memcg;
 
 		if (memcg == oom_domain)
@@ -6569,7 +6569,7 @@ static int memory_oom_group_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	seq_printf(m, "%d\n", memcg->oom_group);
+	seq_printf(m, "%d\n", READ_ONCE(memcg->oom_group));
 
 	return 0;
 }
@@ -6591,7 +6591,7 @@ static ssize_t memory_oom_group_write(struct kernfs_open_file *of,
 	if (oom_group != 0 && oom_group != 1)
 		return -EINVAL;
 
-	memcg->oom_group = oom_group;
+	WRITE_ONCE(memcg->oom_group, oom_group);
 
 	return nbytes;
 }
-- 
2.17.1

