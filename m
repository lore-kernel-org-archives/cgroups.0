From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Thu, 26 Jan 2023 20:13:47 +0100
Message-ID: <Y9LQ615H13RmG7wL@dhcp22.suse.cz>
References: <20230125073502.743446-1-leobras@redhat.com>
 <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
 <Y9IvoDJbLbFcitTc@dhcp22.suse.cz>
 <Y9LDAZmApLeffrT8@tpad>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674760428; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YnzrMwJWnqV7xEolFqXRf8x90j0rKrmMDrv1KOIfhio=;
        b=ei5CGv7oFwVoJj4dBnXnDv29lsXPo+m8Uh+bxtoV2rpzhI8Q3sewvDYNPeZ/J56Sf6OI/Q
        5BPy50FL8QTq/BqhaG6lmuZRaASdcaPCCLxrr2JAro6T5byuInzzNprRAb2ILLPx0l12Cs
        0UkqAkcvrZYEOQ0rOMzZlDb5OKXRfCA=
Content-Disposition: inline
In-Reply-To: <Y9LDAZmApLeffrT8@tpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 26-01-23 15:14:25, Marcelo Tosatti wrote:
> On Thu, Jan 26, 2023 at 08:45:36AM +0100, Michal Hocko wrote:
> > On Wed 25-01-23 15:22:00, Marcelo Tosatti wrote:
> > [...]
> > > Remote draining reduces interruptions whether CPU 
> > > is marked as isolated or not:
> > > 
> > > - Allows isolated CPUs from benefiting of pcp caching.
> > > - Removes the interruption to non isolated CPUs. See for example 
> > > 
> > > https://lkml.org/lkml/2022/6/13/2769
> > 
> > This is talking about page allocato per cpu caches, right? In this patch
> > we are talking about memcg pcp caches. Are you sure the same applies
> > here?
> 
> Both can stall the users of the drain operation.

Yes. But it is important to consider who those users are. We are
draining when
	- we are charging and the limit is hit so that memory reclaim
	  has to be triggered.
	- hard, high limits are set and require memory reclaim.
	- force_empty - full memory reclaim for a memcg
	- memcg offlining - cgroup removel - quite a heavy operation as
	  well.
all those could be really costly kernel operations and they affect
isolated cpu only if the same memcg is used by both isolated and non-isolated
cpus. In other words those costly operations would have to be triggered
from non-isolated cpus and those are to be expected to be stalled. It is
the side effect of the local cpu draining that is scheduled that affects
the isolated cpu as well.

Is that more clear?
-- 
Michal Hocko
SUSE Labs
