From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/9] slab: simplify shutdown_memcg_caches()
Date: Sat, 14 Jan 2017 10:38:01 -0500
Message-ID: <20170114153801.GB32693@mtj.duckdns.org>
References: <20170114055449.11044-1-tj@kernel.org>
 <20170114055449.11044-4-tj@kernel.org>
 <20170114132722.GB2668@esperanza>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5GZMUeo13f/KXXXlC8zyMSwDzNi9vhISsOzCgQPhSDU=;
        b=s9zAACoW/mWTg74mOAb+c1sBsLGXxT/ZBMr4OrZOJjuZ8DOrBb+o8KhoieDDm+useh
         Z6D7SzXBCoPk/agylkGRG/sASaQxORBQBnsvCrmmENlrBToFeazzeF2A4OKJqYPndXjx
         Ry1agSgqCw5cY65lWHH+p1rGY5g2FZQvlGD80+FdK+CVGyZgkMFJeyTM4INZ5zRTkiVo
         C2c165eVBvv79zBJ8SiZhIqJvGdftM6qrk1Cjq3YByHP7lyepaDvpfeU7si+20R8Tuyk
         5HzEYSx30joPTE8sIwADHW2CLj4vCKHY2wpBSvYz5apYqO89dOFRi31mbASwbDLW5Ist
         N2jA==
Content-Disposition: inline
In-Reply-To: <20170114132722.GB2668@esperanza>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@tarantool.org>
Cc: cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

On Sat, Jan 14, 2017 at 04:27:22PM +0300, Vladimir Davydov wrote:
> > -	 * Second, shutdown all caches left from memory cgroups that are now
> > -	 * offline.
> > +	 * Shutdown all caches.
> >  	 */
> >  	list_for_each_entry_safe(c, c2, &s->memcg_params.list,
> >  				 memcg_params.list)
> >  		shutdown_cache(c);
> 
> The point of this complexity was to leave caches that happen to have
> objects when kmem_cache_destroy() is called on the list, so that they
> could be reused later. This behavior was inherited from the global

Ah, right, I misread the branch.  I don't quite get how the cache can
be reused later tho?  This is called when the memcg gets released and
a clear error condition - the caller, kmem_cache_destroy(), handles it
as an error condition too.

> caches - if kmem_cache_destroy() is called on a cache that still has
> object, we print a warning message and don't destroy the cache. This
> patch changes this behavior.

Hmm... yeah, we're missing the error return propagation.  I think
that's the only meaningful difference tho, right?  Will update the
patch.

Thanks!

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
