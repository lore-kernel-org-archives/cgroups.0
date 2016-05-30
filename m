From: Wenwei Tao <wwtao0320@163.com>
Subject: [PATCH] mm/memcontrol.c: add memory allocation result check
Date: Mon, 30 May 2016 16:45:51 +0800
Message-ID: <1464597951-2976-1-git-send-email-wwtao0320@163.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id; bh=j7jhCQ61I2t2Seg6xN
	ISqyEgJTo1ftHKSjnuORZR5CY=; b=aov3wCbNwHCiK5wqNUzCvyfWBYzYp+GYFy
	fTw+HY9OTIJEyEuXW0fv9AtNc/csNf6rIKTgJIb5cGoarRcDQrjK4obfL5xcGm1p
	pXFkM2RZeTZ3d5jnubbRxNYjImOvUQfJWnov9+YkcUGLUWHmxggOADk0jhJWvEoH
	muqPKh8GQ=
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov@virtuozzo.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, ww.tao0320@gmail.com

From: Wenwei Tao <ww.tao0320@gmail.com>

The mem_cgroup_tree_per_node allocation might fail,
check that before continue the memcg init. Since it
is in the init phase, trigger the panic if that failure
happens.

Signed-off-by: Wenwei Tao <ww.tao0320@gmail.com>
---
 mm/memcontrol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 925b431..6385c62 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5712,6 +5712,7 @@ static int __init mem_cgroup_init(void)
 
 		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
 				    node_online(node) ? node : NUMA_NO_NODE);
+		BUG_ON(!rtpn);
 
 		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 			struct mem_cgroup_tree_per_zone *rtpz;
-- 
1.8.3.1


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
