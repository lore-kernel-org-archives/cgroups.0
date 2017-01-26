From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-4.10-fixes] cgroup: don't online subsystems before
 cgroup_name/path() are operational
Date: Thu, 26 Jan 2017 16:50:31 -0500
Message-ID: <20170126215031.GD32152@htj.duckdns.org>
References: <148542370148.63697.501199781041713381.stgit@buzz>
 <148542370808.63697.11031298116868200840.stgit@buzz>
 <20170126193754.GC32152@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MnjzTAVnchYd6QeQatLAnqZrofby/dWHBfs5wLZ1nUg=;
        b=NIWdaWuhfazSovF1KhQLSZKcP4LPk+xIAXZBVF235ZkSLnRmqCfkMxZ2hrm9FoUsVz
         UPbjxR57aOV4iW4pKpCWS/b+xGkZUQUSb+xqnDbMxbWlQbGxVBXxl3Vz0w+ynJF8h+Tz
         5VSRvEZQNUhfErfiSXDL7l0ScHXA0EWg+UfY4u7hJiD6+TDu/5HPmKAmKh+2YqdlWBy9
         x73V8zvVy31Fmtu3ehH2jyp6L9yw6vl5dR0cxkFEuvBKLxICpP2ctEPRnU3tB8dPUxAg
         RG1WTGVzs1eLKQKGbg5xPayRGNN4liEGT7zQIe++9qAimMJKnrh3d5Cj4R9nhiAbK0gy
         ud7Q==
Content-Disposition: inline
In-Reply-To: <20170126193754.GC32152@htj.duckdns.org>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, kernel-team@fb.com

From 07cd12945551b63ecb1a349d50a6d69d1d6feb4a Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 26 Jan 2017 16:47:28 -0500

While refactoring cgroup creation, a5bca2152036 ("cgroup: factor out
cgroup_create() out of cgroup_mkdir()") incorrectly onlined subsystems
before the new cgroup is associated with it kernfs_node.  This is fine
for cgroup proper but cgroup_name/path() depend on the associated
kernfs_node and if a subsystem makes the new cgroup_subsys_state
visible, which they're allowed to after onlining, it can lead to NULL
dereference.

The current code performs cgroup creation and subsystem onlining in
cgroup_create() and cgroup_mkdir() makes the cgroup and subsystems
visible afterwards.  There's no reason to online the subsystems early
and we can simply drop cgroup_apply_control_enable() call from
cgroup_create() so that the subsystems are onlined and made visible at
the same time.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Fixes: a5bca2152036 ("cgroup: factor out cgroup_create() out of cgroup_mkdir()")
Cc: stable@vger.kernel.org # v4.6+
---
Applied to cgroup/for-4.10-fixes.

Thanks.

 kernel/cgroup.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2ee9ec3..688dd02 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5221,6 +5221,11 @@ static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
 	return ERR_PTR(err);
 }
 
+/*
+ * The returned cgroup is fully initialized including its control mask, but
+ * it isn't associated with its kernfs_node and doesn't have the control
+ * mask applied.
+ */
 static struct cgroup *cgroup_create(struct cgroup *parent)
 {
 	struct cgroup_root *root = parent->root;
@@ -5288,11 +5293,6 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 
 	cgroup_propagate_control(cgrp);
 
-	/* @cgrp doesn't have dir yet so the following will only create csses */
-	ret = cgroup_apply_control_enable(cgrp);
-	if (ret)
-		goto out_destroy;
-
 	return cgrp;
 
 out_cancel_ref:
@@ -5300,9 +5300,6 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 out_free_cgrp:
 	kfree(cgrp);
 	return ERR_PTR(ret);
-out_destroy:
-	cgroup_destroy_locked(cgrp);
-	return ERR_PTR(ret);
 }
 
 static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
-- 
2.9.3
