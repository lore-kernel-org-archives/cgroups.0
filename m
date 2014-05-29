From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch 05/10] mm: memcontrol: catch root bypass in move precharge
Date: Thu, 29 May 2014 12:15:57 -0400
Message-ID: <1401380162-24121-6-git-send-email-hannes@cmpxchg.org>
References: <1401380162-24121-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=dJO18E6wA2QQPGsQVXtJBbT0vuVIw1jjYFu30pOKxJ0=;
	b=MEnZCpdOz1MN+iOeG9sGrzhY/BWTfb0NavwvMppYtN3U0Y7j+l0Za/4CbaxnXz+z8OtVYVM77EdORCFsJk65vYWoYFKZXML6AEKJdAvEKFMYoBpOnAuOL77IvHELZpoz7wA5hj2d2F2OGuujlY9IvCI5bm96PPW8v4qBKzPzM8o=;
In-Reply-To: <1401380162-24121-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When mem_cgroup_try_charge() returns -EINTR, it bypassed the charge to
the root memcg.  But move precharging does not catch this and treats
this case as if no charge had happened, thus leaking a charge against
root.  Because of an old optimization, the root memcg's res_counter is
not actually charged right now, but it's still an imbalance and
subsequent patches will charge the root memcg again.

Catch those bypasses to the root memcg and properly cancel them before
giving up the move.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8957d6c945b8..184e67cce4e4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6485,8 +6485,15 @@ one_by_one:
 			cond_resched();
 		}
 		ret = mem_cgroup_try_charge(memcg, GFP_KERNEL, 1, false);
+		/*
+		 * In case of failure, any residual charges against
+		 * mc.to will be dropped by mem_cgroup_clear_mc()
+		 * later on.  However, cancel any charges that are
+		 * bypassed to root right away or they'll be lost.
+		 */
+		if (ret == -EINTR)
+			__mem_cgroup_cancel_charge(root_mem_cgroup, 1);
 		if (ret)
-			/* mem_cgroup_clear_mc() will do uncharge later */
 			return ret;
 		mc.precharge++;
 	}
-- 
1.9.3
