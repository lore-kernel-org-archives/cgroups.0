From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Tue, 21 Apr 2020 18:11:38 +0200
Message-ID: <20200421161138.GL27314@dhcp22.suse.cz>
References: <CALvZod7-r0OrJ+-_uCy_p3BU3348ve2+YatiSdLvFaVqcqCs=w@mail.gmail.com>
 <20200417193539.GC43469@mtj.thefacebook.com>
 <CALvZod6LT25t9aAA1KHmf1U4-L8zSjUXQ4VQvX4cMT1A+R_g+w@mail.gmail.com>
 <20200417225941.GE43469@mtj.thefacebook.com>
 <CALvZod6M4OsM-t8m_KX9wCkEutdwUMgbP9682eHGQor9JvO_BQ@mail.gmail.com>
 <20200420164740.GF43469@mtj.thefacebook.com>
 <20200420170318.GV27314@dhcp22.suse.cz>
 <20200420170650.GA169746@mtj.thefacebook.com>
 <20200421110612.GD27314@dhcp22.suse.cz>
 <20200421142746.GA341682@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200421142746.GA341682-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue 21-04-20 10:27:46, Johannes Weiner wrote:
> On Tue, Apr 21, 2020 at 01:06:12PM +0200, Michal Hocko wrote:
[...]
> > I am also not sure about the isolation aspect. Because an external
> > memory pressure might have pushed out memory to the swap and then the
> > workload is throttled based on an external event. Compare that to the
> > memory.high throttling which is not directly affected by the external
> > pressure.
> 
> Neither memory.high nor swap.high isolate from external pressure.

I didn't say they do. What I am saying is that an external pressure
might punish swap.high memcg because the external memory pressure would
eat up the quota and trigger the throttling.

It is fair to say that this externally triggered interference is already
possible with swap.max as well though. It would likely be just more
verbose because of the oom killer intervention rather than a slowdown.

> They
> are put on cgroups so they don't cause pressure on other cgroups. Swap
> is required when either your footprint grows or your available space
> shrinks. That's why it behaves like that.
> 
> That being said, I think we're getting lost in the implementation
> details before we have established what the purpose of this all
> is. Let's talk about this first.

Thanks for describing it in the length. I have a better picture of the
intention (this should have been in the changelog ideally). I can see
how the swap consumption throttling might be useful but I still dislike the
proposed implementation. Mostly because of throttling of all allocations
regardless whether they can contribute to the swap consumption or not.
-- 
Michal Hocko
SUSE Labs
