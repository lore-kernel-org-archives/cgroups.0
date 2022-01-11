From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 2/4] mm/memcg: mem_cgroup_per_node is already set to 0 on
 allocation
Date: Tue, 11 Jan 2022 10:06:56 -0800
Message-ID: <Yd3HQGCmDcyWY6QB@carbon.dhcp.thefacebook.com>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
 <20220111010302.8864-2-richard.weiyang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=NzaRVqEgStNntr/wegozdwVQ+sz06RAwRK5GgN/PXkI=;
 b=pN1J54qrtRPEz1+FefYP2DKB/tdgtAI8Z3w2eCYGlLwPflU7akMm2+oSGyNXPLNlNBn6
 jij+6vw7W9THm/SJmmmyO+gWqap00uarjx6Pba/t3qHzovdEMXOknT04KYGK/HB5rHgz
 LkYxgnln5gLsmA4L4xFx32O2OKqdbq6ifTA= 
Content-Disposition: inline
In-Reply-To: <20220111010302.8864-2-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Jan 11, 2022 at 01:03:00AM +0000, Wei Yang wrote:
> kzalloc_node() would set data to 0, so it's not necessary to set it
> again.
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thanks!
