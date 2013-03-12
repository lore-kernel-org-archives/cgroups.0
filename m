From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3/8] cgroup: hold cgroup_mutex before calling css_offline()
Date: Tue, 12 Mar 2013 14:50:34 +0800
Message-ID: <513ED03A.1040900@huawei.com>
References: <513ED010.5060906@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <513ED010.5060906@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

cpuset no longer nests cgroup_mutex inside cpu_hotplug lock, so
we don't have to release cgroup_mutex before calling css_offline().

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 Documentation/cgroups/cgroups.txt |  1 +
 kernel/cgroup.c                   | 11 +----------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index bcf1a00..0028e88 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -580,6 +580,7 @@ propagation along the hierarchy. See the comment on
 cgroup_for_each_descendant_pre() for details.
 
 void css_offline(struct cgroup *cgrp);
+(cgroup_mutex held by caller)
 
 This is the counterpart of css_online() and called iff css_online()
 has succeeded on @cgrp. This signifies the beginning of the end of
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 71bc33d..be524ac 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4170,17 +4170,8 @@ static void offline_css(struct cgroup_subsys *ss, struct cgroup *cgrp)
 	if (!(css->flags & CSS_ONLINE))
 		return;
 
-	/*
-	 * css_offline() should be called with cgroup_mutex unlocked.  See
-	 * 3fa59dfbc3 ("cgroup: fix potential deadlock in pre_destroy") for
-	 * details.  This temporary unlocking should go away once
-	 * cgroup_mutex is unexported from controllers.
-	 */
-	if (ss->css_offline) {
-		mutex_unlock(&cgroup_mutex);
+	if (ss->css_offline)
 		ss->css_offline(cgrp);
-		mutex_lock(&cgroup_mutex);
-	}
 
 	cgrp->subsys[ss->subsys_id]->flags &= ~CSS_ONLINE;
 }
-- 
1.8.0.2
