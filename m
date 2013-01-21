From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 4/6] memcg: replace cgroup_lock with memcg specific
 memcg_lock
Date: Mon, 21 Jan 2013 20:12:17 +0400
Message-ID: <50FD68E1.2070303@parallels.com>
References: <1358766813-15095-1-git-send-email-glommer@parallels.com> <1358766813-15095-5-git-send-email-glommer@parallels.com> <20130121144919.GO7798@dhcp22.suse.cz> <50FD5AC0.9020406@parallels.com> <20130121152032.GP7798@dhcp22.suse.cz> <50FD6003.8060703@parallels.com> <20130121160731.GQ7798@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130121160731.GQ7798-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

On 01/21/2013 08:07 PM, Michal Hocko wrote:
>> > And the reason why kmemcg holds the set_limit mutex
>> > is just to protect from itself, then there is no *need* to hold any
>> > extra lock (and we'll never be able to stop holding the creation lock,
>> > whatever it is). So my main point here is not memcg_mutex vs
>> > set_limit_mutex, but rather, memcg_mutex is needed anyway, and once it
>> > is taken, the set_limit_mutex *can* be held, but doesn't need to.
> So you can update kmem specific usage of set_limit_mutex.
Meaning ?
