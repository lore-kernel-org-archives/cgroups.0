From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/12] cfq-iosched: add hierarchical cfq_group statistics
Date: Fri, 14 Dec 2012 14:41:25 -0800
Message-ID: <1355524885-22719-13-git-send-email-tj@kernel.org>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=Iwj2LVJSZpzUfSCyGMnewCuiLibTdFUrV8Pw6UuoU28=;
        b=RfpArfaJPlY+jCIGcCnEg2MphjXoaKu+LJh9gs4lhAPNpyeCcfwv0aECv0cdEFnn9t
         AgZZQC/o+2Gl89jWt99Bm0dGNWekJDEj0Byti+U9v1oOKxspaxNrq8dAVl523LA+MnE+
         hG0xTNvyPSHv80CxcpbhV6SS044Btm6WIq3Jy6Eilltve7BV1wLON27O95zWb7ZO53WB
         aliym0NlVUmHUmq6qW/gRlGbwZkWaspWhjzEhTr3PdEryfYofd58wlvBFAj6WJF7rWPv
         MoD+o8fTV2MR4GiJ8v5ctWFI23aMesbzn+0bwcfr8rPLk6WJEipGgK0TjzIwXE+NpXR3
         XdLQ==
In-Reply-To: <1355524885-22719-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com, Tejun Heo <tj@kernel.org>

Unfortunately, at this point, there's no way to make the existing
statistics hierarchical without creating nasty surprises for the
existing users.  Just create recursive counterpart of the existing
stats.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/cfq-iosched.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ceade6e..15cb97e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1669,6 +1669,26 @@ static int cfqg_print_rwstat(struct cgroup *cgrp, struct cftype *cft,
 	return 0;
 }
 
+static int cfqg_print_stat_recursive(struct cgroup *cgrp, struct cftype *cft,
+				     struct seq_file *sf)
+{
+	struct blkcg *blkcg = cgroup_to_blkcg(cgrp);
+
+	blkcg_print_blkgs(sf, blkcg, blkg_prfill_stat_recursive,
+			  &blkcg_policy_cfq, cft->private, false);
+	return 0;
+}
+
+static int cfqg_print_rwstat_recursive(struct cgroup *cgrp, struct cftype *cft,
+				       struct seq_file *sf)
+{
+	struct blkcg *blkcg = cgroup_to_blkcg(cgrp);
+
+	blkcg_print_blkgs(sf, blkcg, blkg_prfill_rwstat_recursive,
+			  &blkcg_policy_cfq, cft->private, true);
+	return 0;
+}
+
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 static u64 cfqg_prfill_avg_queue_size(struct seq_file *sf,
 				      struct blkg_policy_data *pd, int off)
@@ -1740,6 +1760,7 @@ static struct cftype cfq_blkcg_files[] = {
 		.write_u64 = cfq_set_leaf_weight,
 	},
 
+	/* statistics, covers only the tasks in the cfqg */
 	{
 		.name = "time",
 		.private = offsetof(struct cfq_group, stats.time),
@@ -1780,6 +1801,48 @@ static struct cftype cfq_blkcg_files[] = {
 		.private = offsetof(struct cfq_group, stats.queued),
 		.read_seq_string = cfqg_print_rwstat,
 	},
+
+	/* the same statictics which cover the cfqg and its descendants */
+	{
+		.name = "time_recursive",
+		.private = offsetof(struct cfq_group, stats.time),
+		.read_seq_string = cfqg_print_stat_recursive,
+	},
+	{
+		.name = "sectors_recursive",
+		.private = offsetof(struct cfq_group, stats.sectors),
+		.read_seq_string = cfqg_print_stat_recursive,
+	},
+	{
+		.name = "io_service_bytes_recursive",
+		.private = offsetof(struct cfq_group, stats.service_bytes),
+		.read_seq_string = cfqg_print_rwstat_recursive,
+	},
+	{
+		.name = "io_serviced_recursive",
+		.private = offsetof(struct cfq_group, stats.serviced),
+		.read_seq_string = cfqg_print_rwstat_recursive,
+	},
+	{
+		.name = "io_service_time_recursive",
+		.private = offsetof(struct cfq_group, stats.service_time),
+		.read_seq_string = cfqg_print_rwstat_recursive,
+	},
+	{
+		.name = "io_wait_time_recursive",
+		.private = offsetof(struct cfq_group, stats.wait_time),
+		.read_seq_string = cfqg_print_rwstat_recursive,
+	},
+	{
+		.name = "io_merged_recursive",
+		.private = offsetof(struct cfq_group, stats.merged),
+		.read_seq_string = cfqg_print_rwstat_recursive,
+	},
+	{
+		.name = "io_queued_recursive",
+		.private = offsetof(struct cfq_group, stats.queued),
+		.read_seq_string = cfqg_print_rwstat_recursive,
+	},
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	{
 		.name = "avg_queue_size",
-- 
1.7.11.7
