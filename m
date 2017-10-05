From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [v10 3/6] mm, oom: cgroup-aware OOM killer
Date: Thu, 5 Oct 2017 13:12:30 +0200
Message-ID: <20171005111230.i7am3patptvalcat@dhcp22.suse.cz>
References: <20171004154638.710-1-guro@fb.com>
 <20171004154638.710-4-guro@fb.com>
 <CALvZod6bwyoSWTv139y0wMidpZm5HcDu8RzVjF8U7GHxAzxSQw@mail.gmail.com>
 <20171004201524.GA4174@castle>
 <CALvZod45ObeQwq-pKeqyLe2bNwfKAr0majCbNfqPOEJL+AeiNw@mail.gmail.com>
 <20171005102707.GA12982@castle.dhcp.TheFacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171005102707.GA12982-2xczL/1GIl5a1dPMsufgnw2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu 05-10-17 11:27:07, Roman Gushchin wrote:
> On Wed, Oct 04, 2017 at 02:24:26PM -0700, Shakeel Butt wrote:
[...]
> > Sorry about the confusion. There are two things. First, should we do a
> > css_get on the newly selected memcg within the for loop when we still
> > have a reference to it?
> 
> We're holding rcu_read_lock, it should be enough. We're bumping css counter
> just before releasing rcu lock.

yes

> > 
> > Second, for the OFFLINE memcg, you are right oom_evaluate_memcg() will
> > return 0 for offlined memcgs. Maybe no need to call
> > oom_evaluate_memcg() for offlined memcgs.
> 
> Sounds like a good optimization, which can be done on top of the current
> patchset.

You could achive this by checking whether a memcg has tasks rather than
explicitly checking for children memcgs as I've suggested already.
-- 
Michal Hocko
SUSE Labs
