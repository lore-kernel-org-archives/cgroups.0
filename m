From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Date: Fri, 15 Nov 2013 16:54:01 +0900
Message-ID: <20131115075401.GB9755@mtj.dyndns.org>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com>
 <52820030.6000806@huawei.com>
 <20131112143147.GB6049@dhcp22.suse.cz>
 <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com>
 <20131112165504.GF6049@dhcp22.suse.cz>
 <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com>
 <20131115062458.GA9755@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=LtQuDIa64zRNKqSwmmbXz19oo74TYJZZnJs0yzSvhMQ=;
        b=NDAa7prhEtX+XfSyVlCG3oi3W0haLfPgGZkZ4U0SixWeOyN4ygl0eh2RGrBN3xwtPH
         5Q0jhyfeQQMPys5Uik35BavvYpXepzAmUVUW38ebU056C90R0OHLgN2f8HUxxL7dPcm8
         Jr2FXUt3h3ED/9wgoHD85fHgZomQsI/w2htFc1VHAsF3iqV/gfwddihK0POOZrQu6hfI
         PSa9cAlPnR9zuxAgZRxhn89z1IGUF62v118sdlo7/f8EhmJe4m5CuwxcAnlF9JsW3LBi
         rAizRMRL7nrsd/TQuX0tR6ieGtWdTyy9cHEVIAQDm76BzuE2qR2E6CUNZlvuO4gVyiOK
         yrWg==
Content-Disposition: inline
In-Reply-To: <20131115062458.GA9755-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>

Hello,

Shawn, Hugh, can you please verify whether the attached patch makes
the deadlock go away?

Thanks.

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e0839bc..dc9dc06 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -90,6 +90,14 @@ static DEFINE_MUTEX(cgroup_mutex);
 static DEFINE_MUTEX(cgroup_root_mutex);
 
 /*
+ * cgroup destruction makes heavy use of work items and there can be a lot
+ * of concurrent destructions.  Use a separate workqueue so that cgroup
+ * destruction work items don't end up filling up max_active of system_wq
+ * which may lead to deadlock.
+ */
+static struct workqueue_struct *cgroup_destroy_wq;
+
+/*
  * Generate an array of cgroup subsystem pointers. At boot time, this is
  * populated with the built in subsystems, and modular subsystems are
  * registered after that. The mutable section of this array is protected by
@@ -871,7 +879,7 @@ static void cgroup_free_rcu(struct rcu_head *head)
 	struct cgroup *cgrp = container_of(head, struct cgroup, rcu_head);
 
 	INIT_WORK(&cgrp->destroy_work, cgroup_free_fn);
-	schedule_work(&cgrp->destroy_work);
+	queue_work(cgroup_destroy_wq, &cgrp->destroy_work);
 }
 
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
@@ -4254,7 +4262,7 @@ static void css_free_rcu_fn(struct rcu_head *rcu_head)
 	 * css_put().  dput() requires process context which we don't have.
 	 */
 	INIT_WORK(&css->destroy_work, css_free_work_fn);
-	schedule_work(&css->destroy_work);
+	queue_work(cgroup_destroy_wq, &css->destroy_work);
 }
 
 static void css_release(struct percpu_ref *ref)
@@ -4544,7 +4552,7 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
 	INIT_WORK(&css->destroy_work, css_killed_work_fn);
-	schedule_work(&css->destroy_work);
+	queue_work(cgroup_destroy_wq, &css->destroy_work);
 }
 
 /**
@@ -5025,6 +5033,17 @@ int __init cgroup_init(void)
 	if (err)
 		return err;
 
+	/*
+	 * There isn't much point in executing destruction path in
+	 * parallel.  Good chunk is serialized with cgroup_mutex anyway.
+	 * Use 1 for @max_active.
+	 */
+	cgroup_destroy_wq = alloc_workqueue("cgroup_destroy", 0, 1);
+	if (!cgroup_destroy_wq) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	for_each_builtin_subsys(ss, i) {
 		if (!ss->early_init)
 			cgroup_init_subsys(ss);
@@ -5062,9 +5081,11 @@ int __init cgroup_init(void)
 	proc_create("cgroups", 0, NULL, &proc_cgroupstats_operations);
 
 out:
-	if (err)
+	if (err) {
+		if (cgroup_destroy_wq)
+			destroy_workqueue(cgroup_destroy_wq);
 		bdi_destroy(&cgroup_backing_dev_info);
-
+	}
 	return err;
 }
 
