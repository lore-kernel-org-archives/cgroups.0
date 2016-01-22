From: Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 2/2] cgroup: make sure a parent css isn't freed before its
 children
Date: Fri, 22 Jan 2016 10:45:52 -0500
Message-ID: <20160122154552.GE32380@htj.duckdns.org>
References: <56978452.6010606@de.ibm.com>
 <20160114195630.GA3520@mtj.duckdns.org>
 <5698A023.9070703@de.ibm.com>
 <20160121203111.GF5157@mtj.duckdns.org>
 <20160121203215.GG5157@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=IbXWqlJiW6jOokFxqjEIujHElkEOT2oRhGu/h2o3tqA=;
        b=KbDBAkCEecZ9g7ZmxgDXi74JVjEPDN5bGngnCQlbaLy3wM5gDc+QOEO+CP89e9LvOG
         YyyWehdxD7rc/cIl/oUh93zl1OIRsdtawg2Ig+OHoeLh8eocuuXSxoqeVYG9jWzJiA8g
         ZiRZ87zLgg8YhTiph9k905uWbI1rI4ZnxqXNT9VtXAamut5CJilwzrbDI8o2Vuiibrp1
         O1B226CfzwpcLGGNd9XTWjNAf4bVi5PGc2GLp0ZC4yTxV1XOfsMRa4AFiSettN7uX8+X
         AKBncmy/kGnMu0JRsyE/PAwKADTEswD6T4rdezjfesIVSTWjqcRY/L4dJuiSL3oxwXOC
         SBzg==
Content-Disposition: inline
In-Reply-To: <20160121203215.GG5157@mtj.duckdns.org>
Sender: kvm-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390 <linux-s390@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, kernel-team@fb.com

From 8bb5ef79bc0f4016ecf79e8dce6096a3c63603e4 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 21 Jan 2016 15:32:15 -0500

There are three subsystem callbacks in css shutdown path -
css_offline(), css_released() and css_free().  Except for
css_released(), cgroup core didn't guarantee the order of invocation.
css_offline() or css_free() could be called on a parent css before its
children.  This behavior is unexpected and led to bugs in cpu and
memory controller.

The previous patch updated ordering for css_offline() which fixes the
cpu controller issue.  While there currently isn't a known bug caused
by misordering of css_free() invocations, let's fix it too for
consistency.

css_free() ordering can be trivially fixed by moving putting of the
parent css below css_free() invocation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---
Hello,

Applied to cgroup/for-4.5-fixes w/ description updated.  Will push out
to Linus early next week.

Thanks.

 kernel/cgroup.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d015877..d27904c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4657,14 +4657,15 @@ static void css_free_work_fn(struct work_struct *work)
 
 	if (ss) {
 		/* css free path */
+		struct cgroup_subsys_state *parent = css->parent;
 		int id = css->id;
 
-		if (css->parent)
-			css_put(css->parent);
-
 		ss->css_free(css);
 		cgroup_idr_remove(&ss->css_idr, id);
 		cgroup_put(cgrp);
+
+		if (parent)
+			css_put(parent);
 	} else {
 		/* cgroup free path */
 		atomic_dec(&cgrp->root->nr_cgrps);
-- 
2.5.0

