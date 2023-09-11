From: Wei Xu <weixugc@google.com>
Subject: Re: [PATCH v4 4/4] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Mon, 11 Sep 2023 13:01:25 -0700
Message-ID: <CAAPL-u9XwMcrqVRu871tGNKa3LKmJSy9pZQ7A98uDbG6ACzMxQ@mail.gmail.com>
References: <20230831165611.2610118-1-yosryahmed@google.com>
 <20230831165611.2610118-5-yosryahmed@google.com> <ZPX0kCKd4TaVLJY7@dhcp22.suse.cz>
 <CAAPL-u9D2b=iF5Lf_cRnKxUfkiEe0AMDTu6yhrUAzX0b6a6rDg@mail.gmail.com>
 <ZP8SDdjut9VEVpps@dhcp22.suse.cz> <CAAPL-u8NndkB2zHRtF8pVBSTsz854YmUbx62G7bpw6BMJiLaiQ@mail.gmail.com>
 <ZP9rtiRwRv2bQvde@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694462497; x=1695067297; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rc/ITscuXzrOZNzjOX81ClkWsxPRiA/63di+UZB/Fss=;
        b=loVr5hheOIVu6QcpbW91kAq1raiTl38ExhJf72I1lu/K0nWWQ469avMmQXzMhv6z5A
         mB4jLNCPgCkONX9xh9AQooa160FrsBB22SHjqDlVOx3DqEaYw/qVA1bNDTgLvtajW8dR
         MYhpJ+/ltVZd5yes+IDWvg+AWy0pq7lrAKoMWgifahmI4Ocep8YkkamDSR//fi3FhFYa
         k6rV6eQwg8/jJzqGhsWUebGgxg4+mYCDHKGws/FSVH3jFb+3bs+yxYdFdWp/2AJ5lJjr
         qBVmQjJh1p2qWInGgN5+OQ3oT56vZjcczn8X9xKQfLhr5UywVbcT55CKtDccOvRbFFKi
         hM7A==
In-Reply-To: <ZP9rtiRwRv2bQvde@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko@suse.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>

On Mon, Sep 11, 2023 at 12:34=E2=80=AFPM Michal Hocko <mhocko@suse.com> wro=
te:
>
> On Mon 11-09-23 12:15:24, Wei Xu wrote:
> > On Mon, Sep 11, 2023 at 6:11=E2=80=AFAM Michal Hocko <mhocko@suse.com> =
wrote:
> > >
> > > On Thu 07-09-23 17:52:12, Wei Xu wrote:
> > > [...]
> > > > I tested this patch on a machine with 384 CPUs using a microbenchma=
rk
> > > > that spawns 10K threads, each reading its memory.stat every 100
> > > > milliseconds.
> > >
> > > This is rather extreme case but I wouldn't call it utterly insane
> > > though.
> > >
> > > > Most of memory.stat reads take 5ms-10ms in kernel, with
> > > > ~5% reads even exceeding 1 second.
> > >
> > > Just curious, what would numbers look like if the mutex is removed an=
d
> > > those threads would be condending on the existing spinlock with lock
> > > dropping in place and removed. Would you be willing to give it a shot=
?
> >
> > Without the mutex and with the spinlock only, the common read latency
> > of memory.stat is still 5ms-10ms in kernel. There are very few reads
> > (<0.003%) going above 10ms and none more than 1 second.
>
> Is this with the existing spinlock dropping and same 10k potentially
> contending readers?

Yes, it is the same test (10K contending readers). The kernel change
is to remove stats_user_flush_mutex from mem_cgroup_user_flush_stats()
so that the concurrent mem_cgroup_user_flush_stats() requests directly
contend on cgroup_rstat_lock in cgroup_rstat_flush().

> --
> Michal Hocko
> SUSE Labs
