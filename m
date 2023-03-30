From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v2 7/9] workingset: memcg: sleep when flushing stats in workingset_refault()
Date: Thu, 30 Mar 2023 00:55:17 -0700
Message-ID: <CAJD7tkZfexGoyZx0ormVzp_KkYmOczxBPfFaffKqd_TD4gvGCg@mail.gmail.com>
References: <20230328221644.803272-1-yosryahmed@google.com>
 <20230328221644.803272-8-yosryahmed@google.com> <ZCU8tjqzg8cDbobQ@dhcp22.suse.cz>
 <CAJD7tkZLBs=A8m5u=9jGtMeD0ptOgtCTYUoh2r4Ex+fCkvwAXg@mail.gmail.com> <ZCU/SMr5gC9C0U+R@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680162954;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=anbj3k8bVreIFvoy5ezWKZvlLhuV6pERZy1Bnx+kNns=;
        b=ZD9aj6n0GX26RjIgVcV8XWHXeXxhiTySnXtfLlIh2Y4ULsYer620/o/Gxai5NDEyx0
         U9cLhrKkIyrcXCb9H0C1LsSrI3aYqgf3GO6P4vMGibxu+NJs5rV7tQbNe7/BuzZ9ngD4
         QlTJGq/55WJCvX0baHxwlbOU546xXFXX3rhwhxfTlPe1DtgL+SZFj+3v/M/zynT9IjDn
         ZyadAB66teMDMbs9xKwieRC4GEnlOFheMYpz1xGF7yvvoKjAofsoTZMoVDKAnSS6/+pv
         n2YA0BsqSmXP4EqjlRt/DgekBF6qWk4ejPD+mZWis8RRK9kN76WGkT00+z0dkPShQagp
         7beQ==
In-Reply-To: <ZCU/SMr5gC9C0U+R@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Thu, Mar 30, 2023 at 12:50=E2=80=AFAM Michal Hocko <mhocko@suse.com> wro=
te:
>
> On Thu 30-03-23 00:42:36, Yosry Ahmed wrote:
> > On Thu, Mar 30, 2023 at 12:39=E2=80=AFAM Michal Hocko <mhocko@suse.com>=
 wrote:
> > >
> > > On Tue 28-03-23 22:16:42, Yosry Ahmed wrote:
> > > > In workingset_refault(), we call
> > > > mem_cgroup_flush_stats_atomic_ratelimited() to flush stats within a=
n
> > > > RCU read section and with sleeping disallowed. Move the call above
> > > > the RCU read section and allow sleeping to avoid unnecessarily
> > > > performing a lot of work without sleeping.
> > >
> > > Could you say few words why the flushing is done before counters are
> > > updated rather than after (the RCU section)?
> >
> > It's not about the counters that are updated, it's about the counters
> > that we read. Stats readers do a flush first to read accurate stats.
> > We flush before a read, not after an update.
>
> Right you are, my bad I have misread the intention here.
>
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

>
> --
> Michal Hocko
> SUSE Labs
