From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/6] memcg: cleanup memory cgroup
Date: Sat, 23 Jun 2012 14:14:08 +0800
Message-ID: <1340432054-5053-1-git-send-email-liwp.linux@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=kF9Lsghfh8p3L832g+gGGX3tA70EgDBbXA6ez5qZvaY=;
        b=gaZjcqjqYwK3PtyqSjXQwImAJ9q1ORvJ9ZU6GreM0paz1fKBtMv+L1BdMtTvXwDxVW
         BR5rcRf38OFkcOqT2EKU6CZgEckwOkw4BGXhYCSFAl+cwE9XwqqUsXDx5g1dluyqhla0
         MeuSEl63O1kzAM/bYAqr0otqhvgw4wtIccDBK8M2tfNHZ0touwjGcWMaQPj790352xve
         R13huLEapHB20kaU0BnoYB7BvRuLPjbP06IIBvl95Z4YK7dkSkTFeXqf3z6Q+LCLX6St
         WU/i2Kc2gag0MqIQBkYWz42j2Jwm50I6cwq0SWiS7625QkoKhlmx0m0M6P3O6tpu0lhm
         xFNg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gavin Shan <shangw-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>


Wanpeng Li (6):

memcg: replace unsigned long by u64 to avoid overflow
memcg: cleanup useless LRU_ALL_EVICTABLE
memcg: change mem_control_xxx to mem_cgroup_xxx
memcg: move recent_rotated and recent_scanned informations
memcg: optimize memcg_get_hierarchical_limit
memcg: cleanup all typo in memory cgroup

Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/mmzone.h |    2 +-
 mm/memcontrol.c        |   90 +++++++++++++++++++++++-------------------------
 2 files changed, 45 insertions(+), 47 deletions(-)
-- 
1.7.9.5
