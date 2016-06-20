From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] memcg: mem_cgroup_migrate() may be called with irq
 disabled
Date: Mon, 20 Jun 2016 15:50:01 -0400
Message-ID: <20160620195001.GA19775@cmpxchg.org>
References: <5767CFE5.7080904@de.ibm.com>
 <20160620184158.GO3262@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160620184158.GO3262@mtj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, Linux MM <linux-mm@kvack.org>, cgroups@vger.kernel.org, "linux-kernel@vger.kernel.org >> Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, Christian Borntraeger <borntraeger@de.ibm.com>, kernel-team@fb.com

On Mon, Jun 20, 2016 at 02:41:58PM -0400, Tejun Heo wrote:
> mem_cgroup_migrate() uses local_irq_disable/enable() but can be called
> with irq disabled from migrate_page_copy().  This ends up enabling irq
> while holding a irq context lock triggering the following lockdep
> warning.  Fix it by using irq_save/restore instead.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Fixes: 74485cf2bc85 ("mm: migrate: consolidate mem_cgroup_migrate() calls")
CC: stable@vger.kernel.org # 4.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
