From: Zhang Tianci <zhangtianci.1997-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH] mm: fix hanging shrinker management on long do_shrink_slab
Date: Tue, 18 Oct 2022 11:48:11 +0800
Message-ID: <20221018034811.38775-1-zhangtianci.1997@bytedance.com>
References: <20191129214541.3110-1-ptikhomirov@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F2m1ZUWJ2ANyM6P3f3smBak8ITqttyt+0nIHjF78GeI=;
        b=itBJYtz/JNlV+y5MTCCUiglLPGw+XuFCSVoyCfMRMxrf1EXQNW5ewPJMdeO5Xi64HG
         E/vP20Zhh6Uuf6C53wSHoTday0/EwCFaOQf5pSn4cfY8Rp8POnkr0dx6CWf7WMvZbNom
         S2Mh42xzlijCBWBizacSPtpDTnB+sMk/ndFlACj4XXNfwebb2PkoOYKwRSmsD3Ra7KWG
         MLdJq8etYS2rBsuKOG7klCV7qusIRN+czVDEBHpX+/7sGeY3fYpLSu+2ywPuTynayI7N
         /XyhBfnM5sGEqkHU4neRgYplpQKltjmEt4sylw6kxP/gT+VweHqSeYR1cOxRDTcQ9Wo3
         5LXw==
In-Reply-To: <20191129214541.3110-1-ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, khorenko-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org, anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, zhangjiachen.jaycee-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

Hi all,

I can still reproduce this problem on the latest linux version. The nfs long time
requests will cause the other mount/unmount hang.

I checked the thread and found Tikhomirov Pavel did not cc NFS people. So I reply
this email to cc them.

Is it a problem of NFS that holding shrinker_rwsem so long time? And is there some
thought to fix it?

On 11/30/19 12:45 AM, Pavel Tikhomirov wrote:
>We have a problem that shrinker_rwsem can be held for a long time for
>read in shrink_slab, at the same time any process which is trying to
>manage shrinkers hangs.
>
>The shrinker_rwsem is taken in shrink_slab while traversing shrinker_list.
>It tries to shrink something on nfs (hard) but nfs server is dead at
>these moment already and rpc will never succeed. Generally any shrinker
>can take significant time to do_shrink_slab, so it's a bad idea to hold
>the list lock here.
>
>We have a similar problem in shrink_slab_memcg, except that we are
>traversing shrinker_map+shrinker_idr there.
>
>The idea of the patch is to inc a refcount to the chosen shrinker so it
>won't disappear and release shrinker_rwsem while we are in
>do_shrink_slab, after that we will reacquire shrinker_rwsem, dec
>the refcount and continue the traversal.
>
>We also need a wait_queue so that unregister_shrinker can wait for the
>refcnt to become zero. Only after these we can safely remove the
>shrinker from list and idr, and free the shrinker.
>
>I've reproduced the nfs hang in do_shrink_slab with the patch applied on
>ms kernel, all other mount/unmount pass fine without any hang.
>
>Here is a reproduction on kernel without patch:
>
>1) Setup nfs on server node with some files in it (e.g. 200)
>
>[server]# cat /etc/exports
>/vz/nfs2 *(ro,no_root_squash,no_subtree_check,async)
>
>2) Hard mount it on client node
>
>[client]# mount -ohard 10.94.3.40:/vz/nfs2 /mnt
>
>3) Open some (e.g. 200) files on the mount
>
>[client]# for i in $(find /mnt/ -type f | head -n 200); \
>  do setsid sleep 1000 &>/dev/null <$i & done
>
>4) Kill all openers
>
>[client]# killall sleep -9
>
>5) Put your network cable out on client node
>
>6) Drop caches on the client, it will hang on nfs while holding
>  shrinker_rwsem lock for read
>
>[client]# echo 3 > /proc/sys/vm/drop_caches
>
>  crash> bt ...
>  PID: 18739  TASK: ...  CPU: 3   COMMAND: "bash"
>   #0 [...] __schedule at ...
>   #1 [...] schedule at ...
>   #2 [...] rpc_wait_bit_killable at ... [sunrpc]
>   #3 [...] __wait_on_bit at ...
>   #4 [...] out_of_line_wait_on_bit at ...
>   #5 [...] _nfs4_proc_delegreturn at ... [nfsv4]
>   #6 [...] nfs4_proc_delegreturn at ... [nfsv4]
>   #7 [...] nfs_do_return_delegation at ... [nfsv4]
>   #8 [...] nfs4_evict_inode at ... [nfsv4]
>   #9 [...] evict at ...
>  #10 [...] dispose_list at ...
>  #11 [...] prune_icache_sb at ...
>  #12 [...] super_cache_scan at ...
>  #13 [...] do_shrink_slab at ...
>  #14 [...] shrink_slab at ...
>  #15 [...] drop_slab_node at ...
>  #16 [...] drop_slab at ...
>  #17 [...] drop_caches_sysctl_handler at ...
>  #18 [...] proc_sys_call_handler at ...
>  #19 [...] vfs_write at ...
>  #20 [...] ksys_write at ...
>  #21 [...] do_syscall_64 at ...
>  #22 [...] entry_SYSCALL_64_after_hwframe at ...
>
>7) All other mount/umount activity now hangs with no luck to take
>  shrinker_rwsem for write.
>
>[client]# mount -t tmpfs tmpfs /tmp
>
>  crash> bt ...
>  PID: 5464   TASK: ...  CPU: 3   COMMAND: "mount"
>   #0 [...] __schedule at ...
>   #1 [...] schedule at ...
>   #2 [...] rwsem_down_write_slowpath at ...
>   #3 [...] prealloc_shrinker at ...
>   #4 [...] alloc_super at ...
>   #5 [...] sget at ...
>   #6 [...] mount_nodev at ...
>   #7 [...] legacy_get_tree at ...
>   #8 [...] vfs_get_tree at ...
>   #9 [...] do_mount at ...
>  #10 [...] ksys_mount at ...
>  #11 [...] __x64_sys_mount at ...
>  #12 [...] do_syscall_64 at ...
>  #13 [...] entry_SYSCALL_64_after_hwframe at ...
>
>That is on almost clean and almost mainstream Fedora kernel:
>
>[client]# uname -a
>Linux snorch 5.3.8-200.snorch.fc30.x86_64 #1 SMP Mon Nov 11 16:01:15 MSK
>  2019 x86_64 x86_64 x86_64 GNU/Linux
>
>Signed-off-by: Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
>---
> include/linux/memcontrol.h |   6 +++
> include/linux/shrinker.h   |   6 +++
> mm/memcontrol.c            |  16 ++++++
> mm/vmscan.c                | 107 ++++++++++++++++++++++++++++++++++++-
> 4 files changed, 134 insertions(+), 1 deletion(-)
>
>diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>index ae703ea3ef48..3717b94b6aa5 100644
>--- a/include/linux/memcontrol.h
>+++ b/include/linux/memcontrol.h
>@@ -1348,6 +1348,8 @@ extern int memcg_expand_shrinker_maps(int new_id);
>
> extern void memcg_set_shrinker_bit(struct mem_cgroup *memcg,
> 				   int nid, int shrinker_id);
>+extern void memcg_clear_shrinker_bit(struct mem_cgroup *memcg,
>+				     int nid, int shrinker_id);
> #else
> #define mem_cgroup_sockets_enabled 0
> static inline void mem_cgroup_sk_alloc(struct sock *sk) { };
>@@ -1361,6 +1363,10 @@ static inline void memcg_set_shrinker_bit(struct mem_cgroup *memcg,
> 					  int nid, int shrinker_id)
> {
> }
>+static inline void memcg_clear_shrinker_bit(struct mem_cgroup *memcg,
>+					    int nid, int shrinker_id)
>+{
>+}
> #endif
>
> struct kmem_cache *memcg_kmem_get_cache(struct kmem_cache *cachep);
>diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
>index 0f80123650e2..dd3bb43ed58d 100644
>--- a/include/linux/shrinker.h
>+++ b/include/linux/shrinker.h
>@@ -2,6 +2,9 @@
> #ifndef _LINUX_SHRINKER_H
> #define _LINUX_SHRINKER_H
>
>+#include <linux/refcount.h>
>+#include <linux/wait.h>
>+
> /*
>  * This struct is used to pass information from page reclaim to the shrinkers.
>  * We consolidate the values for easier extention later.
>@@ -75,6 +78,9 @@ struct shrinker {
> #endif
> 	/* objs pending delete, per node */
> 	atomic_long_t *nr_deferred;
>+
>+	refcount_t refcnt;
>+	wait_queue_head_t wq;
> };
> #define DEFAULT_SEEKS 2 /* A good number if you don't know better. */
>
>diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>index 01f3f8b665e9..81f45124feb7 100644
>--- a/mm/memcontrol.c
>+++ b/mm/memcontrol.c
>@@ -442,6 +442,22 @@ void memcg_set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
> 	}
> }
>
>+void memcg_clear_shrinker_bit(struct mem_cgroup *memcg,
>+			      int nid, int shrinker_id)
>+{
>+	struct memcg_shrinker_map *map;
>+
>+	/*
>+	 * The map for refcounted memcg can only be freed in
>+	 * memcg_free_shrinker_map_rcu so we can safely protect
>+	 * map with rcu_read_lock.
>+	 */
>+	rcu_read_lock();
>+	map = rcu_dereference(memcg->nodeinfo[nid]->shrinker_map);
>+	clear_bit(shrinker_id, map->map);
>+	rcu_read_unlock();
>+}
>+
> /**
>  * mem_cgroup_css_from_page - css of the memcg associated with a page
>  * @page: page of interest
>diff --git a/mm/vmscan.c b/mm/vmscan.c
>index ee4eecc7e1c2..59e46d65e902 100644
>--- a/mm/vmscan.c
>+++ b/mm/vmscan.c
>@@ -393,6 +393,13 @@ int prealloc_shrinker(struct shrinker *shrinker)
> 	if (!shrinker->nr_deferred)
> 		return -ENOMEM;
>
>+	/*
>+	 * Shrinker is not yet visible through shrinker_idr or shrinker_list,
>+	 * so no locks required for initialization.
>+	 */
>+	refcount_set(&shrinker->refcnt, 1);
>+	init_waitqueue_head(&shrinker->wq);
>+
> 	if (shrinker->flags & SHRINKER_MEMCG_AWARE) {
> 		if (prealloc_memcg_shrinker(shrinker))
> 			goto free_deferred;
>@@ -411,6 +418,9 @@ void free_prealloced_shrinker(struct shrinker *shrinker)
> 	if (!shrinker->nr_deferred)
> 		return;
>
>+	/* The shrinker shouldn't be used at these point. */
>+	WARN_ON(!refcount_dec_and_test(&shrinker->refcnt));
>+
> 	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
> 		unregister_memcg_shrinker(shrinker);
>
>@@ -447,6 +457,15 @@ void unregister_shrinker(struct shrinker *shrinker)
> {
> 	if (!shrinker->nr_deferred)
> 		return;
>+
>+	/*
>+	 * If refcnt is not zero we need to wait these shrinker to finish all
>+	 * it's do_shrink_slab() calls.
>+	 */
>+	if (!refcount_dec_and_test(&shrinker->refcnt))
>+		wait_event(shrinker->wq,
>+			   (refcount_read(&shrinker->refcnt) == 0));
>+
> 	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
> 		unregister_memcg_shrinker(shrinker);
> 	down_write(&shrinker_rwsem);
>@@ -454,6 +473,9 @@ void unregister_shrinker(struct shrinker *shrinker)
> 	up_write(&shrinker_rwsem);
> 	kfree(shrinker->nr_deferred);
> 	shrinker->nr_deferred = NULL;
>+
>+	/* Pairs with rcu_read_lock in put_shrinker() */
>+	synchronize_rcu();
> }
> EXPORT_SYMBOL(unregister_shrinker);
>
>@@ -589,6 +611,42 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
> 	return freed;
> }
>
>+struct shrinker *get_shrinker(struct shrinker *shrinker)
>+{
>+	/*
>+	 * Pairs with refcnt dec in unregister_shrinker(), if refcnt is zero
>+	 * these shrinker is already in the middle of unregister_shrinker() and
>+	 * we can't use it.
>+	 */
>+	if (!refcount_inc_not_zero(&shrinker->refcnt))
>+		shrinker = NULL;
>+	return shrinker;
>+}
>+
>+void put_shrinker(struct shrinker *shrinker)
>+{
>+	/*
>+	 * The rcu_read_lock pairs with synchronize_rcu() in
>+	 * unregister_shrinker(), so that the shrinker is not freed
>+	 * before the wake_up.
>+	 */
>+	rcu_read_lock();
>+	if (!refcount_dec_and_test(&shrinker->refcnt)) {
>+		/*
>+		 * Pairs with smp_mb in
>+		 * wait_event()->prepare_to_wait()
>+		 */
>+		smp_mb();
>+		/*
>+		 * If refcnt becomes zero, we already have an
>+		 * unregister_shrinker() waiting for us to finish.
>+		 */
>+		if (waitqueue_active(&shrinker->wq))
>+			wake_up(&shrinker->wq);
>+	}
>+	rcu_read_unlock();
>+}
>+
> #ifdef CONFIG_MEMCG
> static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
> 			struct mem_cgroup *memcg, int priority)
>@@ -628,9 +686,23 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
> 		    !(shrinker->flags & SHRINKER_NONSLAB))
> 			continue;
>
>+		/*
>+		 * Take a refcnt on a shrinker so that it can't be freed or
>+		 * removed from shrinker_idr (and shrinker_list). These way we
>+		 * can safely release shrinker_rwsem.
>+		 *
>+		 * We need to release shrinker_rwsem here as do_shrink_slab can
>+		 * take too much time to finish (e.g. on nfs). And holding
>+		 * global shrinker_rwsem can block registring and unregistring
>+		 * of shrinkers.
>+		 */
>+		if (!get_shrinker(shrinker))
>+			continue;
>+		up_read(&shrinker_rwsem);
>+
> 		ret = do_shrink_slab(&sc, shrinker, priority);
> 		if (ret == SHRINK_EMPTY) {
>-			clear_bit(i, map->map);
>+			memcg_clear_shrinker_bit(memcg, nid, i);
> 			/*
> 			 * After the shrinker reported that it had no objects to
> 			 * free, but before we cleared the corresponding bit in
>@@ -655,6 +727,22 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
> 		}
> 		freed += ret;
>
>+		/*
>+		 * Re-aquire shrinker_rwsem, put refcount and reload
>+		 * shrinker_map as it can be modified in
>+		 * memcg_expand_one_shrinker_map if new shrinkers
>+		 * were registred in the meanwhile.
>+		 */
>+		if (!down_read_trylock(&shrinker_rwsem)) {
>+			freed = freed ? : 1;
>+			put_shrinker(shrinker);
>+			return freed;
>+		}
>+		put_shrinker(shrinker);
>+		map = rcu_dereference_protected(
>+				memcg->nodeinfo[nid]->shrinker_map,
>+				true);
>+
> 		if (rwsem_is_contended(&shrinker_rwsem)) {
> 			freed = freed ? : 1;
> 			break;
>@@ -719,10 +807,27 @@ static unsigned long shrink_slab(gfp_t gfp_mask, int nid,
> 			.memcg = memcg,
> 		};
>
>+		/* See comment in shrink_slab_memcg. */
>+		if (!get_shrinker(shrinker))
>+			continue;
>+		up_read(&shrinker_rwsem);
>+
> 		ret = do_shrink_slab(&sc, shrinker, priority);
> 		if (ret == SHRINK_EMPTY)
> 			ret = 0;
> 		freed += ret;
>+
>+		/*
>+		 * We can safely continue traverse of the shrinker_list as
>+		 * our shrinker is still on the list due to refcount.
>+		 */
>+		if (!down_read_trylock(&shrinker_rwsem)) {
>+			freed = freed ? : 1;
>+			put_shrinker(shrinker);
>+			goto out;
>+		}
>+		put_shrinker(shrinker);
>+
> 		/*
> 		 * Bail out if someone want to register a new shrinker to
> 		 * prevent the regsitration from being stalled for long periods
>--
>2.21.0
