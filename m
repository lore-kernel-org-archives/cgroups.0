From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v2 00/29] kmem limitation for memcg
Date: Fri, 11 May 2012 15:05:21 -0300
Message-ID: <4FAD54E1.6040106@parallels.com>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1336758272-24284-1-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org

On 05/11/2012 02:44 PM, Glauber Costa wrote:
> Hello All,
>
> This is my new take for the memcg kmem accounting.
> At this point, I consider the series pretty mature - although of course,
> bugs are always there...
>
> As a disclaimer, however, I must say that the slub code is much more stressed
> by me, since I know it better. If you have no more objections to the concepts
> presented, the remaining edges can probably be polished in a rc cycle,
> at the maintainers discretion, of course.
>
> Otherwise, I'll be happy to address any concerns of yours.
>
> Since last submission:
>
>   * memcgs can be properly removed.
>   * We are not charging based on current->mm->owner instead of current
>   * kmem_large allocations for slub got some fixes, specially for the free case
>   * A cache that is registered can be properly removed (common module case)
>     even if it spans memcg children. Slab had some code for that, now it works
>     well with both
>   * A new mechanism for skipping allocations is proposed (patch posted
>     separately already). Now instead of having kmalloc_no_account, we mark
>     a region as non-accountable for memcg.
>
Forgot to mention the ida-based index allocation, instead of keeping our 
own bitmap.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
