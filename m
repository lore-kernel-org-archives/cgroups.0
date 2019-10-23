From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/2] mm: memcontrol: remove dead code from
 memory_max_write()
Date: Wed, 23 Oct 2019 08:50:57 +0200
Message-ID: <20191023065057.GC754@dhcp22.suse.cz>
References: <20191022201518.341216-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191022201518.341216-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue 22-10-19 16:15:17, Johannes Weiner wrote:
> When the reclaim loop in memory_max_write() is ^C'd or similar, we set
> err to -EINTR. But we don't return err. Once the limit is set, we
> always return success (nbytes). Delete the dead code.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/memcontrol.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 055975b0b3a3..ff90d4e7df37 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6122,10 +6122,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
>  		if (nr_pages <= max)
>  			break;
>  
> -		if (signal_pending(current)) {
> -			err = -EINTR;
> +		if (signal_pending(current))
>  			break;
> -		}
>  
>  		if (!drained) {
>  			drain_all_stock(memcg);
> -- 
> 2.23.0
> 

-- 
Michal Hocko
SUSE Labs
