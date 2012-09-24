From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 06/16] memcg: infrastructure to match an allocation
 to the right cache
Date: Mon, 24 Sep 2012 10:58:01 -0700
Message-ID: <20120924175801.GE7694@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
 <1347977530-29755-7-git-send-email-glommer@parallels.com>
 <20120921205236.GT7264@google.com>
 <50601721.6040805@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+Q2OPwNoy5CX4X/wDhyM+GU7nU64qhbH5MC7h/6Ic3w=;
        b=a2y/J2d4jWWellqD1kavRv7fjd5xlBnGnjyE/nIUPnGwjOV5WTn47y+jsuIPPZxrsW
         0N0aEIsBd1e7VZM5J87ALKiovV73rI94ujci7nB675xUJ3mZE1asa2R0cO6IPHUtTWNu
         +EQj8RTp8k3yn1wjr1pU+za3sxRXL70ceGDylpS4IEUg31sKyenZgJhJCOw/MUmIIo9S
         G1H6HFWvAox8qVf2O03ljXZTxOj4PcAoXIEWz2eanjgyH1Yo64zEImngSwjVac6yiLPV
         x9B+RhSZHVGyHY5l0nlpyUJtJJ1ew2CsSLZ3ntL190+uMHg/ajVDcirNzjjncL4fUdL3
         dDjA==
Content-Disposition: inline
In-Reply-To: <50601721.6040805-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Mon, Sep 24, 2012 at 12:17:37PM +0400, Glauber Costa wrote:
> On 09/22/2012 12:52 AM, Tejun Heo wrote:
> > Missed some stuff.
> > 
> > On Tue, Sep 18, 2012 at 06:12:00PM +0400, Glauber Costa wrote:
> >> +static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
> >> +						  struct kmem_cache *cachep)
> >> +{
> > ...
> >> +	memcg->slabs[idx] = new_cachep;
> > ...
> >> +struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep,
> >> +					  gfp_t gfp)
> >> +{
> > ...
> >> +	return memcg->slabs[idx];
> > 
> > I think you need memory barriers for the above pair.
> > 
> > Thanks.
> > 
> 
> Why is that?
> 
> We'll either see a value, or NULL. If we see NULL, we assume the cache
> is not yet created. Not a big deal.

Because when you see !NULL cache pointer you want to be able to see
the cache fully initialized.  You need wmb between cache creation and
pointer assignment and at least read_barrier_depends() between
fetching the cache pointer and dereferencing it.

Thanks.

-- 
tejun
