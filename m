From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH -next] mm/memcontrol.c: make cgroup_memory_noswap static
Date: Thu, 21 Apr 2022 10:22:09 -0400
Message-ID: <YmFokXAWjp35yIFS@cmpxchg.org>
References: <20220421124736.62180-1-lujialin4@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xZMCVPcYFV3B+SKd3NEIMAMCeRNJPyaeLFKLuEeo51c=;
        b=q3lCCATKuv+Uf5ChmHextg+VIYRg7sglu2vtz03zUPGFsDXhO7asAMZtk1H9E/JnDr
         YibqlpDokwcpSiIdJL8QeVip38kYFCQ2xBWbysfUDwU2V/NRfUkI9/PsfsKYxDZpQ1mb
         r5AXLmwCXYxLFzrCecn/0Y6Au873M0CBj+0vEC9orZ/LT+dE/GvFDYw3rgIA8Op4LCHN
         X0zzweG7A0C3beYpMXbFFw6IKQHaInfwnSTOD6NPwJN7YTK+tGVujdGsHuUJ2H+myjpT
         S6/znAKKqrEvzcWQ1qKqblw6q/aLFBRAYuB9f3t7HhAqRizq4t2KEezpyBvq6OLqFbzI
         JAfg==
Content-Disposition: inline
In-Reply-To: <20220421124736.62180-1-lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Wang Weiyang <wangweiyang2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Apr 21, 2022 at 08:47:36PM +0800, Lu Jialin wrote:
> cgroup_memory_noswap is only used in mm/memcontrol.c, therefore just make
> it static, and remove export in include/linux/memcontrol.h
> 
> Signed-off-by: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Nice. Unused since 2d1c498072de ("mm: memcontrol: make swap tracking
an integral part of memory control"), which removed the two instances
from mm/swap_cgroup.c.

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
