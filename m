From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH mm v2 2/9] memcg: enable accounting for kernfs nodes
Date: Sun, 22 May 2022 14:37:46 +0800
Message-ID: <YonaOq6jrGygwbcH@FVFYT0MHHV2J.usts.net>
References: <Yn6aL3cO7VdrmHHp@carbon>
 <4f129690-88fe-18f2-2142-b179a804924b@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ww3nAvlupQzAe15WForrvTUe0x5VHXpHFHGu6B8UAqk=;
        b=0hlZr6B8DnKA9bzHBoPJuI3N0q1Cxa5yWd71jCU7B3Tojl9HOUU6wHR4PdRbt3926z
         PpD0UBUcN4KB8EJzNWlrONVu2XF79Mb0TPZzt/dIniiOGp2rJCglibNMQXQ+A/RSU6Rc
         bmYuSZKGQVZ/C/nDTW+7XeQ3KZPgqd/uXpcV1t8SgG1FqN2j9TGmal5wzxx24mLowb1l
         /UiUu9pXvWMx7UtkUuN2gLwaB+MxIGAajXVqNAzSILYsGx9OE+2KcuJx2a6NQUsAxms5
         rpYLG0Q+Iwna4R2DVnj4xz7A7aRXcBJ0umOpePq3Q5K/YuGiI5xvVIUehHJI8gbZ8d96
         LhKg==
Content-Disposition: inline
In-Reply-To: <4f129690-88fe-18f2-2142-b179a804924b-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, May 21, 2022 at 07:37:49PM +0300, Vasily Averin wrote:
> kernfs nodes are quite small kernel objects, however there are few
> scenarios where it consumes significant piece of all allocated memory:
> 
> 1) creating a new netdevice allocates ~50Kb of memory, where ~10Kb
>    was allocated for 80+ kernfs nodes.
> 
> 2) cgroupv2 mkdir allocates ~60Kb of memory, ~10Kb of them are kernfs
>    structures.
> 
> 3) Shakeel Butt reports that Google has workloads which create 100s
>    of subcontainers and they have observed high system overhead
>    without memcg accounting of kernfs.
> 
> Usually new kernfs node creates few other objects:
> 
> Allocs  Alloc   Allocation
> number  size
> --------------------------------------------
> 1   +  128      (__kernfs_new_node+0x4d)	kernfs node
> 1   +   88      (__kernfs_iattrs+0x57)		kernfs iattrs
> 1   +   96      (simple_xattr_alloc+0x28)	simple_xattr, can grow over 4Kb
> 1       32      (simple_xattr_set+0x59)
> 1       8       (__kernfs_new_node+0x30)
> 
> '+' -- to be accounted
> 
> This patch enables accounting for kernfs nodes slab cache.
> 
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
