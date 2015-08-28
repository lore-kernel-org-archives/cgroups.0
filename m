From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] memcg: always enable kmemcg on the default hierarchy
Date: Fri, 28 Aug 2015 18:02:37 -0400
Message-ID: <20150828220237.GE11089@htj.dyndns.org>
References: <20150828220158.GD11089@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=TPVl6iWcM8pFNtFLQkMXl9LfSabawwMrrU3MrKXkus8=;
        b=vE4MHW5Fzao5b2boJ8l0YimLGN9634YoqI55AkGRbiHhlOHtgTXJtBa1MREwe9yyqT
         /O0iptgZFHfE3zCr7oIa3TeET9u6nukol4hzoH1Mmj80q8sfAhL9LCiAij2RqGNnBjJZ
         7xlym9SQlKjhDjkbLRT3tjvQM89MWcxWU/pNSl9zq2vTSTFs1qWQpO2lNjimnXSz7CQJ
         zHZ6iJFyXpEM7LbrIPIuAslMqbp4232nU6rtqsuIhfF9OVz3FWSEu6B8k+We7dyhJihX
         TcFGC/6lCcrcMTRq9tz4vgzbHtrTD2rMRSfNMFC0pMhhlN1SS6bgB19yJceBtsIFL+Ts
         dc9g==
Content-Disposition: inline
In-Reply-To: <20150828220158.GD11089-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On the default hierarchy, all memory consumption will be accounted
together and controlled by the same set of limits.  Enable kmemcg on
the default hierarchy by default.  Boot parameter "disable_kmemcg" can
be specified to turn it off.

v2: - v1 triggered oops on nested cgroup creations.  Moved enabling
      mechanism to memcg_propagate_kmem().
    - Bypass busy test on kmem activation as it's unnecessary and gets
      confused by controller being enabled on a cgroup which already
      has processes.
    - "disable_kmemcg" boot param added.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 mm/memcontrol.c |   43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -346,6 +346,17 @@ EXPORT_SYMBOL(tcp_proto_cgroup);
 #endif
 
 #ifdef CONFIG_MEMCG_KMEM
+
+static bool kmemcg_disabled;
+
+static int __init disable_kmemcg(char *s)
+{
+	kmemcg_disabled = true;
+	pr_info("memcg: kernel memory support disabled on cgroup2");
+	return 0;
+}
+__setup("disable_kmemcg", disable_kmemcg);
+
 /*
  * This will be the memcg's index in each cache's ->memcg_params.memcg_caches.
  * The main reason for not using cgroup id for this:
@@ -2908,9 +2919,9 @@ static int memcg_activate_kmem(struct me
 	BUG_ON(memcg->kmem_acct_active);
 
 	/*
-	 * For simplicity, we won't allow this to be disabled.  It also can't
-	 * be changed if the cgroup has children already, or if tasks had
-	 * already joined.
+	 * On traditional hierarchies, for simplicity, we won't allow this
+	 * to be disabled.  It also can't be changed if the cgroup has
+	 * children already, or if tasks had already joined.
 	 *
 	 * If tasks join before we set the limit, a person looking at
 	 * kmem.usage_in_bytes will have no way to determine when it took
@@ -2919,13 +2930,15 @@ static int memcg_activate_kmem(struct me
 	 * After it first became limited, changes in the value of the limit are
 	 * of course permitted.
 	 */
-	mutex_lock(&memcg_create_mutex);
-	if (cgroup_has_tasks(memcg->css.cgroup) ||
-	    (memcg->use_hierarchy && memcg_has_children(memcg)))
-		err = -EBUSY;
-	mutex_unlock(&memcg_create_mutex);
-	if (err)
-		goto out;
+	if (!cgroup_on_dfl(memcg->css.cgroup)) {
+		mutex_lock(&memcg_create_mutex);
+		if (cgroup_has_tasks(memcg->css.cgroup) ||
+		    (memcg->use_hierarchy && memcg_has_children(memcg)))
+			err = -EBUSY;
+		mutex_unlock(&memcg_create_mutex);
+		if (err)
+			goto out;
+	}
 
 	memcg_id = memcg_alloc_cache_id();
 	if (memcg_id < 0) {
@@ -2978,10 +2991,14 @@ static int memcg_propagate_kmem(struct m
 
 	mutex_lock(&memcg_limit_mutex);
 	/*
-	 * If the parent cgroup is not kmem-active now, it cannot be activated
-	 * after this point, because it has at least one child already.
+	 * On the default hierarchy, automatically enable kmemcg unless
+	 * explicitly disabled by the boot param.  On traditional
+	 * hierarchies, inherit from the parent.  If the parent cgroup is
+	 * not kmem-active now, it cannot be activated after this point,
+	 * because it has at least one child already.
 	 */
-	if (memcg_kmem_is_active(parent))
+	if ((!kmemcg_disabled && cgroup_on_dfl(memcg->css.cgroup)) ||
+	    memcg_kmem_is_active(parent))
 		ret = memcg_activate_kmem(memcg, PAGE_COUNTER_MAX);
 	mutex_unlock(&memcg_limit_mutex);
 	return ret;
