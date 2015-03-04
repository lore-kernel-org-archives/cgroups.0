From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: Let mem_cgroup_move_account() have
 effect only if MMU enabled
Date: Wed, 4 Mar 2015 12:40:56 -0500
Message-ID: <20150304174056.GA20376@phnom.home.cmpxchg.org>
References: <54F4E739.6040805@qq.com>
 <20150303134524.GE2409@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150303134524.GE2409-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Chen Gang <762976180-9uewiaClKEY@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Mar 03, 2015 at 02:45:24PM +0100, Michal Hocko wrote:
> On Tue 03-03-15 06:42:01, Chen Gang wrote:
> > When !MMU, it will report warning. The related warning with allmodconfig
> > under c6x:
> 
> Does it even make any sense to enable CONFIG_MEMCG when !CONFIG_MMU?
> Is anybody using this configuration and is it actually usable? My
> knowledge about CONFIG_MMU is close to zero so I might be missing
> something but I do not see a point into fixing compile warnings when
> the whole subsystem is not usable in the first place.

It's very limited, and anonymous memory is not even charged right now,
even though it could be -- see nommu.c::do_mmap_private().  But there
is nothing inherent in the memcg functionality that would require an
MMU I guess, except for these ridiculous charge moving pte walkers.

> > Signed-off-by: Chen Gang <gang.chen.5i5j-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
