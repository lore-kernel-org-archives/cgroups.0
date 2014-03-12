From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 4/8] mm: memcg: push !mm handling out to page cache charge function
Date: Tue, 11 Mar 2014 21:28:30 -0400
Message-ID: <1394587714-6966-5-git-send-email-hannes@cmpxchg.org>
References: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=lg6TwGnAl8UcQFpBty7j0IAE1vLOCPraOXOmMaDOktQ=;
	b=kdaNJPG7I9Ihp59YB0jBi+ztZjvBMmLisKugzKSK2Z+Aj/4GJ9pl/CV2iz6HB+yCisUrzh4k9L3bFy5wDC2QzQ65JOc18pNLnn2D0OYSE+FEZRCTEQl2BJFQqMy/XkQON+H1Hn1L6wo9fTrnJLFmRRMqME6EPlovkfE/BDtHvvA=;
In-Reply-To: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Only page cache charges can happen without an mm context, so push this
special case out of the inner core and into the cache charge function.

An ancient comment explains that the mm can also be NULL in case the
task is currently being migrated, but that is not actually true with
the current case, so just remove it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cfdb9c385d8d..c40186cf22ad 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2737,15 +2737,6 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 
 	if (gfp_mask & __GFP_NOFAIL)
 		oom = false;
-
-	/*
-	 * We always charge the cgroup the mm_struct belongs to.
-	 * The mm_struct's mem_cgroup changes on task migration if the
-	 * thread group leader migrates. It's possible that mm is not
-	 * set, if so charge the root memcg (happens for pagecache usage).
-	 */
-	if (!*ptr && !mm)
-		*ptr = root_mem_cgroup;
 again:
 	if (*ptr) { /* css should be a valid one */
 		memcg = *ptr;
@@ -4070,6 +4061,12 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 		return 0;
 
 	if (!PageSwapCache(page)) {
+		/*
+		 * Page cache insertions can happen without an actual
+		 * task context, e.g. during disk probing on boot.
+		 */
+		if (!mm)
+			memcg = root_mem_cgroup;
 		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, &memcg, true);
 		if (ret != -ENOMEM)
 			__mem_cgroup_commit_charge(memcg, page, 1, type, false);
-- 
1.9.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
