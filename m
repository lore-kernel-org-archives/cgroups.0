From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: restore proper dirty throttling when
 memory.high changes
Date: Fri, 31 Jul 2020 10:18:04 +0200
Message-ID: <20200731081804.GK18727@dhcp22.suse.cz>
References: <20200728135210.379885-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200728135210.379885-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue 28-07-20 09:52:09, Johannes Weiner wrote:
> Commit 8c8c383c04f6 ("mm: memcontrol: try harder to set a new
> memory.high") inadvertently removed a callback to recalculate the
> writeback cache size in light of a newly configured memory.high limit.
> 
> Without letting the writeback cache know about a potentially heavily
> reduced limit, it may permit too many dirty pages, which can cause
> unnecessary reclaim latencies or even avoidable OOM situations.
> 
> This was spotted while reading the code, it hasn't knowingly caused
> any problems in practice so far.
> 
> Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 13f559af1ab6..805a44bf948c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6071,6 +6071,7 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
>  			break;
>  	}
>  
> +	memcg_wb_domain_size_changed(memcg);
>  	return nbytes;
>  }
>  
> -- 
> 2.27.0

-- 
Michal Hocko
SUSE Labs
