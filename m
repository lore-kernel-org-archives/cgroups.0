From: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [RFC 2/2] memcg: Adapt cgroup.top into per-memcg
Date: Fri, 26 Aug 2022 09:15:03 +0800
Message-ID: <20220826011503.103894-3-lujialin4@huawei.com>
References: <20220826011503.103894-1-lujialin4@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220826011503.103894-1-lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

cgroup.top is able to show resource usage information for each cgroups.
Currently only memory usage is monitored ,including usage,anon,file,
kmem(Bytes), stats for other resource types would be added as well.

Show case:
/ # mount -t cgroup2 none /sys/fs/cgroup
/ # cd /sys/fs/cgroup/
/sys/fs/cgroup # echo "+memory" > cgroup.subtree_control
/sys/fs/cgroup # mkdir test1
/sys/fs/cgroup # mkdir test2
/sys/fs/cgroup # mkdir test3
/sys/fs/cgroup # echo $$ > test2/cgroup.procs
/sys/fs/cgroup # cd /test
/test # ./memcg_malloc 512000 &
/test # ./memcg_malloc 512000 &
/test # ./memcg_malloc 512000 &
/test # cd /sys/fs/cgroup
/sys/fs/cgroup # echo $$ > test1/cgroup.procs
/sys/fs/cgroup # cd /test
/test # ./memcg_malloc 512000 &
/test # cd /sys/fs/cgroup
/sys/fs/cgroup # echo $$ > test3/cgroup.procs
/sys/fs/cgroup # cat cgroup.top
memory top:
name            usage           anon            file            kernel
test2           1974272         1671168         0               270336
test1           700416          569344          0               94208
test3           196608          86016           0               86016

Signed-off-by: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Co-developed-by: Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b69979c9ced5..e4d4afefe5a6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5480,6 +5480,92 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 	}
 }
 
+static int cmp_usage(const void *a, const void *b)
+{
+	struct mem_cgroup *memcg_a = *(struct mem_cgroup **)a;
+	struct mem_cgroup *memcg_b = *(struct mem_cgroup **)b;
+
+	return page_counter_read(&memcg_b->memory) -
+	       page_counter_read(&memcg_a->memory);
+}
+
+static int child_memcg_css_count(struct cgroup_subsys_state *css)
+{
+	struct cgroup_subsys_state *child;
+	int count = 0;
+
+	css_for_each_child(child, css)
+		count++;
+
+	return count;
+}
+
+struct memory_top_info {
+	const char *name;
+	unsigned long idx;
+};
+
+static const struct memory_top_info memory_info[] = {
+	{"anon",			NR_ANON_MAPPED},
+	{"file",			NR_FILE_PAGES},
+	{"kernel",			MEMCG_KMEM},
+};
+
+static void mem_cgroup_css_top(struct cgroup_subsys_state *css,
+			       struct seq_file *seq)
+{
+	struct mem_cgroup **array;
+	struct cgroup_subsys_state *child;
+	int memcg_number = child_memcg_css_count(css);
+	int i, j;
+	int count = 0;
+
+	mem_cgroup_flush_stats();
+
+	array = kvmalloc_array(memcg_number, sizeof(struct mem_cgroup *),
+			       GFP_KERNEL);
+	if (!array)
+		return;
+
+	css_for_each_child(child, css) {
+		struct mem_cgroup *memcg = mem_cgroup_from_css(child);
+
+		if (count == memcg_number)
+			break;
+		array[count++] = memcg;
+	}
+
+	sort(array, memcg_number, sizeof(struct mem_cgroup *), cmp_usage, NULL);
+
+	seq_printf(seq, "%s top:\n", css->ss->name);
+
+	seq_puts(seq, "name\t\tusage\t\t");
+	for (j = 0; j < ARRAY_SIZE(memory_info); j++)
+		seq_printf(seq, "%s\t\t", memory_info[j].name);
+	seq_puts(seq, "\n");
+
+	for (i = 0; i < memcg_number; i++) {
+		struct mem_cgroup *memcg = array[i];
+		unsigned long usage = page_counter_read(&memcg->memory);
+		struct cgroup *cgroup = memcg->css.cgroup;
+		const char *name = cgroup->kn->name;
+
+		seq_printf(seq, "%s\t\t%lu\t\t", name, usage * PAGE_SIZE);
+		for (j = 0; j < ARRAY_SIZE(memory_info); j++) {
+			u64 size;
+
+			size = memcg_page_state_output(memcg,
+						       memory_info[j].idx);
+			seq_printf(seq, "%llu\t\t", size);
+		}
+		seq_puts(seq, "\n");
+	}
+
+	kvfree(array);
+
+}
+
+
 #ifdef CONFIG_MMU
 /* Handlers for move charge at task migration. */
 static int mem_cgroup_do_precharge(unsigned long count)
@@ -6600,6 +6686,7 @@ struct cgroup_subsys memory_cgrp_subsys = {
 	.css_free = mem_cgroup_css_free,
 	.css_reset = mem_cgroup_css_reset,
 	.css_rstat_flush = mem_cgroup_css_rstat_flush,
+	.css_top = mem_cgroup_css_top,
 	.can_attach = mem_cgroup_can_attach,
 	.cancel_attach = mem_cgroup_cancel_attach,
 	.post_attach = mem_cgroup_move_task,
-- 
2.17.1

