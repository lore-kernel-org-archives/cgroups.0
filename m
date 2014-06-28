From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] cgroup: implement cgroup_subsys->css_reset()
Date: Fri, 27 Jun 2014 21:03:10 -0400
Message-ID: <1403917392-32555-5-git-send-email-tj@kernel.org>
References: <1403917392-32555-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=W2JgKHH6v7lm++vvoEcCCBPeJ1gwE+Kt0TWb8WBWevM=;
        b=xFONvACTX/0X1nvJqd/pVdA7FBg3oJGJ3PNBMCd2lCRn/Bj4+SShbMMXCorGZdxEUt
         6m7aBOvinerEy29GBmaidKmx2Cz9QVvkNDJzKj4/sJpAHZtwcUIrwMXJFmmsFOjtSFff
         6YzllSNVmLdYkPlolyOXr6I7gDnYvdi6XQ11Jc/hFwWZU5vvQwT/HlBoyRRxwu5FqZzU
         BZfxxB6ZJ6lWKfp7bmgBAxzp6PcLKO3HdjoO327303Cq9cFTgTK8E9Hb5IDABDEpkQzZ
         Y/ZnSr0CuHVqIRFOxD80C3mNUjdTnd0156yqlf39JVOrwXx3sIOw/iF8kQPR4fmNKBFx
         7AcQ==
In-Reply-To: <1403917392-32555-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, mhocko@suse.cz, vgoyal@redhat.com, axboe@kernel.dk, Tejun Heo <tj@kernel.org>

cgroup is implementing support for subsystem dependency which would
require a way to enable a subsystem even when it's not directly
configured through "cgroup.subtree_control".

The previous patches added support for explicitly and implicitly
enabled subsystems and showing/hiding their interface files.  An
explicitly enabled subsystem may become implicitly enabled if it's
turned off through "cgroup.subtree_control" but there are subsystems
depending on it.  In such cases, the subsystem, as it's turned off
when seen from userland, shouldn't enforce any resource control.
Also, the subsystem may be explicitly turned on later again and its
interface files should be as close to the intial state as possible.

This patch adds cgroup_subsys->css_reset() which is invoked when a css
is hidden.  The callback should disable resource control and reset the
state to the vanilla state.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 Documentation/cgroups/cgroups.txt | 14 ++++++++++++++
 include/linux/cgroup.h            |  1 +
 kernel/cgroup.c                   | 16 ++++++++++++----
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 821de56..10c949b 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -599,6 +599,20 @@ fork. If this method returns 0 (success) then this should remain valid
 while the caller holds cgroup_mutex and it is ensured that either
 attach() or cancel_attach() will be called in future.
 
+void css_reset(struct cgroup_subsys_state *css)
+(cgroup_mutex held by caller)
+
+An optional operation which should restore @css's configuration to the
+initial state.  This is currently only used on the unified hierarchy
+when a subsystem is disabled on a cgroup through
+"cgroup.subtree_control" but should remain enabled because other
+subsystems depend on it.  cgroup core makes such a css invisible by
+removing the associated interface files and invokes this callback so
+that the hidden subsystem can return to the initial neutral state.
+This prevents unexpected resource control from a hidden css and
+ensures that the configuration is in the initial state when it is made
+visible again later.
+
 void cancel_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 (cgroup_mutex held by caller)
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5287f93..db99e3b 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -642,6 +642,7 @@ struct cgroup_subsys {
 	int (*css_online)(struct cgroup_subsys_state *css);
 	void (*css_offline)(struct cgroup_subsys_state *css);
 	void (*css_free)(struct cgroup_subsys_state *css);
+	void (*css_reset)(struct cgroup_subsys_state *css);
 
 	int (*can_attach)(struct cgroup_subsys_state *css,
 			  struct cgroup_taskset *tset);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 331fa296..3a6b77d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2740,17 +2740,25 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	/*
 	 * All tasks are migrated out of disabled csses.  Kill or hide
 	 * them.  A css is hidden when the userland requests it to be
-	 * disabled while other subsystems are still depending on it.
+	 * disabled while other subsystems are still depending on it.  The
+	 * css must not actively control resources and be in the vanilla
+	 * state if it's made visible again later.  Controllers which may
+	 * be depended upon should provide ->css_reset() for this purpose.
 	 */
 	for_each_subsys(ss, ssid) {
 		if (!(disable & (1 << ssid)))
 			continue;
 
 		cgroup_for_each_live_child(child, cgrp) {
-			if (css_disable & (1 << ssid))
-				kill_css(cgroup_css(child, ss));
-			else
+			struct cgroup_subsys_state *css = cgroup_css(child, ss);
+
+			if (css_disable & (1 << ssid)) {
+				kill_css(css);
+			} else {
 				cgroup_clear_dir(child, 1 << ssid);
+				if (ss->css_reset)
+					ss->css_reset(css);
+			}
 		}
 	}
 
-- 
1.9.3
