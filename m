From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH v2 0/3] memcg : renaming and cleanup enum/macro
Date: Tue, 05 Jun 2012 10:27:58 +0900
Message-ID: <4FCD609E.8070704@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm@kvack.org
Cc: cgroups@vger.kernel.org, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org

This series 
   rename MEM_CGROUP_STAT_SWAPOUT as MEM_CGROUP_STAT_SWAP
   rename MEM_CGROUP_CHARGE_TYPE_MAPPED as MEM_CGROUP_CHARGE_TYPE_ANON
   remove MEM_CGROUP_CHARGE_TYPE_FORCE

 mm/memcontrol.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

based on feedback from community.

Thanks,
-Kame

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
