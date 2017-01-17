From: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Subject: Re: [PATCH 2/9] slab: remove synchronous rcu_barrier() call in memcg
 cache release path
Date: Tue, 17 Jan 2017 09:07:54 +0900
Message-ID: <20170117000754.GA25218@js1304-P5Q-DELUXE>
References: <20170114055449.11044-1-tj@kernel.org>
 <20170114055449.11044-3-tj@kernel.org>
 <20170114131939.GA2668@esperanza>
 <20170114151921.GA32693@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170114151921.GA32693-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-mJ5StSI9eqKXDw4h08c5KA@public.gmane.org>, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, jsvana-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Sat, Jan 14, 2017 at 10:19:21AM -0500, Tejun Heo wrote:
> Hello, Vladimir.
> 
> On Sat, Jan 14, 2017 at 04:19:39PM +0300, Vladimir Davydov wrote:
> > On Sat, Jan 14, 2017 at 12:54:42AM -0500, Tejun Heo wrote:
> > > This patch updates the cache release path so that it simply uses
> > > call_rcu() instead of the synchronous rcu_barrier() + custom batching.
> > > This doesn't cost more while being logically simpler and way more
> > > scalable.
> > 
> > The point of rcu_barrier() is to wait until all rcu calls freeing slabs
> > from the cache being destroyed are over (rcu_free_slab, kmem_rcu_free).
> > I'm not sure if call_rcu() guarantees that for all rcu implementations
> > too. If it did, why would we need rcu_barrier() at all?
> 
> Yeah, I had a similar question and scanned its users briefly.  Looks
> like it's used in combination with ctors so that its users can
> opportunistically dereference objects and e.g. check ids / state /
> whatever without worrying about the objects' lifetimes.

Hello, Tejun.

Long time no see! :)

IIUC, rcu_barrier() here prevents to destruct the kmem_cache until all
slab pages in it are freed. These slab pages are freed through call_rcu().

Your patch changes it to another call_rcu() and, I think, if sequence of
executing rcu callbacks is the same with sequence of adding rcu
callbacks, it would work. However, I'm not sure that it is
guaranteed by RCU API. Am I missing something?

Thanks.
