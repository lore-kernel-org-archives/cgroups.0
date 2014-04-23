From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] device_cgroup: rework device access check and exception
 checking
Date: Wed, 23 Apr 2014 10:32:27 -0400
Message-ID: <20140423143226.GK29214@redhat.com>
References: <20140421161303.GG29214@redhat.com>
 <20140421223253.GB22730@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140421223253.GB22730-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Apr 21, 2014 at 06:32:53PM -0400, Tejun Heo wrote:
> On Mon, Apr 21, 2014 at 12:13:03PM -0400, Aristeu Rozanski wrote:
> > Whenever a device file is opened and checked against current device
> > cgroup rules, it uses the same function (may_access()) as when a new
> > exception rule is added by writing devices.{allow,deny}. And in both
> > cases, the algorithm is the same, doesn't matter the behavior.
> ...
> > Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> > Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Signed-off-by: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Applied to cgroup/for-3.15-fixes.
> 
> A nit: Can you please prepare a separate patch to reformat the
> function comments.  The usual style is single line at the top for the
> function name and brief description.  The actual description should
> come after the param list.

Will submit with a v3, another bug found :\

-- 
Aristeu
