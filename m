From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] memcg: enable accounting for large allocations in mem_cgroup_css_alloc
Date: Fri, 20 May 2022 01:07:07 +0000
Message-ID: <20220520010707.77z5blxpbsddwmyo@google.com>
References: <Ynv7+VG+T2y9rpdk@carbon> <212f1b74-7d4e-29f2-9e92-2a1820beff61@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=G6gtvqYNjnVwht1zFDxId2+CvU+SMvS0Nm0E4p7o9cM=;
        b=Gq0rw+MrvLWVPrWEBXryZB1jQV/V1G9kqtZ5HVH9URkE6LQh50hBnHJMNqkGngRE1B
         OKQFxrvMTob/C1c6Prc225WuKjE8WCTLx3fHin7rlnzNSeIOtlGLTu74nl6iciYuNa6V
         wKGClUZev9JgvVbePXUNUNBu7Uz1/J49jE9sWsl47yg7HwP0TiOqv882QwVKD+FEXZY5
         VRHfGsaPeQ8uLVWv02vR138ZcXZ+G+eh5CxwWdQnlEieVAYcg1VZgbsIj+VW85zoNOBM
         wo1vIABj/7CfTuXAAnloVwGNjfYF36gl6mrEArXq+HVLQCpFYG1ejzHnmXk3KpUV9HEj
         Th3w==
In-Reply-To: <212f1b74-7d4e-29f2-9e92-2a1820beff61-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 13, 2022 at 06:51:41PM +0300, Vasily Averin wrote:
> cgroup mkdir can be misused inside memcg limited container. It can allocate
> a lot of host memory without memcg accounting, cause global memory shortage
> and force OOM to kill random host process.
> 
> Below [1] is result of mkdir /sys/fs/cgroup/test tracing on VM with 4 cpus
> 
> number	bytes	$1*$2	sum	note	call_site
> of	alloc
> allocs
> ------------------------------------------------------------
> 1       14448   14448   14448   =       percpu_alloc_percpu:
> 1       8192    8192    22640           (mem_cgroup_css_alloc+0x54)
> 49      128     6272    28912           (__kernfs_new_node+0x4e)
> 49      96      4704    33616           (simple_xattr_alloc+0x2c)
> 49      88      4312    37928           (__kernfs_iattrs+0x56)
> 1       4096    4096    42024           (cgroup_mkdir+0xc7)
> 1       3840    3840    45864   =       percpu_alloc_percpu:
> 4       512     2048    47912           (alloc_fair_sched_group+0x166)
> 4       512     2048    49960           (alloc_fair_sched_group+0x139)
> 1       2048    2048    52008           (mem_cgroup_css_alloc+0x109)
> 	[smaller objects skipped]
> ---
> Total			61728
> 
> '=' --  accounted allocations
> 
> This patch enabled accounting for one of the main memory hogs in this
> experiment: allocation which are called inside mem_cgroup_css_alloc()
> 
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> Link: [1] https://lore.kernel.org/all/1aa4cd22-fcb6-0e8d-a1c6-23661d618864-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org/
> 

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
