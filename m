From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PROPOSAL] memcg: per-memcg user space reclaim interface
Date: Tue, 7 Jul 2020 14:14:22 +0200
Message-ID: <20200707121422.GP5913@dhcp22.suse.cz>
References: <20200702152222.2630760-1-shakeelb@google.com>
 <20200703063548.GM18446@dhcp22.suse.cz>
 <CALvZod5gthVX5m6o50OiYsXa=0_NpXK-tVvjTF42Oj4udr4Nuw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALvZod5gthVX5m6o50OiYsXa=0_NpXK-tVvjTF42Oj4udr4Nuw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri 03-07-20 07:23:14, Shakeel Butt wrote:
> On Thu, Jul 2, 2020 at 11:35 PM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Thu 02-07-20 08:22:22, Shakeel Butt wrote:
> > [...]
> > > Interface options:
> > > ------------------
> > >
> > > 1) memcg interface e.g. 'echo 10M > memory.reclaim'
> > >
> > > + simple
> > > + can be extended to target specific type of memory (anon, file, kmem).
> > > - most probably restricted to cgroup v2.
> > >
> > > 2) fadvise(PAGEOUT) on cgroup_dir_fd
> > >
> > > + more general and applicable to other FSes (actually we are using
> > > something similar for tmpfs).
> > > + can be extended in future to just age the LRUs instead of reclaim or
> > > some new use cases.
> >
> > Could you explain why memory.high as an interface to trigger pro-active
> > memory reclaim is not sufficient. Also memory.low limit to protect
> > latency sensitve workloads?
> 
> Yes, we can use memory.high to trigger [proactive] reclaim in a memcg
> but note that it can also introduce stalls in the application running
> in that memcg. Let's suppose the memory.current of a memcg is 100MiB
> and we want to reclaim 20MiB from it, we can set the memory.high to
> 80MiB but any allocation attempt from the application running in that
> memcg can get stalled/throttled. I want the functionality of the
> reclaim without potential stalls.

It would be great if the proposal mention this limitation.

> The memory.min is for protection against the global reclaim and is
> unrelated to this discussion.

Well, I was talkingg about memory.low. It is not meant only to protect
from the global reclaim. It can be used for balancing memory reclaim
from _any_ external memory pressure source. So it is somehow related to
the usecase you have mentioned.

What you consider a latency sensitive workload could be protected from
directly induced reclaim latencies. You could use low events to learn
about the external memory pressure and update your protection to allow
for some reclaim. I do understand that this wouldn't solve your problem
who gets reclaimed and maybe that is the crux on why it is not
applicable but that should really be mentioned explicitly.

-- 
Michal Hocko
SUSE Labs
