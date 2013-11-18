From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Date: Sun, 17 Nov 2013 18:17:17 -0800 (PST)
Message-ID: <alpine.LNX.2.00.1311171746160.15789@eggly.anvils>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com> <52820030.6000806@huawei.com> <20131112143147.GB6049@dhcp22.suse.cz> <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com> <20131112165504.GF6049@dhcp22.suse.cz>
 <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com> <20131115062458.GA9755@mtj.dyndns.org> <20131115075401.GB9755@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=g17sVYX54g9VZ6E+giK2axC9kBfvU+Dq8Cv4+dwwpUw=;
        b=VEn2gNFCRpd9FViw6KCltJTTsYroN46T0ICjsI56ILaHw7HlmSmj2TLozrAH4546CF
         CU5Vq8vHyhTtZiYdZ2gLf891b90k/Mbn9J4H+1RM3GDAE4qriJxdmuSuAS/IKh4zg3g8
         TlNQ9Zco0fNy0dzIGyyqDPYXh11XeEi9fNqlF+PXctf/UW2rMxGBlF/WnOh2dRQBPqBu
         qysR7ir920d1vFkqgiVG1NsBOpK5RxUxJns1Bo07SyOg33yzjsmS5kd+OjbFkC8a9gyq
         kEbTmuMdExrC7cUtVOvp3zh/Lw/LZ2mLZmzupt5vesxQE040fpIS5YeHtFU2fB15kvBh
         zfpA==
In-Reply-To: <20131115075401.GB9755-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>

On Fri, 15 Nov 2013, Tejun Heo wrote:

> Hello,
> 
> Shawn, Hugh, can you please verify whether the attached patch makes
> the deadlock go away?

Thanks a lot, Tejun: report below.

> 
> Thanks.
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index e0839bc..dc9dc06 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -90,6 +90,14 @@ static DEFINE_MUTEX(cgroup_mutex);
>  static DEFINE_MUTEX(cgroup_root_mutex);
>  
>  /*
> + * cgroup destruction makes heavy use of work items and there can be a lot
> + * of concurrent destructions.  Use a separate workqueue so that cgroup
> + * destruction work items don't end up filling up max_active of system_wq
> + * which may lead to deadlock.
> + */
> +static struct workqueue_struct *cgroup_destroy_wq;
> +
> +/*
>   * Generate an array of cgroup subsystem pointers. At boot time, this is
>   * populated with the built in subsystems, and modular subsystems are
>   * registered after that. The mutable section of this array is protected by
> @@ -871,7 +879,7 @@ static void cgroup_free_rcu(struct rcu_head *head)
>  	struct cgroup *cgrp = container_of(head, struct cgroup, rcu_head);
>  
>  	INIT_WORK(&cgrp->destroy_work, cgroup_free_fn);
> -	schedule_work(&cgrp->destroy_work);
> +	queue_work(cgroup_destroy_wq, &cgrp->destroy_work);
>  }
>  
>  static void cgroup_diput(struct dentry *dentry, struct inode *inode)
> @@ -4254,7 +4262,7 @@ static void css_free_rcu_fn(struct rcu_head *rcu_head)
>  	 * css_put().  dput() requires process context which we don't have.
>  	 */
>  	INIT_WORK(&css->destroy_work, css_free_work_fn);
> -	schedule_work(&css->destroy_work);
> +	queue_work(cgroup_destroy_wq, &css->destroy_work);
>  }
>  
>  static void css_release(struct percpu_ref *ref)
> @@ -4544,7 +4552,7 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
>  		container_of(ref, struct cgroup_subsys_state, refcnt);
>  
>  	INIT_WORK(&css->destroy_work, css_killed_work_fn);
> -	schedule_work(&css->destroy_work);
> +	queue_work(cgroup_destroy_wq, &css->destroy_work);
>  }
>  
>  /**
> @@ -5025,6 +5033,17 @@ int __init cgroup_init(void)
>  	if (err)
>  		return err;
>  
> +	/*
> +	 * There isn't much point in executing destruction path in
> +	 * parallel.  Good chunk is serialized with cgroup_mutex anyway.
> +	 * Use 1 for @max_active.
> +	 */
> +	cgroup_destroy_wq = alloc_workqueue("cgroup_destroy", 0, 1);
> +	if (!cgroup_destroy_wq) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
>  	for_each_builtin_subsys(ss, i) {
>  		if (!ss->early_init)
>  			cgroup_init_subsys(ss);
> @@ -5062,9 +5081,11 @@ int __init cgroup_init(void)
>  	proc_create("cgroups", 0, NULL, &proc_cgroupstats_operations);
>  
>  out:
> -	if (err)
> +	if (err) {
> +		if (cgroup_destroy_wq)
> +			destroy_workqueue(cgroup_destroy_wq);
>  		bdi_destroy(&cgroup_backing_dev_info);
> -
> +	}
>  	return err;
>  }
>  

Sorry for the delay: I was on the point of reporting success last
night, when I tried a debug kernel: and that didn't work so well
(got spinlock bad magic report in pwd_adjust_max_active(), and
tests wouldn't run at all).

Even the non-early cgroup_init() is called well before the
early_initcall init_workqueues(): though only the debug (lockdep
and spinlock debug) kernel appeared to have a problem with that.

Here's the patch I ended up with successfully on a 3.11.7-based
kernel (though below I've rediffed it against 3.11.8): the
schedule_work->queue_work hunks are slightly different on 3.11
than in your patch against current, and I did alloc_workqueue()
from a separate core_initcall.

The interval between cgroup_init and that is a bit of a worry;
but we don't seem to have suffered from the interval between
cgroup_init and init_workqueues before (when system_wq is NULL)
- though you may have more courage than I to reorder them!

Initially I backed out my system_highpri_wq workaround, and
verified that it was still easy to reproduce the problem with
one of our cgroup stresstests.  Yes it was, then your modified
patch below convincingly fixed it.

I ran with Johannes's patch adding extra mem_cgroup_reparent_charges:
as I'd expected, that didn't solve this issue (though it's worth
our keeping it in to rule out another source of problems).  And I
checked back on dumps of failures: they indeed show the tell-tale
256 kworkers doing cgroup_offline_fn, just as you predicted.

Thanks!
Hugh

---
 kernel/cgroup.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

--- 3.11.8/kernel/cgroup.c	2013-11-17 17:40:54.200640692 -0800
+++ linux/kernel/cgroup.c	2013-11-17 17:43:10.876643941 -0800
@@ -89,6 +89,14 @@ static DEFINE_MUTEX(cgroup_mutex);
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
@@ -890,7 +898,7 @@ static void cgroup_free_rcu(struct rcu_h
 	struct cgroup *cgrp = container_of(head, struct cgroup, rcu_head);
 
 	INIT_WORK(&cgrp->destroy_work, cgroup_free_fn);
-	schedule_work(&cgrp->destroy_work);
+	queue_work(cgroup_destroy_wq, &cgrp->destroy_work);
 }
 
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
@@ -4205,7 +4213,7 @@ static void css_release(struct percpu_re
 	struct cgroup_subsys_state *css =
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
-	schedule_work(&css->dput_work);
+	queue_work(cgroup_destroy_wq, &css->dput_work);
 }
 
 static void init_cgroup_css(struct cgroup_subsys_state *css,
@@ -4439,7 +4447,7 @@ static void cgroup_css_killed(struct cgr
 
 	/* percpu ref's of all css's are killed, kick off the next step */
 	INIT_WORK(&cgrp->destroy_work, cgroup_offline_fn);
-	schedule_work(&cgrp->destroy_work);
+	queue_work(cgroup_destroy_wq, &cgrp->destroy_work);
 }
 
 static void css_ref_killed_fn(struct percpu_ref *ref)
@@ -4967,6 +4975,22 @@ out:
 	return err;
 }
 
+static int __init cgroup_destroy_wq_init(void)
+{
+	/*
+	 * There isn't much point in executing destruction path in
+	 * parallel.  Good chunk is serialized with cgroup_mutex anyway.
+	 * Use 1 for @max_active.
+	 *
+	 * We would prefer to do this in cgroup_init() above, but that
+	 * is called before init_workqueues(): so leave this until after.
+	 */
+	cgroup_destroy_wq = alloc_workqueue("cgroup_destroy", 0, 1);
+	BUG_ON(!cgroup_destroy_wq);
+	return 0;
+}
+core_initcall(cgroup_destroy_wq_init);
+
 /*
  * proc_cgroup_show()
  *  - Print task's cgroup paths into seq_file, one line for each hierarchy
