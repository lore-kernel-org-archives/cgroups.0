From: Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.11 1/3] cgroup: mark "tasks" cgroup file
 as  insane
Date: Fri, 7 Jun 2013 07:10:40 +0200
Message-ID: <20130607051040.GA1364@tango.0pointer.de>
References: <20130604021302.GH29989@mtj.dyndns.org>
 <20130604111556.GA4963@redhat.com>
 <20130604201947.GE14916@htj.dyndns.org>
 <20130606092055.GF30217@redhat.com>
 <20130606211410.GF5045@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130606211410.GF5045-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, kay.sievers-tD+1rO4QERM@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 06.06.13 14:14, Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org) wrote:

> > You say the old interface will be around for the forseeable future, but
> > if systemd starts applying a different setup to comply with your new
> > scheme, then libvirt does get given any option to continue to use the
> > old scheme. So even if you leave old interfaces around, we're going to
> > be forced to change. That's not really a back-compatibility story that
> > works for applications.
> 
> Even after unified hierarchy, it will be possible to tell systemd to
> not to do that and the system should be able to continue using
> multiple hierarchies as before.  Nothing really should change in that
> respect.  It may not be the prettiest but is still a workable
> compatibility.

Uhm. So I don't think we will support two ways to set this up for long
in systemd (if at all). And even if we did, the distributions would pick
one or the other as default, and if you are unlucky, then you couldn't
run libvirt on it without reconfiguration and rebooting to get the other
cgroup setup logic...

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
