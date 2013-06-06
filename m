From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v10 00/35] kmemcg shrinkers
Date: Thu, 6 Jun 2013 00:18:55 -0700
Message-ID: <20130606001855.48d9da2e.akpm@linux-foundation.org>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org>
	<20130605160721.da995af82eb247ccf8f8537f@linux-foundation.org>
	<51B02347.60809@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B02347.60809-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, 6 Jun 2013 09:51:03 +0400 Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:

> On 06/06/2013 03:07 AM, Andrew Morton wrote:
> > On Mon,  3 Jun 2013 23:29:29 +0400 Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> 
> > I haven't seen any show-stoppers yet so I guess I'll slam it all into
> > -next and cross fingers.  I would ask that the relevant developers set
> > aside a solid day to read and runtime test it all.  Realistically, it's
> > likely to take considerably more time that that.
> > 
> > I do expect that I'll drop the entire patchset again for the next
> > version, if only because the next version should withdraw all the
> > switch-random-code-to-xfs-coding-style changes...
> > 
> Ok, how do you want me to proceed ? Should I send a new series, or
> incremental? When exactly?
> 
> I do have at least two fixes to send that popped out this week: one of
> them for the drivers patch, since Kent complained about a malconversion
> of the bcache driver, and another one in the memcg page path.

Definitely a new series.  I tossed this series into -mm and -next so
that others can conveniently review and test it (hint).

> > 
> > I'm thinking that we should approach this in two stages: all the new
> > shrinker stuff separated from the memcg_kmem work.  So we merge
> > everything up to "shrinker: Kill old ->shrink API" and then continue to
> > work on the memcg things?
> > 
> 
> I agree with this, the shrinker part got a very thorough review from Mel
> recently. I do need to send you the fix for the bcache driver (or the
> whole thing, as you would prefer), and fix whatever comments you have.
> 
> Please note that as I have mentioned in the opening letter, I have two
> follow up patches for memcg (one of them allows us to use the shrinker
> infrastructure to reduce the value of kmem.limit, and the other one
> flushes the caches upon destruction). I haven't included in the series
> because the series is already huge, and I believe by including them,
> they would not get the review they deserve (by being new). Splitting it
> in two would allow me to include them in a smaller series.
> 
> I will go over your comments in a couple of hours. Please just advise me
> how would you like me to proceed with this logistically (new submission,
> fixes, for which patches, etc)

New everything, please.  There's no hurry - linux-next is going on
holidays for a week.

The shrinker stuff seems sensible and straightforward and I expect we
can proceed with that at the normal pace.  The memcg changes struck me
as being hairy as hell and I'd really like to see the other memcg
people go through it carefully.

Of course, "new series" doesn't give you an easily accessible tree to
target.  I could drop it all again to give you a clean shot at
tomorrow's -next?
