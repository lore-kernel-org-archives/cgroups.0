From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/3] mm: Charge active memcg when no mm is set
Date: Thu, 20 Feb 2020 13:14:17 -0800
Message-ID: <CALvZod5_AgaS_=uvXsfsL1bthxMUk3DiD90Ach=cdMkaync5vQ@mail.gmail.com>
References: <cover.1582216294.git.schatzberg.dan@gmail.com>
 <0a27b6fcbd1f7af104d7f4cf0adc6a31e0e7dd19.1582216294.git.schatzberg.dan@gmail.com>
 <CALvZod5bDQvYHTMCHoWbhiEbcBs4KATv=QLdjjivJ33kb6ZY+w@mail.gmail.com> <20200220210344.GK54486@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ktuN17gmiqlKE/I4GYw0sVSSXcxY6RgmY2JpLivgLB4=;
        b=F18pix32o4K9RJdf3Ge/L+3NgYmCrMt8y8HZvV7+XlYsyAkPvClxTvbluEB0EVBNoS
         9+5z76T7v66vZmEXr5Fa4C/xKMwaD8hX4VGSvj8eZYiZhBSzZACB9ZEorWg+DVYqunsU
         RFZh8hBBTc1wggIAqZQ8fPUMT+E336fsvX6EBArXEQTHs+Q6GmOMMeP/F2BbTvjRp3yP
         38VdoqNYXn7SI2xBaY09WCr+qilbJTaiNEXxjdzAV9AQQ9JUqPWXdte/fUYO6KBM0A0C
         FpO9xdOiWJLrQSK1axpfwR42CRT4jmUVITnSPFR0HZjupTxdP02SIacYzr13JUNGmFkW
         yvWw==
In-Reply-To: <20200220210344.GK54486-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

Hi Johannes,

On Thu, Feb 20, 2020 at 1:03 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> Hey Shakeel!
>
> On Thu, Feb 20, 2020 at 10:14:45AM -0800, Shakeel Butt wrote:
> > On Thu, Feb 20, 2020 at 8:52 AM Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > > memalloc_use_memcg() worked for kernel allocations but was silently
> > > ignored for user pages.
> > >
> > > This patch establishes a precedence order for who gets charged:
> > >
> > > 1. If there is a memcg associated with the page already, that memcg is
> > >    charged. This happens during swapin.
> > >
> > > 2. If an explicit mm is passed, mm->memcg is charged. This happens
> > >    during page faults, which can be triggered in remote VMs (eg gup).
> > >
> > > 3. Otherwise consult the current process context. If it has configured
> > >    a current->active_memcg, use that.
> >
> > What if css_tryget_online(current->active_memcg) in
> > get_mem_cgroup_from_current() fails? Do we want to change this to
> > css_tryget() and even if that fails should we fallback to
> > root_mem_cgroup or current->mm->memcg?
>
> Good questions.
>
> I think we can switch to css_tryget(). If a cgroup goes offline
> between issuing the IO and the loop layer executing that IO, the
> resources used could end up in the root instead of the closest
> ancestor of the offlined group. However, the risk of that actually
> happening and causing problems is probably pretty small, and the
> behavior isn't really worse than before Dan's patches.

Agreed.

>
> Would you mind sending a separate patch for this? AFAICS similar
> concerns apply to all users of foreign charging.

Sure and yes similar concerns apply to other users as well.

>
> As for tryget failing: can that actually happen? AFAICS, all current
> users acquire a reference first (get_memcg_from_somewhere()) that they
> assign to current->active_memcg. We should probably codify this rule
> and do WARN_ON(!css_tryget()) /* current->active_memcg must hold a ref */

Yes, we should WARN_ON().

Shakeel
