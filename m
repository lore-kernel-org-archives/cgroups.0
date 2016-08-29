From: Sargun Dhillon <sargun@sargun.me>
Subject: [net-next RFC v2 2/9] cgroups: move helper cgroup_parent to cgroup.h
Date: Mon, 29 Aug 2016 04:46:09 -0700
Message-ID: <20160829114608.GA20848@ircssh.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=w+gIwX5HH79oqKbqc860XJSFF19qxoex+1tXYt+p3a8=;
        b=sEr6AJcDvbkcfD5C5O9r8TS3hKpHlKeQWhoOLUJpF+5pKDKH1SZfnSGgF8nyI3Ci2P
         ex/GIYDszeuWBs+F62ai8x+cC1lyCL0W2EFtMfkRVBTE49L0AQNgV0mMW4z8GHzQSSNd
         9M4VHUUdb90UV3XQXOylyk0oae3+soqw+kAOg=
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: cgroups@vger.kernel.org, linux-security-module@vger.kernel.org, daniel@iogearbox.net, ast@fb.com

This patch moves cgroup_parent into cgroup.h as a static inline helper
function so that others can use it. Although this pattern is easy
to implement, having it in one place simplifies the creation
of new cgroup controllers.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 include/linux/cgroup.h | 16 ++++++++++++++++
 kernel/cgroup.c        |  9 ---------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index a4414a1..b84eb6e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -571,6 +571,22 @@ static inline void pr_cont_cgroup_path(struct cgroup *cgrp)
 	pr_cont_kernfs_path(cgrp->kn);
 }
 
+/**
+ * cgroup_parent - Get the parent of a specific cgroup
+ * @cgrp: target cgroup
+ *
+ * If the cgroup does not have a parent (top level), then this function
+ * returns NULL. Otherwise, it'll return a pointer to te the parent cgroup.
+ */
+static inline struct cgroup *cgroup_parent(struct cgroup *cgrp)
+{
+	struct cgroup_subsys_state *parent_css = cgrp->self.parent;
+
+	if (parent_css)
+		return container_of(parent_css, struct cgroup, self);
+	return NULL;
+}
+
 #else /* !CONFIG_CGROUPS */
 
 struct cgroup_subsys_state;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d1c51b7..1ec1a4e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -358,15 +358,6 @@ static void cgroup_idr_remove(struct idr *idr, int id)
 	spin_unlock_bh(&cgroup_idr_lock);
 }
 
-static struct cgroup *cgroup_parent(struct cgroup *cgrp)
-{
-	struct cgroup_subsys_state *parent_css = cgrp->self.parent;
-
-	if (parent_css)
-		return container_of(parent_css, struct cgroup, self);
-	return NULL;
-}
-
 /* subsystems visibly enabled on a cgroup */
 static u16 cgroup_control(struct cgroup *cgrp)
 {
-- 
2.7.4

