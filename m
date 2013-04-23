From: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] vmpressure: in-kernel notifications
Date: Tue, 23 Apr 2013 17:01:49 -0400
Message-ID: <20130423210149.GA9019@teo>
References: <1366705329-9426-1-git-send-email-glommer@openvz.org>
 <1366705329-9426-2-git-send-email-glommer@openvz.org>
 <20130423202446.GA2484@teo>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130423202446.GA2484@teo>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Tue, Apr 23, 2013 at 04:24:46PM -0400, Anton Vorontsov wrote:
[...]
> >  /**
> > + * vmpressure_register_kernel_event() - Register kernel-side notification
> 
> Why don't we need the unregister function? I see that the memcg portion
> deals with dangling memcgs, but do they dangle forver?

Oh, I got it. vmpressure_unregister_event() will unregister all the events
anyway. Cool.

Thanks!

Anton
