From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 02/18] mm: memcontrol: fix theoretical race in charge
 moving
Date: Wed, 22 Apr 2020 13:42:29 -0400
Message-ID: <20200422174229.GD362484@cmpxchg.org>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-3-hannes@cmpxchg.org>
 <CALvZod4gFC1TDo8dtdaeQKj_ZEoOnQvRnw_dZANH7qQYCmnnGA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cjTwD6uKqnZZSCCcyV16R+WZpCxCW7qEmnrNY09I9TU=;
        b=SXe+TpnWHooh9QOLTZ6dPrc+kEXDChrdMWSwPBBvrbiuRWeGWW4hR03UNURAOWyCOp
         A1ivM3w+kYgYiUu+raGzagTVxzAhGDXYZcsTCw6/tsVAY3o4o96oA/5u0oHg7RjjMTq9
         tgPnfshzSvCpYaPzIkCLITPjO6AAJIMqP3Wky3w89IvCWzujBOauLENhuaU/X8CuKuFB
         8EledqZQwjMwAG0LDDP2CO649rhMDeXWU9lcZdD6RFJtGFZVkWheR2JO6HN7ol45mBUs
         vSj0lAKRCmXtbhp4BRu1PeJvtSagZIOT3/OIgRyEa/DVVTdkukHbVZO6fwxvfFVXDdCc
         7YlA==
Content-Disposition: inline
In-Reply-To: <CALvZod4gFC1TDo8dtdaeQKj_ZEoOnQvRnw_dZANH7qQYCmnnGA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Wed, Apr 22, 2020 at 09:51:20AM -0700, Shakeel Butt wrote:
> On Mon, Apr 20, 2020 at 3:11 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > @@ -5426,15 +5420,23 @@ static int mem_cgroup_move_account(struct page *page,
> >         }
> >
> >         /*
> > +        * All state has been migrated, let's switch to the new memcg.
> > +        *
> >          * It is safe to change page->mem_cgroup here because the page
> > -        * is referenced, charged, and isolated - we can't race with
> > -        * uncharging, charging, migration, or LRU putback.
> > +        * is referenced, charged, isolated, and locked: we can't race
> > +        * with (un)charging, migration, LRU putback, or anything else
> > +        * that would rely on a stable page->mem_cgroup.
> > +        *
> > +        * Note that lock_page_memcg is a memcg lock, not a page lock,
> > +        * to save space. As soon as we switch page->mem_cgroup to a
> > +        * new memcg that isn't locked, the above state can change
> > +        * concurrently again. Make sure we're truly done with it.
> >          */
> > +       smp_mb();
> 
> You said theoretical race in the subject but the above comment
> convinced me that smp_mb() is required. So, why is the race still
> theoretical?

Sorry about the confusion.

I said theoretical because I spotted it while thinking about the
code. I'm not aware of any real users that suffered the consequences
of this race condition. But they could exist in theory :-)

I think it's a real bug that needs fixing.
