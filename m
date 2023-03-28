From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 6/9] memcg: sleep during flushing stats in safe contexts
Date: Tue, 28 Mar 2023 12:26:01 -0700
Message-ID: <CAJD7tkYBO9QNZOyMt8WC0bd=wB9m1H3PHdxqPpWBx5HpUAS4Ug@mail.gmail.com>
References: <20230328061638.203420-1-yosryahmed@google.com>
 <20230328061638.203420-7-yosryahmed@google.com> <ZCMzfQuo9IhWVzRA@cmpxchg.org>
 <CAJD7tkZxEEcVZ9G7NSM56q_uOyL7e353NT06kD0mY5DyNmKTpw@mail.gmail.com> <ZCM6m/4ujEqvFVsn@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680031597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mXQXsZqlBT+IvrC1SlejLvJwmsFqvbFWj1xTrESNOYw=;
        b=CknRXyRUtdGTwn5BeQWmVKT7SMD2819Xs8pLx5U4MGjre+MnImaICr8wSz9TGbOWC9
         mVV1DZsNNCBwQc7YRWY/4N5hWGHjFAG4IBa2FO35XMRs2SQWu406qZl/OOAMaxMO3pqF
         UvlmTwbzzKtXz4FgENrQqQ1zWe3cDhXwJOwPFHqAfE1Vk2R9GD+1j3doH0DabaJ8EwPs
         kEMdmTlfozsQAlMhCy8ia1T3+1fUt8rGhUogVpJR+7XhEyMrvUiyCF3WtjzuSe3DyYnx
         IEBXT1pgM8v+EXEXYeb2OBk7LR1PCsjNlNs5qRde5KW9n23G6cBqdlRh0qNxHsDqBnGd
         cFLA==
In-Reply-To: <ZCM6m/4ujEqvFVsn-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 28, 2023 at 12:06=E2=80=AFPM Johannes Weiner <hannes-druUgvl0LCPF2uMehF1BdA@public.gmane.org=
g> wrote:
>
> On Tue, Mar 28, 2023 at 11:45:19AM -0700, Yosry Ahmed wrote:
> > On Tue, Mar 28, 2023 at 11:35=E2=80=AFAM Johannes Weiner <hannes@cmpxch=
g.org> wrote:
> > > On Tue, Mar 28, 2023 at 06:16:35AM +0000, Yosry Ahmed wrote:
> > > >  void mem_cgroup_flush_stats_ratelimited(void)
> > > >  {
> > > >       if (time_after64(jiffies_64, READ_ONCE(flush_next_time)))
> > > > -             mem_cgroup_flush_stats();
> > > > +             mem_cgroup_flush_stats_atomic();
> > > > +}
> > >
> > > This should probably be mem_cgroup_flush_stats_atomic_ratelimited().
> > >
> > > (Whee, kinda long, but that's alright. Very specialized caller...)
> >
> > It should, but the following patch makes it non-atomic anyway, so I
> > thought I wouldn't clutter the diff by renaming it here and then
> > reverting it back in the next patch.
> >
> > There is an argument for maintaining a clean history tho in case the
> > next patch is reverted separately (which is the reason I put it in a
> > separate patch to begin with) -- so perhaps I should rename it here to
> > mem_cgroup_flush_stats_atomic_ratelimited () and back to
> > mem_cgroup_flush_stats_ratelimited() in the next patch, just for
> > consistency?
>
> Sounds good to me. It's pretty minor churn.

Ack. Will do so for v2. Thanks!

>
> > > Btw, can you guys think of a reason against moving the threshold chec=
k
> > > into the common function? It would then apply to the time-limited
> > > flushes as well, but that shouldn't hurt anything. This would make th=
e
> > > code even simpler:
> >
> > I think the point of having the threshold check outside the common
> > function is that the periodic flusher always flushes, regardless of
> > the threshold, to keep rstat flushing from critical contexts as cheap
> > as possible.
>
> Good point. Yeah, let's keep it separate then.

Agreed.

>
> > > > @@ -2845,7 +2845,7 @@ static void prepare_scan_count(pg_data_t *pgd=
at, struct scan_control *sc)
> > > >        * Flush the memory cgroup stats, so that we read accurate pe=
r-memcg
> > > >        * lruvec stats for heuristics.
> > > >        */
> > > > -     mem_cgroup_flush_stats();
> > > > +     mem_cgroup_flush_stats_atomic();
> > >
> > > I'm thinking this one could be non-atomic as well. It's called fairly
> > > high up in reclaim without any locks held.
> >
> > A later patch does exactly that. I put making the reclaim and refault
> > paths non-atomic in separate patches to easily revert them if we see a
> > regression. Let me know if this is too defensive and if you'd rather
> > have them squashed.
>
> No, good call. I should have just looked ahead first :-)
