From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Thu, 27 Sep 2012 14:15:58 +0200
Message-ID: <20120927121558.GB29104@dhcp22.suse.cz>
References: <50635F46.7000700@parallels.com>
 <20120926201629.GB20342@google.com>
 <50637298.2090904@parallels.com>
 <20120926221046.GA10453@mtj.dyndns.org>
 <506381B2.2060806@parallels.com>
 <20120926224235.GB10453@mtj.dyndns.org>
 <50638793.7060806@parallels.com>
 <20120926230807.GC10453@mtj.dyndns.org>
 <50638DBB.4000002@parallels.com>
 <20120926233334.GD10453@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120926233334.GD10453-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Wed 26-09-12 16:33:34, Tejun Heo wrote:
[...]
> > > So, this seems properly crazy to me at the similar level of
> > > use_hierarchy fiasco.  I'm gonna NACK on this.
> > 
> > As I said: all use cases I particularly care about are covered by a
> > global switch.
> > 
> > I am laying down my views because I really believe they make more sense.
> > But at some point, of course, I'll shut up if I believe I am a lone voice.
> > 
> > I believe it should still be good to hear from mhocko and kame, but from
> > your point of view, would all the rest, plus the introduction of a
> > global switch make it acceptable to you?
> 
> The only thing I'm whining about is per-node switch + silently
> ignoring past accounting, so if those two are solved, I think I'm
> pretty happy with the rest.

I think that per-group "switch" is not nice as well but if we make it
hierarchy specific (which I am proposing for quite some time) and do not
let enable accounting for a group with tasks then we get both
flexibility and reasonable semantic. A global switch sounds too coars to
me and it really not necessary.

Would this work with you?
-- 
Michal Hocko
SUSE Labs
