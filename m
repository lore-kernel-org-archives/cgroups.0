From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.13-fixes] cgroup: create dfl_root files on
 subsys registration
Date: Tue, 18 Jul 2017 18:09:16 -0400
Message-ID: <d44b7b53-0be6-7019-169a-aa45b4d02598@redhat.com>
References: <1500406336-29512-1-git-send-email-longman@redhat.com>
 <20170718195148.GC3365493@devbig577.frc2.facebook.com>
 <539870d2-8b85-2f54-61bd-4ba068e75ce0@redhat.com>
 <20170718201229.GD3365493@devbig577.frc2.facebook.com>
 <255cc198-2c10-af76-98ca-086807d11540@redhat.com>
 <20170718205009.GE3365493@devbig577.frc2.facebook.com>
 <20170718210658.GF3365493@devbig577.frc2.facebook.com>
 <20170718215746.GG3365493@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com B90E980476
In-Reply-To: <20170718215746.GG3365493-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 07/18/2017 05:57 PM, Tejun Heo wrote:
> On subsystem registration, css_populate_dir() is not called on the new
> root css, so the interface files for the subsystem on cgrp_dfl_root
> aren't created on registration.  This is a residue from the days when
> cgrp_dfl_root was used only as the parking spot for unused subsystems,
> which no longer is true as it's used as the root for cgroup2.
>
> This is often fine as later operations tend to create them as a part
> of mount (cgroup1) or subtree_control operations (cgroup2); however,
> it's not difficult to mount cgroup2 with the controller interface
> files missing as Waiman found out.
>
> Fix it by invoking css_populate_dir() on the root css on subsys
> registration.
>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v4.5+
> ---
> Hello, Waiman.
>
> Can you please verify that this fixes the bug?
>

Yes, this patch fix the problem.

Tested-by:  Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
