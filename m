From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 4/7] cgroup: rstat: support cgroup1
Date: Thu, 4 Feb 2021 17:42:23 +0100
Message-ID: <YBwj7wC4+mVcx8GO@dhcp22.suse.cz>
References: <20210202184746.119084-1-hannes@cmpxchg.org>
 <20210202184746.119084-5-hannes@cmpxchg.org>
 <YBv5Dc1I9QpPH69n@dhcp22.suse.cz>
 <YBwaWkJgqPNF3I3w@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612456944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wsgw8MnfsGuS5yxbjBVn1LDBc6ZqPnfi34fb3SCAx6k=;
        b=NgWdQMlyE3luXm8XWKjVOe9zxEg7WQv8SecLlF4cS78MHz5/hEi4X7DpQCw0sW1QSTz4hN
        nktjmzFeN8/ZAV74ArRlOObu1QFbDkAvWW+gvQ0q7FaQ1W8UipbvtGwvyayYl/wCbxfbkn
        Sjl3ubKHaA2GT9ueS1b9xCOOoCMP6GU=
Content-Disposition: inline
In-Reply-To: <YBwaWkJgqPNF3I3w-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu 04-02-21 11:01:30, Johannes Weiner wrote:
> On Thu, Feb 04, 2021 at 02:39:25PM +0100, Michal Hocko wrote:
> > On Tue 02-02-21 13:47:43, Johannes Weiner wrote:
> > > Rstat currently only supports the default hierarchy in cgroup2. In
> > > order to replace memcg's private stats infrastructure - used in both
> > > cgroup1 and cgroup2 - with rstat, the latter needs to support cgroup1.
> > > 
> > > The initialization and destruction callbacks for regular cgroups are
> > > already in place. Remove the cgroup_on_dfl() guards to handle cgroup1.
> > > 
> > > The initialization of the root cgroup is currently hardcoded to only
> > > handle cgrp_dfl_root.cgrp. Move those callbacks to cgroup_setup_root()
> > > and cgroup_destroy_root() to handle the default root as well as the
> > > various cgroup1 roots we may set up during mounting.
> > > 
> > > The linking of css to cgroups happens in code shared between cgroup1
> > > and cgroup2 as well. Simply remove the cgroup_on_dfl() guard.
> > > 
> > > Linkage of the root css to the root cgroup is a bit trickier: per
> > > default, the root css of a subsystem controller belongs to the default
> > > hierarchy (i.e. the cgroup2 root). When a controller is mounted in its
> > > cgroup1 version, the root css is stolen and moved to the cgroup1 root;
> > > on unmount, the css moves back to the default hierarchy. Annotate
> > > rebind_subsystems() to move the root css linkage along between roots.
> > 
> > I am not familiar with rstat API and from this patch it is not really
> > clear to me how does it deal with memcg v1 use_hierarchy oddness.
> 
> That's gone, right?
> 
> static int mem_cgroup_hierarchy_write(struct cgroup_subsys_state *css,
>                                       struct cftype *cft, u64 val)
> {
>         if (val == 1)
>                 return 0;
> 
>         pr_warn_once("Non-hierarchical mode is deprecated. "
>                      "Please report your usecase to linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org if you "
>                      "depend on this functionality.\n");
> 
>         return -EINVAL;
> }

Ohh, right! I have completely forgot it hit the Linus tree.

-- 
Michal Hocko
SUSE Labs
