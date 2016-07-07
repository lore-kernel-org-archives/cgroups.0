From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH rebase] mm: fix vm-scalability regression in cgroup-aware
 workingset code
Date: Thu, 7 Jul 2016 15:40:24 -0400
Message-ID: <20160707194024.GA26580@cmpxchg.org>
References: <20160622182019.24064-1-hannes@cmpxchg.org>
 <20160624175101.GA3024@cmpxchg.org>
 <20160627130527.GK31799@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TKcLtVvt0tREayz8swQ8y6s6XntqXCmLVn7EWJlq5bs=; b=0LPI2Affs2QGm4DFnvmdN/w8Xv
	vPjqvV+9OOuzYZHzVBe2/1VQBzxtX0fea9PxqEF56jpz4H/UHgKN/y44rsdD3oS4UQlDeZSZUwmbS
	iBk1DbeX3xf86tfu4h6PLIu5lSSl3clysghuXQ7zpH/hG92zjWmkC7ceRcLJW7bKKn0Y=;
Content-Disposition: inline
In-Reply-To: <20160627130527.GK31799@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Xiaolong <xiaolong.ye@intel.com>, Vladimir Davydov <vdavydov@virtuozzo.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hi Michal,

[sorry for the delay, I was traveling with no connectivity]

On Mon, Jun 27, 2016 at 03:05:28PM +0200, Michal Hocko wrote:
> On Fri 24-06-16 13:51:01, Johannes Weiner wrote:
>
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

> Minor note below
> 
> > +static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
> > +{
> 
> I guess rcu_read_lock_held() here would be appropriate
> 
> > +	return READ_ONCE(page->mem_cgroup);

Agreed.

Andrew, could you please fold this?

From ed49e364e47c933d84533a0d8bd355831b5ca9f1 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Thu, 7 Jul 2016 15:38:26 -0400
Subject: [PATCH] mm: fix vm-scalability regression in cgroup-aware workingset
 code fix

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/mm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index b21e5f30378e..97065e1f0237 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -975,6 +975,7 @@ static inline struct mem_cgroup *page_memcg(struct page *page)
 }
 static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
 {
+	WARN_ON_ONCE(!rcu_read_lock_held());
 	return READ_ONCE(page->mem_cgroup);
 }
 #else
@@ -984,6 +985,7 @@ static inline struct mem_cgroup *page_memcg(struct page *page)
 }
 static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
 {
+	WARN_ON_ONCE(!rcu_read_lock_held());
 	return NULL;
 }
 #endif
-- 
2.9.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
