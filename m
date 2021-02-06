From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/8] cgroup: rstat: support cgroup1
Date: Fri, 5 Feb 2021 22:00:00 -0500
Message-ID: <YB4GMLKa56KLwBX2@mtj.duckdns.org>
References: <20210205182806.17220-1-hannes@cmpxchg.org>
 <20210205182806.17220-5-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jsYTfAyddo367IDFzdQpxCbNtMumdTCO9J/dsgKO1IE=;
        b=etfqZ32m21s7qD/Oo8PaMdd8ZJ/AMC7yYpO89fS0vn3zirJaF3BbEo+yKkwTUCjAQQ
         tGpXQnXizzt+65NyOovBqftshiZuHcEcbthq1v+JoPcZTMIGwQGtNe1uDUGmuAEM5jf8
         C4YE4cE5euCOF6XFWa04yEOVtg+EczKUgf7atmpXKWgRvbYrJzdPnT98ZiCnschwlUJL
         UcbCNJvEmmjljr0zNUEv5xkD/0w4KeBUl7c5l3ddI/DSX/DY3lqXqCyS5vEvyI5oWAAi
         hex4hpU3tvTApMqrqON756efcFVTYjwONs6e6ljXlJoj1hWfxZ3E9YTiMkUygSeQ6+QF
         Hu9A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210205182806.17220-5-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Feb 05, 2021 at 01:28:02PM -0500, Johannes Weiner wrote:
> Rstat currently only supports the default hierarchy in cgroup2. In
> order to replace memcg's private stats infrastructure - used in both
> cgroup1 and cgroup2 - with rstat, the latter needs to support cgroup1.
> 
> The initialization and destruction callbacks for regular cgroups are
> already in place. Remove the cgroup_on_dfl() guards to handle cgroup1.
> 
> The initialization of the root cgroup is currently hardcoded to only
> handle cgrp_dfl_root.cgrp. Move those callbacks to cgroup_setup_root()
> and cgroup_destroy_root() to handle the default root as well as the
> various cgroup1 roots we may set up during mounting.
> 
> The linking of css to cgroups happens in code shared between cgroup1
> and cgroup2 as well. Simply remove the cgroup_on_dfl() guard.
> 
> Linkage of the root css to the root cgroup is a bit trickier: per
> default, the root css of a subsystem controller belongs to the default
> hierarchy (i.e. the cgroup2 root). When a controller is mounted in its
> cgroup1 version, the root css is stolen and moved to the cgroup1 root;
> on unmount, the css moves back to the default hierarchy. Annotate
> rebind_subsystems() to move the root css linkage along between roots.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
