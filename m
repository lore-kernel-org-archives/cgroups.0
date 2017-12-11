From: weiping zhang <zhangweiping@didichuxing.com>
Subject: [RFC] blk-throttle: export io_serviced_recursive,
 io_service_bytes_recursive
Date: Mon, 11 Dec 2017 22:56:25 +0800
Message-ID: <20171211145621.GA2115@localhost.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, tj@kernel.org, shli@kernel.org, lizefan@huawei.com
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org

export these two interface for cgroup-v1.

Signed-off-by: weiping zhang <zhangweiping@didichuxing.com>
---
 block/blk-throttle.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 96ad326..1d7637f 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1512,10 +1512,20 @@ static struct cftype throtl_legacy_files[] = {
 		.seq_show = blkg_print_stat_bytes,
 	},
 	{
+		.name = "throttle.io_service_bytes_recursive",
+		.private = (unsigned long)&blkcg_policy_throtl,
+		.seq_show = blkg_print_stat_bytes_recursive,
+	},
+	{
 		.name = "throttle.io_serviced",
 		.private = (unsigned long)&blkcg_policy_throtl,
 		.seq_show = blkg_print_stat_ios,
 	},
+	{
+		.name = "throttle.io_serviced_recursive",
+		.private = (unsigned long)&blkcg_policy_throtl,
+		.seq_show = blkg_print_stat_ios_recursive,
+	},
 	{ }	/* terminate */
 };
 
-- 
2.9.4

