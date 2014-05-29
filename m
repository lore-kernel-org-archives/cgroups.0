From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 03/10] mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL charges
Date: Thu, 29 May 2014 12:15:55 -0400
Message-ID: <1401380162-24121-4-git-send-email-hannes@cmpxchg.org>
References: <1401380162-24121-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=vAlV8qRAdK04PgpTmeibfXA9XhX3D/dEUtE1EhTph4k=;
	b=oiFXpaAWuEVqUrpIooZ9Y2yegwzkWjfTj7vFay5RO2yj2QXF+yQ8XtYe+SXdJew89XAk3tVZMWXnWlSf01GCUu9njdfsHyPnkRxKHHvnADF4dBzOlgJLecnsDN2sTE6SA+Z2T1nEvYEanNNNuB3CSDkc9Q9ewOpRyy6gFFvmwZk=;
In-Reply-To: <1401380162-24121-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

There is no reason why oom-disabled and __GFP_NOFAIL charges should
try to reclaim only once when every other charge tries several times
before giving up.  Make them all retry the same number of times.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 46b3e37542ad..e8d5075c081f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2567,7 +2567,7 @@ static int mem_cgroup_try_charge(struct mem_cgroup *memcg,
 				 bool oom)
 {
 	unsigned int batch = max(CHARGE_BATCH, nr_pages);
-	int nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct res_counter *fail_res;
 	unsigned long nr_reclaimed;
@@ -2639,6 +2639,9 @@ retry:
 	if (mem_cgroup_wait_acct_move(mem_over_limit))
 		goto retry;
 
+	if (nr_retries--)
+		goto retry;
+
 	if (gfp_mask & __GFP_NOFAIL)
 		goto bypass;
 
@@ -2648,9 +2651,6 @@ retry:
 	if (!oom)
 		goto nomem;
 
-	if (nr_oom_retries--)
-		goto retry;
-
 	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(batch));
 nomem:
 	if (!(gfp_mask & __GFP_NOFAIL))
-- 
1.9.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
