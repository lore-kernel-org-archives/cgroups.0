From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v10 12/35] shrinker: add node awareness
Date: Thu, 6 Jun 2013 13:26:59 +1000
Message-ID: <20130606032659.GR29338@dastard>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org>
 <1370287804-3481-13-git-send-email-glommer@openvz.org>
 <20130605160810.5b203c3368b9df7d087ee3b1@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20130605160810.5b203c3368b9df7d087ee3b1@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Glauber Costa <glommer@openvz.org>, linux-fsdevel@vger.kernel.org, Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, hughd@google.com, Greg Thelen <gthelen@google.com>, Dave Chinner <dchinner@redhat.com>

On Wed, Jun 05, 2013 at 04:08:10PM -0700, Andrew Morton wrote:
> On Mon,  3 Jun 2013 23:29:41 +0400 Glauber Costa <glommer@openvz.org> wrote:
> 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Pass the node of the current zone being reclaimed to shrink_slab(),
> > allowing the shrinker control nodemask to be set appropriately for
> > node aware shrinkers.
> 
> Again, some musings on node hotplug would be interesting.
> 
> > --- a/drivers/staging/android/ashmem.c
> > +++ b/drivers/staging/android/ashmem.c
> > @@ -692,6 +692,9 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> >  				.gfp_mask = GFP_KERNEL,
> >  				.nr_to_scan = 0,
> >  			};
> > +
> > +			nodes_setall(sc.nodes_to_scan);
> 
> hm, is there some way to do this within the initializer? ie:
> 
> 				.nodes_to_scan = magic_goes_here(),

Nothing obvious - it's essentially a memset call, so I'm not sure
how that could be put in the initialiser...

> Also, it's a bit sad to set bits for not-present and not-online nodes.

Yup. Plenty of scope for future optimisation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
