From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] cgroup: revert ss_id_lock to spinlock
Date: Thu, 19 Jan 2012 12:50:10 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1201191249000.29542@eggly.anvils>
References: <alpine.LSU.2.00.1201182155480.7862@eggly.anvils> <1326958401.1113.22.camel@edumazet-laptop> <CAOS58YO585NYMLtmJv3f9vVdadFqoWF+Y5vZ6Va=2qHELuePJA@mail.gmail.com> <1326979818.2249.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <alpine.LSU.2.00.1201191235330.29542@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=F8pqGbO5J+QxydqUDPBgp/vrMZKD1dwEgaBzYskTt6U=;
        b=J0aR3jVj7tOmr6vpws2BoRyGFjQirjAxxQU7qK61RftY4B7oldc7ZLbrabQe9wVk+A
         5FyU8p/30f43ZyH6WE5l/HHjj2b6YaENumnbE/aOxevAhGHDov+TfA5ZAN2BzxiEcsCM
         8HfTj9WPjZwVGzVBx/bHxuEYijRqIlz4yYiZA=
In-Reply-To: <alpine.LSU.2.00.1201191235330.29542-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Manfred Spraul <manfred-nhLOkwUX5cPe2c5cEj3t2g@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Commit c1e2ee2dc436 "memcg: replace ss->id_lock with a rwlock" has
now been seen to cause the unfair behavior we should have expected
from converting a spinlock to an rwlock: softlockup in cgroup_mkdir(),
whose get_new_cssid() is waiting for the wlock, while there are 19
tasks using the rlock in css_get_next() to get on with their memcg
workload (in an artificial test, admittedly).  Yet lib/idr.c was
made suitable for RCU way back: revert that commit, restoring
ss->id_lock to a spinlock.

Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Acked-by: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 include/linux/cgroup.h |    2 +-
 kernel/cgroup.c        |   18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

--- 3.2.0+.orig/include/linux/cgroup.h	2012-01-14 13:01:57.000000000 -0800
+++ 3.2.0+/include/linux/cgroup.h	2012-01-19 12:14:47.420233522 -0800
@@ -535,7 +535,7 @@ struct cgroup_subsys {
 	struct list_head sibling;
 	/* used when use_id == true */
 	struct idr idr;
-	rwlock_t id_lock;
+	spinlock_t id_lock;
 
 	/* should be defined only by modular subsystems */
 	struct module *module;
--- 3.2.0+.orig/kernel/cgroup.c	2012-01-14 13:01:57.000000000 -0800
+++ 3.2.0+/kernel/cgroup.c	2012-01-19 12:16:04.132235263 -0800
@@ -4939,9 +4939,9 @@ void free_css_id(struct cgroup_subsys *s
 
 	rcu_assign_pointer(id->css, NULL);
 	rcu_assign_pointer(css->id, NULL);
-	write_lock(&ss->id_lock);
+	spin_lock(&ss->id_lock);
 	idr_remove(&ss->idr, id->id);
-	write_unlock(&ss->id_lock);
+	spin_unlock(&ss->id_lock);
 	kfree_rcu(id, rcu_head);
 }
 EXPORT_SYMBOL_GPL(free_css_id);
@@ -4967,10 +4967,10 @@ static struct css_id *get_new_cssid(stru
 		error = -ENOMEM;
 		goto err_out;
 	}
-	write_lock(&ss->id_lock);
+	spin_lock(&ss->id_lock);
 	/* Don't use 0. allocates an ID of 1-65535 */
 	error = idr_get_new_above(&ss->idr, newid, 1, &myid);
-	write_unlock(&ss->id_lock);
+	spin_unlock(&ss->id_lock);
 
 	/* Returns error when there are no free spaces for new ID.*/
 	if (error) {
@@ -4985,9 +4985,9 @@ static struct css_id *get_new_cssid(stru
 	return newid;
 remove_idr:
 	error = -ENOSPC;
-	write_lock(&ss->id_lock);
+	spin_lock(&ss->id_lock);
 	idr_remove(&ss->idr, myid);
-	write_unlock(&ss->id_lock);
+	spin_unlock(&ss->id_lock);
 err_out:
 	kfree(newid);
 	return ERR_PTR(error);
@@ -4999,7 +4999,7 @@ static int __init_or_module cgroup_init_
 {
 	struct css_id *newid;
 
-	rwlock_init(&ss->id_lock);
+	spin_lock_init(&ss->id_lock);
 	idr_init(&ss->idr);
 
 	newid = get_new_cssid(ss, 0);
@@ -5094,9 +5094,9 @@ css_get_next(struct cgroup_subsys *ss, i
 		 * scan next entry from bitmap(tree), tmpid is updated after
 		 * idr_get_next().
 		 */
-		read_lock(&ss->id_lock);
+		spin_lock(&ss->id_lock);
 		tmp = idr_get_next(&ss->idr, &tmpid);
-		read_unlock(&ss->id_lock);
+		spin_unlock(&ss->id_lock);
 
 		if (!tmp)
 			break;
