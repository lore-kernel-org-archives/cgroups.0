From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 01/10] cgroup: don't print subsystems for the default hierarchy
Date: Fri, 24 Jul 2015 14:43:45 -0400
Message-ID: <1437763434-28699-2-git-send-email-tj@kernel.org>
References: <1437763434-28699-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eQucyLF+fTdpF8+2riXi2ULsfHKilO2rS2kc7qBM0Ws=;
        b=RDJj8O92FTLkmGF0sxtLk3B/YZpcrhQ/GzbM5WCurGlsxZEMT014YtJiOloBfuW6PQ
         uOaR9W50SwZ391OD6klnsRu0C32fVCOBST+N/vFPs67Tv5wrjsuQd83os4nYZT1Bi4Lc
         DUeyV+QQXKH1faI+tGhzpzYRT87M0pClWyZ30EYFcM7MsHNyNZjnG775lgmvD5hF139N
         9IiT4iYjcquvL7yzSaSZR7tXTSFifJslF2rXC/il0+dDSfFr1oWIM66hpYlxT6ZpppCQ
         lB8x+qDmtopUZ/HM8fa7W9epDKyVGwXzdrln14jU53w+0uavUMknGtcfRQKfRpR2577F
         20RQ==
In-Reply-To: <1437763434-28699-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

It doesn't make sense to print subsystems on mount option or
/proc/PID/cgroup for the default hierarchy.

* cgroup.controllers file at the root of the default hierarchy lists
  the currently attached controllers.

* The default hierarchy is catch-all for unmounted subsystems.

* The default hierarchy doesn't accept any mount options.

Suppress subsystem printing on mount options and /proc/PID/cgroup for
the default hierarchy.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 kernel/cgroup.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f89d929..6c85e6d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1332,9 +1332,10 @@ static int cgroup_show_options(struct seq_file *seq,
 	struct cgroup_subsys *ss;
 	int ssid;
 
-	for_each_subsys(ss, ssid)
-		if (root->subsys_mask & (1 << ssid))
-			seq_printf(seq, ",%s", ss->name);
+	if (root != &cgrp_dfl_root)
+		for_each_subsys(ss, ssid)
+			if (root->subsys_mask & (1 << ssid))
+				seq_printf(seq, ",%s", ss->name);
 	if (root->flags & CGRP_ROOT_NOPREFIX)
 		seq_puts(seq, ",noprefix");
 	if (root->flags & CGRP_ROOT_XATTR)
@@ -5136,9 +5137,11 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 			continue;
 
 		seq_printf(m, "%d:", root->hierarchy_id);
-		for_each_subsys(ss, ssid)
-			if (root->subsys_mask & (1 << ssid))
-				seq_printf(m, "%s%s", count++ ? "," : "", ss->name);
+		if (root != &cgrp_dfl_root)
+			for_each_subsys(ss, ssid)
+				if (root->subsys_mask & (1 << ssid))
+					seq_printf(m, "%s%s", count++ ? "," : "",
+						   ss->name);
 		if (strlen(root->name))
 			seq_printf(m, "%sname=%s", count ? "," : "",
 				   root->name);
-- 
2.4.3
