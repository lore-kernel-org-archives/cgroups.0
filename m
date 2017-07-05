From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: kmemleaks reports a lot of cases around memcg_create_kmem_cache
Date: Wed, 5 Jul 2017 10:47:43 -0400
Message-ID: <20170705144743.GA19330@htj.duckdns.org>
References: <CANaxB-x=xgLq116VReo4Og+jFsAB+ehx3xThnXoCx8pR3YXPSA@mail.gmail.com>
 <20170702185017.ew5cn4altyw7nomi@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=K8aruXhlmQg9wAjKh7cJ2UZpy4GEXsUfntM6UUR871U=;
        b=d4NXlML7qyyLMx0cQqaNBelDDSTnZWnjFMW5YN7t/fxYvXHdvDVs1wKww6YjntIytn
         N5/ytc/iqJG6zNIwUs7kp4ywyxpL7uR3TgiVpWPKizjJ3ASCeWuIE/IR7lSNWBgiIuhs
         a6MdFRsP6z9fcoAjsUgvefvgO0vG9s7PrCttrKe5pJtv9KSZrfpOy81eJoaZT3znfRzO
         pI5jFe4lZaPEHD5/fmrwpuya/HCxfs/AIrTczJjyDnRDr4urjKPvlusw19qmY9hKtDR2
         E1ipZBb55C2cYtNMzOoiNIqnydgdgD4GzbLhbid/sX+xJNov76RaoAZnnSyM5Z1i6plZ
         a/dg==
Content-Disposition: inline
In-Reply-To: <20170702185017.ew5cn4altyw7nomi@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Sun, Jul 02, 2017 at 09:50:17PM +0300, Vladimir Davydov wrote:
> From: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Subject: [PATCH] slub: fix per memcg cache leak on css offline
> 
> To avoid a possible deadlock, sysfs_slab_remove() schedules an
> asynchronous work to delete sysfs entries corresponding to the kmem
> cache. To ensure the cache isn't freed before the work function is
> called, it takes a reference to the cache kobject. The reference is
> supposed to be released by the work function. However, the work function
> (sysfs_slab_remove_workfn()) does nothing in case the cache sysfs entry
> has already been deleted, leaking the kobject and the corresponding
> cache. This may happen on a per memcg cache destruction, because sysfs
> entries of a per memcg cache are deleted on memcg offline if the cache
> is empty (see __kmemcg_cache_deactivate()).
...
> Reported-by: Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Fixes: 3b7b314053d02 ("slub: make sysfs file removal asynchronous")

Oops,

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
