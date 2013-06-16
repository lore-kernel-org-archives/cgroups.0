From: Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.11] cgroup: disallow rename(2) if
 sane_behavior
Date: Sun, 16 Jun 2013 09:16:48 +0200
Message-ID: <20130616071648.GA1978@tango.0pointer.de>
References: <20130614034717.GA31533@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130614034717.GA31533-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>

On Thu, 13.06.13 20:47, Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org) wrote:

> cgroup's rename(2) isn't a proper migration implementation - it can't
> move the cgroup to a different parent in the hierarchy.  All it can do
> is swapping the name string for that cgroup.  This isn't useful and
> can mislead users to think that cgroup supports proper cgroup-level
> migration.  Disallow rename(2) if sane_behavior.

Note that in the long run I'd really like to see functionality added to
move a full cgroup subtree to a different point in the tree, so that we
can migrate containers and such atomically from one partition to
another, without the container having to be aware of this (which of
course implies that we have a somewhat more useful cgroup namespacing
solution in place).

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
