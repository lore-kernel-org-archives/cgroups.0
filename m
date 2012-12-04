From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 3/4] memcg: split part of memcg creation to css_online
Date: Tue, 4 Dec 2012 09:52:28 +0100
Message-ID: <20121204085228.GD31319@dhcp22.suse.cz>
References: <1354282286-32278-1-git-send-email-glommer@parallels.com>
 <1354282286-32278-4-git-send-email-glommer@parallels.com>
 <20121203173205.GI17093@dhcp22.suse.cz>
 <50BDAEC1.8040805@parallels.com>
 <20121204081756.GA31319@dhcp22.suse.cz>
 <50BDB511.5070107@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50BDB511.5070107-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Tue 04-12-12 12:32:17, Glauber Costa wrote:
> On 12/04/2012 12:17 PM, Michal Hocko wrote:
> >> But it should be extremely easy to protect against this. It is just a
> >> > matter of not returning online css in the iterator: then we'll never see
> >> > them until they are online. This also sounds a lot more correct than
> >> > returning allocated css.
> > Yes but... Look at your other patch which relies on iterator when counting
> > children to find out if there is any available.
> >  
> And what is the problem with it ?

Bahh. Right you are because the value is copied only at the css_online
time.  So even if mem_cgroup_hierarchy_write wouldn't see any child
(because they are still offline) and managed to set use_hierarchy=1 with
some children linked in all would be fixed in mem_cgroup_css_online.

P.S.
Hey mhocko stop saying crap.
-- 
Michal Hocko
SUSE Labs
