From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/9] slab: remove synchronous rcu_barrier() call in memcg
 cache release path
Date: Sat, 14 Jan 2017 10:19:21 -0500
Message-ID: <20170114151921.GA32693@mtj.duckdns.org>
References: <20170114055449.11044-1-tj@kernel.org>
 <20170114055449.11044-3-tj@kernel.org>
 <20170114131939.GA2668@esperanza>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eMmD3jXw77Ozr6Eg6UFF0gXVIxZFJwRjgWqVdORcaYs=;
        b=IFn9lI7XtmLwMXE6+zlfqcxmsYACdMsRoC0faHGj++/0I+zffFhNJp1orSJQvSrp/l
         j2kYNzfEja+jMjJpQNsjYr5qBOtkOaRb0EiCM6fXOLZdfPVzHpvySw4LzOLTq0CkB8VB
         tY6Ixo8Bq4RczDXioNWBk0pwULgd+oxQ/HGW/8pnbjQMH4QBzSXKsubjYwcUrh05T1dN
         gyDqhoRT5klknLFC9nGBCmlpSdMLcYXTEH3BdeQKGI3G988Uwiw10ktnbWcs/YQMv1LR
         E0afzrQQ64vmPmdP3gLRWKzE6s+yYglyvRQEh1YCtJGTHxuq+l6hYjYZNM+ZHRs33YCv
         UglQ==
Content-Disposition: inline
In-Reply-To: <20170114131939.GA2668@esperanza>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@tarantool.org>
Cc: cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

Hello, Vladimir.

On Sat, Jan 14, 2017 at 04:19:39PM +0300, Vladimir Davydov wrote:
> On Sat, Jan 14, 2017 at 12:54:42AM -0500, Tejun Heo wrote:
> > This patch updates the cache release path so that it simply uses
> > call_rcu() instead of the synchronous rcu_barrier() + custom batching.
> > This doesn't cost more while being logically simpler and way more
> > scalable.
> 
> The point of rcu_barrier() is to wait until all rcu calls freeing slabs
> from the cache being destroyed are over (rcu_free_slab, kmem_rcu_free).
> I'm not sure if call_rcu() guarantees that for all rcu implementations
> too. If it did, why would we need rcu_barrier() at all?

Yeah, I had a similar question and scanned its users briefly.  Looks
like it's used in combination with ctors so that its users can
opportunistically dereference objects and e.g. check ids / state /
whatever without worrying about the objects' lifetimes.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
