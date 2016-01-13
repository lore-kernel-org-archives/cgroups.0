From: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] cpuacct: rename parameter in cpuusage_write for readability
Date: Wed, 13 Jan 2016 16:41:04 +0800
Message-ID: <1452674464-31750-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

The name of 'reset' makes a little confusion in reading, we would
say, if we want to reset usage, return -EINVAL. That's not true.

Actually, we want to say, we only allow user to do a reset. This
patch rename reset to val and add a comment here, making the code
more readable.

Signed-off-by: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
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


