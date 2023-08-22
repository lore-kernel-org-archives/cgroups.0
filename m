From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH 2/3] mm: memcg: add a helper for non-unified stats flushing
Date: Tue, 22 Aug 2023 09:00:06 -0700
Message-ID: <CAJD7tkaVuiMU-ifJiyH5d_W1hi9DnAymYJxzBxEKCVX+tU=OCA@mail.gmail.com>
References: <20230821205458.1764662-1-yosryahmed@google.com>
 <20230821205458.1764662-3-yosryahmed@google.com> <y7vvyndehadwy5ouounm5oyo52bqhsysiizuphzki2h3bwpdpc@3hvaq6sp6f4k>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692720043; x=1693324843;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/rWz75d47k1ZaMKSZ8edfmuuQmWRaz5rkymhn45IF0k=;
        b=15DCdBwX9G07pujOr3Nbx+i2bQ13Rphta48yDKVMfOIAUrZfp2m22HFbnXuC7Oprxc
         42lqBtGWYqaLduCFwdCo1FynweYmtDURInMRPCUhGUVgu5oG6stOtXegP48Q3A1ICaKY
         mLXJqLzKp6NFvac+PoOcfeHDT0Ie8vy0eeyyqIA1UQwwnJr8+OV0+tZwBa6fFKNNajbx
         /R3v6DMUGqUbo0C/VZjwBMI/FVX+Kt7H3Q/NXSv6GsmwHD3pN0N2pSB8V2M4uwhGCThg
         5KSOGPPN5e+K+6w4K5ICQ5i34gRorsUI8RcNwjR34ZQoyFdkIT0jWtcp9wAs94exiQYO
         Zklw==
In-Reply-To: <y7vvyndehadwy5ouounm5oyo52bqhsysiizuphzki2h3bwpdpc@3hvaq6sp6f4k>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Aug 22, 2023 at 6:01=E2=80=AFAM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> On Mon, Aug 21, 2023 at 08:54:57PM +0000, Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > +static void do_stats_flush(struct mem_cgroup *memcg)
> > +{
> > +     cgroup_rstat_flush(memcg->css.cgroup);
>         if(memcg =3D=3D root_mem_cgroup)
>                 atomic_set(&stats_flush_threshold, 0);
> > +}
> > +
> >  /*
> >   * do_unified_stats_flush - do a unified flush of memory cgroup statis=
tics
> >   *
> > @@ -656,7 +667,7 @@ static void do_unified_stats_flush(void)
> >
> >       WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
> >
> > -     cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
> > +     do_stats_flush(root_mem_cgroup);
> >
>   -     atomic_set(&stats_flush_threshold, 0);
> >       atomic_set(&stats_flush_ongoing, 0);
>
> You may reset stats_flush_threshold to save the unified flushers some
> work.

We can probably also kick FLUSH_TIME forward as well. Perhaps I can
move both into do_stats_flush() then. If I understand correctly this
is what you mean?

static void do_stats_flush(struct mem_cgroup *memcg)
{
       if (mem_cgroup_is_root(memcg))
               WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);

       cgroup_rstat_flush(memcg->css.cgroup);

       if (mem_cgroup_is_root(memcg))
               atomic_set(&stats_flush_threshold, 0);
}

  static void do_unified_stats_flush(void)
  {
          if (atomic_read(&stats_flush_ongoing) ||
              atomic_xchg(&stats_flush_ongoing, 1))
                  return;

          do_stats_flush(root_mem_cgroup);
          atomic_set(&stats_flush_ongoing, 0);
  }

, or simplify it further by just resetting stats_flush_threshold
before we flush as well:

static void do_stats_flush(struct mem_cgroup *memcg)
{
       /* for unified flushing, root non-unified flushing can help as well =
*/
       if (mem_cgroup_is_root(memcg)) {
               WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
               atomic_set(&stats_flush_threshold, 0);
       }

       cgroup_rstat_flush(memcg->css.cgroup);
}

  static void do_unified_stats_flush(void)
  {
          if (atomic_read(&stats_flush_ongoing) ||
              atomic_xchg(&stats_flush_ongoing, 1))
                  return;

          do_stats_flush(root_mem_cgroup);
          atomic_set(&stats_flush_ongoing, 0);
  }


What do you think?
