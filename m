From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v5 06/14] memcg: kmem controller infrastructure
Date: Wed, 17 Oct 2012 15:40:46 +0900
Message-ID: <507E52EE.7080706@jp.fujitsu.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-7-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1350382611-20579-7-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, devel@openvz.org, linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>

(2012/10/16 19:16), Glauber Costa wrote:
> This patch introduces infrastructure for tracking kernel memory pages to
> a given memcg. This will happen whenever the caller includes the flag
> __GFP_KMEMCG flag, and the task belong to a memcg other than the root.
> 
> In memcontrol.h those functions are wrapped in inline acessors.  The
> idea is to later on, patch those with static branches, so we don't incur
> any overhead when no mem cgroups with limited kmem are being used.
> 
> Users of this functionality shall interact with the memcg core code
> through the following functions:
> 
> memcg_kmem_newpage_charge: will return true if the group can handle the
>                             allocation. At this point, struct page is not
>                             yet allocated.
> 
> memcg_kmem_commit_charge: will either revert the charge, if struct page
>                            allocation failed, or embed memcg information
>                            into page_cgroup.
> 
> memcg_kmem_uncharge_page: called at free time, will revert the charge.
> 
> [ v2: improved comments and standardized function names ]
> [ v3: handle no longer opaque, functions not exported,
>    even more comments ]
> [ v4: reworked Used bit handling and surroundings for more clarity ]
> [ v5: simplified code for kmemcg compiled out and core functions in
>    memcontrol.c, moved kmem code to the middle to avoid forward decls ]
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> CC: Christoph Lameter <cl@linux.com>
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Tejun Heo <tj@kernel.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
