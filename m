From: Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC][PATCH 1/3] memcg: add methods to access pc->mem_cgroup
Date: Mon, 19 Mar 2012 14:58:00 +0400
Message-ID: <4F671138.3000508@parallels.com>
References: <4F66E6A5.10804@jp.fujitsu.com> <4F66E773.4000807@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4F66E773.4000807@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>, Han Ying <yinghan@google.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, suleiman@google.com, n-horiguchi@ah.jp.nec.com, khlebnikov@openvz.org, Tejun Heo <tj@kernel.org>

On 03/19/2012 11:59 AM, KAMEZAWA Hiroyuki wrote:
> In order to encode pc->mem_cgroup and pc->flags to be in a word,
> access function to pc->mem_cgroup is required.
> 
> This patch replaces access to pc->mem_cgroup with
>   pc_to_mem_cgroup(pc)          : pc->mem_cgroup
>   pc_set_mem_cgroup(pc, memcg)  : pc->mem_cgroup = memcg
> 
> Following patch will remove pc->mem_cgroup.
> 
> Signed-off-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
Kame,

I can't see a reason not to merge this patch right now, regardless of
the other ones.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
