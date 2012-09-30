From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Sun, 30 Sep 2012 16:57:00 +0900
Message-ID: <20120930075700.GE10383@mtj.dyndns.org>
References: <20120926221046.GA10453@mtj.dyndns.org>
 <506381B2.2060806@parallels.com>
 <20120926224235.GB10453@mtj.dyndns.org>
 <50638793.7060806@parallels.com>
 <20120926230807.GC10453@mtj.dyndns.org>
 <20120927142822.GG3429@suse.de>
 <20120927144942.GB4251@mtj.dyndns.org>
 <50646977.40300@parallels.com>
 <20120927174605.GA2713@localhost>
 <50649EAD.2050306@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=G4L6ycz5f+No/L1NwYK+S+HNYss5CbwhGi0g9peabW4=;
        b=mBSKJ8ATD2m2g50uWvN81wIM82jZ+2axqvGgCZWVPLGx4k7A8diRexbjFq3rU/Tt9u
         IJbQZUEAv/hmrOoumE5zvs6sdrtq+QHkcwZZUBfDiwqBdlhUpQhUcpiOQ1B+Ch1XwrXV
         y5DGNFvNAWbXcMDloNBqhtiJOepMwyGTJOPZxyDiYhH3zL3MGuLEBJ8n5jeGbXCGOGl+
         GgNtYwUdJRH2CauPJrkfiZtE7F3QenbJGZdNBJcr73clf67OYVGbR7ISfl/CfDCYKOes
         AG4IZow7tk9D1GGXZ3XnqGx8QTlX9pufc4NCmpy36+o2gKgvlRlyXrpxWU1exHLag86r
         PjOA==
Content-Disposition: inline
In-Reply-To: <50649EAD.2050306-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Glauber.

On Thu, Sep 27, 2012 at 10:45:01PM +0400, Glauber Costa wrote:
> > Can you please give other examples of cases where this type of issue
> > exists (plenty of shared kernel data structure which is inherent to
> > the workload at hand)?  Until now, this has been the only example for
> > this type of issues.
> 
> Yes. the namespace related caches (*), all kinds of sockets and network
> structures, other file system structures like file struct, vm areas, and
> pretty much everything a full container does.
> 
> (*) we run full userspace, so we have namespaces + cgroups combination.

This is probably me being dumb but wouldn't resources used by full
namespaces be mostly independent?  Which parts get shared?  Also, if
you do full namespace, isn't it more likely that you would want fuller
resource isolation too?

> >> Mel suggestion of not allowing this to happen once the cgroup has tasks
> >> takes care of this, and is something I thought of myself.
> > 
> > You mean Michal's?  It should also disallow switching if there are
> > children cgroups, right?
> 
> No, I meant Mel, quoting this:
> 
> "Further I would expect that an administrator would be aware of these
> limitations and set kmem_accounting at cgroup creation time before any
> processes start. Maybe that should be enforced but it's not a
> fundamental problem."
> 
> But I guess it is pretty much the same thing Michal proposes, in essence.
> 
> Or IOW, if your concern is with the fact that charges may have happened
> in the past before this is enabled, we can make sure this cannot happen
> by disallowing the limit to be set if currently unset (value changes are
> obviously fine) if you have children or any tasks already in the group.

Yeah, please do that.

Thanks.

-- 
tejun
