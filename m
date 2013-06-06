From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v10 03/35] dcache: convert dentry_stat.nr_unused to
 per-cpu counters
Date: Fri, 7 Jun 2013 09:42:04 +1000
Message-ID: <20130606234204.GF29338@dastard>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org>
 <1370287804-3481-4-git-send-email-glommer@openvz.org>
 <20130605160731.91a5cd3ff700367f5e155d83@linux-foundation.org>
 <20130606014509.GN29338@dastard>
 <20130605194801.f9b25abf.akpm@linux-foundation.org>
 <51B0834A.8020606@parallels.com>
 <20130606152546.52f614d852da32d28a0b460f@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130606152546.52f614d852da32d28a0b460f-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, Jun 06, 2013 at 03:25:46PM -0700, Andrew Morton wrote:
> On Thu, 6 Jun 2013 16:40:42 +0400 Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> 
> > +/*
> > + * Here we resort to our own counters instead of using generic per-cpu counters
> > + * for consistency with what the vfs inode code does. We are expected to harvest
> > + * better code and performance by having our own specialized counters.
> > + *
> > + * Please note that the loop is done over all possible CPUs, not over all online
> > + * CPUs. The reason for this is that we don't want to play games with CPUs going
> > + * on and off. If one of them goes off, we will just keep their counters.
> > + *
> > + * glommer: See cffbc8a for details, and if you ever intend to change this,
> > + * please update all vfs counters to match.
> 
> Handling CPU hotplug is really quite simple - see lib/percpu_counter.c

Yes, it is - you're preaching to the choir, Andrew.

But, well, if you want us to add notifiers to optimise the summation
to just the active CPUs, then lets just covert the code to use the
generic per-cpu counters and stop wasting time rehashing tired old
arguments.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
