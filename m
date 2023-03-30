From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 4/9] cgroup: rstat: add WARN_ON_ONCE() if flushing
 outside task context
Date: Thu, 30 Mar 2023 09:49:06 +0200
Message-ID: <ZCU+8lSi+e4WgT3F@dhcp22.suse.cz>
References: <20230328221644.803272-1-yosryahmed@google.com>
 <20230328221644.803272-5-yosryahmed@google.com>
 <ZCQfZJFufkJ10o01@dhcp22.suse.cz>
 <CAJD7tkb-UpKm2QbjYzB=B=oGk6Hyj9cbUviZUPC+7VsvBecH7g@mail.gmail.com>
 <20230329192059.2nlme5ubshzdbpg6@google.com>
 <ZCU1Bp+5bKNJzWIu@dhcp22.suse.cz>
 <CAJD7tka0CmRvcvB0k8DZuid1vC9OK_mFriHHbXNTUkVE7OjaTA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680162547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zl6vnuhb0+tm4UNYVkua6ap4lB/Vnj1JGtAkmTbyth8=;
        b=OtqKKjzUcmO/o0IDfFsZZQhAvhs/NKY4kJjUmP4UIDS3us0gtfDjwpZ5/hrmfHWxHHPzpI
        dZ7X131mCHa/QAdw7J0fEZfW35910RAIMN0WuPe7lYwebuRZiekoQnwdQ8sA+rGDGkzp83
        p1Te8uGBUwpnjYZ5L8u7t6zIzW2B6cI=
Content-Disposition: inline
In-Reply-To: <CAJD7tka0CmRvcvB0k8DZuid1vC9OK_mFriHHbXNTUkVE7OjaTA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Thu 30-03-23 00:13:16, Yosry Ahmed wrote:
> On Thu, Mar 30, 2023 at 12:06=E2=80=AFAM Michal Hocko <mhocko@suse.com> w=
rote:
[...]
> > So the real question is. Do we really care so deeply? After all somebody
> > might be calling this from within a spin lock or irq disabled section
> > resulting in a similar situation without noticing.
>=20
> There are discussions in [1] about making atomic rstat flush not
> disable irqs throughout the process, so in that case it would only
> result in a similar situation if the caller has irq disabled. The only
> caller that might have irq disabled is the same caller that might be
> in irq context before this series: mem_cgroup_usage().
>=20
> On that note, and while I have your attention, I was wondering if we
> can eliminate the flush call completely from mem_cgroup_usage(), and
> read the global stats counters for root memcg instead of the root
> counters. There might be subtle differences, but the root memcg usage
> isn't super accurate now anyway (e.g. it doesn't include kernel
> memory).

root memcg stats are imprecise indeed and I have to admit I do not
really know why we are adding more work for that case. I have tried to
dig into git history for that yesterday but couldn't find a satisfying
answer. It goes all the way down to 2d146aa3aa842 which has done the
switch to rstat. Maybe Johannes remembers.

Anyway, back to this particular patch. I still do not see strong reasons
to be verbose about !in_task case so I would just drop this patch.
--=20
Michal Hocko
SUSE Labs
