From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [External] Re: [PATCH v2] mm: memcg/slab: Fix return child memcg
 objcg for root memcg
Date: Thu, 29 Oct 2020 09:18:45 -0700
Message-ID: <CALvZod68HooK_bnaxFLEBL_neVybVRECkHJyb6r8LHWqwTOe5Q@mail.gmail.com>
References: <20201028035013.99711-1-songmuchun@bytedance.com>
 <CALvZod6p_y2fTEK5fzAL=JfPsguqYbttgWC4_GPc=rF1PsN6TQ@mail.gmail.com> <CAMZfGtW38sFcdpnx3Xx+RgRL37WzpQsq8qvfdnmhbh4H9Ex0cg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G9EtR8ay+CFHP0VWhr60l9Agx6oBhnBUNvO58Pm5n2c=;
        b=ZypFrwHFGFdiH3//0NKW6vQX1p5u1pLj9CchSpsY8VglCbaO2vGBx2uveHOn+HSxzq
         O9Uwvtp1dzgD56WgMNXb2hhjjdjiSi/B1wQtiI6Ap/p4ZUtD3xctBS+5x3BZ2cOEhSSg
         +nX9mb4w+MOOeGPQM6MbQXVpUd2uhKi+z1z7Xtf6A07T8HHVYZ8i3zH4begi4U/VBCuX
         Yn2KWTFJa0FSTi3LiRcT1LGfcNUBE8/Mza2QMwPBACfFLoCzE6DaLbauBuPCkbTQgTWr
         QDTXah3K6U8HNIb/ifAcYX6mB4g+Nsw837iHGB7rnB488OMnyCTszLAZZ84zKoyFiCZ6
         VzDw==
In-Reply-To: <CAMZfGtW38sFcdpnx3Xx+RgRL37WzpQsq8qvfdnmhbh4H9Ex0cg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, areber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu, Oct 29, 2020 at 9:09 AM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>
> On Thu, Oct 29, 2020 at 11:48 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Tue, Oct 27, 2020 at 8:50 PM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> > >
> > > Consider the following memcg hierarchy.
> > >
> > >                     root
> > >                    /    \
> > >                   A      B
> > >
> > > If we get the objcg of memcg A failed,
> >
> > Please fix the above statement.
>
> Sorry, could you be more specific, I don't quite understand.

Fix the grammar. Something like "If we failed to get the reference on
objcg of memcg A..."
