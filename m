From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] Documentation/cgroup-v1: fix outdated programming
 details
Date: Tue, 2 Jan 2018 07:05:02 -0800
Message-ID: <20180102150502.GC3668920@devbig577.frc2.facebook.com>
References: <20171229200200.18873-1-matthew.d.roper@intel.com>
 <20171229203449.GS5820@mdroper-desk.amr.corp.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YTR7IrLSTCXIRwPvHmTQ+lVzrKs6OoNUOamduXwtZYU=;
        b=GHX27r/xvbn2avfPAggDg475ErlGKwmlGXN71iXQLjqyNhOEJF42z6JGCizxknQtB7
         5vsZvG391dr7Jo2ifllF2tEB0ciJDNfn7WAvdnb9X2g4Bs/APZjJLhIQwS4quFGuRw3F
         Ttg7P+7XtwKnJKE1icTL7Wqsa3zkyi1S++V7Ttc8M1mVU+2HanFZWaBmSQo4dnw6nInz
         QzE032N1MW3xSyjAJvN/xn53ZltgyO4arUNrqW2G4Pw0WFAn2QgsXZMwyQjzlGhbSYbT
         bfhsm0FBPoxzGHO4gfrzFrJza0dwA561RA0oNptHG8ZtvrjJLYg9o8et72KonoAHbp8Y
         gMsw==
Content-Disposition: inline
In-Reply-To: <20171229203449.GS5820-b/RNqDZ/lqH1fpGqjiHozbKMmGWinSIL2HeeBUIffwg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Matt.

On Fri, Dec 29, 2017 at 12:34:49PM -0800, Matt Roper wrote:
> If a system is already using a cgroups-v2 hierarchy to manage other
> system resources via the standard controllers, I think it would be ideal
> if we could leverage that existing process organization to supply i915
> with desired driver-specific policy and resource assignments.  Since
> cgroup controllers don't seem to support this at the moment, is there an
> alternate mechanism I should be looking at instead?  Or is this a type
> of use case that we may want to evolve cgroups to support in a different
> manner?

cgroup membership of a task and the hierarchical relationships of
cgroups can be determined trivially.  Unless the resource in question
needs to and can strictly follow the resource rules for cgroup
controllers, which can become really involving and invasive, the
better and easier approach is using cgroup membership as an extra
information from the subsystem, which is how the network and bpf
handle cgroup membership too.

Thanks.

-- 
tejun
