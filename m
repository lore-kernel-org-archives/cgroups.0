From: Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org>
Subject: [PATCH] mm/memcontrol: remove the unnecessary rcu_read_[un]lock
Date: Wed, 16 Dec 2020 13:52:13 +0800
Message-ID: <20201216055213.GA63520@rlk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=BBKRI
        TNFFT+q7yGvwOTx4/tWHfQzcYeyta5d1Cb3V68=; b=fB/bHrF7W+wEz0U0iVXbW
        ATCoPSFOK67Iehdh5ukdjw4pGkuhbuE8YfAlOWVvLKt+5hznZ0U6IHJGPO1vabp0
        WbnGtiCpykUl6cS9IIOgcP7ZD6Qo9+8RUjfi9347z63Wx8y5d/vcgT0OeTN6CIWH
        xKzmE/1w/+8oGAFZC+kNDM=
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sh_def-9Onoh4P/yGk@public.gmane.org

the rcu_read_lock and rcu_read_unlock is unnecessary in:
	lock_page_lruvec()
	lock_page_lruvec_irq()
	lock_page_lruvec_irqsave()

Signed-off-by: Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org>
---
 mm/memcontrol.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e3c7ca7dc174..a19f820e8a3f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1396,10 +1396,8 @@ struct lruvec *lock_page_lruvec(struct page *page)
 	struct lruvec *lruvec;
 	struct pglist_data *pgdat = page_pgdat(page);
 
-	rcu_read_lock();
 	lruvec = mem_cgroup_page_lruvec(page, pgdat);
 	spin_lock(&lruvec->lru_lock);
-	rcu_read_unlock();
 
 	lruvec_memcg_debug(lruvec, page);
 
@@ -1411,10 +1409,8 @@ struct lruvec *lock_page_lruvec_irq(struct page *page)
 	struct lruvec *lruvec;
 	struct pglist_data *pgdat = page_pgdat(page);
 
-	rcu_read_lock();
 	lruvec = mem_cgroup_page_lruvec(page, pgdat);
 	spin_lock_irq(&lruvec->lru_lock);
-	rcu_read_unlock();
 
 	lruvec_memcg_debug(lruvec, page);
 
@@ -1426,10 +1422,8 @@ struct lruvec *lock_page_lruvec_irqsave(struct page *page, unsigned long *flags)
 	struct lruvec *lruvec;
 	struct pglist_data *pgdat = page_pgdat(page);
 
-	rcu_read_lock();
 	lruvec = mem_cgroup_page_lruvec(page, pgdat);
 	spin_lock_irqsave(&lruvec->lru_lock, *flags);
-	rcu_read_unlock();
 
 	lruvec_memcg_debug(lruvec, page);
 
-- 
2.29.2

