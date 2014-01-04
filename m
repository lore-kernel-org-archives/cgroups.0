From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/4] x86: Add Cache QoS Monitoring (CQM) support
Date: Sat, 4 Jan 2014 11:10:50 -0500
Message-ID: <20140104161050.GA24306@htj.dyndns.org>
References: <1388781285-18067-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=UYvHOdglf2XjjnSd6ikxv1nJbwHhcPXULvsoD/Nrs5c=;
        b=RbZ/yY2u4iMtWgGkv7u79NiJIn4IdeaLUYheMkUL863VoJYioWKUjueqhnd3ojkEVy
         dFD8bVMstjuFvGTJXVgpWNB9ivvplioDJ7WiVwvkz9Kufp0w+srbZ+Gybq6gRVOEF7Bo
         72HWmEGi1ZzqIR5qjdQ+x8Vn3zlkVWJP/OQgCOn22/pJLuw+iwooF0ZGqSoyMCWO6qL9
         kDftAxajCEQmfJv34MthriE7Bu67+q1+nuGG/HfG+ZGqTwn5QwEmhBWvm/zM98AndVzG
         hJtXz21hoHDAJTFlJCWlNun3EJ8cSXAdZFFaaFLlupNd37dGTvJAmTDqccwiW7Labs+j
         GhdA==
Content-Disposition: inline
In-Reply-To: <1388781285-18067-1-git-send-email-peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Jan 03, 2014 at 12:34:41PM -0800, Peter P Waskiewicz Jr wrote:
> The CPU features themselves are relatively straight-forward, but
> the presentation of the data is less straight-forward.  Since this
> tracks cache usage and occupancy per process (by swapping Resource
> Monitor IDs, or RMIDs, when processes are rescheduled), perf would
> not be a good fit for this data, which does not report on a
> per-process level.  Therefore, a new cgroup subsystem, cacheqos, has
> been added.  This operates very similarly to the cpu and cpuacct
> cgroup subsystems, where tasks can be grouped into sub-leaves of the
> root-level cgroup.

I don't really understand why this is implemented as part of cgroup.
There doesn't seem to be anything which requires cgroup.  Wouldn't
just doing it per-process make more sense?  Even grouping would be
better done along the traditional process hierarchy, no?  And
per-cgroup accounting can be trivially achieved from userland by just
accumulating the stats according to the process's cgroup membership.
What am I missing here?

Thanks.

-- 
tejun
