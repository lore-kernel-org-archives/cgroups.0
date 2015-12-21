From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [RESEND PATCH 1/2] cpuacct: rename parameter in cpuusage_write for readability
Date: Mon, 21 Dec 2015 19:14:42 +0800
Message-ID: <1450696483-2864-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org, tj@kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

The name of 'reset' makes a little confusion in reading, we would
say, if we want to reset usage, return -EINVAL. That's not true.

Actually, we want to say, we only allow user to do a reset. This
patch rename reset to val and add a comment here, making the code
more readable.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
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
1.8.4.2


