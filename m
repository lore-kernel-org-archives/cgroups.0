From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 8/8] memcg: accounting for ldt_struct objects
Date: Mon, 15 Mar 2021 08:48:26 -0700
Message-ID: <CALvZod7aT7t_Yp67CaECbCSzk8CuqBRMUBccthLCpz4osqDLKw@mail.gmail.com>
References: <YEnWUrYOArju66ym@dhcp22.suse.cz> <360b4c94-8713-f621-1049-6bc0865c1867@virtuozzo.com>
 <20210315132740.GB20497@zn.tnic>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uMQX9cSTk4pNl9nGi7mtI/mLokkbjIxGL748SGLyk7Q=;
        b=cyJf+6PyxCCi1Oz5oXDGFThBCrClPxSRsk4OIhR45gZ2yQRY5505jv96pHlPM/tocl
         KPKqQJb+vUy978TiwjWk3UPiulBwwPx58fsQNlVOJKblEvN6u9pCGreAPcktDGh2C2sU
         wKzfAotaFmv1XxCu51PCvql11jzjj2Y0SJbTz4hPCZ1lalDud8yTldxQLM1kbOMh/Uu9
         OPSJwhyq4omWbP7uT8st4DL9pnnbZvr2MwMEuww9YQ9xUKiNW/TZiPls4Ry2k2BsVM7m
         dkK3DT0CwEdJred10Dzs6Bvjx0UWVLhcsglbl/5f/1omrcFR/v8hb89/8egTNRWofpJo
         k3Dg==
In-Reply-To: <20210315132740.GB20497-Jj63ApZU6fQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Mon, Mar 15, 2021 at 6:27 AM Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:
>
> On Mon, Mar 15, 2021 at 03:24:01PM +0300, Vasily Averin wrote:
> > Unprivileged user inside memcg-limited container can create
> > non-accounted multi-page per-thread kernel objects for LDT
>
> I have hard time parsing this commit message.
>
> And I'm CCed only on patch 8 of what looks like a patchset.
>
> And that patchset is not on lkml so I can't find the rest to read about
> it, perhaps linux-mm.
>
> /me goes and finds it on lore
>
> I can see some bits and pieces, this, for example:
>
> https://lore.kernel.org/linux-mm/05c448c7-d992-8d80-b423-b80bf5446d7c-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org/
>
>  ( Btw, that version has your SOB and this patch doesn't even have a
>    Signed-off-by. Next time, run your whole set through checkpatch please
>    before sending. )
>
> Now, this URL above talks about OOM, ok, that gets me close to the "why"
> this patch.
>
> From a quick look at the ldt.c code, we allow a single LDT struct per
> mm. Manpage says so too:
>
> DESCRIPTION
>        modify_ldt()  reads  or  writes  the local descriptor table (LDT) for a process.
>        The LDT is an array of segment descriptors that can be referenced by user  code.
>        Linux  allows  processes  to configure a per-process (actually per-mm) LDT.
>
> We allow
>
> /* Maximum number of LDT entries supported. */
> #define LDT_ENTRIES     8192
>
> so there's an upper limit per mm.
>
> Now, please explain what is this accounting for?
>

Let me try to provide the reasoning at least from my perspective.
There are legitimate workloads with hundreds of processes and there
can be hundreds of workloads running on large machines. The
unaccounted memory can cause isolation issues between the workloads
particularly on highly utilized machines.
