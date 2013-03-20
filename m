From: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/5] memcg: provide root figures from system totals
Date: Wed, 20 Mar 2013 09:40:48 -0700
Message-ID: <20130320164047.GA22177@lizard.fhda.edu>
References: <1362489058-3455-1-git-send-email-glommer@parallels.com>
 <1362489058-3455-3-git-send-email-glommer@parallels.com>
 <20130319124650.GE7869@dhcp22.suse.cz>
 <20130319125509.GF7869@dhcp22.suse.cz>
 <51495F35.9040302@parallels.com>
 <20130320080347.GE20045@dhcp22.suse.cz>
 <51496E71.5010707@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51496E71.5010707-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>

On Wed, Mar 20, 2013 at 12:08:17PM +0400, Glauber Costa wrote:
[...]
> >> The fact that I keep bypassing when hierarchy is present, it is
> >> more of a reuse of the infrastructure since it's there anyway.
> >>
> >> Also, I would like the root memcg to be usable, albeit cheap, for
> >> projects like memory pressure notifications.
> >  
> > root memcg without any childre, right?
> > 
> yes, of course.

Just want to raise a voice of support for this one. Thanks to Glauber's
efforts, we might not need another memory pressure interface for
CONFIG_MEMCG=n case, since we might have CONFIG_MEMCG=y that will be super
cheap when used with just a root memcg w/o children, and still usable for
mem pressure. So this particular scenario is actually in demand[1].

Thanks!

Anton

[1] http://lkml.indiana.edu/hypermail/linux/kernel/1302.2/03173.html
