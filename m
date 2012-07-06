From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm/memcg: add BUG() to mem_cgroup_reset
Date: Fri, 6 Jul 2012 13:19:16 +0800
Message-ID: <20120706051916.GB29829@shangw>
References: <1341546297-6223-1-git-send-email-liwp.linux@gmail.com>
Reply-To: Gavin Shan <shangw@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1341546297-6223-1-git-send-email-liwp.linux@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 11:44:57AM +0800, Wanpeng Li wrote:
>From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>
>Branch in mem_cgroup_reset only can be RES_MAX_USAGE, RES_FAILCNT.
>
>Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
>---
> mm/memcontrol.c |    2 ++
> 1 files changed, 2 insertions(+), 0 deletions(-)
>
>diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>index a501660..5e4d1ab 100644
>--- a/mm/memcontrol.c
>+++ b/mm/memcontrol.c
>@@ -3976,6 +3976,8 @@ static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
> 		else
> 			res_counter_reset_failcnt(&memcg->memsw);
> 		break;
>+	default:
>+		BUG();

It might be not convinced to have "BUG()" here. You might add
something for debugging purpose. For example,
	default:
		printk(KERN_WARNING "%s: Unrecognized name %d\n",
			__func__, name);

Thanks,
Gavin
 
> 	}
>
> 	return 0;
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
