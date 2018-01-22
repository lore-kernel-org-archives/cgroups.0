From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v4.15-rc9] sched, cgroup: Don't reject lower cpu.max on
 ancestors
Date: Mon, 22 Jan 2018 11:26:18 -0800
Message-ID: <20180122192618.GA1771050@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=qb5iT4jk+y1VmQ1Nw1bi0Iz/JWEhGHjcDcMsDzKiiTA=;
        b=m1xeBZ56PX1WUvV5sLIxcgQenO34zJDRsn0cx9OyL5k9ZYXiz50vQ7nPCp1i5nAAqw
         CueOFSEsXudTNsiYWPke5lIRvdf2y/z7PjwuMnFSt2dRzo2mvnqrBRQWBZPBWsoxpTRF
         Ko4gF6RvrNbDNVSgF/+o4Uv+pAxSPyGwo3KJwyNRnlPqyOk/vBrIOtEk7+s4rphUps1H
         QG6oI6AvY5k2Y92Ukl3YAOu1zRWWGlmpEBh1jxAs2cYhl0A4gUKwxzZxN2zJkzOF5vgc
         oJbicJcyNxuR0TnzFHEBKWpn7N4dF16K51Ki8mso+R9+Q9HzhpIbXcVbdgOa7KiMOYvf
         cQDA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

While adding cgroup2 interface for the cpu controller, 0d5936344f30
("sched: Implement interface for cgroup unified hierarchy") forgot to
update input validation and left it to reject cpu.max config if any
descendant has set a higher value.

cgroup2 officially supports delegation and a descendant must not be
able to restrict what its ancestors can configure.  For absolute
limits such as cpu.max and memory.max, this means that the config at
each level should only act as the upper limit at that level and
shouldn't interfere with what other cgroups can configure.

This patch updates config validation on cgroup2 so that the cpu
controller follows the same convention.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Fixes: 0d5936344f30 ("sched: Implement interface for cgroup unified hierarchy")
---
 kernel/sched/core.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a7bf32a..e06e484 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6610,13 +6610,18 @@ static int tg_cfs_schedulable_down(struct task_group *tg, void *data)
 		parent_quota = parent_b->hierarchical_quota;
 
 		/*
-		 * Ensure max(child_quota) <= parent_quota, inherit when no
+		 * Ensure max(child_quota) <= parent_quota.  On cgroup2,
+		 * always take the min.  On cgroup1, only inherit when no
 		 * limit is set:
 		 */
-		if (quota == RUNTIME_INF)
-			quota = parent_quota;
-		else if (parent_quota != RUNTIME_INF && quota > parent_quota)
-			return -EINVAL;
+		if (cgroup_subsys_on_dfl(cpu_cgrp_subsys)) {
+			quota = min(quota, parent_quota);
+		} else {
+			if (quota == RUNTIME_INF)
+				quota = parent_quota;
+			else if (parent_quota != RUNTIME_INF && quota > parent_quota)
+				return -EINVAL;
+		}
 	}
 	cfs_b->hierarchical_quota = quota;
 
