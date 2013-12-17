From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-3.13-fixes] cgroup: don't recycle cgroup id until
 all csses' have been destroyed
Date: Tue, 17 Dec 2013 08:15:25 -0500
Message-ID: <20131217131525.GH29989@htj.dyndns.org>
References: <alpine.LNX.2.00.1312160025200.2785@eggly.anvils>
 <52AEC989.4080509@huawei.com>
 <20131216095345.GB23582@dhcp22.suse.cz>
 <20131216104042.GC23582@dhcp22.suse.cz>
 <20131216163530.GH32509@htj.dyndns.org>
 <20131216171937.GG26797@dhcp22.suse.cz>
 <20131216172143.GJ32509@htj.dyndns.org>
 <alpine.LNX.2.00.1312161718001.2037@eggly.anvils>
 <52AFC163.5010507@huawei.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=gQOwf2au8QsMKufBe9InSLdnS+SjAlXcb/0CcyadEHM=;
        b=efV2+6rLoUb258VPh4Am59QV8FAVeq9382U+Qy7DMmgV1sExherFP4IF0VRZPZQbcq
         /G4e6W7JekXSZ3A8bfqyYYwt5sl8/2irgCoLZtnHmmZPMxbCJ8SgU2kNFq+3nEi6Dhal
         J6IivUVxuY7GCEzfKMHWjuTz3MlGq8by95moBninAHOUS9SNBZrfdP7AESgkLigSYgd/
         ihRZnHy7MCQSULdEugbtDd78TruIU3+l6SxsqVVZWGddRD+agYP6HVJQFKiwTf3Piam/
         /ZqTz9FN06Ty8TU965CKJVmrFp3Bugyii3s7Qc3UW0xs8LeOSc8edbsHA4HcxnSq6ztE
         54kw==
Content-Disposition: inline
In-Reply-To: <52AFC163.5010507@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hey,

I updated the comment myself and applied the patch to
cgroup/for-3.13-fixes.

Thanks!
-------- 8< --------
From c1a71504e9715812a2d15e7c03b5aa147ae70ded Mon Sep 17 00:00:00 2001
From: Li Zefan <lizefan@huawei.com>
Date: Tue, 17 Dec 2013 11:13:39 +0800

Hugh reported this bug:

> CONFIG_MEMCG_SWAP is broken in 3.13-rc.  Try something like this:
>
> mkdir -p /tmp/tmpfs /tmp/memcg
> mount -t tmpfs -o size=1G tmpfs /tmp/tmpfs
> mount -t cgroup -o memory memcg /tmp/memcg
> mkdir /tmp/memcg/old
> echo 512M >/tmp/memcg/old/memory.limit_in_bytes
> echo $$ >/tmp/memcg/old/tasks
> cp /dev/zero /tmp/tmpfs/zero 2>/dev/null
> echo $$ >/tmp/memcg/tasks
> rmdir /tmp/memcg/old
> sleep 1	# let rmdir work complete
> mkdir /tmp/memcg/new
> umount /tmp/tmpfs
> dmesg | grep WARNING
> rmdir /tmp/memcg/new
> umount /tmp/memcg
>
> Shows lots of WARNING: CPU: 1 PID: 1006 at kernel/res_counter.c:91
>                            res_counter_uncharge_locked+0x1f/0x2f()
>
> Breakage comes from 34c00c319ce7 ("memcg: convert to use cgroup id").
>
> The lifetime of a cgroup id is different from the lifetime of the
> css id it replaced: memsw's css_get()s do nothing to hold on to the
> old cgroup id, it soon gets recycled to a new cgroup, which then
> mysteriously inherits the old's swap, without any charge for it.

Instead of removing cgroup id right after all the csses have been
offlined, we should do that after csses have been destroyed.

To make sure an invalid css pointer won't be returned after the css
is destroyed, make sure css_from_id() returns NULL in this case.

tj: Updated comment to note planned changes for cgrp->id.

Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index bcb1755..bc1dcab 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -890,6 +890,16 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		struct cgroup *cgrp = dentry->d_fsdata;
 
 		BUG_ON(!(cgroup_is_dead(cgrp)));
+
+		/*
+		 * XXX: cgrp->id is only used to look up css's.  As cgroup
+		 * and css's lifetimes will be decoupled, it should be made
+		 * per-subsystem and moved to css->id so that lookups are
+		 * successful until the target css is released.
+		 */
+		idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
+		cgrp->id = -1;
+
 		call_rcu(&cgrp->rcu_head, cgroup_free_rcu);
 	} else {
 		struct cfent *cfe = __d_cfe(dentry);
@@ -4268,6 +4278,7 @@ static void css_release(struct percpu_ref *ref)
 	struct cgroup_subsys_state *css =
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
+	rcu_assign_pointer(css->cgroup->subsys[css->ss->subsys_id], NULL);
 	call_rcu(&css->rcu_head, css_free_rcu_fn);
 }
 
@@ -4733,14 +4744,6 @@ static void cgroup_destroy_css_killed(struct cgroup *cgrp)
 	/* delete this cgroup from parent->children */
 	list_del_rcu(&cgrp->sibling);
 
-	/*
-	 * We should remove the cgroup object from idr before its grace
-	 * period starts, so we won't be looking up a cgroup while the
-	 * cgroup is being freed.
-	 */
-	idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
-	cgrp->id = -1;
-
 	dput(d);
 
 	set_bit(CGRP_RELEASABLE, &parent->flags);
-- 
1.8.4.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
