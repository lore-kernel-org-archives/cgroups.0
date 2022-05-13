From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 6/6] zswap: memcg accounting
Date: Fri, 13 May 2022 13:08:13 -0400
Message-ID: <Yn6QfdouzkcrygTR@cmpxchg.org>
References: <20220510152847.230957-1-hannes@cmpxchg.org>
 <20220510152847.230957-7-hannes@cmpxchg.org>
 <20220511173218.GB31592@blackbody.suse.cz>
 <YnwJUL90fuoHs3YW@cmpxchg.org>
 <20220513151426.GC16096@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zXhkDIVf27CV50GWaqhnTSClMrVWORrrk1UTjwHnru8=;
        b=cnwlzxqBMjsJ+1WY7JYGk0zmaRis0uxKC7n7kcvotpz3nsqvchPQgSX6XYMUfhDe6C
         zQX+xYwhjdbi9MoF65ZpjqRRK7MJ0XKfxooT6ZqFqqo5RjIKjDa+M6SKyoLVYCac5pnq
         F/Ub9Xe3njx+6EalimZC+4nsWYG/wjM6ZV3DJI5rfIRoltmydpP3cLFDVWHPmw472OJh
         wjt3Bfjw86NWL6eyRuQrhiFfaHCEQEWvic5An3l6SAxg8tWA6OZwBS1CE8KjO+VtdCEW
         IPvb1TfV5UEO/ymbUOlWpPhhEU9+bxxgQMSRElxcmydKAxpio18y2YkuyD7/w+eB4Eo5
         aUFw==
Content-Disposition: inline
In-Reply-To: <20220513151426.GC16096-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello Michal,

On Fri, May 13, 2022 at 05:14:26PM +0200, Michal Koutn=FD wrote:
> On Wed, May 11, 2022 at 03:06:56PM -0400, Johannes Weiner <hannes-druUgvl=
0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > Correct. After which the uncompressed page is reclaimed and uncharged.
> > So the zswapout process will reduce the charge bottom line.
>=20
> A zswap object falling under memory.current was my first thinking, I was
> confused why it's exported as a separate counter memory.zswap.current
> (which IMO suggests disjoint counting) and it doubles a
> memory.stat:zswap entry.
>=20
> Is the separate memory.zswap.current good for anything? (Except maybe
> avoiding global rstat flush on memory.stat read but that'd be an
> undesired precendent.)

Right, it's accounted as a subset rather than fully disjointed. But it
is a limitable counter of its own, so I exported it as such, with a
current and a max knob. This is comparable to the kmem counter in v1.

From an API POV it would be quite strange to have max for a counter
that has no current. Likewise it would be strange for a major memory
consumer to be missing from memory.stat.

> (Ad the eventually reduced footprint, the transitional excursion above
> memcg's (or ancestor's) limit should be limited by number of parallel
> reclaims running (each one at most a page, right?), so it doesn't seem
> necessary to tackle (now).)

Correct.

> > memory.zswap.* are there to configure zswap policy, within the
> > boundaries of available memory - it's by definition a subset.
>=20
> I see how the .max works when equal to 0 or "max". The intermediate
> values are more difficult to reason about.

It needs to be configured to the workload's access frequency curve,
which can be done with trial-and-error (reasonable balance between
zswpins and pswpins) or in a more targeted manner using tools such as
page_idle, damon etc.

> Also, I can see that on the global level, zswap is configured relatively
> (/sys/module/zswap/parameters/max_pool_percent).
> You wrote that the actual configured value is workload specific, would
> it be simpler to have also relative zswap limit per memcg?
>
> (Relative wrt memory.max, it'd be rather just a convenience with this
> simple ratio, however, it'd correspond to the top level limit. OTOH, the
> relatives would have counter-intuitive hierarchical behavior. I don't
> mean this should be changed, rather wondering why this variant was
> chosen.)

A percentage isn't a bad way to pick a global default limit for a
kernel feature. But it would have been preferable if zswap had used
the percentage internally and made the knob based in bytes (like
min_free_kbytes for example).

Because for load tuning, bytes make much more sense. That's how you
measure the workingset, so a percentage is an awkward indirection. At
the cgroup level, it makes even less sense: all memcg tunables are in
bytes, it would be quite weird to introduce a "max" that is 0-100. Add
the confusion of how percentages would propagate down the hierarchy...

> > +bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
> > +{
> > +     struct mem_cgroup *memcg, *original_memcg;
> > +     bool ret =3D true;
> > +
> > +     original_memcg =3D get_mem_cgroup_from_objcg(objcg);
> > +     for (memcg =3D original_memcg; memcg !=3D root_mem_cgroup;
> > +          memcg =3D parent_mem_cgroup(memcg)) {
> > +             unsigned long max =3D READ_ONCE(memcg->zswap_max);
> > +             unsigned long pages;
> > +
> > +             if (max =3D=3D PAGE_COUNTER_MAX)
> > +                     continue;
> > +             if (max =3D=3D 0) {
> > +                     ret =3D false;
> > +                     break;
> > +             }
> > +
> > +             cgroup_rstat_flush(memcg->css.cgroup);
>=20
> Here, I think it'd be better not to bypass mem_cgroup_flush_stats() (the
> mechanism is approximate and you traverse all ancestors anyway), i.e.
> mem_cgroup_flush_stats() before the loop instead of this.

I don't traverse all ancestors, I bail on disabled groups and skip
unlimited ones. This saves a lot of flushes in practice right now: our
heaviest swapping cgroups have zswap disabled (max=3D0) because they're
lowpri and forced to disk. Likewise, the zswap users have their zswap
limit several levels down from the root, and I currently don't ever
flush the higher levels (max=3DPAGE_COUNTER_MAX).

Flushing unnecessary groups with a ratelimit doesn't sound like an
improvement to me.

Thanks
