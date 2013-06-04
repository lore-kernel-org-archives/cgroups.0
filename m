From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/3] memcg: fix subtle memory barrier bug in mem_cgroup_iter()
Date: Mon,  3 Jun 2013 17:44:37 -0700
Message-ID: <1370306679-13129-2-git-send-email-tj@kernel.org>
References: <1370306679-13129-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=IsYqIhtOYnRhIhjdcX0UtMMJuXP6felF+106on/R+CM=;
        b=uZWREc61GuuAKligECpDx7jPOO0hKIq2Bef7JpUJU4YIxrgdTs4dEXldLBlPDMaR2h
         AVsguAR9YfwJ9tGOpK7xJMkvhEJvWlOywL0wYS9dUSD2kqH31owjLuY+KUIcbcrWY31e
         1VmMvBUK8WeA3PdMR7ucISmTrHT2Cp4xhOS/rfh6rli9CdH6BC2AgCPIU5vsOBZmru7S
         swsPcX1UADzZO1YXpF89R+jvBDHyXIInlT+3vdYY9aQ0UJ6CtRLXWec+mTzMBl1yJZf1
         LdueKbI0p+RXMLJ4BnxHQ8UbxU5E2VFSdmnqfji1YcEgXC69yKN2C1Oi8oWpigPbLs2E
         AfyA==
In-Reply-To: <1370306679-13129-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

mem_cgroup_iter() plays a rather delicate game to allow sharing
reclaim iteration across multiple reclaimers.  It uses
reclaim_iter->last_visited and ->dead_count to remember the last
visited cgroup and verify whether the cgroup is still safe to access.

For the mechanism to work properly, updates to ->last_visited must be
visible before ->dead_count; otherwise, a stale ->last_visited may be
considered to be associated with more recent ->dead_count and thus
escape the dead condition detection which may lead to use-after-free.

The function has smp_rmb() where the dead condition is checked and
smp_wmb() where the two variables are updated but the smp_rmb() isn't
between dereferences of the two variables making the whole thing
pointless.  It's right after atomic_read(&root->dead_count) whose only
requirement is to belong to the same RCU critical section.

This patch moves the smp_rmb() between ->last_visited and
->last_dead_count dereferences and adds comment explaining how the
barriers are paired and for what.

Let's please not add memory barriers without explicitly explaining the
pairing and what they are achieving.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 mm/memcontrol.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cb1c9de..cb2f91c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1218,9 +1218,18 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 			 * is alive.
 			 */
 			dead_count = atomic_read(&root->dead_count);
-			smp_rmb();
+
 			last_visited = iter->last_visited;
 			if (last_visited) {
+				/*
+				 * Paired with smp_wmb() below in this
+				 * function.  The pair guarantee that
+				 * last_visited is more current than
+				 * last_dead_count, which may lead to
+				 * spurious iteration resets but guarantees
+				 * reliable detection of dead condition.
+				 */
+				smp_rmb();
 				if ((dead_count != iter->last_dead_count) ||
 					!css_tryget(&last_visited->css)) {
 					last_visited = NULL;
@@ -1235,6 +1244,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 				css_put(&last_visited->css);
 
 			iter->last_visited = memcg;
+			/* paired with smp_rmb() above in this function */
 			smp_wmb();
 			iter->last_dead_count = dead_count;
 
-- 
1.8.2.1
