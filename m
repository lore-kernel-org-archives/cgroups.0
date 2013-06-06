From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v10 00/35] kmemcg shrinkers
Date: Thu, 6 Jun 2013 11:37:03 +0400
Message-ID: <51B03C1F.4000501@parallels.com>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org> <20130605160721.da995af82eb247ccf8f8537f@linux-foundation.org> <51B02347.60809@parallels.com> <20130606001855.48d9da2e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130606001855.48d9da2e.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 06/06/2013 11:18 AM, Andrew Morton wrote:
> The shrinker stuff seems sensible and straightforward and I expect we
> can proceed with that at the normal pace.  The memcg changes struck me
> as being hairy as hell and I'd really like to see the other memcg
> people go through it carefully.
> 
> Of course, "new series" doesn't give you an easily accessible tree to
> target.  I could drop it all again to give you a clean shot at
> tomorrow's -next?
If you just keep them on top (not really sure how hard it is for you), I
can just remove them all and apply a new series on top.
