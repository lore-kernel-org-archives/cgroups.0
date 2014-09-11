From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [RFC] memory cgroup: my thoughts on memsw
Date: Thu, 11 Sep 2014 13:50:37 +0400
Message-ID: <20140911095037.GC4151@esperanza>
References: <20140905082846.GA25641@esperanza>
 <5409C6BB.7060009@jp.fujitsu.com>
 <20140905160029.GF25641@esperanza>
 <540A4420.2030504@jp.fujitsu.com>
 <20140908110131.GA11812@esperanza>
 <540DB4EC.6060100@jp.fujitsu.com>
 <20140909103943.GA29897@esperanza>
 <54110339.6000702@jp.fujitsu.com>
 <20140911082311.GB4151@esperanza>
 <54116324.7000200@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54116324.7000200-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Motohiro Kosaki <Motohiro.Kosaki-gkcJ3tX5bYHQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pavel Emelianov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Konstantin Khorenko <khorenko-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, LKML-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML-cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Sep 11, 2014 at 05:53:56PM +0900, Kamezawa Hiroyuki wrote:
> (2014/09/11 17:23), Vladimir Davydov wrote:
> >For example, there are two cgroups, one having a huge soft limit excess
> >and full of anon memory and another not exceeding its soft limit but
> >using primarily clean file caches. This prioritizing/weighting stuff
> >would result in shrinking the first group first on global pressure,
> >though it's way slower than shrinking the second one.
> 
> Current implementation just round-robin all memcgs under the tree.
> With re-designed soft-limit, things will be changed, you can change it.
> 
> 
> >That means a latency spike in other containers.
> 
> why ? you said the other container just contains file caches.

A container wants some mem (anon, file, whatever) under pressure. If the
pressure is high, it falls into direct reclaim and starts shrinking the
container with a lot of anon memory, which is going to be slow, - here
goes a latency spike.

> latency-spike just because file cache drops ?
> If the service is such naive, please use hard limit.

File caches are evicted much easier than anon memory, simply because the
latter is (almost) always dirty, However, file caches still can be a
vital part of the working set. It all depends on the load. What's wrong
with a web server that most of the time sends the same set of web pages
to clients? The data it needs are stored on the disk and mostly clean,
but it's still its working set. Evicting it will lower the server
responsiveness, which will result in clients getting upset and stopping
visiting the web site. Or do you suppose the web server must cache disk
data in anon memory on its own? Why do we keep clean caches at all then?

> Hmm.
> How about raising kswapd's scheduling threshold in some situation ?
> Per-memcg-kswapd-for-helping-softlimit may work.

Instead of preventing the worst case you propose to prepare the
after-treatment...

> >The heuristics you proposed above
> >will only make it non-critical - the system will get over sooner or
> >later.
> 
> My idea is always based on there is a container-manager on the system,
> which can do enough clever decision based on a policy, admin specified.
> IIUC, reducing cpu-hog caused by memory pressure is always helpful.
> 
> >However, it's still a kind of DOS, which anon+swap hard limit would prevent.
> 
> by oom-killer.

*Local* oom-killer inside the container behaving badly. This is way
better than waiting until it puts the whole system under heavy pressure.

> >On Tue, Sep 09, 2014 at 02:39:43PM +0400, Vladimir Davydov wrote:
> >>However, there's one thing, which made me start this discussion, and it
> >>still bothers me. It's about memsw.limit_in_bytes knob itself.
> >>
> >>First, its value must be greater or equal to memory.limit_in_bytes.
> >>IMO, such a dependency in the user interface isn't great, but it isn't
> >>the worst thing. What is worse, there's only point in setting it to
> >>infinity if one wants to fully make use of soft limits as I pointed out
> >>earlier.
> >>
> >>So, we have a userspace knob that suits only for strict sand-boxing when
> >>one wants to hard-limit the amount of memory and swap an app can use.
> >>When it comes to soft limits, you have to set it to infinity, and it'll
> >>still be accounted at the cost of performance, but without any purpose.
> >>It just seems meaningless to me.
> >>
> >>Not counting that the knob itself is a kind of confusing IMO. memsw
> >>means memory+swap, so one would mistakenly think memsw.limit-mem.limit
> >>is the limit on swap usage, but that's wrong.
> >>
> >>My point is that anon+swap accounting instead of the current
> >>anon+file+swap memsw implementation would be more flexible. We could
> >>still sandbox apps by setting hard anon+swap and memory limits, but it
> >>would also be possible to make use of it in "soft" environments. It
> >>wouldn't be mandatory though. If one doesn't like OOM, he can use
> >>threshold notifications to restart the container when it starts to
> >>behave badly. But if the user just doesn't want to bother about
> >>configuration or is OK with OOM-killer, he could set hard anon+swap
> >>limit. Besides, it would untie mem.limit knob from memsw.limit, which
> >>would make the user interface simpler and cleaner.
> >>
> >>So, I think anon+swap limit would be more flexible than file+anon+swap
> >>limit we have now. Is there any use case where anon+swap and anon+file
> >>accounting couldn't satisfy the user requirements while the
> >>anon+file+swap and anon+file pair could?
> >
> >I would appreciate if anybody could answer this.
> >
> 
> I can't understand why you want to use OOM killer for resource controlling .

Because there are situations when an app inside a container goes mad.
There must be a reliable way to stop it. It's all about the compromise
between safety (sand-boxing) and efficiency (soft limits). Currently we
can't mix them. Soft limits are intrinsically unsafe though must be
efficient while hard limits guarantee safety at cost of performance.
Anon+swap limit would allow us to combine them to yield an efficient yet
safe setup.

Besides, memsw limit eventually means OOM too, why is it better?

What I propose is to give the admin a choice. If he thinks the app is
100% safe, let him rely on userspace handling and in-kernel after-care.
But if there's a possibility of a malicious and/or badly designed app,
let him configure in-kernel OOM per container to prevent a disaster for
sure. The latter is usually the case when you sell containers to
third-party users.

Thanks,
Vladimir
