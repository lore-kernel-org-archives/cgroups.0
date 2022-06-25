From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH -next] mm/memcontrol.c: replace cgroup_memory_nokmem with
 mem_cgroup_kmem_disabled()
Date: Sat, 25 Jun 2022 16:58:38 +0800
Message-ID: <YrbOPktTSb00DvYw@FVFYT0MHHV2J.usts.net>
References: <20220625061844.226764-1-xiangyang3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yBLfi92gAlfWDayXHgzw4YwyIEMK5sbZZcp3v3R4WvY=;
        b=vWECR4lLdOmckfTvOtrYhFODIrM4aq0XBkbDVkccpRjJ3+cMeUvXRYavTTP+yfUnbX
         w6+J8m/kcwHkSZzmeu90jyJ4IHHBP0StpdY3RIXtbqNihYBxZAT27XARGx07UqgXeU3y
         01EYfl9HNI/lphnYRGJjUaO46ig2ViHWHtRFePaayXwsyi8aoJCj72pwSANRc1WThHL1
         tmtUkNuzPsKLzhrXfUX7uXSPKmb3opDWoWCq8GFZe3XYLVPj4P86uCXjA1fiZoOMC3kA
         g8mg9T5IRuUlgBoPJ7tT/uIOH458e1rOQLqTqaGGZ9RSmZ07ahQTQbgL0xbfqf4bvYR8
         FB5A==
Content-Disposition: inline
In-Reply-To: <20220625061844.226764-1-xiangyang3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xiang Yang <xiangyang3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jun 25, 2022 at 02:18:44PM +0800, Xiang Yang wrote:
> mem_cgroup_kmem_disabled() checks whether the kmem accounting is off.
> Therefore, replace cgroup_memory_nokmem with mem_cgroup_kmem_disabled(),
> which is the same work in percpu.c and slab_common.c.
> 
> Signed-off-by: Xiang Yang <xiangyang3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks.
