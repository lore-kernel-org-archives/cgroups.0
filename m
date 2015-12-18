From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v2 7/7] Documentation: cgroup: add
 memory.swap.{current,max} description
Date: Fri, 18 Dec 2015 11:51:23 +0900
Message-ID: <567374AB.3010101@jp.fujitsu.com>
References: <cover.1450352791.git.vdavydov@virtuozzo.com>
 <dbb4bf6bc071997982855c8f7d403c22cea60ffb.1450352792.git.vdavydov@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <dbb4bf6bc071997982855c8f7d403c22cea60ffb.1450352792.git.vdavydov@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vladimir Davydov <vdavydov@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 2015/12/17 21:30, Vladimir Davydov wrote:
> The rationale of separate swap counter is given by Johannes Weiner.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
> ---
> Changes in v2:
>   - Add rationale of separate swap counter provided by Johannes.
> 
>   Documentation/cgroup.txt | 33 +++++++++++++++++++++++++++++++++
>   1 file changed, 33 insertions(+)
> 
> diff --git a/Documentation/cgroup.txt b/Documentation/cgroup.txt
> index 31d1f7bf12a1..f441564023e1 100644
> --- a/Documentation/cgroup.txt
> +++ b/Documentation/cgroup.txt
> @@ -819,6 +819,22 @@ PAGE_SIZE multiple when read back.
>   		the cgroup.  This may not exactly match the number of
>   		processes killed but should generally be close.
>   
> +  memory.swap.current
> +
> +	A read-only single value file which exists on non-root
> +	cgroups.
> +
> +	The total amount of swap currently being used by the cgroup
> +	and its descendants.
> +
> +  memory.swap.max
> +
> +	A read-write single value file which exists on non-root
> +	cgroups.  The default is "max".
> +
> +	Swap usage hard limit.  If a cgroup's swap usage reaches this
> +	limit, anonymous meomry of the cgroup will not be swapped out.
> +
>   
>   5-2-2. General Usage
>   
> @@ -1291,3 +1307,20 @@ allocation from the slack available in other groups or the rest of the
>   system than killing the group.  Otherwise, memory.max is there to
>   limit this type of spillover and ultimately contain buggy or even
>   malicious applications.
> +
> +The combined memory+swap accounting and limiting is replaced by real
> +control over swap space.
> +
> +The main argument for a combined memory+swap facility in the original
> +cgroup design was that global or parental pressure would always be
> +able to swap all anonymous memory of a child group, regardless of the
> +child's own (possibly untrusted) configuration.  However, untrusted
> +groups can sabotage swapping by other means - such as referencing its
> +anonymous memory in a tight loop - and an admin can not assume full
> +swappability when overcommitting untrusted jobs.
> +
> +For trusted jobs, on the other hand, a combined counter is not an
> +intuitive userspace interface, and it flies in the face of the idea
> +that cgroup controllers should account and limit specific physical
> +resources.  Swap space is a resource like all others in the system,
> +and that's why unified hierarchy allows distributing it separately.
> 
Could you give here a hint how to calculate amount of swapcache,
counted both in memory.current and swap.current ?

Thanks,
-Kame




