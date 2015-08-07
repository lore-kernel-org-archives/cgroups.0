From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/3] cgroup: define controller file conventions
Date: Fri, 7 Aug 2015 20:17:23 +0200
Message-ID: <20150807181722.GA24877@dhcp22.suse.cz>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-2-git-send-email-tj@kernel.org>
 <20150804193101.GI17598@mtj.duckdns.org>
 <55C15B4C.9080202@jp.fujitsu.com>
 <20150805074758.GA11182@dhcp22.suse.cz>
 <55C2C6B0.3080203@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55C2C6B0.3080203-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu 06-08-15 11:30:08, KAMEZAWA Hiroyuki wrote:
[...]
> Sure. I think following has users.
>  - *.stat             - for chekcing health of cgroup ,or for debug

Yes but we want to have something which is closer to meminfo/vmstat IMO

>  - *.pressure_level   - for notifying memory pressure

Notifications are definitely useful I am just not sure this interface is
the right one. We have seen some requests to adjust the interface to get
new semantics (edge vs. level triggered). This should be sorted out
before we expose the knob.

>  - *.swappiness       - for adjusting LRU activity per application type.

Yes, and I wanted to post a patch to export it several times but then I
realized that this should be done only as long as vm.swappiness stays
and it is not deprecated. And more and more I think about swappiness
the less sure I am about it's usefulness. It is not doing much for
quite some time because we are heavily biasing to the pagecache reclaim
and the knob is more and more misleading. It is also not offering what
people might want it to do. E.g. it doesn't allow for preferring swapout
which might be useful when the swap is backed by a really fast storage.
Maybe we will need a new metric here so I wouldn't rush exporting memcg
alternative much.

>  - *.oom_control      - for surviving/notifiyng out of memory
>                         memcg's oom can be recovered if limit goes up rather than kill.

I think it is very much useful - when used wisely. I have seen many
calls for user defined OOM policies but then we have seen those that are
more creative like having the policy maker live in the same memcg which
requires some hacks to prevent from self-deadlocks.
So overall this is very attractive but we might need to think about a
better interface. BPF sounds like a potential way to go. I feel the
memcg and the global approaches should be consistent as much as possible
wrt. API.
-- 
Michal Hocko
SUSE Labs
