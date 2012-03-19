From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [RFC][PATCH 0/3] page cgroup diet
Date: Mon, 19 Mar 2012 16:56:21 +0900
Message-ID: <4F66E6A5.10804@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm@kvack.org
Cc: cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>, Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, suleiman@google.com, n-horiguchi@ah.jp.nec.com, khlebnikov@openvz.org, Tejun Heo <tj@kernel.org>

This is just an RFC...test is not enough yet.

I know it's merge window..this post is just for sharing idea.

This patch merges pc->flags and pc->mem_cgroup into a word. Then,
memcg's overhead will be 8bytes per page(4096bytes?).

Because this patch will affect all memory cgroup developers, I'd like to
show patches before MM Summit. I think we can agree the direction to
reduce size of page_cgroup..and finally integrate into 'struct page'
(and remove cgroup_disable= boot option...)

Patch 1/3 - introduce pc_to_mem_cgroup and hide pc->mem_cgroup
Patch 2/3 - remove pc->mem_cgroup
Patch 3/3 - remove memory barriers.

I'm now wondering when this change should be merged....


Thanks,
-Kame

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
