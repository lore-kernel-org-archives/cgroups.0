From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v18 12/32] mm/memcg: optimize mem_cgroup_page_lruvec
Date: Mon, 24 Aug 2020 20:54:45 +0800
Message-ID: <1598273705-69124-13-git-send-email-alex.shi@linux.alibaba.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com
Cc: Michal Hocko <mhocko@kernel.org>

From: Hugh Dickins <hughd@google.com>

Add READ_ONCE on page->mem_cgroup, since we will check it later.
Also the page should not be PageTail(page), so add a check.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: cgroups@vger.kernel.org
---
 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 505f54087e82..65c1e873153e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1321,7 +1321,8 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgd
 		goto out;
 	}
 
-	memcg = page->mem_cgroup;
+	VM_BUG_ON_PAGE(PageTail(page), page);
+	memcg = READ_ONCE(page->mem_cgroup);
 	/* Readahead page is charged too, to see if other page uncharged */
 	VM_WARN_ON_ONCE_PAGE(!memcg, page);
 	if (!memcg)
-- 
1.8.3.1

