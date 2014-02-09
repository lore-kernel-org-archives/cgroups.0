From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/16] cpuset: don't use cgroup_taskset_cur_css()
Date: Sun,  9 Feb 2014 08:52:41 -0500
Message-ID: <1391953964-22088-14-git-send-email-tj@kernel.org>
References: <1391953964-22088-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DomtmMNjpMdk1RJOPw6GXjG/RDYhfosatWUmFltHmLs=;
        b=uxkFTaQuxyyu4C6szViQp3SmTGVJHS0vzBBk+Wo5fZ+Livhiatbb8bYgnXa6Iaoczr
         TTd1o2XsUfQcNQs+vC+rbhLchapSMSMPkXEa6kBIJlq1QvZ8HkuqwBLd0mIkXqczgTJQ
         br9Xhyr5b389gZGOCpa+FQVB0ut/16ghmPeh2SnwqC+t7fM0pbcjSRXYubZJDJeCxssh
         uN0AMSXmWEZh40zVtL1rNjiHKN3dFlwIKJCl+mZ10CHRArLMttXRe2iTE31L4RTP8tL2
         DsSPzPW4hchFhyhoHLGSAJCp5HbkIGqFnzO3zNLV9GDwfRkjZUUEu/1zp1ypa5al/g5h
         q5OA==
In-Reply-To: <1391953964-22088-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

cgroup_taskset_cur_css() will be removed during the planned
resturcturing of migration path.  The only use of
cgroup_taskset_cur_css() is finding out the old cgroup_subsys_state of
the leader in cpuset_attach().  This usage can easily be removed by
remembering the old value from cpuset_can_attach().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index bf20e4a..d8bec21 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1379,6 +1379,8 @@ static int fmeter_getrate(struct fmeter *fmp)
 	return val;
 }
 
+static struct cpuset *cpuset_attach_old_cs;
+
 /* Called by cgroups to determine if a cpuset is usable; cpuset_mutex held */
 static int cpuset_can_attach(struct cgroup_subsys_state *css,
 			     struct cgroup_taskset *tset)
@@ -1387,6 +1389,9 @@ static int cpuset_can_attach(struct cgroup_subsys_state *css,
 	struct task_struct *task;
 	int ret;
 
+	/* used later by cpuset_attach() */
+	cpuset_attach_old_cs = task_cs(cgroup_taskset_first(tset));
+
 	mutex_lock(&cpuset_mutex);
 
 	/*
@@ -1450,10 +1455,8 @@ static void cpuset_attach(struct cgroup_subsys_state *css,
 	struct mm_struct *mm;
 	struct task_struct *task;
 	struct task_struct *leader = cgroup_taskset_first(tset);
-	struct cgroup_subsys_state *oldcss = cgroup_taskset_cur_css(tset,
-							cpuset_cgrp_id);
 	struct cpuset *cs = css_cs(css);
-	struct cpuset *oldcs = css_cs(oldcss);
+	struct cpuset *oldcs = cpuset_attach_old_cs;
 	struct cpuset *cpus_cs = effective_cpumask_cpuset(cs);
 	struct cpuset *mems_cs = effective_nodemask_cpuset(cs);
 
-- 
1.8.5.3
