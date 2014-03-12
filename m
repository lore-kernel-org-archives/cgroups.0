From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 5/8] memcg: remove unnecessary !mm check from try_get_mem_cgroup_from_mm()
Date: Tue, 11 Mar 2014 21:28:31 -0400
Message-ID: <1394587714-6966-6-git-send-email-hannes@cmpxchg.org>
References: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=fBkK2xwbcLRwb9T0BaDRc1uBjgaTdQrKFK3yE+P0z1I=;
	b=vBYVgBqSHFsBYQCIf6EMGwnvAfJsluG947OnVL17YiajJ9nzvpCpEmsKGMbjG6EL/eYC9hCHIIhSx/1f50uQRW2IrubK5O1/4YCSwyWi1ScfRVxV4e/tZtannE8rlpIkLcWl9/stE4Z4Ov9e7bztcO4EcjgmcT0VIMTgrz34ikU=;
In-Reply-To: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Users pass either a mm that has been established under task lock, or
use a verified current->mm, which means the task can't be exiting.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c40186cf22ad..1780e66ec61e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1075,13 +1075,6 @@ struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
 {
 	struct mem_cgroup *memcg = NULL;
 
-	if (!mm)
-		return NULL;
-	/*
-	 * Because we have no locks, mm->owner's may be being moved to other
-	 * cgroup. We use css_tryget() here even if this looks
-	 * pessimistic (rather than adding locks here).
-	 */
 	rcu_read_lock();
 	do {
 		memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
-- 
1.9.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
