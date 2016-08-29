From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2] mm: memcontrol: avoid unused function warning
Date: Mon, 29 Aug 2016 09:51:42 -0400
Message-ID: <20160829135142.GA2172@cmpxchg.org>
References: <20160824113733.2776701-1-arnd@arndb.de>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bi6yHFnAhgsVg1oljmnFwI+2bg6dfVd1lqSEcwq7I6s=; b=BibA5o4ipH32S+E7N/STXMSq5H
	PtqrFjoKpRqbs1GFcA9wz0zQjx/d/HQVo2CN4d/QpB/KgZEweyZ1m4mIYxAyULJeuDxQztZHNH9ks
	xnXvF9d8VXxwOSLUHAI/oSBMZ3k++oUtXxFodEEv0cyu3Rq/9qgWpg/2qZFJxQ4Ilkyg=;
Content-Disposition: inline
In-Reply-To: <20160824113733.2776701-1-arnd@arndb.de>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Mel Gorman <mgorman@techsingularity.net>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Wed, Aug 24, 2016 at 12:23:00PM +0200, Arnd Bergmann wrote:
> A bugfix in v4.8-rc2 introduced a harmless warning when CONFIG_MEMCG_SWAP
> is disabled but CONFIG_MEMCG is enabled:
> 
> mm/memcontrol.c:4085:27: error: 'mem_cgroup_id_get_online' defined but not used [-Werror=unused-function]
>  static struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg)
> 
> This moves the function inside of the #ifdef block that hides the
> calling function, to avoid the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 1f47b61fb407 ("mm: memcontrol: fix swap counter leak on swapout from offline cgroup")
> Acked-by: Michal Hocko <mhocko@suse.com>
> Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
