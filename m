From: Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.11] cgroup: disallow rename(2) if
  sane_behavior
Date: Mon, 17 Jun 2013 18:33:53 +0200
Message-ID: <20130617163353.GD22846@tango.0pointer.de>
References: <20130614034717.GA31533@htj.dyndns.org>
 <20130616071648.GA1978@tango.0pointer.de>
 <20130616221556.GC28587@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130616221556.GC28587-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Sun, 16.06.13 15:15, Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org) wrote:

> We want composability regardless of migration, but as for migration
> itself, an alternative could be having an atomic "move everything in
> cgroup A to cgroup B" interface, so that the admin (whether human or
> base system software) can set up a new cgroup and then move the member
> tasks atomically.

I am not sure this would cut it for containers. For containers we'll
usually have a fully populated cgroup subtree, and if we want to migrate
that somewhere else, then we'd something that works recursively and
allows us to not tell the container at all about the move (i.e. the
namespace of cgroupfs the container sees should ideall stay entirely
unaltered by the move).

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
