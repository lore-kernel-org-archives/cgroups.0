From: Paolo Valente <paolo.valente@linaro.org>
Subject: [PATCH 08/12] block, cfq: allow cgroup files to be shared
Date: Mon, 12 Nov 2018 10:56:28 +0100
Message-ID: <20181112095632.69114-9-paolo.valente@linaro.org>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BhhSrhl3GPkKSUoXIhn9nAMo7Bh19cGOMzxu3Gi9vPg=;
        b=QG+hymxrp0k2JHc1mCXq7bGzmIVfKn8kyei84SG0+Y3J9yu8gRuP/KiUBxNO6H35Yw
         PAM/xy0h10htiE9hYdXK9BcdZPCqgmM0bjBMsEt8TvvDzFJTQMZNtCgl4n1iF4YqNIE/
         nqEomghns5VaEzxAIC/4QDraAfkZx5bQG9Ixk=
In-Reply-To: <20181112095632.69114-1-paolo.valente@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Paolo Valente <paolo.valente@linaro.org>

From: Angelo Ruocco <angeloruocco90@gmail.com>

Some of the files exposed in a cgroup by cfq have the same meaning as
the files exposed by bfq and throttle.

This commit allows these files to be shared.

Signed-off-by: Angelo Ruocco <angeloruocco90@gmail.com>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
---
 block/cfq-iosched.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index af0c59c2dcde..f046039bdfc6 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2016,7 +2016,8 @@ static struct cftype cfq_blkcg_legacy_files[] = {
 	},
 	{
 		.name = "weight",
-		.flags = CFTYPE_NOT_ON_ROOT,
+		.owner_name = "cfq",
+		.flags = CFTYPE_NOT_ON_ROOT | CFTYPE_SHARES_FILE,
 		.seq_show = cfq_print_weight,
 		.write_u64 = cfq_set_weight,
 	},
@@ -2035,40 +2036,56 @@ static struct cftype cfq_blkcg_legacy_files[] = {
 	/* statistics, covers only the tasks in the cfqg */
 	{
 		.name = "time",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.private = offsetof(struct cfq_group, stats.time),
 		.seq_show_cft = cfqg_print_stat,
 	},
 	{
 		.name = "sectors",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.seq_show = cfqg_print_stat_sectors,
 	},
 	{
 		.name = "io_service_bytes",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.private = (unsigned long)&blkcg_policy_cfq,
 		.seq_show_cft = blkg_print_stat_bytes,
 	},
 	{
 		.name = "io_serviced",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.private = (unsigned long)&blkcg_policy_cfq,
 		.seq_show_cft = blkg_print_stat_ios,
 	},
 	{
 		.name = "io_service_time",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.private = offsetof(struct cfq_group, stats.service_time),
 		.seq_show_cft = cfqg_print_rwstat,
 	},
 	{
 		.name = "io_wait_time",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.private = offsetof(struct cfq_group, stats.wait_time),
 		.seq_show_cft = cfqg_print_rwstat,
 	},
 	{
 		.name = "io_merged",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.private = offsetof(struct cfq_group, stats.merged),
 		.seq_show_cft = cfqg_print_rwstat,
 	},
 	{
 		.name = "io_queued",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.private = offsetof(struct cfq_group, stats.queued),
 		.seq_show_cft = cfqg_print_rwstat,
 	},
@@ -2076,70 +2093,97 @@ static struct cftype cfq_blkcg_legacy_files[] = {
 	/* the same statictics which cover the cfqg and its descendants */
 	{
 		.name = "time_recursive",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.private = offsetof(struct cfq_group, stats.time),
 		.seq_show_cft = cfqg_print_stat_recursive,
 	},
 	{
 		.name = "sectors_recursive",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.seq_show = cfqg_print_stat_sectors_recursive,
 	},
 	{
 		.name = "io_service_bytes_recursive",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.private = (unsigned long)&blkcg_policy_cfq,
 		.seq_show_cft = blkg_print_stat_bytes_recursive,
 	},
 	{
 		.name = "io_serviced_recursive",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.private = (unsigned long)&blkcg_policy_cfq,
 		.seq_show_cft = blkg_print_stat_ios_recursive,
 	},
 	{
 		.name = "io_service_time_recursive",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.private = offsetof(struct cfq_group, stats.service_time),
 		.seq_show_cft = cfqg_print_rwstat_recursive,
 	},
 	{
 		.name = "io_wait_time_recursive",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.private = offsetof(struct cfq_group, stats.wait_time),
 		.seq_show_cft = cfqg_print_rwstat_recursive,
 	},
 	{
 		.name = "io_merged_recursive",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.private = offsetof(struct cfq_group, stats.merged),
 		.seq_show_cft = cfqg_print_rwstat_recursive,
 	},
 	{
 		.name = "io_queued_recursive",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.private = offsetof(struct cfq_group, stats.queued),
 		.seq_show_cft = cfqg_print_rwstat_recursive,
 	},
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	{
 		.name = "avg_queue_size",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.seq_show = cfqg_print_avg_queue_size,
 	},
 	{
 		.name = "group_wait_time",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.private = offsetof(struct cfq_group, stats.group_wait_time),
 		.seq_show_cft = cfqg_print_stat,
 	},
 	{
 		.name = "idle_time",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.private = offsetof(struct cfq_group, stats.idle_time),
 		.seq_show_cft = cfqg_print_stat,
 	},
 	{
 		.name = "empty_time",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.private = offsetof(struct cfq_group, stats.empty_time),
 		.seq_show_cft = cfqg_print_stat,
 	},
 	{
 		.name = "dequeue",
+		.owner_name = "cfq",
+		.flags = CFTYPE_SHARES_FILE,
 		.private = offsetof(struct cfq_group, stats.dequeue),
 		.seq_show_cft = cfqg_print_stat,
 	},
 	{
 		.name = "unaccounted_time",
+		.owner_name = "cfq",
 		.private = offsetof(struct cfq_group, stats.unaccounted_time),
 		.seq_show_cft = cfqg_print_stat,
 	},
@@ -2181,7 +2225,8 @@ static ssize_t cfq_set_weight_on_dfl(struct kernfs_open_file *of,
 static struct cftype cfq_blkcg_files[] = {
 	{
 		.name = "weight",
-		.flags = CFTYPE_NOT_ON_ROOT,
+		.owner_name = "cfq",
+		.flags = CFTYPE_NOT_ON_ROOT | CFTYPE_SHARES_FILE,
 		.seq_show = cfq_print_weight_on_dfl,
 		.write = cfq_set_weight_on_dfl,
 	},
-- 
2.16.1

