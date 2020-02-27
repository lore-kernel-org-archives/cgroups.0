From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: asynchronous reclaim for memory.high
Date: Thu, 27 Feb 2020 10:58:59 +0100
Message-ID: <20200227095859.GA3771@dhcp22.suse.cz>
References: <20200219181219.54356-1-hannes@cmpxchg.org>
 <CALvZod7fya+o8mO+qo=FXjk3WgNje=2P=sxM5StgdBoGNeXRMg@mail.gmail.com>
 <20200226222642.GB30206@cmpxchg.org>
 <2be6ac8d-e290-0a85-5cfa-084968a7fe36@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2be6ac8d-e290-0a85-5cfa-084968a7fe36-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Wed 26-02-20 16:12:23, Yang Shi wrote:
[...]
> Actually I'm wondering if we really need account CPU cycles used by
> background reclaimer or not. For our usecase (this may be not general), the
> purpose of background reclaimer is to avoid latency sensitive workloads get
> into direct relcaim (avoid the stall from direct relcaim). In fact it just
> "steal" CPU cycles from lower priority or best-effort workloads to guarantee
> latency sensitive workloads behave well. If the "stolen" CPU cycles are
> accounted, it means the latency sensitive workloads would get throttled from
> somewhere else later, i.e. by CPU share.

I believe we need to because that work is not for free and so you are
essentially stealing those CPUs cycles from everybody else outside of
your throttled cgroup.
-- 
Michal Hocko
SUSE Labs
