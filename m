From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH] ipc: remove memcg accounting for sops objects in
 do_semtimedop()
Date: Tue, 14 Sep 2021 16:32:20 +0200
Message-ID: <YUCydCo+N8XFdyTU@dhcp22.suse.cz>
References: <90e254df-0dfe-f080-011e-b7c53ee7fd20@virtuozzo.com>
 <YT8NrsaztWNDpKXk@dhcp22.suse.cz>
 <CALvZod7Y4pC4XvqVp+tJ==CnS5Ay8YPqrxeUzA8tMLu+0U3hjQ@mail.gmail.com>
 <YUBLrJOL6DGxmira@dhcp22.suse.cz>
 <20210914142316.GA23024@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631629940; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H8cl6i/Xuxe8x3+G+xdschhZeDxTx8TVhW/IfLYXe8g=;
        b=ic/UhyEZIPK10iNW01IYfzvu+rOZxxQP19bKkTCbeUetDCBq7x25/tljIRbq7E9Xf9yWGs
        s1bw70mn5grnjbE5rrWFcN1ivU/qIVXWNtsGAW1jnxtmK4IQ+JdSTcoHnFf1puZhFpQT/B
        Uv5QTCrnI+Y9RByFJ7YrBZRk/5q8nU4=
Content-Disposition: inline
In-Reply-To: <20210914142316.GA23024@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Shakeel Butt <shakeelb@google.com>, Vasily Averin <vvs@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, kernel@openvz.org, Cgroups <cgroups@vger.kernel.org>

On Tue 14-09-21 16:23:16, Michal Koutny wrote:
> On Tue, Sep 14, 2021 at 09:13:48AM +0200, Michal Hocko <mhocko@suse.com> =
wrote:
> > "
> > This object can consume up to 2 pages, syscall is sleeping one,
> > size and duration can be controlled by user, and this allocation
> > can be repeated by many thread at the same time.
> > "
> >=20
> > It sounds like a problem, except it is not because? A worst case
> > scenario evaluation would be beneficial for example
>=20
> AFAICS, the offending allocation is in place only during the duration of
> the syscall. So it's basically O(#tasks).
> Considering at least 2 pages for task_struct + 2 pages for kernel stack,
> back of the envelope calculation gives me the footprint amplification is
> <1.5.
> The factor would IMO be interesting if it was >> 2 (from the PoV of
> excessive (ab)use, fine-grained accounting seems to be currently
> unfeasible due to performance impact).

Yes this sounds exactly like something I would appreciate in the
changelog. With that or similar feel free to add
Acked-by: Michal Hocko <mhocko@suse.com>

Thanks a lot Michal for this clarification!=20

> The commit message can be more explicit about this but to the patch
> Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>
--=20
Michal Hocko
SUSE Labs
