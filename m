From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH v1 0/7] memcg remove pre_destroy
Date: Thu, 12 Apr 2012 20:17:18 +0900
Message-ID: <4F86B9BE.8000105@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In recent discussion, Tejun Heo, cgroup maintainer, has a plan to remove
->pre_destroy(). And now, in cgroup tree, pre_destroy() failure cause WARNING.

By pre_destroy(), rmdir of cgroup can return -EBUSY or some error.
It makes cgroup complicated and unstable. I said O.K. to remove it and
this patch is modification for memcg.

One of problem in current implementation is that memcg moves all charges to
parent in pre_destroy(). At doing so, if use_hierarchy=0, pre_destroy() may
hit parent's limit and may return -EBUSY. To fix this problem, this patch
changes behavior of rmdir() as

 - if use_hierarchy=0, all remaining charges will go to root cgroup.
 - if use_hierarchy=1, all remaining charges will go to the parent.

By this, rmdir failure will not be caused by parent's limitation. And
I think this meets meaning of use_hierarchy.

This series does
  - add above change of behavior
  - use workqueue to move all pages to parent
  - remove unnecessary codes.

I'm sorry if my reply is delayed, I'm not sure I can have enough time in
this weekend. Any comments are welcomed.

Thanks,
-Kame


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
