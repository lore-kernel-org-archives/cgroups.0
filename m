From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH mmotm/next] cgroup: remove stray references to css_id
Date: Sun, 12 Jan 2014 20:23:27 -0800 (PST)
Message-ID: <alpine.LSU.2.11.1401122018400.1701@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=Tvm4jyqbaEyPzQYy0LHeglsv+JydixW/fFdU+M84Xd8=;
        b=E+pVjrgpLznB3goWii5u3mAFdvqQAzmMbLcDNrwl+i6gmf+4BV9DASU2RfFPhLK1aQ
         hKLDQJq5MIXWbjKFjlbGeBQsr7JTps6RhlsVK3PKXqrrai27yiqNMwSF47b5MINiInmL
         qu7b4l1cSTGTaOR6LwEcMsNLPJi83akfoKvGZEeXqv4Fx4UY6CV3xN/NVhiSOGR/jl86
         qlD9yXPabzCsKa4MZ6g2awUwnUozVedSI4nswbGXCYeTLT1lms9AXLpIc+QgaD4mwaPq
         Kyku60BOV7ORH2fA9swIr/5zMERQFTVAzK82ko3gZirFsY0woz8VuMA6HaETZWBy9bqB
         LaFg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Trivial: remove the few stray references to css_id, which itself
was removed in v3.13's 2ff2a7d03bbe "cgroup: kill css_id".

Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
But I don't know your plans with respect to the XXX in
kernel/cgroup.c, so perhaps you'd prefer to amend this.

 drivers/md/bcache/request.c |    1 -
 include/linux/cgroup.h      |    3 ---
 mm/page_cgroup.c            |    2 +-
 3 files changed, 1 insertion(+), 5 deletions(-)

--- mmotm/drivers/md/bcache/request.c	2014-01-10 18:24:58.212448858 -0800
+++ linux/drivers/md/bcache/request.c	2014-01-12 20:00:07.641685957 -0800
@@ -163,7 +163,6 @@ static struct cgroup_subsys_state *bcach
 static void bcachecg_destroy(struct cgroup *cgroup)
 {
 	struct bch_cgroup *cg = cgroup_to_bcache(cgroup);
-	free_css_id(&bcache_subsys, &cg->css);
 	kfree(cg);
 }
 
--- mmotm/include/linux/cgroup.h	2014-01-10 18:25:01.820448944 -0800
+++ linux/include/linux/cgroup.h	2014-01-12 20:00:07.645685957 -0800
@@ -29,7 +29,6 @@ struct cgroupfs_root;
 struct cgroup_subsys;
 struct inode;
 struct cgroup;
-struct css_id;
 
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
@@ -79,8 +78,6 @@ struct cgroup_subsys_state {
 	struct cgroup_subsys_state *parent;
 
 	unsigned long flags;
-	/* ID for this css, if possible */
-	struct css_id __rcu *id;
 
 	/* percpu_ref killing and RCU release */
 	struct rcu_head rcu_head;
--- mmotm/mm/page_cgroup.c	2014-01-10 18:25:02.256448954 -0800
+++ linux/mm/page_cgroup.c	2014-01-12 20:00:07.645685957 -0800
@@ -452,7 +452,7 @@ unsigned short swap_cgroup_record(swp_en
  * lookup_swap_cgroup_id - lookup mem_cgroup id tied to swap entry
  * @ent: swap entry to be looked up.
  *
- * Returns CSS ID of mem_cgroup at success. 0 at failure. (0 is invalid ID)
+ * Returns ID of mem_cgroup at success. 0 at failure. (0 is invalid ID)
  */
 unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
 {
