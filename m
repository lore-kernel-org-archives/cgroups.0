From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] cgroup: memcg: net: do not associate sock with unrelated cgroup
Date: Fri, 14 Feb 2020 14:24:15 -0800
Message-ID: <20200214222415.181467-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=gqPN6rca6tQbB2wbaK3mUEwUJIuY7eBrM+y+4z2O/UE=;
        b=IBiQ45SugGiYgT2pAGmSYKd2rySIEgvA5tF8RFPtcJAYQzPcRnZZQr24PUCzcN/nOy
         fuH+tT2GGPHZ/JMiRmG1u9zClkRghNwblFj7VdyFHxNkqGOW7qmcfVMZSDe0HIS0nK0R
         fk0Ye33LfaW/FfzbJvH+2/9aeoq0Ew1e2MkVST/thn104F3pBTElosxodPQEzWRLm1SW
         T0qx/k/kdqkGZ/0scvEn7yc1YnSSuFmlsfYPk6xlcBLpGJVFHI7EPaMWi01x19xcxP9c
         8Wesjy05hYcLRq6fCWOiqpxwsjtTmDR5fDLTKl2BYzX6v59fF2uCPKJFma+ZaAmJmMj8
         7HZw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

We are testing network memory accounting in our setup and noticed
inconsistent network memory usage and often unrelated cgroups network
usage correlates with testing workload. On further inspection, it
seems like mem_cgroup_sk_alloc() and cgroup_sk_alloc() are broken in
irq context specially for cgroup v1.

mem_cgroup_sk_alloc() and cgroup_sk_alloc() can be called in irq context
and kind of assumes that this can only happen from sk_clone_lock()
and the source sock object has already associated cgroup. However in
cgroup v1, where network memory accounting is opt-in, the source sock
can be unassociated with any cgroup and the new cloned sock can get
associated with unrelated interrupted cgroup.

Cgroup v2 can also suffer if the source sock object was created by
process in the root cgroup or if sk_alloc() is called in irq context.
The fix is to just do nothing in interrupt.

Fixes: 2d7580738345 ("mm: memcontrol: consolidate cgroup socket tracking")
Fixes: d979a39d7242 ("cgroup: duplicate cgroup reference when cloning sockets")
Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---

Changes since v1:
- Fix cgroup_sk_alloc() too.

 kernel/cgroup/cgroup.c | 4 ++++
 mm/memcontrol.c        | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 9a8a5ded3c48..46e5f5518fba 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6449,6 +6449,10 @@ void cgroup_sk_alloc(struct sock_cgroup_data *skcd)
 		return;
 	}
 
+	/* Do not associate the sock with unrelated interrupted task's memcg. */
+	if (in_interrupt())
+		return;
+
 	rcu_read_lock();
 
 	while (true) {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 63bb6a2aab81..f500da82bfe8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6697,6 +6697,10 @@ void mem_cgroup_sk_alloc(struct sock *sk)
 		return;
 	}
 
+	/* Do not associate the sock with unrelated interrupted task's memcg. */
+	if (in_interrupt())
+		return;
+
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(current);
 	if (memcg == root_mem_cgroup)
-- 
2.25.0.265.gbab2e86ba0-goog

