From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 2/7] memcg: split part of memcg creation to css_online
Date: Mon, 21 Jan 2013 09:38:28 +0100
Message-ID: <20130121083828.GB7798@dhcp22.suse.cz>
References: <1357897527-15479-1-git-send-email-glommer@parallels.com>
 <1357897527-15479-3-git-send-email-glommer@parallels.com>
 <20130118152526.GF10701@dhcp22.suse.cz>
 <50FCEF40.8040709@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50FCEF40.8040709-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Mon 21-01-13 11:33:20, Glauber Costa wrote:
> On 01/18/2013 07:25 PM, Michal Hocko wrote:
> >> -	spin_lock_init(&memcg->move_lock);
> >> > +	memcg->swappiness = mem_cgroup_swappiness(parent);
> > Please move this up to oom_kill_disable and use_hierarchy
> > initialization.
> 
> One thing: wouldn't moving it to inside use_hierarchy be a change of
> behavior here?

I do not see how it would change the behavior. But maybe I wasn't clear
enough. I just wanted to make all three:
	memcg->use_hierarchy = parent->use_hierarchy;
	memcg->oom_kill_disable = parent->oom_kill_disable;
	memcg->swappiness = mem_cgroup_swappiness(parent);

in the same visual block so that we can split the function into three
parts. Inherited values which don't depend on use_hierarchy, those that
depend on use_hierarchy and the rest that depends on the previous
decisions (kmem e.g.).
Makes sense?

-- 
Michal Hocko
SUSE Labs
