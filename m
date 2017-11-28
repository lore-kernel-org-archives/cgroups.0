From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH] mm, memcg: fix mem_cgroup_swapout() for THPs
Date: Tue, 28 Nov 2017 08:19:41 -0800
Message-ID: <20171128161941.20931-1-shakeelb@google.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UTyNnyG2s0ShJbSv+ecwyudSbkHGC4gsvMDM7j4Q3GY=;
        b=YGIAH9FaZu6mMJpleL65vgCCXhHXq4/PohTiSZdFvdefRfzP36lHgiE2mL+/TMbngl
         jusOcRfo22MyS0c17Dtb/eNj6wNSrR7H6DUdfWOdnxG947UDdV94uaNCvGvoh7T7u1ZU
         9JdWsXbH4LOTTp9OWB0+PFiH48LuDTd7pamqRGNLKvDNftyK1luQzGGYp9DpoLilDsL7
         PN8AQ9GeOoNFe9HvcnZSj2iiB69FDjAeOUtGKNf9MjDaUVwqfuFt7Q0ZH3xwUpEAitzF
         ZdDT4JlknA272ZasBjvfwM7YPdJ5MGpy+V5EAcuRLRSpYdK3+em0Lg/+nM8NsEj/ybR5
         EBQg==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Huang Ying <ying.huang@intel.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@kernel.org>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Shakeel Butt <shakeelb@google.com>, stable@vger.kernel.org

The commit d6810d730022 ("memcg, THP, swap: make mem_cgroup_swapout()
support THP") changed mem_cgroup_swapout() to support transparent huge
page (THP). However the patch missed one location which should be
changed for correctly handling THPs. The resulting bug will cause the
memory cgroups whose THPs were swapped out to become zombies on
deletion.

Fixes: d6810d730022 ("memcg, THP, swap: make mem_cgroup_swapout() support THP")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: stable@vger.kernel.org
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 50e6906314f8..ac2ffd5e02b9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6044,7 +6044,7 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 	memcg_check_events(memcg, page);
 
 	if (!mem_cgroup_is_root(memcg))
-		css_put(&memcg->css);
+		css_put_many(&memcg->css, nr_entries);
 }
 
 /**
-- 
2.15.0.417.g466bffb3ac-goog

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
