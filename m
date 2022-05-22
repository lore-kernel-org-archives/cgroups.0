From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH mm v2 4/9] memcg: enable accounting for struct
 simple_xattr
Date: Sun, 22 May 2022 14:38:54 +0800
Message-ID: <YonafoqQkw22i41B@FVFYT0MHHV2J.usts.net>
References: <Yn6aL3cO7VdrmHHp@carbon>
 <b69d2389-3a1f-d0bb-6a14-83473fe2d815@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L2Pe0MYHq/Yx78fCTpUgbwdSX/KtiLZzQfFUiCB9rR4=;
        b=2yX+PxR79RziW6XLaAynJWecE1Q0bheyhr3naloLu2PlOc+IfkrnlU/rZn33HmEjpv
         EdTY9j89e2UdiePS9za4CH5f9jEsK5SAldon3f6WO9nGwbMyVLhbBU/iZWDFkAtg+lSI
         WHUsv68nRcZvXAKJ5YbSlk8+0B5k9z3ARTy6Bs1SWP5L9xVAD4EbVnDMCwQLAL0cOXNm
         Z13qKhUnxfchrKP3qprM2GOZZnFc6kJ7UycB/bId4/bo8iOrIa9sorUPGtza2P+b+j/h
         mNalOAMptkd5Ci5/dhDH++4UW7brno4SVp2T2RWIdgCG2sEMp9mndu4EVvIMtffRkEvZ
         KdwA==
Content-Disposition: inline
In-Reply-To: <b69d2389-3a1f-d0bb-6a14-83473fe2d815-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, May 21, 2022 at 07:38:11PM +0300, Vasily Averin wrote:
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
> 1   +  128      (__kernfs_new_node+0x4d)        kernfs node
> 1   +   88      (__kernfs_iattrs+0x57)          kernfs iattrs
> 1   +   96      (simple_xattr_alloc+0x28)       simple_xattr
> 1       32      (simple_xattr_set+0x59)
> 1       8       (__kernfs_new_node+0x30)
> 
> '+' -- to be accounted
> 
> This patch enables accounting for struct simple_xattr. Size of this
> structure depends on userspace and can grow over 4Kb.
> 
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
