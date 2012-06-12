From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 2/4] Add a __GFP_SLABMEMCG flag
Date: Tue, 12 Jun 2012 15:36:27 +0100
Message-ID: <1339511787.3050.5.camel@dabdike.int.hansenpartnership.com>
References: <1339148601-20096-1-git-send-email-glommer@parallels.com>
	 <1339148601-20096-3-git-send-email-glommer@parallels.com>
	 <alpine.DEB.2.00.1206081430380.4213@router.home>
	 <1339203416.6893.10.camel@dabdike.int.hansenpartnership.com>
	 <alpine.DEB.2.00.1206110905220.31180@router.home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1206110905220.31180-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbeck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, 2012-06-11 at 09:24 -0500, Christoph Lameter wrote:
> On Sat, 9 Jun 2012, James Bottomley wrote:
> 
> > On Fri, 2012-06-08 at 14:31 -0500, Christoph Lameter wrote:
> > > On Fri, 8 Jun 2012, Glauber Costa wrote:
> > >
> > > >   */
> > > >  #define __GFP_NOTRACK_FALSE_POSITIVE (__GFP_NOTRACK)
> > > >
> > > > -#define __GFP_BITS_SHIFT 25	/* Room for N __GFP_FOO bits */
> > > > +#define __GFP_BITS_SHIFT 26	/* Room for N __GFP_FOO bits */
> > > >  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
> > >
> > > Please make this conditional on CONFIG_MEMCG or so. The bit can be useful
> > > in particular on 32 bit architectures.
> >
> > I really don't think that's at all a good idea.  It's asking for trouble
> > when we don't spot we have a flag overlap.  It also means that we're
> > trusting the reuser to know that their use case can never clash with
> > CONFIG_MEMGC and I can't think of any configuration where this is
> > possible currently.
> 
> Flag overlap can be avoided using the same method as we have done with the
> page flags (which uses an enum).  There are other uses of N bits after
> GFP_BITS_SHIFT. On first look this looks like its 4 right now so we cannot
> go above 28 on 32 bit platforms. It would also be useful to have that
> limit in there somehow so that someone modifying the GFP_BITS sees the
> danger.

But if there's no possible configuration that can use a flag and depends
on !CONFIG_MEMGC then why bother?  The main problem is that unless you
get two configurations which exactly cancel each other and require a GFP
flag, you end up eventually with unbuildable configurations that need
>32 flags.

> > I think making the flag define of __GFP_SLABMEMCG conditional might be a
> > reasonable idea so we get a compile failure if anyone tries to use it
> > when !CONFIG_MEMCG.
> 
> Ok that is another reason to do so.

A reason to make it conditional, not a reason to go to the trouble of
making the flags reusable.

James

