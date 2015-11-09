From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/5] memcg/kmem: switch to white list policy
Date: Mon, 9 Nov 2015 15:30:53 -0500
Message-ID: <20151109203053.GD28507@mtj.duckdns.org>
References: <cover.1446924358.git.vdavydov@virtuozzo.com>
 <20151109140832.GE8916@dhcp22.suse.cz>
 <20151109182840.GJ31308@esperanza>
 <20151109185401.GB28507@mtj.duckdns.org>
 <20151109192747.GN31308@esperanza>
 <20151109193253.GC28507@mtj.duckdns.org>
 <20151109201218.GP31308@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ccDSqBgdy6gte5gnDWCDbgxy0BcQ+X5q6f0eAV3cb50=;
        b=V4BmeXB/raVuwVbtn07mFThWrdnlr/4ff8QmADSdCMoBwa0F36rFvK/uxEVFgUb6v3
         myIlBd93YnMmdMkCEQsdNuKdCtW5v6OWT3dHkR52J26ciVqYHP+0KQkFN7/EPgga5JPc
         9Wm0JpGEm3pckVU5avp7rVMdUwHT/AI3SE18F6BL440CEMnnPfVxBMOwMpYjfen3ZmXP
         iYjXQJGH1xfsibxPfQcPLZ2ytv+Thd6PP+Y/nMRKqOuemp/CsS/wJDpqFaRdVv3HwieR
         bjh/PJF77ptCzdGYkRdz8gIJJxKbAo77qh75kH9sXMTgJA3OFB3SnS2uTBx1KhkMgNd9
         INow==
Content-Disposition: inline
In-Reply-To: <20151109201218.GP31308@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Vladimir.

On Mon, Nov 09, 2015 at 11:12:18PM +0300, Vladimir Davydov wrote:
> Because we won't be able to distinguish kmem_cache_alloc calls that
> should be accounted from those that shouldn't. The problem is if two
> caches
> 
> 	A = kmem_cache_create(...)
> 
> and
> 
> 	B = kmem_cache_create(...)
> 
> happen to be merged, A and B will point to the same kmem_cache struct.
> As a result, there is no way to distinguish
> 
> 	kmem_cache_alloc(A)
> 
> which we want to account from
> 
> 	kmem_cache_alloc(B)
> 
> which we don't.

Hmm.... can't we simply merge among !SLAB_ACCOUNT and SLAB_ACCOUNT
kmem_caches within themselves?  I don't think we'd be losing anything
by restricting merge at that level.  For anything to be tagged
SLAB_ACCOUNT, it has to have a potential to grow enormous after all.

Thanks.

-- 
tejun
