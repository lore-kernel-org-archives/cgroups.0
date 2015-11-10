From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup_pids: add fork limit
Date: Tue, 10 Nov 2015 10:44:18 -0500
Message-ID: <20151110154418.GA5275@mtj.duckdns.org>
References: <144716440621.20175.1000688899886388119.stgit@rabbit.intern.cm-ag>
 <20151110151223.GA17938@mtj.duckdns.org>
 <20151110153746.GA20758@rabbit.intern.cm-ag>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=lA4ZEUW2PtvGKJrXXzc3q2VF9JjUJRKxhwLciSJ16QY=;
        b=xBDbpiR7AC+mHGi+Z/xLx9Zja7zpKwc44HbOleh2EemtLkEZ15Lf7kQNLYS5T3tz3F
         SBl830rNh+IWX/Ord4bq/Ydfl3d45QVOI7MAbHxDp4oHvhFb63g/+nlKXjGE/whe22RV
         nn6SR2ioH6acclTgH4ri204YoxXdbw6sNpI7nkmt3pUmUk0GqD28Bzlu0nqV4fx3zsqs
         iO0lTGCg3vFuznHkEjgVj2WftpQLMBcu6O8BrvPSnvcxLNUBp9ypJmFuVLInb8n0WZAt
         tEc6eX2vsDm6vMXDUxc+lb5mCmqwUSehCkfH9MkbF2uvQ8Q/wzTmm2zsZ1YyHZVtwtQl
         oxGA==
Content-Disposition: inline
In-Reply-To: <20151110153746.GA20758-Rjmu19FXx3rR8JxBgnUBv+rzNCUFrscg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Max.

On Tue, Nov 10, 2015 at 04:37:46PM +0100, Max Kellermann wrote:
> > But what's the resource here?
> 
> CPU consumption and memory bandwidth.  A fork/clone is an operation

Both are abstracted as CPU usage and controlled by the cpu controller.

> that puts considerable load on a machine, most of which happens in
> kernel space (copying page tables etc.).
> 
> > All first-order resources which can be consumed by forking
> > repeatedly already have proper controllers.
> 
> They do?

Yes.

> I can limit CPU time with RLIMIT_CPU, but that's per-process and thus
> completely useless.  There's no cgroup controller with such a feature.

There's the cpu controller

> There's "cpu" which changes priority, "cpuset" selects CPUs, "cpuacct"

The cpu controller can limit both in terms of relative weight and
absolute CPU cycle bandwidth.

> only does accounting and "freezer" (somewhat related).  But nothing
> that limits CPU usage according to configured rules.
> 
> I can limit absolute memory usage with memcg, which is a good thing,
> but is orthogonal to this feature.  Note that there are already
> various RLIMITs about memory usage, and despite that, memcg was
> merged due to RLIMIT shortcomings.
> 
> "pids" was merged even though there already was RLIMIT_NPROC.  Again,
> RLIMITs have their shortcomings.

Because pids turned out to be a first-order resource which is not
contrained by memory due to the limited pid space.

> But which controllers can I use to achieve the same effect as my fork
> limit feature?  Did I miss one?

Apparently.

> > What's the point of adding an extra second-order controller?
> 
> I explained that, and you just cited my explanation.
> 
> > Where do we go from there?  Limit on the number of syscalls?
> 
> No idea.  Are these questions really relevant for my patch?

Well, it's relevant to the fact that it's failing to distinguish what
are actual resources and what aren't.

Thanks.

-- 
tejun
