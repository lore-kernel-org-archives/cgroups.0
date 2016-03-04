From: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 1/2] cpuacct: rename parameter in cpuusage_write for readability
Date: Fri, 4 Mar 2016 17:47:05 +0800
Message-ID: <874fad2881cb09366a618093a05141847ad9a9fa.1457082730.git.zhaolei@cn.fujitsu.com>
References: <cover.1457082730.git.zhaolei@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1457082730.git.zhaolei@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: zhaolei@cn.fujitsu.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org, tj@kernel.org
Cc: Yang Dongsheng <yangds.fnst@cn.fujitsu.com>

From: Yang Dongsheng <yangds.fnst@cn.fujitsu.com>

The name of 'reset' makes a little confusion in reading, we would
say, if we want to reset usage, return -EINVAL. That's not true.

Actually, we want to say, we only allow user to do a reset. This
patch rename reset to val and add a comment here, making the code
more readable.

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/sched/cpuacct.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index dd7cbb5..9c2bbf7 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -145,13 +145,16 @@ static u64 cpuusage_read(struct cgroup_subsys_state *css, struct cftype *cft)
 }
 
 static int cpuusage_write(struct cgroup_subsys_state *css, struct cftype *cft,
-			  u64 reset)
+			  u64 val)
 {
 	struct cpuacct *ca = css_ca(css);
 	int err = 0;
 	int i;
 
-	if (reset) {
+	/*
+	 * Only allow '0' here to do a reset.
+	 */
+	if (val) {
 		err = -EINVAL;
 		goto out;
 	}
-- 
1.8.5.1



