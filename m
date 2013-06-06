From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v10 22/35] shrinker: convert remaining shrinkers to
 count/scan API
Date: Thu, 6 Jun 2013 13:41:16 +1000
Message-ID: <20130606034116.GT29338@dastard>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org>
 <1370287804-3481-23-git-send-email-glommer@openvz.org>
 <20130605160821.59adf9ad4efe48144fd9e237@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130605160821.59adf9ad4efe48144fd9e237-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "J. Bruce Fields" <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Trond Myklebust <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>

On Wed, Jun 05, 2013 at 04:08:21PM -0700, Andrew Morton wrote:
> On Mon,  3 Jun 2013 23:29:51 +0400 Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> 
> > From: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > 
> > Convert the remaining couple of random shrinkers in the tree to the
> > new API.
> 
> Gee we have a lot of shrinkers.

And a large number of them are busted in some way, too :/

> > --- a/arch/x86/kvm/mmu.c
> > +++ b/arch/x86/kvm/mmu.c
> > @@ -4213,13 +4213,14 @@ restart:
> >  	spin_unlock(&kvm->mmu_lock);
> >  }
> >  
> > -static int mmu_shrink(struct shrinker *shrink, struct shrink_control *sc)
> > +static long
> > +mmu_shrink_scan(
> > +	struct shrinker		*shrink,
> > +	struct shrink_control	*sc)
> >
> > ...
> >
> > --- a/net/sunrpc/auth.c
> > +++ b/net/sunrpc/auth.c
> > -static int
> > -rpcauth_cache_shrinker(struct shrinker *shrink, struct shrink_control *sc)
> > +static long
> > +rpcauth_cache_shrink_scan(
> > +	struct shrinker		*shrink,
> > +	struct shrink_control	*sc)
> > +
> 
> It is pretty poor form to switch other people's code into this very
> non-standard XFSish coding style.  The maintainers are just going to
> have to go wtf and switch it back one day.

My bad.  That's left over from when I was originally developing the
the patch set passed a couple more parameters to the shrinkers
pushing every single declaration to well over the line length
limits. I never converted them back as I removed the extra
parameters, because it's far easier to just have delete a line that
delete a variable and reformat the entire function declaration....

> Really, it would be best if you were to go through the entire patchset
> and undo all this.

Sure, that can be done.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
