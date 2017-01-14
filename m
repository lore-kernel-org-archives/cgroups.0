From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/9] slab: simplify shutdown_memcg_caches()
Date: Sat, 14 Jan 2017 10:53:43 -0500
Message-ID: <20170114155343.GA13589@mtj.duckdns.org>
References: <20170114055449.11044-1-tj@kernel.org>
 <20170114055449.11044-4-tj@kernel.org>
 <20170114132722.GB2668@esperanza>
 <20170114153801.GB32693@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yMexK7hyBwxJ71vyXI4fFPA/LqJ+M/hDl4wWVMnUZvU=;
        b=rBh7VropopKy/Y6/fka3aHnuPnMSKLSGSb8SwGJTxYsrcUlajpLA4spNcH2ay4K3wa
         E138MoOrpgoZnJ8H7y2Vh9JhLnyqGsmrPfyLAeKj80l5Ne6DQrPFzs6EC5NtA6RHSst4
         nf4rPl9k+KSQZ0KRvjSpXT0de171XsnvWWf0NZ1QX3/kXHwM9flWGEfDPJfUdFm9gidB
         Mnd/tWC9zroxgLD5crIPG12TRHhpOANkAoAqF7G7w0JKjT4G7oAXcmvlnxP6orPX36Jd
         Ta2prLZD1jYfIqk4LlaybY+ZN3b6+LJVwhhpSTTXr3L+YK+in8wvV0LTWF4oO5tu1yq0
         ILew==
Content-Disposition: inline
In-Reply-To: <20170114153801.GB32693@mtj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@tarantool.org>
Cc: cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

On Sat, Jan 14, 2017 at 10:38:01AM -0500, Tejun Heo wrote:
> On Sat, Jan 14, 2017 at 04:27:22PM +0300, Vladimir Davydov wrote:
> > > -	 * Second, shutdown all caches left from memory cgroups that are now
> > > -	 * offline.
> > > +	 * Shutdown all caches.
> > >  	 */
> > >  	list_for_each_entry_safe(c, c2, &s->memcg_params.list,
> > >  				 memcg_params.list)
> > >  		shutdown_cache(c);
> > 
> > The point of this complexity was to leave caches that happen to have
> > objects when kmem_cache_destroy() is called on the list, so that they
> > could be reused later. This behavior was inherited from the global
> 
> Ah, right, I misread the branch.  I don't quite get how the cache can
> be reused later tho?  This is called when the memcg gets released and
> a clear error condition - the caller, kmem_cache_destroy(), handles it
> as an error condition too.

I think I understand it now.  This is the alias being able to find and
reuse the cache.  Heh, that's a weird optimization for a corner error
case.  Anyways, I'll drop this patch.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
