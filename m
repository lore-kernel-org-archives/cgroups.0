From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Mon, 20 Apr 2020 19:03:18 +0200
Message-ID: <20200420170318.GV27314@dhcp22.suse.cz>
References: <CALvZod78ZUhU+yr2x1h_gv+VgVGTPnSSGKh_+fd+MeiAKreJvg@mail.gmail.com>
 <20200417162355.GA43469@mtj.thefacebook.com>
 <CALvZod4ftvXCu8SbQUXwTGVvx5K2+at9h30r28chZLXEB1JdfQ@mail.gmail.com>
 <20200417173615.GB43469@mtj.thefacebook.com>
 <CALvZod7-r0OrJ+-_uCy_p3BU3348ve2+YatiSdLvFaVqcqCs=w@mail.gmail.com>
 <20200417193539.GC43469@mtj.thefacebook.com>
 <CALvZod6LT25t9aAA1KHmf1U4-L8zSjUXQ4VQvX4cMT1A+R_g+w@mail.gmail.com>
 <20200417225941.GE43469@mtj.thefacebook.com>
 <CALvZod6M4OsM-t8m_KX9wCkEutdwUMgbP9682eHGQor9JvO_BQ@mail.gmail.com>
 <20200420164740.GF43469@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200420164740.GF43469-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon 20-04-20 12:47:40, Tejun Heo wrote:
[...]
> > Coming back to this path series, to me, it seems like the patch series
> > is contrary to the vision you are presenting. Though the users are not
> > setting memory.[high|max] but they are setting swap.max and this
> > series is asking to set one more tunable i.e. swap.high. The approach
> > more consistent with the presented vision is to throttle or slow down
> > the allocators when the system swap is near full and there is no need
> > to set swap.max or swap.high.

I have the same impression as Shakeel here. The overall information we
have here is really scarce.
 
> It's a piece of the puzzle to make memory protection work comprehensively.
> You can argue that the fact swap isn't protection based is against the
> direction but I find that argument rather facetious as swap is quite
> different resource from memory and it's not like I'm saying limits shouldn't
> be used at all. There sure still are missing pieces - ie. slowing down on
> global depletion, but that doesn't mean swap.high isn't useful.

I have asked about the semantic of this know already and didn't really
get any real answer. So how does swap.high fit into high limit semantic
when it doesn't act as a limit. Considering that we cannot reclaim swap
space I find this really hard to grasp.

We definitely need more information here!
-- 
Michal Hocko
SUSE Labs
