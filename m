From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: legacy mode
Date: Thu, 27 Aug 2015 15:21:37 -0500
Message-ID: <20150827202137.GA4221@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

after the unified cgroup overview at the containers mini-summit last week,
I mentioned the idea of supporting backward-compatible cgroupfs mounts in
the unified hierarchy.

The problem this would solve is running older userspace (i.e. libvirt in
a container running an older distro) on a newer kernel which has unified
hierarchy mounted.

I was thinking this could do the same tricks I'm doing in cgmanager to
support the existing cgmanager API with the unified hierarchy:  i.e. create
a leaf node for every cgroup, and redirect any tasks written to the
cgroup.procs file for $cgroup to $cgroup/.leaf.  I realize there will
likely be other changes, but keeping in mind that new unified-only features
aren't relevant for legacy support, maybe this sort of approach wouldn't
be as bad as I originally thought it would be.  Not supporting release-agent
is also a non-issue imo.

The combination of cgroup namespaces, a "legacy-mount" mode, and fully
proper hierarchical support leading to full safe delegation, would
allow cgmanager and lxcfs to be killed with extreme privilege - WIN!

So is anyone interested on working on a legacy mount option?  What other
issues need to be considered there?

thanks,
-serge
