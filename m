From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 4/6] slab: add SLAB_ACCOUNT flag
Date: Tue, 10 Nov 2015 13:38:08 -0500
Message-ID: <20151110183808.GB13740@mtj.duckdns.org>
References: <cover.1447172835.git.vdavydov@virtuozzo.com>
 <1ce23e932ea53f47a3376de90b21a9db8293bd6c.1447172835.git.vdavydov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=xSaIKpsm4T5UqN7MOvSUqB41rWicg5PNjVPscUgDVPU=;
        b=NzgSi95z833MEBfHylug4RKGCdUM44p+1LJJwcNfkhLPjdMyMqCBuRhlJu0XRLH7iw
         YjS7r0I7/mcHg2icviJmzbFDXT8NoNpPTXD67jBx5c1mccGcO+Qyz1YXhQF9OC3Ba+JI
         mZfmSvb1/RlggqPX66qKf3OaVKgiWnoLZWqzecHxRy0jRLjDmOSStaa1arfszT6faLaD
         lhEumYN2v6BkdswrMds+pHGT5q6zUwxzjYNSqx4yXzxGqxVGHSLJFJ7XV2hzTk9Z0jZc
         CyubtZQuESKWQD37jEPsrVl+zUnkDFc6CFoN72muRvyXToCcL2gC+8AYiS/aguALev7H
         4QtQ==
Content-Disposition: inline
In-Reply-To: <1ce23e932ea53f47a3376de90b21a9db8293bd6c.1447172835.git.vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 10, 2015 at 09:34:05PM +0300, Vladimir Davydov wrote:
> Currently, if we want to account all objects of a particular kmem cache,
> we have to pass __GFP_ACCOUNT to each kmem_cache_alloc call, which is
> inconvenient. This patch introduces SLAB_ACCOUNT flag which if passed to
> kmem_cache_create will force accounting for every allocation from this
> cache even if __GFP_ACCOUNT is not passed.
> 
> This patch does not make any of the existing caches use this flag - it
> will be done later in the series.
> 
> Note, a cache with SLAB_ACCOUNT cannot be merged with a cache w/o
> SLAB_ACCOUNT, i.e. using this flag will probably reduce the number of
> merged slabs even if kmem accounting is not used (only compiled in).

Am I correct in thinking that we should eventually be able to removed
__GFP_ACCOUNT and that only caches explicitly marked with SLAB_ACCOUNT
would need to be handled by kmemcg?

Thanks a lot for doing this!

-- 
tejun
