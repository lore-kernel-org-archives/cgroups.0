From: Roman Gushchin <guro@fb.com>
Subject: [PATCH 1/2] mm, memcg: reset memory.low during memcg offlining
Date: Thu, 27 Jul 2017 14:04:27 +0100
Message-ID: <20170727130428.28856-1-guro@fb.com>
References: <20170726083017.3yzeucmi7lcj46qd@esperanza>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=GZrdh9NA7cYNBsxPnA59GnPXWGuOyLWyHZU6QtC6K0s=;
 b=QiFwp/0lczUhQ1eysafO4n5ABmO0N3WZtHdx5kRoQm3YpFXIrHhsS3+xWqVOGXNynzcT
 7hhTS/qyalR1rjJ0M0haNmLHBb44TUf4opd5RP7U5QfiQZVlJDmUI/HW+hzpd2bn+HNl
 HBKi8ITuREOJP72WOMuvi2LCf8ewwbXtQTM= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=GZrdh9NA7cYNBsxPnA59GnPXWGuOyLWyHZU6QtC6K0s=;
 b=h25gebyDJCIFPr0NMc7p4P6NR1uOaOJHJxl3CvP+LrKvE2mD8Xp/a1kC+yxye9csSgRy+9skQao4zOW25vLFCB6CJVhGybOqBF3dzRs0FphsyBNHda2QWKL0M7db8lOM8b1y+pVekMOGSSwcXtm1CPgrYQC1FfJ2DODUMegm0Go=
In-Reply-To: <20170726083017.3yzeucmi7lcj46qd@esperanza>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Roman Gushchin <guro@fb.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-mm@kvack.org

A removed memory cgroup with a defined memory.low and some belonging
pagecache has very low chances to be freed.

If a cgroup has been removed, there is likely no memory pressure inside
the cgroup, and the pagecache is protected from the external pressure
by the defined low limit. The cgroup will be freed only after
the reclaim of all belonging pages. And it will not happen until
there are any reclaimable memory in the system. That means,
there is a good chance, that a cold pagecache will reside
in the memory for an undefined amount of time, wasting
system resources.

This problem was fixed earlier by commit fa06235b8eb0
("cgroup: reset css on destruction"), but it's not a best way
to do it, as we can't really reset all limits/counters during
cgroup offlining.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/memcontrol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d61133e6af99..7b24210596ea 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4300,6 +4300,8 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	}
 	spin_unlock(&memcg->event_list_lock);
 
+	memcg->low = 0;
+
 	memcg_offline_kmem(memcg);
 	wb_memcg_offline(memcg);
 
-- 
2.13.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
