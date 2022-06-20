From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v5 07/11] mm: memcontrol: make all the callers of
 {folio,page}_memcg() safe
Date: Mon, 20 Jun 2022 14:13:43 +0800
Message-ID: <YrAQFysifBga7H8k@FVFYT0MHHV2J.usts.net>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
 <20220530074919.46352-8-songmuchun@bytedance.com>
 <Yq96/NEanbbUUUIW@castle>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YkPqpfUX+L0hoB9Kerf1NXcOCvW4O6Wrp9vBOyavaFk=;
        b=Sppa+cznksmSnBN0Hb4tnd39OxbExYMGS14dgliIM6xPRw/js90Q5vuen3RaccDVM5
         +QsuOAQ6T9HD8irEpLB3MO7T0xKMmuoJJ0WLppjaITPcl7icv0Bq2MVpw1ms1v3D/HMS
         jJt2W+zx39RpJMloaVl7FFXL++y0Pn4GxUjeX9dHHQuFeo000sEeq5s3rvlYAO0WagjC
         SjwvH+1PBzGF1nb56G64rpo33emu3MTDoVT7HEKIq2Iz6jFVnjESTWXXB6o6tMApC3Bw
         E8zzdoHnBmgYPoiJ3VaklC+iP71Uk1xULCza4MWM+Z+egAVv/pu9bQcMgLXW83rHwh+A
         nRtQ==
Content-Disposition: inline
In-Reply-To: <Yq96/NEanbbUUUIW@castle>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Sun, Jun 19, 2022 at 12:37:32PM -0700, Roman Gushchin wrote:
> On Mon, May 30, 2022 at 03:49:15PM +0800, Muchun Song wrote:
> > When we use objcg APIs to charge the LRU pages, the page will not hold
> > a reference to the memcg associated with the page. So the caller of the
> > {folio,page}_memcg() should hold an rcu read lock or obtain a reference
> > to the memcg associated with the page to protect memcg from being
> > released. So introduce get_mem_cgroup_from_{page,folio}() to obtain a
> > reference to the memory cgroup associated with the page.
> > 
> > In this patch, make all the callers hold an rcu read lock or obtain a
> > reference to the memcg to protect memcg from being released when the LRU
> > pages reparented.
> > 
> > We do not need to adjust the callers of {folio,page}_memcg() during
> > the whole process of mem_cgroup_move_task(). Because the cgroup migration
> > and memory cgroup offlining are serialized by @cgroup_mutex. In this
> > routine, the LRU pages cannot be reparented to its parent memory cgroup.
> > So {folio,page}_memcg() is stable and cannot be released.
> > 
> > This is a preparation for reparenting the LRU pages.
> > 
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
>

Thanks for your review.
 
> The locking seems to be correct. I'm slightly worried about a potential
> perf degradation, especially on dying cgroups, where css_get() is relatively
> expensive. I hope getting it into mm-unstable will help to determine
> whether it's actually a problem.
> 

I'll send a new version based on mm-unstable ASAP.

Thanks.

> Thanks!
> 
