From: Lin Feng <linf-VqLewplIU37QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup-v1: use find granularity format identifiers to make /proc/cgroups show pretty
Date: Thu, 30 Jun 2022 16:25:39 +0800
Message-ID: <20220630082539.83602-1-linf@wangsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linf-VqLewplIU37QT0dZR+AlfA@public.gmane.org

The listing subsys info is unaligned with the header columns and we can
make the output more intuitive to read by specifying "left alignment"
and "fixed length" format styles for seq_printf.

# cat /proc/cgroups

the output originally:

#subsys_name	hierarchy	num_cgroups	enabled
cpuset	11	19	1
cpu	5	122	1
cpuacct	5	122	1
blkio	4	122	1
memory	10	129	1
devices	6	122	1
freezer	9	19	1
net_cls	8	19	1
perf_event	3	19	1
net_prio	8	19	1
hugetlb	7	19	1
pids	12	122	1
rdma	2	1	1

output after this patch:

#subsys_name	hierarchy	num_cgroups	enabled
cpuset      	11        	19      	1
cpu         	5         	122     	1
cpuacct     	5         	122     	1
blkio       	4         	122     	1
memory      	10        	129     	1
devices     	6         	122     	1
freezer     	9         	19      	1
net_cls     	8         	19      	1
perf_event  	3         	19      	1
net_prio    	8         	19      	1
hugetlb     	7         	19      	1
pids        	12        	122     	1
rdma        	2         	1       	1

Signed-off-by: Lin Feng <linf-VqLewplIU37QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup-v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index afc6c0e9c966..1a74b0c504aa 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -677,7 +677,7 @@ int proc_cgroupstats_show(struct seq_file *m, void *v)
 	 */
 
 	for_each_subsys(ss, i)
-		seq_printf(m, "%s\t%d\t%d\t%d\n",
+		seq_printf(m, "%-12s\t%-10d\t%-10d\t%-d\n",
 			   ss->legacy_name, ss->root->hierarchy_id,
 			   atomic_read(&ss->root->nr_cgrps),
 			   cgroup_ssid_enabled(i));
-- 
2.31.1

