From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH mm v2 3/9] memcg: enable accounting for kernfs iattrs
Date: Sun, 22 May 2022 14:38:24 +0800
Message-ID: <YonaYCdTkxoyz815@FVFYT0MHHV2J.usts.net>
References: <Yn6aL3cO7VdrmHHp@carbon>
 <e5a8bbc2-3d97-d016-f2ba-4b2b3073a9d3@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=63w6MmKKarIOHYX+K5PAEKcR1bSxb1g9RSGqBi4nt8U=;
        b=Wx+SmgtailJYnAhwvCnC+y1AuVwXo46QNLoLpoUb8rjVzBy5xo17x6lY2EmUp6sVHu
         l8rGunXcntC+8LTB0b38OVBedUWlQ47Xv+fYt8y2hIK2D9iH7/CRngOu9kSVBGc6TXFL
         7RR9Zbl4Se+3YzKL9QmEf0AjB3Au30OSZlbshIcHneNizPzLdf4qfKySRtWPH6eV1RaD
         dCWHf2/vyiL69waPlmn2Ld3st9Y0kgrihwiSDETjrQ5145s8fQdluLTJ/0ltDMOY/OTR
         oRtt0ry2h3Xz7CDwMzplhnN0OtOJ3ZmREN/4PdnvTXgPq9UEFWaLcwwACBJihbNQeMim
         japQ==
Content-Disposition: inline
In-Reply-To: <e5a8bbc2-3d97-d016-f2ba-4b2b3073a9d3-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, May 21, 2022 at 07:37:59PM +0300, Vasily Averin wrote:
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
> Allocs  Alloc    Allocation
> number  size
> --------------------------------------------
> 1   +  128      (__kernfs_new_node+0x4d)        kernfs node
> 1   +   88      (__kernfs_iattrs+0x57)          kernfs iattrs
> 1   +   96      (simple_xattr_alloc+0x28)       simple_xattr, can grow over 4Kb
> 1       32      (simple_xattr_set+0x59)
> 1       8       (__kernfs_new_node+0x30)
> 
> '+' -- to be accounted
> 
> This patch enables accounting for kernfs_iattrs_cache slab cache
> 
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
