From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/7] netprio_cgroup: reimplement priomap expansion
Date: Mon, 19 Nov 2012 23:06:27 -0800
Message-ID: <1353395190-4530-5-git-send-email-tj@kernel.org>
References: <1353395190-4530-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=nxoX7/09XcFlAJtp5JvIN7J7pyG/7u5OouawDeg8wMU=;
        b=eAlrijW8CKJ4B9zFv5cC51kybrjbk5tPZip+nyF3FxIx7WWhcKLAD7TB0JRhClhD9p
         fp67us3SC5kgMo4T8LR5VOUjYG6BnpAfDQUh6zPJVIs3Vsu4OoFj5wzFYwbkU/KwnAOg
         wwcYUmQ1C0uxzmEiw5ZguIiaRvPP92EfLfESFUODvd3Q/CLMfXcERLHm0HMT2ArjGBka
         QP+xlYoFSN1U4WEPDQ5cc3I5P6hTKNr9KI6Jq6KuZvusDKtCHCygQGHCMcMnJ5PWyG/9
         hKkvlRLULssNlG1GQ1HrtJiKDNALUB3wfZX7gzugZNaV12eqmZyPb+MKacg8RQbVqb3F
         N/5Q==
In-Reply-To: <1353395190-4530-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: daniel.wagner@bmw-carit.de, serge.hallyn@canonical.com, ebiederm@xmission.com, nhorman@tuxdriver.com, tgraf@suug.ch
Cc: davem@davemloft.net, lizefan@huawei.com, cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

netprio kept track of the highest prioidx allocated and resized
priomaps accordingly when necessary.  This makes it necessary to keep
track of prioidx allocation and may end up resizing on every new
prioidx.

Update extend_netdev_table() such that it takes @target_idx which the
priomap should be able to accomodate.  If the priomap is large enough,
nothing happens; otherwise, the size is doubled until @target_idx can
be accomodated.

This makes max_prioidx and write_update_netdev_table() unnecessary.
write_priomap() now calls extend_netdev_table() directly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 net/core/netprio_cgroup.c | 56 ++++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index 92cc54c..569d83d 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -27,11 +27,11 @@
 
 #include <linux/fdtable.h>
 
+#define PRIOMAP_MIN_SZ		128
 #define PRIOIDX_SZ 128
 
 static unsigned long prioidx_map[PRIOIDX_SZ];
 static DEFINE_SPINLOCK(prioidx_map_lock);
-static atomic_t max_prioidx = ATOMIC_INIT(0);
 
 static inline struct cgroup_netprio_state *cgrp_netprio_state(struct cgroup *cgrp)
 {
@@ -51,8 +51,6 @@ static int get_prioidx(u32 *prio)
 		return -ENOSPC;
 	}
 	set_bit(prioidx, prioidx_map);
-	if (atomic_read(&max_prioidx) < prioidx)
-		atomic_set(&max_prioidx, prioidx);
 	spin_unlock_irqrestore(&prioidx_map_lock, flags);
 	*prio = prioidx;
 	return 0;
@@ -67,15 +65,40 @@ static void put_prioidx(u32 idx)
 	spin_unlock_irqrestore(&prioidx_map_lock, flags);
 }
 
-static int extend_netdev_table(struct net_device *dev, u32 new_len)
+/*
+ * Extend @dev->priomap so that it's large enough to accomodate
+ * @target_idx.  @dev->priomap.priomap_len > @target_idx after successful
+ * return.  Must be called under rtnl lock.
+ */
+static int extend_netdev_table(struct net_device *dev, u32 target_idx)
 {
-	size_t new_size = sizeof(struct netprio_map) +
-			   ((sizeof(u32) * new_len));
-	struct netprio_map *new = kzalloc(new_size, GFP_KERNEL);
-	struct netprio_map *old;
+	struct netprio_map *old, *new;
+	size_t new_sz, new_len;
 
+	/* is the existing priomap large enough? */
 	old = rtnl_dereference(dev->priomap);
+	if (old && old->priomap_len > target_idx)
+		return 0;
+
+	/*
+	 * Determine the new size.  Let's keep it power-of-two.  We start
+	 * from PRIOMAP_MIN_SZ and double it until it's large enough to
+	 * accommodate @target_idx.
+	 */
+	new_sz = PRIOMAP_MIN_SZ;
+	while (true) {
+		new_len = (new_sz - offsetof(struct netprio_map, priomap)) /
+			sizeof(new->priomap[0]);
+		if (new_len > target_idx)
+			break;
+		new_sz *= 2;
+		/* overflowed? */
+		if (WARN_ON(new_sz < PRIOMAP_MIN_SZ))
+			return -ENOSPC;
+	}
 
+	/* allocate & copy */
+	new = kzalloc(new_sz, GFP_KERNEL);
 	if (!new) {
 		pr_warn("Unable to alloc new priomap!\n");
 		return -ENOMEM;
@@ -87,26 +110,13 @@ static int extend_netdev_table(struct net_device *dev, u32 new_len)
 
 	new->priomap_len = new_len;
 
+	/* install the new priomap */
 	rcu_assign_pointer(dev->priomap, new);
 	if (old)
 		kfree_rcu(old, rcu);
 	return 0;
 }
 
-static int write_update_netdev_table(struct net_device *dev)
-{
-	int ret = 0;
-	u32 max_len;
-	struct netprio_map *map;
-
-	max_len = atomic_read(&max_prioidx) + 1;
-	map = rtnl_dereference(dev->priomap);
-	if (!map || map->priomap_len < max_len)
-		ret = extend_netdev_table(dev, max_len);
-
-	return ret;
-}
-
 static struct cgroup_subsys_state *cgrp_css_alloc(struct cgroup *cgrp)
 {
 	struct cgroup_netprio_state *cs;
@@ -191,7 +201,7 @@ static int write_priomap(struct cgroup *cgrp, struct cftype *cft,
 
 	rtnl_lock();
 
-	ret = write_update_netdev_table(dev);
+	ret = extend_netdev_table(dev, prioidx);
 	if (ret)
 		goto out_unlock;
 
-- 
1.7.11.7
