From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 1/2] memcg: flush stats only if updated
Date: Thu, 4 Nov 2021 15:09:18 -0700
Message-ID: <CALvZod5xT2Mi2wktD-OTS0xkChNzArnMCLBNy7cg0dVupSOhXw@mail.gmail.com>
References: <20211013180130.GB22036@blackbody.suse.cz> <20211014163146.2177266-1-shakeelb@google.com>
 <20211104142751.5ab290d5cf4be1749c9c87ed@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ODhjY+JjkYpUpFv09zJB9aBghMhLyhOS/H4FgA78QU8=;
        b=JHVS8Ow1HVeUipVMLT11yHlvnxUVD2nceGQ5AKOw+p77/NeUjmgxc/oFiHSOxrbrpy
         Is/GwTZWZuoxrsC80rpbv/2Y8AaAq/cFI3MhtzhNbqZ2SeltjziPfSnhXJUAjXXzuneh
         06pZbRk62NEQyFwifnDmYhpdXaj5WIbqygNh018AToErjr1rpOAMHzMlLBgBnFYYWmsM
         n3epCtFUKoO951mcxkIQfDT2Ez/LVEgPNqs68kV3L8jvbEOgor4J5JFG089J8+xV4Vwu
         lLYjqTpUdsD5O3nUSnHNlw2U5elxiK5a1njy2kFnY+pVVBcnd9VbIH0GJWibXuXHxCHT
         qOTQ==
In-Reply-To: <20211104142751.5ab290d5cf4be1749c9c87ed@linux-foundation.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mkoutny@suse.com, cgroups@vger.kernel.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org

On Thu, Nov 4, 2021 at 2:27 PM Andrew Morton <akpm@linux-foundation.org> wr=
ote:
>
> On Thu, 14 Oct 2021 09:31:46 -0700 Shakeel Butt <shakeelb@google.com> wro=
te:
>
> > Hi Michal,
> >
> > On Wed, Oct 13, 2021 at 11:01 AM Michal Koutn=C3=BD <mkoutny@suse.com> =
wrote:
> > >
> > > On Fri, Oct 01, 2021 at 12:00:39PM -0700, Shakeel Butt <shakeelb@goog=
le.com> wrote:
> > > > In this patch we kept the stats update codepath very minimal and le=
t the
> > > > stats reader side to flush the stats only when the updates are over=
 a
> > > > specific threshold.  For now the threshold is (nr_cpus * CHARGE_BAT=
CH).
> > >
> > > BTW, a noob question -- are the updates always single page sized?
> > >
> > > This is motivated by apples vs oranges comparison since the
> > >         nr_cpus * MEMCG_CHARGE_BATCH
> > > suggests what could the expected error be in pages (bytes). But it's =
mostly
> > > wrong since: a) uncertain single-page updates, b) various counter
> > > updates summed together. I wonder whether the formula can serve to
> > > provide at least some (upper) estimate.
> > >
> >
> > Thanks for your review. This forces me to think more on this because ea=
ch
> > update does not necessarily be a single page sized update e.g. adding a=
 hugepage
> > to an LRU.
> >
> > Though I think the error is time bounded by 2 seconds but in those 2 se=
conds
> > mathematically the error can be large.
>
> Sounds significant?

Yes it can be.

>
> > What do you think of the following
> > change? It will bound the error better within the 2 seconds window.
>
> This didn't seem to go anywhere.  I'll send "memcg: flush stats only if
> updated" Linuswards, but please remember to resurrect this idea soonish
> (this month?) if you think such a change is desirable.
>

Yes, I will follow up on this soon.
