From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: [PATCH] cfq-iosched: add "leaf_weight" setting for the root cgroup in
 cgroups v2
Date: Sun, 29 Oct 2017 17:36:53 +0100
Message-ID: <a1828795-3f51-9455-9d0b-93f9dcfb6fd4@maciej.szmigiero.name>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>
Cc: Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org

CFQ scheduler has a property that processes (or tasks in cgroups v1) that
aren't assigned to any particular cgroup - that is, which stay in the root
cgroup - effectively form an implicit leaf child node attached to the root
cgroup.

This behavior is documented in blkio-controller.txt for cgroups v1, however
as far as I know it isn't documented anywhere for cgroups v2 besides a
generic remark that "How resource consumption in the root cgroup is
governed is up to each controller" in cgroup-v2.txt.

By default, this implicit leaf child node has a (CFQ) weight which is two
times higher that the default weight of a child cgroup.

cgroups v1 provide a "leaf_weight" setting which allow changing this value.
However, this setting is missing from cgroups v2 and so the only way to
tweak how much IO time processes in the root cgroup get is to adapt
weight settings of all child cgroups accordingly.
Let's add a "leaf_weight" setting to the root cgroup in cgroups v2, too.

Note that new kernel threads appear in the root cgroup and there seems to
be no way to change this since kthreadd cannot be moved to another cgroup
(for a good reason).

Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
---
 Documentation/cgroup-v2.txt | 11 +++++++++++
 block/cfq-iosched.c         | 40 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index dc44785dc0fa..3190c5108c31 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -1290,6 +1290,17 @@ IO Interface Files
 	  8:16 200
 	  8:0 50
 
+  io.leaf_weight
+	A read-write flat-keyed file which exists only on the root cgroup.
+	It operates the same way as io.weight but controls the weight of an
+	implicit leaf child node.
+	This implicit leaf child node hosts all the processes that are in
+	the root cgroup.
+	When distributing IO time this implicit child node is taken into
+	account as if it was a normal child cgroup of the root cgroup.
+
+	The default is "default 200".
+
   io.max
 	A read-write nested-keyed file which exists on non-root
 	cgroups.
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9f342ef1ad42..85b6970abb89 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2136,6 +2136,17 @@ static struct cftype cfq_blkcg_legacy_files[] = {
 	{ }	/* terminate */
 };
 
+static int cfq_print_leaf_weight_on_dfl(struct seq_file *sf, void *v)
+{
+	struct blkcg *blkcg = css_to_blkcg(seq_css(sf));
+	struct cfq_group_data *cgd = blkcg_to_cfqgd(blkcg);
+
+	seq_printf(sf, "default %u\n", cgd->leaf_weight);
+	blkcg_print_blkgs(sf, blkcg, cfqg_prfill_leaf_weight_device,
+			  &blkcg_policy_cfq, 0, false);
+	return 0;
+}
+
 static int cfq_print_weight_on_dfl(struct seq_file *sf, void *v)
 {
 	struct blkcg *blkcg = css_to_blkcg(seq_css(sf));
@@ -2147,8 +2158,9 @@ static int cfq_print_weight_on_dfl(struct seq_file *sf, void *v)
 	return 0;
 }
 
-static ssize_t cfq_set_weight_on_dfl(struct kernfs_open_file *of,
-				     char *buf, size_t nbytes, loff_t off)
+static ssize_t cfq_set_weight_on_dfl_common(struct kernfs_open_file *of,
+					    char *buf, size_t nbytes,
+					    loff_t off, bool is_leaf_weight)
 {
 	char *endp;
 	int ret;
@@ -2159,15 +2171,35 @@ static ssize_t cfq_set_weight_on_dfl(struct kernfs_open_file *of,
 	/* "WEIGHT" or "default WEIGHT" sets the default weight */
 	v = simple_strtoull(buf, &endp, 0);
 	if (*endp == '\0' || sscanf(buf, "default %llu", &v) == 1) {
-		ret = __cfq_set_weight(of_css(of), v, true, false, false);
+		ret = __cfq_set_weight(of_css(of), v, true, false,
+				       is_leaf_weight);
 		return ret ?: nbytes;
 	}
 
 	/* "MAJ:MIN WEIGHT" */
-	return __cfqg_set_weight_device(of, buf, nbytes, off, true, false);
+	return __cfqg_set_weight_device(of, buf, nbytes, off, true,
+					is_leaf_weight);
+}
+
+static ssize_t cfq_set_leaf_weight_on_dfl(struct kernfs_open_file *of,
+					  char *buf, size_t nbytes, loff_t off)
+{
+	return cfq_set_weight_on_dfl_common(of, buf, nbytes, off, true);
+}
+
+static ssize_t cfq_set_weight_on_dfl(struct kernfs_open_file *of,
+				     char *buf, size_t nbytes, loff_t off)
+{
+	return cfq_set_weight_on_dfl_common(of, buf, nbytes, off, false);
 }
 
 static struct cftype cfq_blkcg_files[] = {
+	{
+		.name = "leaf_weight",
+		.flags = CFTYPE_ONLY_ON_ROOT,
+		.seq_show = cfq_print_leaf_weight_on_dfl,
+		.write = cfq_set_leaf_weight_on_dfl,
+	},
 	{
 		.name = "weight",
 		.flags = CFTYPE_NOT_ON_ROOT,
