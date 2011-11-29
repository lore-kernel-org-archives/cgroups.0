From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 7/7] mm: memcg: remove unneeded checks from uncharge_page()
Date: Tue, 29 Nov 2011 11:52:05 +0100
Message-ID: <1322563925-1667-8-git-send-email-hannes@cmpxchg.org>
References: <1322563925-1667-1-git-send-email-hannes@cmpxchg.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1322563925-1667-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

From: Johannes Weiner <jweiner@redhat.com>

mem_cgroup_uncharge_page() is only called on either freshly allocated
pages without page->mapping or on rmapped PageAnon() pages.  There is
no need to check for a page->mapping that is not an anon_vma.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f5aa1b8..468a5a4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2992,8 +2992,7 @@ void mem_cgroup_uncharge_page(struct page *page)
 	/* early check. */
 	if (page_mapped(page))
 		return;
-	if (page->mapping && !PageAnon(page))
-		return;
+	VM_BUG_ON(page->mapping && !PageAnon(page));
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_MAPPED);
 }
 
-- 
1.7.6.4
