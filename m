From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] cgroup: make sure a parent css isn't offlined before its
 children
Date: Thu, 21 Jan 2016 15:31:11 -0500
Message-ID: <20160121203111.GF5157@mtj.duckdns.org>
References: <56978452.6010606@de.ibm.com>
 <20160114195630.GA3520@mtj.duckdns.org>
 <5698A023.9070703@de.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=W5Yxw1O2YgCTFBx5lVxLkjq2nB4rG00+oM+Fuy2De6I=;
        b=zCBk4n/cmtamTpxEIeaYSeic9KLKbIRzQo+JHtY5izp3n1F/Kt1TIlIN1rc4F5C4ct
         mNezLbm4U6UL37MRIwT4mz/vFG9vJFzFJXD7vlH3v1fMuwpULqXY6C2IvtC3vYmAZ/5W
         xkO8iFbL8zwkgfvISbhdhcj/EG06ErpLPRHCaxICH6DJWdbbBMzj/xdduRC89RQ21hsE
         HcXyWvhZ7HeGCE++GgmVCTqTzu7dmE9dtxYWX/Q5+/UOLkB+qlcCAq+VDmC1L/AkvYsp
         Rwp/Zr5yQ1evaP1sYbWtVfHRful13CQP6qzcrfZKYNmANJMo4gqV959wdKRP0dfMsWwC
         DXEw==
Content-Disposition: inline
In-Reply-To: <5698A023.9070703-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390 <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

There are three subsystem callbacks in css shutdown path -
css_offline(), css_released() and css_free().  Except for
css_released(), cgroup core didn't use to guarantee the order of
invocation.  css_offline() or css_free() could be called on a parent
css before its children.  This behavior is unexpected and led to
use-after-free in cpu controller.

This patch updates offline path so that a parent css is never offlined
before its children.  Each css keeps online_cnt which reaches zero iff
itself and all its children are offline and offline_css() is invoked
only after online_cnt reaches zero.

This fixes the reported cpu controller malfunction.  The next patch
will update css_free() handling.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Link: http://lkml.kernel.org/g/5698A023.9070703-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org
Cc: Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
Hello, Christian.

Can you please verify whether this patch fixes the issue?

Thanks.

 include/linux/cgroup-defs.h |    6 ++++++
 kernel/cgroup.c             |   22 +++++++++++++++++-----
 2 files changed, 23 insertions(+), 5 deletions(-)

--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -127,6 +127,12 @@ struct cgroup_subsys_state {
 	 */
 	u64 serial_nr;
 
+	/*
+	 * Incremented by online self and children.  Used to guarantee that
+	 * parents are not offlined before their children.
+	 */
+	atomic_t online_cnt;
+
 	/* percpu_ref killing and RCU release */
 	struct rcu_head rcu_head;
 	struct work_struct destroy_work;
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4761,6 +4761,7 @@ static void init_and_link_css(struct cgr
 	INIT_LIST_HEAD(&css->sibling);
 	INIT_LIST_HEAD(&css->children);
 	css->serial_nr = css_serial_nr_next++;
+	atomic_set(&css->online_cnt, 0);
 
 	if (cgroup_parent(cgrp)) {
 		css->parent = cgroup_css(cgroup_parent(cgrp), ss);
@@ -4783,6 +4784,10 @@ static int online_css(struct cgroup_subs
 	if (!ret) {
 		css->flags |= CSS_ONLINE;
 		rcu_assign_pointer(css->cgroup->subsys[ss->id], css);
+
+		atomic_inc(&css->online_cnt);
+		if (css->parent)
+			atomic_inc(&css->parent->online_cnt);
 	}
 	return ret;
 }
@@ -5020,10 +5025,15 @@ static void css_killed_work_fn(struct wo
 		container_of(work, struct cgroup_subsys_state, destroy_work);
 
 	mutex_lock(&cgroup_mutex);
-	offline_css(css);
-	mutex_unlock(&cgroup_mutex);
 
-	css_put(css);
+	do {
+		offline_css(css);
+		css_put(css);
+		/* @css can't go away while we're holding cgroup_mutex */
+		css = css->parent;
+	} while (css && atomic_dec_and_test(&css->online_cnt));
+
+	mutex_unlock(&cgroup_mutex);
 }
 
 /* css kill confirmation processing requires process context, bounce */
@@ -5032,8 +5042,10 @@ static void css_killed_ref_fn(struct per
 	struct cgroup_subsys_state *css =
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
-	INIT_WORK(&css->destroy_work, css_killed_work_fn);
-	queue_work(cgroup_destroy_wq, &css->destroy_work);
+	if (atomic_dec_and_test(&css->online_cnt)) {
+		INIT_WORK(&css->destroy_work, css_killed_work_fn);
+		queue_work(cgroup_destroy_wq, &css->destroy_work);
+	}
 }
 
 /**
