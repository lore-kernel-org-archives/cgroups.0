From: Roman Gushchin <guro@fb.com>
Subject: [PATCH] mm, memcg: reset low limit during memcg offlining
Date: Tue, 25 Jul 2017 12:40:47 +0100
Message-ID: <20170725114047.4073-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=oFVNGX+6MZFqcakdJ1+ZlD5PMslt3MhkTMrXtkv/DCM=;
 b=byTJjg7Bin8ikRUzjWF1VSIEJr41OsUF049W/WFpTuY5q23bypQr1UyElPwm/EmGH/y/
 V1ESrlYNbzpxbb5s1end9xJCWx4VAwi8w1GxbVWrT3NcHijKqDsKtJqderfaEk5yxzPD
 0o9wIK/QO6HwN/sGVv6Ruuth4laAoJrJomM= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=oFVNGX+6MZFqcakdJ1+ZlD5PMslt3MhkTMrXtkv/DCM=;
 b=gsUGVlRlhDPME3LjioLIqsBUIi0S92ylGOFewgaFSjZibvWpTtiAV6ObEH4JWc8mGUATzuvfgD/rLjQVtnoEjAnM0uTX4DPEw7EzPOQh54Qw2CEYcxMh2AqErNYlPAKEqQr0QSO1EZaut70GytStHLNdZlLu3RFBQf0znr2av5M=
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

A removed memory cgroup with a defined low limit and some belonging
pagecache has very low chances to be freed.

If a cgroup has been removed, there is likely no memory pressure inside
the cgroup, and the pagecache is protected from the external pressure
by the defined low limit. The cgroup will be freed only after
the reclaim of all belonging pages. And it will not happen until
there are any reclaimable memory in the system. That means,
there is a good chance, that a cold pagecache will reside
in the memory for an undefined amount of time, wasting
system resources.

Fix this issue by zeroing memcg->low during memcg offlining.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/memcontrol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aed11b2d0251..2aa204b8f9fd 100644
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
