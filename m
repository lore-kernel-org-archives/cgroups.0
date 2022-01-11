From: Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH 2/4] mm/memcg: mem_cgroup_per_node is already set to 0 on allocation
Date: Tue, 11 Jan 2022 01:03:00 +0000
Message-ID: <20220111010302.8864-2-richard.weiyang@gmail.com>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cOmBhmo4B4Ukm6s0FflMe2nP4T2kTWokfAC8k0+Tp8A=;
        b=YdgiRcT5b4ToQFSxyF5G4EFVb1dSoHDJMo4BUDntHy0fbYJAVvGNz2aLcQ9HPdOnrG
         Z1sygXtxjEKW5l21yHQYo6TMcsMuKs8+IwB4Bm5KBUiS2pCZK5M/by1eZa65loOVD11n
         /fQN9xKi5oCnon17uwfJ83+pqOmbLnfQ4gAuhkLEOrTz96IMpxOLoC6hD0ZugnSWdQ5f
         oMkmm+o+nQUJ9UZYxNmro9tT+l6fj5/Gssaid2pvz+RMJj7hjueA9Gk7AjS+CDpqSncg
         kiDq+AS7sukqRCjwLFbsn03pN318DzDzfQiZcvXxyZEpfYs8luKYAB85EAZG+JX0dren
         X+XA==
In-Reply-To: <20220111010302.8864-1-richard.weiyang@gmail.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, guro@fb.com, vbabka@suse.cz, willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com, surenb@google.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Wei Yang <richard.weiyang@gmail.com>

kzalloc_node() would set data to 0, so it's not necessary to set it
again.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
---
 mm/memcontrol.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 11715f7323c0..a504616f904a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5067,8 +5067,6 @@ static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 	}
 
 	lruvec_init(&pn->lruvec);
-	pn->usage_in_excess = 0;
-	pn->on_tree = false;
 	pn->memcg = memcg;
 
 	memcg->nodeinfo[node] = pn;
-- 
2.33.1

