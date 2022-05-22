From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH mm v2 1/9] memcg: enable accounting for struct cgroup
Date: Sun, 22 May 2022 14:37:14 +0800
Message-ID: <YonaGuR/hB9vJJMw@FVFYT0MHHV2J.usts.net>
References: <Yn6aL3cO7VdrmHHp@carbon>
 <a76dc143-68d9-41f4-81d1-85ec15135b1e@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SS4jw3jE67JbDZTZdbjql/HYvYPNQbA1HjLNkPGV220=;
        b=tH30EpVK2h/cCwkIA89339RbASD9rwQYzV2mpWXdJeN1f2qCoMf0aw+zavoo/5g+Im
         szoe9euSzxHQzARGh9ChqS4tUPL1BtXXyt39qSSHWItE4nzGG4KjRDUi2GXIutzNildO
         wswdljmUZs04AM1qJeN5L4dR80f/jFVvYOfM+kYYqWqT1Gn6VtxFyeRCyxWMu8VVi9z4
         rq9SjvSnZ7eSzbzO4IXPUb/T1UV/BGSnSzRpOKGBHaNJq5cqbp7YL4osznVW8jiRpg8k
         RS0QtL1EeAIbWz230hGs/rrOofuOszZl9MPmnt2Ei5ECuQJAasNZlslU1Q5OSQXKqKvf
         Pc3A==
Content-Disposition: inline
In-Reply-To: <a76dc143-68d9-41f4-81d1-85ec15135b1e-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, May 21, 2022 at 07:37:36PM +0300, Vasily Averin wrote:
> Creating each new cgroup allocates 4Kb for struct cgroup. This is the
> largest memory allocation in this scenario and is epecially important
> for small VMs with 1-2 CPUs.
> 
> Common part of the cgroup creation:
> Allocs  Alloc   $1*$2   Sum     Allocation
> number  size
> --------------------------------------------
> 16  ~   352     5632    5632    KERNFS
> 1   +   4096    4096    9728    (cgroup_mkdir+0xe4)
> 1       584     584     10312   (radix_tree_node_alloc.constprop.0+0x89)
> 1       192     192     10504   (__d_alloc+0x29)
> 2       72      144     10648   (avc_alloc_node+0x27)
> 2       64      128     10776   (percpu_ref_init+0x6a)
> 1       64      64      10840   (memcg_list_lru_alloc+0x21a)
> percpu:
> 1   +   192     192     192     call_site=psi_cgroup_alloc+0x1e
> 1   +   96      96      288     call_site=cgroup_rstat_init+0x5f
> 2       12      24      312     call_site=percpu_ref_init+0x23
> 1       6       6       318     call_site=__percpu_counter_init+0x22
> 
>  '+' -- to be accounted,
>  '~' -- partially accounted
> 
> Accounting of this memory helps to avoid misuse inside memcg-limited
> containers.
> 
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
