From: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] Documentation/cgroup-v1: fix outdated programming
 details
Date: Fri, 29 Dec 2017 12:34:49 -0800
Message-ID: <20171229203449.GS5820@mdroper-desk.amr.corp.intel.com>
References: <20171229200200.18873-1-matthew.d.roper@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171229200200.18873-1-matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Fri, Dec 29, 2017 at 12:01:59PM -0800, Matt Roper wrote:
> The cgroup-v1 documentation is out of date in a few places:
> 
>  * cgroup controllers can no longer be compiled as modules since commit
>    3ed80a6 ("cgroup: drop module support"); the functions and fields
>    referenced here no longer exist.
...

This is actually exactly what I was digging into the cgroups
documentation to figure out how to do.  I was hoping to be able to
create a controller inside an existing device driver that could manage
driver-specific policy and resources.  However based on the explanation
given in https://www.spinics.net/lists/cgroups/msg10077.html , it sounds
like this isn't really a direction that the cgroups framework wants to
go.

My specific goal was to use the cgroups-v2 hierarchy to assign i915
(GPU) workloads with an initial priority according to the cgroup
classification of the submitting process.  In the future I could also
see driver-specific cgroup controllers potentially being useful for
managing specialized resources like graphics-specific stolen memory or
video RAM on discrete gpu's.

If a system is already using a cgroups-v2 hierarchy to manage other
system resources via the standard controllers, I think it would be ideal
if we could leverage that existing process organization to supply i915
with desired driver-specific policy and resource assignments.  Since
cgroup controllers don't seem to support this at the moment, is there an
alternate mechanism I should be looking at instead?  Or is this a type
of use case that we may want to evolve cgroups to support in a different
manner?

Thanks!


Matt

-- 
Matt Roper
Graphics Software Engineer
IoTG Platform Enabling & Development
Intel Corporation
(916) 356-2795
