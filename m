From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH -next] mm/memcontrol.c: replace cgroup_memory_nokmem with
 mem_cgroup_kmem_disabled()
Date: Sat, 25 Jun 2022 18:41:46 -0700
Message-ID: <Yre5WiiXDejuhwe/@castle>
References: <20220625061844.226764-1-xiangyang3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656207712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZHwnwrn3rPLBw4iau7Jw3zxeWr01E6ma/j2ZXjk5zGg=;
        b=inhynC+/9JmTzlEUN75pSJA6UyVqmDxmnGSgTFQHSr2kBt1CK8HHksb3zxHQsrKsUctugk
        SpYIih+PNnMaCVDkKN7IUONVnXa4JDeJ+OIHiL6jjGlrQTlPkj+zbYVVeDLiEFoaJXx6oQ
        3ELrf+PeJB10lLu5X+Q7mJuA9mTGfk8=
Content-Disposition: inline
In-Reply-To: <20220625061844.226764-1-xiangyang3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xiang Yang <xiangyang3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jun 25, 2022 at 02:18:44PM +0800, Xiang Yang wrote:
> mem_cgroup_kmem_disabled() checks whether the kmem accounting is off.
> Therefore, replace cgroup_memory_nokmem with mem_cgroup_kmem_disabled(),
> which is the same work in percpu.c and slab_common.c.
> 
> Signed-off-by: Xiang Yang <xiangyang3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Thanks!
