From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 8/8] memcg: accounting for ldt_struct objects
Date: Mon, 15 Mar 2021 16:58:32 +0100
Message-ID: <YE+EKC2yiyzjsEkq@dhcp22.suse.cz>
References: <YEnWUrYOArju66ym@dhcp22.suse.cz>
 <360b4c94-8713-f621-1049-6bc0865c1867@virtuozzo.com>
 <20210315132740.GB20497@zn.tnic>
 <CALvZod7aT7t_Yp67CaECbCSzk8CuqBRMUBccthLCpz4osqDLKw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615823914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S1QyVKaSB8Yw5ODdqZSJJFR0A2j33an6mNYtE7mQyMI=;
        b=DzMFy86fpC0NliOMOn+TLBRnx2vAXvuYsfAytAevIQcYeOJThvqXU/EWqRTQijA2PbPf5u
        Sfej+/GbLTBq7vbacY/++OH3rcXiiXi6UHEeQIb8LVTDFWexz7tRhkJKu/sk+RhAPHU8/R
        RgwVgISDX5ikFoETUaJNN+j2EU8Dvg4=
Content-Disposition: inline
In-Reply-To: <CALvZod7aT7t_Yp67CaECbCSzk8CuqBRMUBccthLCpz4osqDLKw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Mon 15-03-21 08:48:26, Shakeel Butt wrote:
> On Mon, Mar 15, 2021 at 6:27 AM Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:
> >
> > On Mon, Mar 15, 2021 at 03:24:01PM +0300, Vasily Averin wrote:
> > > Unprivileged user inside memcg-limited container can create
> > > non-accounted multi-page per-thread kernel objects for LDT
> >
> > I have hard time parsing this commit message.
> >
> > And I'm CCed only on patch 8 of what looks like a patchset.
> >
> > And that patchset is not on lkml so I can't find the rest to read about
> > it, perhaps linux-mm.
> >
> > /me goes and finds it on lore
> >
> > I can see some bits and pieces, this, for example:
> >
> > https://lore.kernel.org/linux-mm/05c448c7-d992-8d80-b423-b80bf5446d7c-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org/
> >
> >  ( Btw, that version has your SOB and this patch doesn't even have a
> >    Signed-off-by. Next time, run your whole set through checkpatch please
> >    before sending. )
> >
> > Now, this URL above talks about OOM, ok, that gets me close to the "why"
> > this patch.
> >
> > From a quick look at the ldt.c code, we allow a single LDT struct per
> > mm. Manpage says so too:
> >
> > DESCRIPTION
> >        modify_ldt()  reads  or  writes  the local descriptor table (LDT) for a process.
> >        The LDT is an array of segment descriptors that can be referenced by user  code.
> >        Linux  allows  processes  to configure a per-process (actually per-mm) LDT.
> >
> > We allow
> >
> > /* Maximum number of LDT entries supported. */
> > #define LDT_ENTRIES     8192
> >
> > so there's an upper limit per mm.
> >
> > Now, please explain what is this accounting for?
> >
> 
> Let me try to provide the reasoning at least from my perspective.
> There are legitimate workloads with hundreds of processes and there
> can be hundreds of workloads running on large machines. The
> unaccounted memory can cause isolation issues between the workloads
> particularly on highly utilized machines.

It would be better to be explicit

8192 * 8 = 64kB * number_of_tasks

so realistically this is in range of lower megabytes. Is this worth the
memcg accounting overhead? Maybe yes but what kind of workloads really
care?

-- 
Michal Hocko
SUSE Labs
