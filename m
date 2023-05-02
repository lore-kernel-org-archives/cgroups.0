From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 1/1] psi: remove 500ms min window size limitation for
 triggers
Date: Tue, 2 May 2023 19:24:04 +0200
Message-ID: <20230502172404.GI1597538@hirez.programming.kicks-ass.net>
References: <20230303011346.3342233-1-surenb@google.com>
 <CAJuCfpHcgu5Cti0t+U=S1C5-0ZgebhxzrOnhDiSu5qCyuq5_Wg@mail.gmail.com>
 <CAJuCfpE_aB6KQZj6A0NTCcv09bJ26L1hECDho3M2OyiNoMfFEA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=hrcCJlzTEWTjYDj+PsLFsdbovv7vXKPWKk6sNRy/lTs=; b=qHun9WZXPvt4wdHJ6P0pkB1o/5
        E/ri8TDaZGkBh0zusE18HSRSMDEwT0FEz+LpLM3rUN86dbm7KPkxy6/RUQ8Ur4lh2mA5I2yp9Y+rO
        VJiZz9HytEWqnZ79cpEpij8B4bbKSaN/Bn5y+u0/bd/1ub9wKIX7Dfh8KwfjVEwUbCyEKF9hfmndm
        Pd1iqy5s+flkn2iVMeoxFgK9yUU04jnWWkGf2RvPZxQj/y2lSvPl22O6ivV7EPRDECuU+NayXGWk5
        GTflEOThiCrz1ZEVg/psUxh0iZsOJ1VEgQHS8Ba0GD7LzEGquQggZsjJTdOrT+TLKeDxm8mRn0XqB
        B5dR7HxA==;
Content-Disposition: inline
In-Reply-To: <CAJuCfpE_aB6KQZj6A0NTCcv09bJ26L1hECDho3M2OyiNoMfFEA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, johunt-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, May 02, 2023 at 10:20:34AM -0700, Suren Baghdasaryan wrote:
> On Thu, Mar 2, 2023 at 5:16 PM Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Thu, Mar 2, 2023 at 5:13 PM Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > Current 500ms min window size for psi triggers limits polling interval
> > > to 50ms to prevent polling threads from using too much cpu bandwidth by
> > > polling too frequently. However the number of cgroups with triggers is
> > > unlimited, so this protection can be defeated by creating multiple
> > > cgroups with psi triggers (triggers in each cgroup are served by a single
> > > "psimon" kernel thread).
> > > Instead of limiting min polling period, which also limits the latency of
> > > psi events, it's better to limit psi trigger creation to authorized users
> > > only, like we do for system-wide psi triggers (/proc/pressure/* files can
> > > be written only by processes with CAP_SYS_RESOURCE capability). This also
> > > makes access rules for cgroup psi files consistent with system-wide ones.
> > > Add a CAP_SYS_RESOURCE capability check for cgroup psi file writers and
> > > remove the psi window min size limitation.
> > >
> > > Suggested-by: Sudarshan Rajagopalan <quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
> > > Link: https://lore.kernel.org/all/cover.1676067791.git.quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org/
> > > Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> > > Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> >
> > Forgot to change the --to field from Tejun to PeterZ.
> > Peter, just to clarify, this change is targeted for inclusion in your tree.
> 
> I think this patch slipped through the cracks. Peter, could you please
> take it into your tree?

Sorry, yes, got lost. I'll go queue it for post -rc1. No urgency with
this right?
