From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/2] cgroup: make sure a parent css isn't freed before its
 children
Date: Thu, 21 Jan 2016 15:32:15 -0500
Message-ID: <20160121203215.GG5157@mtj.duckdns.org>
References: <56978452.6010606@de.ibm.com>
 <20160114195630.GA3520@mtj.duckdns.org>
 <5698A023.9070703@de.ibm.com>
 <20160121203111.GF5157@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FI+DT/lekq1J+kMTGXHqvhctvpJWJxk2kGWLxSzGnNo=;
        b=WrjfbpBnGHbDxWODptSvQ+wTbgoy2tFkz4vUK042J0wV8bVhwKJbAyMg0tUw/eq5Au
         nMnP7JlYcjuZmUhh/xGhM/T9HniOXJNhIogJpT8hkJGEs1BmPPWqCWv2rsKKgcJY6Yt5
         WB3vxLQVNGHWLLJLMPqCp66rZfGf/iCXTT2cT2uhOhm2NJGvELkZ/YXipcJmdE2VDNHU
         7moSE78tNKRHrqP4/hU1EWcua6zhcBpWh0qIZSaLGJd+uqMniMU57gG9FjmUOT85Z3wS
         l1miFuIDMS4/a6RWDttPe0bGfS2UV1b8PjfyACQR/GbpCKnWUj3GF9/gpEtNl9mv2rPa
         /10Q==
Content-Disposition: inline
In-Reply-To: <20160121203111.GF5157@mtj.duckdns.org>
Sender: kvm-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390 <linux-s390@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, kernel-team@fb.com

There are three subsystem callbacks in css shutdown path -
css_offline(), css_released() and css_free().  Except for
css_released(), cgroup core didn't use to guarantee the order of
invocation.  css_offline() or css_free() could be called on a parent
css before its children.  This behavior is unexpected and led to
use-after-free in cpu controller.

The previous patch updated ordering for css_offline() which fixes the
cpu controller issue.  While there currently isn't a known bug caused
by misordering of css_free() invocations, let's fix it too for
consistency.

css_free() ordering can be trivially fixed by moving putting of the
parent css below css_free() invocation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/cgroup.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4657,14 +4657,15 @@ static void css_free_work_fn(struct work
 
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
