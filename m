From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 5/7] memcg: divide force_empty into 2 functions, avoid
 memory reclaim at rmdir
Date: Thu, 12 Apr 2012 10:33:29 -0300
Message-ID: <4F86D9A9.9070309@parallels.com>
References: <4F86B9BE.8000105@jp.fujitsu.com> <4F86BC71.9070403@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4F86BC71.9070403@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>

On 04/12/2012 08:28 AM, KAMEZAWA Hiroyuki wrote:
> Now, at rmdir, memory cgroup's charge will be moved to
>    - parent if use_hierarchy=1
>    - root   if use_hierarchy=0
> 
> Then, we don't have to have memory reclaim code at destroying memcg.
> 
> This patch divides force_empty to 2 functions as
> 
>   - memory_cgroup_recharge() ... try to move all charges to ancestors.
>   - memory_cgroup_force_empty().. try to reclaim all memory.
> 
> After this patch, memory.force_empty will _not_ move charges to ancestors
> but just reclaim all pages. (This meets documenation.)
> 
> rmdir() will not reclaim any memory but moves charge to other cgroup,
> parent or root.
> 
> Signed-off-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>

Seems fine by me...

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
