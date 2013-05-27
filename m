From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH][trivial] memcg: Kconfig info update
Date: Mon, 27 May 2013 17:46:38 +0200
Message-ID: <20130527154638.GK27274@dhcp22.suse.cz>
References: <1369668984-2787-1-git-send-email-dserrg@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1369668984-2787-1-git-send-email-dserrg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sergey Dyasly <dserrg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

CCing Andrew

On Mon 27-05-13 19:36:24, Sergey Dyasly wrote:
> Now there are only 2 members in struct page_cgroup.
> Update config MEMCG description accordingly.
> 
> Signed-off-by: Sergey Dyasly <dserrg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  init/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 9d3a788..16d1502 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -876,7 +876,7 @@ config MEMCG
>  
>  	  Note that setting this option increases fixed memory overhead
>  	  associated with each page of memory in the system. By this,
> -	  20(40)bytes/PAGE_SIZE on 32(64)bit system will be occupied by memory
> +	  8(16)bytes/PAGE_SIZE on 32(64)bit system will be occupied by memory
>  	  usage tracking struct at boot. Total amount of this is printed out
>  	  at boot.
>  
> -- 
> 1.8.1.2
> 

-- 
Michal Hocko
SUSE Labs
