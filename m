From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v5 04/16] memcg: enable accounting for VLAN group array
Date: Mon, 19 Jul 2021 13:44:44 +0300
Message-ID: <71acccea-fc9a-13bc-3744-ae5638bd9cc7@virtuozzo.com>
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=w+0FNs53pgnmzx96zi7TBJAdHiw/aP1PrzGmhZUmSkE=; b=IO1vcqg4VE8nP6Skqrj
        94WKAjOjSObrDnICD6nbIGI921wjlD0hPgSg20oEXGcgnMqhdIIl27qyTUILZ1YzbCB0Fqs5TEtww
        yDgqt0/G8hFOspvB8rxqfB1CeKRNUSxdee7eEKlrRqEqalNeGtTOZIwDbfxZA3mW7/S7NvPaC/Y=;
In-Reply-To: <cover.1626688654.git.vvs@virtuozzo.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

vlan array consume up to 8 pages of memory per net device.

It makes sense to account for them to restrict the host's memory
consumption from inside the memcg-limited container.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/8021q/vlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 4cdf841..55275ef 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -67,7 +67,7 @@ static int vlan_group_prealloc_vid(struct vlan_group *vg,
 		return 0;
 
 	size = sizeof(struct net_device *) * VLAN_GROUP_ARRAY_PART_LEN;
-	array = kzalloc(size, GFP_KERNEL);
+	array = kzalloc(size, GFP_KERNEL_ACCOUNT);
 	if (array == NULL)
 		return -ENOBUFS;
 
-- 
1.8.3.1

