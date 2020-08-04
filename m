From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 1/2][next] mm: memcontrol: Use flex_array_size() helper
 in memcpy()
Date: Tue, 4 Aug 2020 15:25:26 +0200
Message-ID: <20200804132526.GC7306@dhcp22.suse.cz>
References: <cover.1596214831.git.gustavoars@kernel.org>
 <ddd60dae2d9aea1ccdd2be66634815c93696125e.1596214831.git.gustavoars@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ddd60dae2d9aea1ccdd2be66634815c93696125e.1596214831.git.gustavoars@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org

On Fri 31-07-20 12:12:53, Gustavo A. R. Silva wrote:
> Make use of the flex_array_size() helper to calculate the size of a
> flexible array member within an enclosing structure.
> 
> This helper offers defense-in-depth against potential integer
> overflows, while at the same time makes it explicitly clear that
> we are dealing with a flexible array member.
> 
> Also, remove unnecessary braces.

I was not aware of this helper. The code looks slightly better.
 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Acked-by: Michal Hocko <mhocko@suse.com>
> ---
>  mm/memcontrol.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e84c2b5596f2..bd7f972ceea4 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4246,10 +4246,9 @@ static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
>  	new->size = size;
>  
>  	/* Copy thresholds (if any) to new array */
> -	if (thresholds->primary) {
> -		memcpy(new->entries, thresholds->primary->entries, (size - 1) *
> -				sizeof(struct mem_cgroup_threshold));
> -	}
> +	if (thresholds->primary)
> +		memcpy(new->entries, thresholds->primary->entries,
> +		       flex_array_size(new, entries, size - 1));
>  
>  	/* Add new threshold */
>  	new->entries[size - 1].eventfd = eventfd;
> -- 
> 2.27.0

-- 
Michal Hocko
SUSE Labs
