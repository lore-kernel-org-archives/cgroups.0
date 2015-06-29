From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] mm:Return proper error code return if call to
 kzalloc_node falis in the function alloc_mem_cgroup_per_zone_info
Date: Mon, 29 Jun 2015 17:52:14 +0200
Message-ID: <20150629155214.GD4612@dhcp22.suse.cz>
References: <1435592813-24499-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1435592813-24499-1-git-send-email-xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 29-06-15 11:46:53, Nicholas Krause wrote:
> This changes us returning the value of one to -ENOMEM when the call
> for allocating memory with the function kzalloc_node fails in order
> to better comply with kernel coding pratices of returning this
> particular error code when memory allocations that are unrecoverable
> occur.

I do not see any point in such a patch. Let me repeat, and hopefully for
the last time, the patch has to make _sense_ and the changelog should
provide a _justification_ for the change. None of this is true for this
patch.

> Signed-off-by: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

I am not interested in changes like this in the code I maintain.

> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index acb93c5..4e80811 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4442,7 +4442,7 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
>  		tmp = -1;
>  	pn = kzalloc_node(sizeof(*pn), GFP_KERNEL, tmp);
>  	if (!pn)
> -		return 1;
> +		return -ENOMEM;
>  
>  	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
>  		mz = &pn->zoneinfo[zone];
> -- 
> 2.1.4
> 

-- 
Michal Hocko
SUSE Labs
