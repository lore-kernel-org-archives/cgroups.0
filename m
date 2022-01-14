From: Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/4] mm/memcg: use NUMA_NO_NODE to indicate allocation
 from unspecified node
Date: Fri, 14 Jan 2022 13:07:05 +0200
Message-ID: <YeFZWQn79xMG6Z3L@kernel.org>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642158434;
        bh=rg04tT8R1FkbVTYI0SCSCtVRaw71c3Km2IEW1JE51T4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QmK6P2ERTNTveN2AIVdc6Lnz3VzhcoPkYWRz3fR9Y0QTcs/iKutdB1GOzjm5pX3CO
         7edBo8SNpYe4DWdGV73ntqSi+gUcrRdeUS5ahZ/R5+z5R2GKqgDimdxk2/vXM0XxKZ
         hDdW+Iiq8p8Jjd8OuWUonO7ylUrE2cl9VXuKNk5GhadV2F7gwcrmUk/CZhBXSWb0+8
         W4j0mKwZHQOLAM3MZGm0BgctEep/5hg1fsr9vPGpVEb3me3N6+e0RAYOpjppChkMM1
         KLjsilIw3SY9lAipeHc/tICBEHJBwvl1pGkKlTefDkI5s7pagKZnsZVNWMPG4Xv73F
         T1UCuSqIlcBRg==
Content-Disposition: inline
In-Reply-To: <20220111010302.8864-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Jan 11, 2022 at 01:02:59AM +0000, Wei Yang wrote:
> Instead of use "-1", let's use NUMA_NO_NODE for consistency.
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Reviewed-by: Mike Rapoport <rppt-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>

> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2ed5f2a0879d..11715f7323c0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5054,7 +5054,7 @@ static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
>  	 *       function.
>  	 */
>  	if (!node_state(node, N_NORMAL_MEMORY))
> -		tmp = -1;
> +		tmp = NUMA_NO_NODE;
>  	pn = kzalloc_node(sizeof(*pn), GFP_KERNEL, tmp);
>  	if (!pn)
>  		return 1;
> -- 
> 2.33.1
> 
> 

-- 
Sincerely yours,
Mike.
