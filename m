From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 6/7] cgroup: refactor cgroup_masks_read() in the debug controller
Date: Wed, 14 Jun 2017 16:08:41 -0400
Message-ID: <20170614200842.15174-7-tj@kernel.org>
References: <20170614200842.15174-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cW+oysWxhPuyWwQtpDvvg7dppEDihsTUuDcVSNsdG2E=;
        b=iXUVkXe4iR5M7v30/puP7gFEL6uFLx/Ah7is0YBflwKaGTBxca/N3mI/LThumXZxjw
         VTyKmyRap79XfdpyKpYz2WMBeQ6ALyI52nUL2EC46iNbn69jONHmkuR52EZZk88uN08D
         hVA0eiIdlMxZzq4WGU8wjTuw/4Okoiq8/Zjk2presoD0HDHAmjLF1o2+f1A8uFiynSOw
         Yyvho3GvVkb4efT8eYife/8z8q+Rqr8k9T3Ntxg453jzhr0jPwKZ8zk2bNc2rzPlaQCA
         TkabiZ81eH2cSj3u+F+JfnBjbtdv2c7HzLWat8b9ObEZACgc0oEYyLy47WXaFeqDDLYQ
         6WgA==
In-Reply-To: <20170614200842.15174-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Factor out cgroup_masks_read_one() out of cgroup_masks_read() for
simplicity.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/debug.c | 46 +++++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff --git a/kernel/cgroup/debug.c b/kernel/cgroup/debug.c
index d61e692a5338..163fdbd7adf6 100644
--- a/kernel/cgroup/debug.c
+++ b/kernel/cgroup/debug.c
@@ -200,36 +200,32 @@ static int cgroup_subsys_states_read(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int cgroup_masks_read(struct seq_file *seq, void *v)
+static void cgroup_masks_read_one(struct seq_file *seq, const char *name,
+				  u16 mask)
 {
-	struct cgroup *cgrp = seq_css(seq)->cgroup;
 	struct cgroup_subsys *ss;
-	int i, j;
-	struct {
-		u16  *mask;
-		char *name;
-	} mask_list[] = {
-		{ &cgrp->subtree_control,  "subtree_control"  },
-		{ &cgrp->subtree_ss_mask,  "subtree_ss_mask"  },
-	};
+	int ssid;
+	bool first = true;
 
-	mutex_lock(&cgroup_mutex);
-	for (i = 0; i < ARRAY_SIZE(mask_list); i++) {
-		u16 mask = *mask_list[i].mask;
-		bool first = true;
-
-		seq_printf(seq, "%-17s: ", mask_list[i].name);
-		for_each_subsys(ss, j) {
-			if (!(mask & (1 << ss->id)))
-				continue;
-			if (!first)
-				seq_puts(seq, ", ");
-			seq_puts(seq, ss->name);
-			first = false;
-		}
-		seq_putc(seq, '\n');
+	seq_printf(seq, "%-17s: ", name);
+	for_each_subsys(ss, ssid) {
+		if (!(mask & (1 << ssid)))
+			continue;
+		if (!first)
+			seq_puts(seq, ", ");
+		seq_puts(seq, ss->name);
+		first = false;
 	}
+	seq_putc(seq, '\n');
+}
 
+static int cgroup_masks_read(struct seq_file *seq, void *v)
+{
+	struct cgroup *cgrp = seq_css(seq)->cgroup;
+
+	mutex_lock(&cgroup_mutex);
+	cgroup_masks_read_one(seq, "subtree_control", cgrp->subtree_control);
+	cgroup_masks_read_one(seq, "subtree_ss_mask", cgrp->subtree_ss_mask);
 	mutex_unlock(&cgroup_mutex);
 	return 0;
 }
-- 
2.13.0
