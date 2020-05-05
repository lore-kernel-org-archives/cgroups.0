From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: oom: ignore oom warnings from memory.max
Date: Tue, 5 May 2020 11:27:12 -0400
Message-ID: <20200505152712.GB58018@cmpxchg.org>
References: <20200430182712.237526-1-shakeelb@google.com>
 <20200504065600.GA22838@dhcp22.suse.cz>
 <CALvZod5Ao2PEFPEOckW6URBfxisp9nNpNeon1GuctuHehqk_6Q@mail.gmail.com>
 <20200504141136.GR22838@dhcp22.suse.cz>
 <CALvZod7Ls7rTDOr5vXwEiPneLqbq3JoxfFBxZZ71YWgvLkNr5A@mail.gmail.com>
 <20200504150052.GT22838@dhcp22.suse.cz>
 <CALvZod7EeQm-T4dsBddfMY_szYw3m8gRh5R5GfjQiuQAtCocug@mail.gmail.com>
 <20200504160613.GU22838@dhcp22.suse.cz>
 <CALvZod79hWns9366B+8ZK2Roz8c+vkdA80HqFNMep56_pumdRQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r/em/r1WAWdIxfLddFgVdK8/WA54vnvCFmZ5eTaHEGI=;
        b=uuzwPXhvPztMz4zHd3EPswjaU7UzyVLgP82njzHGSMhiwR7satUNP/H9oFmb2zmBl5
         roz08OHw6yDtf5Pytm0tv38O7lGL7Qd2QRHmJugb2TZycLQSah4WdqOk5gw599MivkHp
         RCDAR0ljKALkXIj6099CztWvxNRAyHv7a4ZolmsRwjb61C2Mof0IbYRyxWnMY32Qegcy
         BR6BEgzPa5/wJZzHwWRMvsex+cJAIMBplmh6n+c4XfhSUZwmp7EOJy4Mv3YOLsK3mTcs
         TXxNZEIogoS1EOphfSvEWmBrZbpPpUGSnPwBXhI/r5GnunV7OX6rnQXGolj581CtOEqP
         iECg==
Content-Disposition: inline
In-Reply-To: <CALvZod79hWns9366B+8ZK2Roz8c+vkdA80HqFNMep56_pumdRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, May 04, 2020 at 12:23:51PM -0700, Shakeel Butt wrote:
> On Mon, May 4, 2020 at 9:06 AM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > I really hate to repeat myself but this is no different from a regular
> > oom situation.
> 
> Conceptually yes there is no difference but there is no *divine
> restriction* to not make a difference if there is a real world
> use-case which would benefit from it.

I would wholeheartedly agree with this in general.

However, we're talking about the very semantics that set memory.max
apart from memory.high: triggering OOM kills to enforce the limit.

> > when the kernel cannot act and mentions that along with the
> > oom report so that whoever consumes that information can debug or act on
> > that fact.
> >
> > Silencing the oom report is simply removing a potentially useful
> > aid to debug further a potential problem.
> 
> *Potentially* useful for debugging versus actually beneficial for
> "sweep before tear down" use-case. Also I am not saying to make "no
> dumps for memory.max when no eligible tasks" a set in stone rule. We
> can always reevaluate when such information will actually be useful.
> 
> Johannes/Andrew, what's your opinion?

I still think that if you want to sweep without triggering OOMs,
memory.high has the matching semantics.

As you pointed out, it doesn't work well for foreign charges, but that
is more of a limitation in the implementation than in the semantics:

	/*
	 * If the hierarchy is above the normal consumption range, schedule
	 * reclaim on returning to userland.  We can perform reclaim here
	 * if __GFP_RECLAIM but let's always punt for simplicity and so that
	 * GFP_KERNEL can consistently be used during reclaim.  @memcg is
	 * not recorded as it most likely matches current's and won't
	 * change in the meantime.  As high limit is checked again before
	 * reclaim, the cost of mismatch is negligible.
	 */

Wouldn't it be more useful to fix that instead? It shouldn't be much
of a code change to do sync reclaim in try_charge().

Then you could express all things that you asked for without changing
any user-visible semantics: sweep an empty cgroup as well as possible,
do not oom on remaining charges that continue to be used by processes
outside the cgroup, do trigger oom on new foreign charges appearing
due to a misconfiguration.

	echo 0 > memory.high
	cat memory.current > memory.max

Would this work for you?
