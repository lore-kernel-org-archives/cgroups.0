From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/9] cgroup: bounce css release through css->destroy_work
Date: Fri,  9 May 2014 17:13:33 -0400
Message-ID: <1399670015-23463-8-git-send-email-tj@kernel.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4DPo1FdKSz7tVMhXCqn7IxH4HbzTBL/D7ITuH8FRi1s=;
        b=Vq4qaC+/AHTL8LeSIIFeH2yNg53UcxKWbpLO2R1pAZHD37X7R+W9a37Kj+AXxDnsi/
         yCnggf5ayr5Pw8zHk1vhYx5APgt91qpLRyuzpW+AjrugHnCuGqskDo69Hvg8O9KvN8EF
         0PzNRp/7DyX3+wGOdHNoltWBISW/MWSK4HiK3Q89ktntXlY4BFbmcXGawg04bBrl5adG
         yCWXUOnuIyQxm72Lx0pJI/WVHbM83cU2+0SZAJXFcrbNxnPwlZWuyfn2YtSauYxKnb9Y
         QLUeUFzOtxYhpJFEw+stJyHl53884WPCHT7O+d2jal5Rv9Xk+4gKxXpdHvJ1aSsBVyuE
         YlhQ==
In-Reply-To: <1399670015-23463-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

css release is planned to do more and would require process context.
Bounce it through css->destroy_work.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index bb67acb..b382383 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4125,10 +4125,10 @@ static void css_free_rcu_fn(struct rcu_head *rcu_head)
 	queue_work(cgroup_destroy_wq, &css->destroy_work);
 }
 
-static void css_release(struct percpu_ref *ref)
+static void css_release_work_fn(struct work_struct *work)
 {
 	struct cgroup_subsys_state *css =
-		container_of(ref, struct cgroup_subsys_state, refcnt);
+		container_of(work, struct cgroup_subsys_state, destroy_work);
 	struct cgroup_subsys *ss = css->ss;
 
 	cgroup_idr_remove(&ss->css_idr, css->id);
@@ -4136,6 +4136,15 @@ static void css_release(struct percpu_ref *ref)
 	call_rcu(&css->rcu_head, css_free_rcu_fn);
 }
 
+static void css_release(struct percpu_ref *ref)
+{
+	struct cgroup_subsys_state *css =
+		container_of(ref, struct cgroup_subsys_state, refcnt);
+
+	INIT_WORK(&css->destroy_work, css_release_work_fn);
+	queue_work(cgroup_destroy_wq, &css->destroy_work);
+}
+
 static void init_and_link_css(struct cgroup_subsys_state *css,
 			      struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
-- 
1.9.0
