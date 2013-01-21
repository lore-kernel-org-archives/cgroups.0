From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 2/7] memcg: split part of memcg creation to css_online
Date: Mon, 21 Jan 2013 11:33:20 +0400
Message-ID: <50FCEF40.8040709@parallels.com>
References: <1357897527-15479-1-git-send-email-glommer@parallels.com> <1357897527-15479-3-git-send-email-glommer@parallels.com> <20130118152526.GF10701@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130118152526.GF10701-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 01/18/2013 07:25 PM, Michal Hocko wrote:
>> -	spin_lock_init(&memcg->move_lock);
>> > +	memcg->swappiness = mem_cgroup_swappiness(parent);
> Please move this up to oom_kill_disable and use_hierarchy
> initialization.

One thing: wouldn't moving it to inside use_hierarchy be a change of
behavior here?
