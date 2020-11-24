From: Aaron Tomlin <atomlin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: add support to generate the total count of children from root
Date: Tue, 24 Nov 2020 10:58:36 +0000
Message-ID: <20201124105836.713371-1-atomlin@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606215521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=93iiWXlJJ6IXGgnGTBAqbCv2bSJUjXfqZiq9BMzLTt8=;
        b=U/is7sloglMBZMt3jdw1KgxWeNHZU3N8l+xPagEIp6xVArivT3+R7PlwZXDOSXAnNCkmGB
        NBSPkdZaPqLGS3R4eSru7DP69uQKNdKsqp0DN6XFmk5FIXYkQ5hZuzRh7H+1oBzlhJFffq
        XeWivHlDTIJCJCq0gzmVtQY3c1sjw1k=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Each memory-controlled cgroup is assigned a unique ID and the total
number of memory cgroups is limited to MEM_CGROUP_ID_MAX.

This patch provides the ability to determine the number of
memory cgroups from the root memory cgroup, only.
A value of 1 (i.e. self count) is returned if there are no children.
For example, the number of memory cgroups can be established by
reading the /sys/fs/cgroup/memory/memory.total_cnt file.

Signed-off-by: Aaron Tomlin <atomlin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 29459a6ce1c7..a4f7cb40e233 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4535,6 +4535,19 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
 	return 0;
 }
 
+static int mem_cgroup_total_count_read(struct cgroup_subsys_state *css,
+				      struct cftype *cft)
+{
+	struct mem_cgroup *iter, *memcg = mem_cgroup_from_css(css);
+	int num = 0;
+
+	for_each_mem_cgroup_tree(iter, memcg)
+		num++;
+
+	/* Returns 1 (i.e. self count) if no children. */
+	return num;
+}
+
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 #include <trace/events/writeback.h>
@@ -5050,6 +5063,11 @@ static struct cftype mem_cgroup_legacy_files[] = {
 		.write_u64 = mem_cgroup_oom_control_write,
 		.private = MEMFILE_PRIVATE(_OOM_TYPE, OOM_CONTROL),
 	},
+	{
+		.name = "total_cnt",
+		.flags = CFTYPE_ONLY_ON_ROOT,
+		.read_u64 = mem_cgroup_total_count_read,
+	},
 	{
 		.name = "pressure_level",
 	},
-- 
2.26.2

