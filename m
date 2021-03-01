From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 2/3] mm: Force update of mem cgroup soft limit tree on
 usage excess
Date: Mon, 1 Mar 2021 08:39:23 +0100
Message-ID: <YDyaK2wSKc80c4vM@dhcp22.suse.cz>
References: <YC+ApsntwnlVfCuK@dhcp22.suse.cz>
 <884d7559-e118-3773-351d-84c02642ca96@linux.intel.com>
 <YDNuAIztiGJpLEtw@dhcp22.suse.cz>
 <e132f836-b5d5-3776-22d6-669e713983e4@linux.intel.com>
 <YDQBh5th9txxEFUm@dhcp22.suse.cz>
 <cf5ca7a1-7965-f307-22e1-e216316904cf@linux.intel.com>
 <YDY+PydRUGQpHNaJ@dhcp22.suse.cz>
 <b5b1944d-846b-3212-fe4a-f10f5fcb87d7@linux.intel.com>
 <YDi2udQqIML6Vdpo@dhcp22.suse.cz>
 <781634ee-ffb9-598d-fdb6-0ae6067448b7@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614584364; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=34KjJW6+smFTvdlwXxTHDLwnzuvbuoymQf/sE3k7JDk=;
        b=vU+v0gpxQZomsgNvE8gpmxUfse2pH+A/rl+TVwbFGvyrWd8cPG1s4z3QEmjtqqVzhvUOGz
        CNOgbtrM+9vHwXEKis5Iw6Dx2e/rVoIweBr7mXZ+roPJJXen8HgAP06WQiIoWY0oB3d4Cv
        uQmB3+xzn6iXB4207y2xgFbDmKCiDR4=
Content-Disposition: inline
In-Reply-To: <781634ee-ffb9-598d-fdb6-0ae6067448b7-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 26-02-21 16:56:28, Tim Chen wrote:
> 
> 
> On 2/26/21 12:52 AM, Michal Hocko wrote:
> 
> >>
> >> Michal,
> >>
> >> Let's take an extreme case where memcg 1 always generate the
> >> first event and memcg 2 generates the rest of 128*8-1 events
> >> and the pattern repeat.
> > 
> > I do not follow. Events are per-memcg, aren't they?
> > 	__this_cpu_read(memcg->vmstats_percpu->targets[target]);
> > 	[...]
> > 	__this_cpu_write(memcg->vmstats_percpu->targets[target], next);
> > 
> 
> You are right. My previous reasoning is incorrect as the sampling is done per memcg.
> I'll do some additional debugging on why memcg is not on the tree.

OK, thanks for the confirmation. I think we want to do 2 things. Remove
the soft limit specific threshold and stay with a single one and
recognize THPs.
-- 
Michal Hocko
SUSE Labs
