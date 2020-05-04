From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: oom: ignore oom warnings from memory.max
Date: Mon, 4 May 2020 18:06:13 +0200
Message-ID: <20200504160613.GU22838@dhcp22.suse.cz>
References: <20200430182712.237526-1-shakeelb@google.com>
 <20200504065600.GA22838@dhcp22.suse.cz>
 <CALvZod5Ao2PEFPEOckW6URBfxisp9nNpNeon1GuctuHehqk_6Q@mail.gmail.com>
 <20200504141136.GR22838@dhcp22.suse.cz>
 <CALvZod7Ls7rTDOr5vXwEiPneLqbq3JoxfFBxZZ71YWgvLkNr5A@mail.gmail.com>
 <20200504150052.GT22838@dhcp22.suse.cz>
 <CALvZod7EeQm-T4dsBddfMY_szYw3m8gRh5R5GfjQiuQAtCocug@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALvZod7EeQm-T4dsBddfMY_szYw3m8gRh5R5GfjQiuQAtCocug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon 04-05-20 08:35:57, Shakeel Butt wrote:
> On Mon, May 4, 2020 at 8:00 AM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Mon 04-05-20 07:53:01, Shakeel Butt wrote:
[...]
> > > I am trying to see if "no eligible task" is really an issue and should
> > > be warned for the "other use cases". The only real use-case I can
> > > think of are resource managers adjusting the limit dynamically. I
> > > don't see "no eligible task" a concerning reason for such use-case.
> >
> > It is very much a concerning reason to notify about like any other OOM
> > situation due to hard limit breach. In this case it is worse in some
> > sense because the limit cannot be trimmed down because there is no
> > directly reclaimable memory at all. Such an oom situation is
> > effectivelly conserved.
> > --
> 
> Let me make a more precise statement and tell me if you agree. The "no
> eligible task" is concerning for the charging path but not for the
> writer of memory.max. The writer can read the usage and
> cgroup.[procs|events] to figure out the situation if needed.

I really hate to repeat myself but this is no different from a regular
oom situation. Admin sets the hard limit and the kernel tries to act
upon that.

You cannot make any assumption about what admin wanted or didn't want
to see. We simply trigger the oom killer on memory.max and this is a
documented behavior. No eligible task or no task at all is a simply a
corner case when the kernel cannot act and mentions that along with the
oom report so that whoever consumes that information can debug or act on
that fact.

Silencing the oom report is simply removing a potentially useful
aid to debug further a potential problem. But let me repeat this is not
reallly any different from a regular oom situation when the oom killer
is able to act.

-- 
Michal Hocko
SUSE Labs
