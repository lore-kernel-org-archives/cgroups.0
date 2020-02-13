From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Thu, 13 Feb 2020 08:53:48 -0500
Message-ID: <20200213135348.GF88887@mtj.thefacebook.com>
References: <20191219200718.15696-1-hannes@cmpxchg.org>
 <20191219200718.15696-4-hannes@cmpxchg.org>
 <20200130170020.GZ24244@dhcp22.suse.cz>
 <20200203215201.GD6380@cmpxchg.org>
 <20200211164753.GQ10636@dhcp22.suse.cz>
 <20200212170826.GC180867@cmpxchg.org>
 <20200213074049.GA31689@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NlK/bjEFsXh3ZUaRYaJXsg13O7KnRNlLmTitoPpLaEE=;
        b=RD/t0DYRkjg2v0l7LbvA1SM3AhbagXxt34WCWdJhaFpgAzoMY6e+khjk2cwPGiR10D
         aTFgnm5hT+CUSE4PuyoIcbZGiMBw7krH7p2VHybmp6fcs7owpHIAifcL7TuNJ1HKRXNH
         0wZN68Y99o9IJh+nKtSLFVurRhV/pla+3AZxXyAwMq6ifvSw/w33GOVWIBjgAGEbr+cx
         ttic9M1HePVTJBn7XEeY5P/9nk5eQpVDFRNKpwB0ueYpnmBijtIECdbY+eawzmMM0vme
         CwWnXscLtVr9I9yGj29HLPTB2lhjTczuCOTtgZ9WbuCCtFU3F43OwD6ecTUG9Gnqom/i
         ieVg==
Content-Disposition: inline
In-Reply-To: <20200213074049.GA31689-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello, Michal.

On Thu, Feb 13, 2020 at 08:40:49AM +0100, Michal Hocko wrote:
> So how are we going to deal with hierarchies where the actual workload
> of interest is a leaf deeper in the hierarchy and the upper levels of
> the hierarchy are shared between unrelated workloads?  Look at how
> systemd organizes system into cgroups for example (slices vs. scopes)
> and say you want to add a protection to a single user or a service.

The above scenario where descendants of a cgroup behave unrelated to
each other sound plausible in theory but doesn't really work in
practice because memory management is closely tied with IO and all IO
control mechanisms are strictly hierarchical and arbitrate
level-by-level.

A workload's memory footprint can't be protected without protecting
its IOs and a descendant cgroup's IOs can't be protected without
protecting its ancestors, so implementing that in memory controller in
isolation, while doable, won't serve many practical purposes. It just
ends up creating cgroups which are punished on memory while greedly
burning up IOs.

The same pattern for CPU control, so for any practical configuration,
the hierarchy layout has to follow the resource distribution hierarchy
of the system - it's what the whole thing is for after all. The
existing memory.min/low semantics is mostly from failing to recognize
them being closely intertwined with IO and resembling weight based
control mechanisms, and rather blindly copying memory.high/max
behaviors, for which, btw, individual configurations may make sense.

Thanks.

-- 
tejun
