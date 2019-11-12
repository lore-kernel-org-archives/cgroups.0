From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 3/3] mm: vmscan: enforce inactive:active ratio at the
 reclaim root
Date: Tue, 12 Nov 2019 11:13:09 -0800
Message-ID: <CAJuCfpFJ-tzqc6Ng-6ntQn46iatgOdLF5PY6WAcOHVvGSQGwMg@mail.gmail.com>
References: <20191107205334.158354-1-hannes@cmpxchg.org> <20191107205334.158354-4-hannes@cmpxchg.org>
 <CAJuCfpHSTr8Vt+Tj-Hj4OBYHq1ucw7_B1VoVWKEHQVPHaMhUdA@mail.gmail.com> <20191112180019.GB178331@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RtM0xm6pvdP2cIipj503CLA+c94Cc19gSxiP/7lkCo0=;
        b=oX0opbp+DaCHjx5NPFMutLUzOXNzS9qzrTQmMpDfKyHpUE5q/PBcpbwYBiWRikr0T+
         ID/+T5BH/Fixjg/Un5sKJ2fqggO2bDcV/7OnEGuNU0SpT04cpVg5galbiZtTukCxNJYS
         ezBGYSpp20/SEYfh3UyfDeDfIEkrIYBCcXW+aZleBlQRN5OyfkqbdqDFnsp5UtYSR9mf
         MSbaVZpN3HHZAQ7cWAIzDpJh0W73RsMgFsDs7RfoYIRtLAR2dETepgjpOtotx15onznZ
         92EEUVSNj0Cyic50ZTBFs243Xq2zt6jKDWsj2fFkzzD7kdi4QsUYfwQ9+hWVTT4odJd5
         dnoQ==
In-Reply-To: <20191112180019.GB178331@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Shakeel Butt <shakeelb@google.com>, Rik van Riel <riel@surriel.com>, Michal Hocko <mhocko@suse.com>, linux-mm <linux-mm@kvack.org>, cgroups mailinglist <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com

On Tue, Nov 12, 2019 at 10:00 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Sun, Nov 10, 2019 at 06:15:50PM -0800, Suren Baghdasaryan wrote:
> > On Thu, Nov 7, 2019 at 12:53 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > @@ -2758,7 +2775,17 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
> > >                         total_high_wmark += high_wmark_pages(zone);
> > >                 }
> > >
> > > -               sc->file_is_tiny = file + free <= total_high_wmark;
> > > +               /*
> > > +                * Consider anon: if that's low too, this isn't a
> > > +                * runaway file reclaim problem, but rather just
> > > +                * extreme pressure. Reclaim as per usual then.
> > > +                */
> > > +               anon = node_page_state(pgdat, NR_INACTIVE_ANON);
> > > +
> > > +               sc->file_is_tiny =
> > > +                       file + free <= total_high_wmark &&
> > > +                       !(sc->may_deactivate & DEACTIVATE_ANON) &&
> > > +                       anon >> sc->priority;
> >
> > The name of file_is_tiny flag seems to not correspond with its actual
> > semantics anymore. Maybe rename it into "skip_file"?
>
> I'm not a fan of file_is_tiny, but I also don't like skip_file. IMO
> it's better to have it describe a situation instead of an action, in
> case we later want to take additional action for that situation.
>
> Any other ideas? ;)

All other ideas still yield verbs (like sc->prefer_anon). Maybe then
add some comment at the file_is_tiny declaration that it represents
not only the fact that the file LRU is too small to reclaim but also
that there are easily reclaimable anon pages?

>
> > I'm confused about why !(sc->may_deactivate & DEACTIVATE_ANON) should
> > be a prerequisite for skipping file LRU reclaim. IIUC this means we
> > will skip reclaiming from file LRU only when anonymous page
> > deactivation is not allowed. Could you please add a comment explaining
> > this?
>
> The comment above this check tries to explain it: the definition of
> file being "tiny" is dependent on the availability of anon. It's a
> relative comparison.
>
> If file only has a few pages, and anon is easily reclaimable (does not
> require deactivation to reclaim pages), then file is "tiny" and we
> should go after the more plentiful anon pages.

Your above explanation is much clearer to me than the one in the comment :)

>
> If anon is under duress, too, this preference doesn't make sense and
> we should just reclaim both lists equally, as per usual.
>
> Note that I'm not introducing this constraint, I'm just changing how
> it's implemented. From the patch:
>
> > >         /*
> > >          * If the system is almost out of file pages, force-scan anon.
> > > -        * But only if there are enough inactive anonymous pages on
> > > -        * the LRU. Otherwise, the small LRU gets thrashed.
> > >          */
> > > -       if (sc->file_is_tiny &&
> > > -           !inactive_list_is_low(lruvec, false, sc, false) &&
> > > -           lruvec_lru_size(lruvec, LRU_INACTIVE_ANON,
> > > -                           sc->reclaim_idx) >> sc->priority) {
> > > +       if (sc->file_is_tiny) {
> > >                 scan_balance = SCAN_ANON;
> > >                 goto out;
> > >         }
>
> So it's always been checking whether reclaim would deactivate anon,
> and whether inactive_anon has sufficient pages for this priority.

I didn't realize !inactive_list_is_low(lruvec, false, sc, false) is
effectively the same as !(sc->may_deactivate & DEACTIVATE_ANON) but
after re-reading the patch that makes sense... Except when
force_deactivate==true, in which case shouldn't you consider
NR_ACTIVE_ANON as easily reclaimable too? IOW should it be smth like
this:

anon = node_page_state(pgdat, NR_INACTIVE_ANON) +
(sc->force_deactivate ? node_page_state(pgdat, NR_ACTIVE_ANON) : 0);

?
