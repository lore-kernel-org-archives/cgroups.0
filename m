From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [patch] mm, memcg: do not retry precharge charges
Date: Wed, 11 Jan 2017 20:32:12 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1701112031250.94269@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version;
        bh=ASn2BXrU7x/X78QEUQGxl+u3R4r3PEzc1mJ/FotKHyM=;
        b=DpJgC2yoWo5dihZZ4qt94HVQ6oliOpQdG+6cCnP9OkL/z+APgYIR49ECYRnTLMfRm5
         OISwO2M86kg+PWyhtzQyNVopdqTIBtoTjxMO1bDSXFo1Au2UqDn5FgekgONuJ9+Wuttu
         CGpWWWUGmfigXkgxLa7RKhL6qxEJmecYtHKJTX3raxMffmcF49uvGqbTqqwMIkj2zWbb
         5D0L/U53mVhDiylhxdPLS+C8gkhKDukwIIA3a22vyRcaATTwDIhBnBw+sNHMGstrGtM1
         12hKHknVXsaunLybUMFoGgxSc37f1TPUVhK7iYd5otc8Iv/MsPhBjHsmozSlutnzngPU
         tr0A==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

When memory.move_charge_at_immigrate is enabled and precharges are
depleted during move, mem_cgroup_move_charge_pte_range() will attempt to
increase the size of the precharge.

This livelocks if reclaim fails and if an oom killed process attached to
the destination memcg is trying to exit, which requires 
cgroup_threadgroup_rwsem, since we're holding the mutex (we also livelock
while holding mm->mmap_sem for read).

Prevent precharges from ever looping by setting __GFP_NORETRY.  This was
probably the intention of the GFP_KERNEL & ~__GFP_NORETRY, which is
pointless as written.

This also restructures mem_cgroup_wait_acct_move() since it is not
possible for mc.moving_task to be current.

Fixes: 0029e19ebf84 ("mm: memcontrol: remove explicit OOM parameter in charge path")
Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1125,18 +1125,19 @@ static bool mem_cgroup_under_move(struct mem_cgroup *memcg)
 
 static bool mem_cgroup_wait_acct_move(struct mem_cgroup *memcg)
 {
-	if (mc.moving_task && current != mc.moving_task) {
-		if (mem_cgroup_under_move(memcg)) {
-			DEFINE_WAIT(wait);
-			prepare_to_wait(&mc.waitq, &wait, TASK_INTERRUPTIBLE);
-			/* moving charge context might have finished. */
-			if (mc.moving_task)
-				schedule();
-			finish_wait(&mc.waitq, &wait);
-			return true;
-		}
+	DEFINE_WAIT(wait);
+
+	if (likely(!mem_cgroup_under_move(memcg)))
+		return false;
+
+	prepare_to_wait(&mc.waitq, &wait, TASK_INTERRUPTIBLE);
+	/* moving charge context might have finished. */
+	if (mc.moving_task) {
+		WARN_ON_ONCE(mc.moving_task == current);
+		schedule();
 	}
-	return false;
+	finish_wait(&mc.waitq, &wait);
+	return true;
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
@@ -4355,9 +4356,14 @@ static int mem_cgroup_do_precharge(unsigned long count)
 		return ret;
 	}
 
-	/* Try charges one by one with reclaim */
+	/*
+	 * Try charges one by one with reclaim, but do not retry.  This avoids
+	 * looping forever when try_charge() cannot reclaim memory and the oom
+	 * killer defers while waiting for a process to exit which is trying to
+	 * acquire cgroup_threadgroup_rwsem in the exit path.
+	 */
 	while (count--) {
-		ret = try_charge(mc.to, GFP_KERNEL & ~__GFP_NORETRY, 1);
+		ret = try_charge(mc.to, GFP_KERNEL | __GFP_NORETRY, 1);
 		if (ret)
 			return ret;
 		mc.precharge++;
