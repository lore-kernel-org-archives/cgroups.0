From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v1 6/9] memcg: sleep during flushing stats in safe
 contexts
Date: Tue, 28 Mar 2023 15:06:03 -0400
Message-ID: <ZCM6m/4ujEqvFVsn@cmpxchg.org>
References: <20230328061638.203420-1-yosryahmed@google.com>
 <20230328061638.203420-7-yosryahmed@google.com>
 <ZCMzfQuo9IhWVzRA@cmpxchg.org>
 <CAJD7tkZxEEcVZ9G7NSM56q_uOyL7e353NT06kD0mY5DyNmKTpw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112; t=1680030365;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WQyIrdKCsHvb8zLTh5h/QnKicAPnjV8XyfAnbUhyqtc=;
        b=eGikLsGLFoVUkW6GbVQkOFBoDpp+W99UiFbI/1642zWEFZ3juLQaRaltNCn2wU02D4
         YL7jzA8mTQn67wxUeBcnWhvdMnr7A5ebifJPOyfQPIkEOzJxi6194cbH6C6j3kKl8Ywl
         XY3zE4et0pjZlCrDxONVchgaIVK8GzX60e6GQTpdrsOE/QF3qkhQESQeWnFpo7qhv9f7
         3d5b6XKEPzhosboezNX9Lu3mnNa36lMRugddSdn5yJmIE4bQr6mBDyVxDY/HWbX3+3KJ
         cJRFP4ssIfd/HvC3ZbE6cl+jYuymOoi7hkVc8hvAod8Y9FnsSo8mTPul4jkMAP7OITxv
         Ta/A==
Content-Disposition: inline
In-Reply-To: <CAJD7tkZxEEcVZ9G7NSM56q_uOyL7e353NT06kD0mY5DyNmKTpw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Tue, Mar 28, 2023 at 11:45:19AM -0700, Yosry Ahmed wrote:
> On Tue, Mar 28, 2023 at 11:35=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.=
org> wrote:
> > On Tue, Mar 28, 2023 at 06:16:35AM +0000, Yosry Ahmed wrote:
> > >  void mem_cgroup_flush_stats_ratelimited(void)
> > >  {
> > >       if (time_after64(jiffies_64, READ_ONCE(flush_next_time)))
> > > -             mem_cgroup_flush_stats();
> > > +             mem_cgroup_flush_stats_atomic();
> > > +}
> >
> > This should probably be mem_cgroup_flush_stats_atomic_ratelimited().
> >
> > (Whee, kinda long, but that's alright. Very specialized caller...)
>=20
> It should, but the following patch makes it non-atomic anyway, so I
> thought I wouldn't clutter the diff by renaming it here and then
> reverting it back in the next patch.
>=20
> There is an argument for maintaining a clean history tho in case the
> next patch is reverted separately (which is the reason I put it in a
> separate patch to begin with) -- so perhaps I should rename it here to
> mem_cgroup_flush_stats_atomic_ratelimited () and back to
> mem_cgroup_flush_stats_ratelimited() in the next patch, just for
> consistency?

Sounds good to me. It's pretty minor churn.

> > Btw, can you guys think of a reason against moving the threshold check
> > into the common function? It would then apply to the time-limited
> > flushes as well, but that shouldn't hurt anything. This would make the
> > code even simpler:
>=20
> I think the point of having the threshold check outside the common
> function is that the periodic flusher always flushes, regardless of
> the threshold, to keep rstat flushing from critical contexts as cheap
> as possible.

Good point. Yeah, let's keep it separate then.

> > > @@ -2845,7 +2845,7 @@ static void prepare_scan_count(pg_data_t *pgdat=
, struct scan_control *sc)
> > >        * Flush the memory cgroup stats, so that we read accurate per-=
memcg
> > >        * lruvec stats for heuristics.
> > >        */
> > > -     mem_cgroup_flush_stats();
> > > +     mem_cgroup_flush_stats_atomic();
> >
> > I'm thinking this one could be non-atomic as well. It's called fairly
> > high up in reclaim without any locks held.
>=20
> A later patch does exactly that. I put making the reclaim and refault
> paths non-atomic in separate patches to easily revert them if we see a
> regression. Let me know if this is too defensive and if you'd rather
> have them squashed.

No, good call. I should have just looked ahead first :-)
