From: Sha Zhengju <handai.szj@gmail.com>
Subject: [PATCH 1/6] memcg: use global stat directly for root memcg usage
Date: Tue, 12 Mar 2013 18:08:40 +0800
Message-ID: <1363082920-3711-1-git-send-email-handai.szj@taobao.com>
References: <1363082773-3598-1-git-send-email-handai.szj@taobao.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=GKnapj0bvXDJv8px9dJ1sxzEnVJrf99O98T9yyWaaKs=;
        b=KopBco1H/ukUzfj0tOdqSID64ruG3dLPtJfVsaPsWX3cp8JnPxLHIwReoBzxORGhyq
         w2iJjPqJt6uYuGNA0RLKis1KKBfHX5v/LDsP836Cy0oLqi4lFmCHykibCuk7EdNB5hI8
         AzJTO97CwL8UUOGHaIu39M2K9MWhXZ1LKkUM8hmFEqT9a/2scpLfo08dUdR9Wmm13XH9
         oUdbAiPx8Ersgj1xeEVxImUkxx60KA1Dn8ud9wMurO5gc2avtpDsnJ1vHdDRTC7SFJto
         n+xFCKWIXtjIWbV7I3ynGwCEjJ5zhHnB7zk/8/oNMrOqwIsDKG9ktmESt6qAMc9QiZE+
         WGrA==
In-Reply-To: <1363082773-3598-1-git-send-email-handai.szj@taobao.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-mm@kvack.org
Cc: mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, glommer@parallels.com, akpm@linux-foundation.org, mgorman@suse.de, Sha Zhengju <handai.szj@taobao.com>

Since mem_cgroup_recursive_stat(root_mem_cgroup, INDEX) will sum up
all memcg stats without regard to root's use_hierarchy, we may use
global stats instead for simplicity.

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
---
 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 669d16a..735cd41 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4987,11 +4987,11 @@ static inline u64 mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 			return res_counter_read_u64(&memcg->memsw, RES_USAGE);
 	}
 
-	val = mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_CACHE);
-	val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_RSS);
+	val = global_page_state(NR_FILE_PAGES);
+	val += global_page_state(NR_ANON_PAGES);
 
 	if (swap)
-		val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_SWAP);
+		val += total_swap_pages - atomic_long_read(&nr_swap_pages);
 
 	return val << PAGE_SHIFT;
 }
-- 
1.7.9.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
