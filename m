From: Andrea Righi <andrea.righi@canonical.com>
Subject: [PATCH v2 2/3] blkcg: introduce io.sync_isolation
Date: Thu,  7 Mar 2019 19:08:33 +0100
Message-ID: <20190307180834.22008-3-andrea.righi@canonical.com>
References: <20190307180834.22008-1-andrea.righi@canonical.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190307180834.22008-1-andrea.righi@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Josef Bacik <josef@toxicpanda.com>, Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Paolo Valente <paolo.valente@linaro.org>, Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Dennis Zhou <dennis@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Add a flag to the blkcg cgroups to make sync()'ers in a cgroup only be
allowed to write out pages that have been dirtied by the cgroup itself.

This flag is disabled by default (meaning that we are not changing the
previous behavior by default).

When this flag is enabled any cgroup can write out only dirty pages that
belong to the cgroup itself (except for the root cgroup that would still
be able to write out all pages globally).

Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  9 ++++++
 block/blk-throttle.c                    | 37 +++++++++++++++++++++++++
 include/linux/blk-cgroup.h              |  7 +++++
 3 files changed, 53 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 53d3288c328b..17fff0ee97b8 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1448,6 +1448,15 @@ IO Interface Files
 	Shows pressure stall information for IO. See
 	Documentation/accounting/psi.txt for details.
 
+  io.sync_isolation
+        A flag (0|1) that determines whether a cgroup is allowed to write out
+        only pages that have been dirtied by the cgroup itself. This option is
+        set to false (0) by default, meaning that any cgroup would try to write
+        out dirty pages globally, even those that have been dirtied by other
+        cgroups.
+
+        Setting this option to true (1) provides a better isolation across
+        cgroups that are doing an intense write I/O activity.
 
 Writeback
 ~~~~~~~~~
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index da817896cded..4bc3b40a4d93 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1704,6 +1704,35 @@ static ssize_t tg_set_limit(struct kernfs_open_file *of,
 	return ret ?: nbytes;
 }
 
+#ifdef CONFIG_CGROUP_WRITEBACK
+static int sync_isolation_show(struct seq_file *sf, void *v)
+{
+	struct blkcg *blkcg = css_to_blkcg(seq_css(sf));
+
+	seq_printf(sf, "%d\n", test_bit(BLKCG_SYNC_ISOLATION, &blkcg->flags));
+	return 0;
+}
+
+static ssize_t sync_isolation_write(struct kernfs_open_file *of,
+				    char *buf, size_t nbytes, loff_t off)
+{
+	struct blkcg *blkcg = css_to_blkcg(of_css(of));
+	unsigned long val;
+	int err;
+
+	buf = strstrip(buf);
+	err = kstrtoul(buf, 0, &val);
+	if (err)
+		return err;
+	if (val)
+		set_bit(BLKCG_SYNC_ISOLATION, &blkcg->flags);
+	else
+		clear_bit(BLKCG_SYNC_ISOLATION, &blkcg->flags);
+
+	return nbytes;
+}
+#endif
+
 static struct cftype throtl_files[] = {
 #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
 	{
@@ -1721,6 +1750,14 @@ static struct cftype throtl_files[] = {
 		.write = tg_set_limit,
 		.private = LIMIT_MAX,
 	},
+#ifdef CONFIG_CGROUP_WRITEBACK
+	{
+		.name = "sync_isolation",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = sync_isolation_show,
+		.write = sync_isolation_write,
+	},
+#endif
 	{ }	/* terminate */
 };
 
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 0f7dcb70e922..6ac5aa049334 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -44,6 +44,12 @@ enum blkg_rwstat_type {
 
 struct blkcg_gq;
 
+/* blkcg->flags */
+enum {
+	/* sync()'ers allowed to write out pages dirtied by the blkcg */
+	BLKCG_SYNC_ISOLATION,
+};
+
 struct blkcg {
 	struct cgroup_subsys_state	css;
 	spinlock_t			lock;
@@ -55,6 +61,7 @@ struct blkcg {
 	struct blkcg_policy_data	*cpd[BLKCG_MAX_POLS];
 
 	struct list_head		all_blkcgs_node;
+	unsigned long			flags;
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head		cgwb_wait_node;
 	struct list_head		cgwb_list;
-- 
2.19.1

