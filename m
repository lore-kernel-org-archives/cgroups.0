From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm/memcg: swappiness should between 0 and 100
Date: Fri, 6 Jul 2012 13:00:13 +0800
Message-ID: <20120706050013.GA15372@shangw>
References: <1341550312-6815-1-git-send-email-liwp.linux@gmail.com>
Reply-To: Gavin Shan <shangw@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1341550312-6815-1-git-send-email-liwp.linux@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 12:51:52PM +0800, Wanpeng Li wrote:
>From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>
>Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
>---
> mm/memcontrol.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>index 5e4d1ab..69a7d45 100644
>--- a/mm/memcontrol.c
>+++ b/mm/memcontrol.c
>@@ -4176,7 +4176,7 @@ static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,

It seems that we don't have the function in mainline.

shangw@shangw:~/sandbox/linux/mm$ grep mem_cgroup_swappiness_write -r .
shangw@shangw:~/sandbox/linux/mm$ 

Thanks,
Gavin

> 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
> 	struct mem_cgroup *parent;
>
>-	if (val > 100)
>+	if (val > 100 || val < 0)
> 		return -EINVAL;
>
> 	if (cgrp->parent == NULL)
>-- 
>1.7.5.4
>
>--
>To unsubscribe, send a message with 'unsubscribe linux-mm' in
>the body to majordomo@kvack.org.  For more info on Linux MM,
>see: http://www.linux-mm.org/ .
>Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
