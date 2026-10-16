Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7B938F64D
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 11:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151040; cv=pass; b=eky4GvUV0jGGIjAGnuqnhGilYtJyzVOthXmLU4wYyj9zPg24juz2Q3hHZhN2iMdi7rBTzt14o3jyTtBemzXXkZqrnPIdrFJmfVVrffkuA3Vclm0fxjhL1r6lrKS0nwd0LN8WNAlhkHieJ/gaLbuzhJmbZcGqQ6o5+rtJ0V0sgyE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151040; c=relaxed/simple;
	bh=ateyapjZ1+Cpplrl/O9ZlmzsqV17CoauWuDhejOISq4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uy2++Wys3+skHL/WC0pVWkOncftYFKjC70LQ22DqQN8OhUVQ5r4A6CWM0y5ZI5Db+o9IkUGekpUIxRdBRK/g3I+AMhXpD+/XKaMxga27ygGmEx7W+RVp4JprYev7e5EK966dZltw7KRwO2jDFxvsS7wo+fcFmCRKcPBOWpAZu7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I/SVNt7p; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I/SVNt7p"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b2232d8ef5so3270005a12.3
        for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 04:43:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792151037; cv=none;
        d=google.com; s=arc-20260327;
        b=Xyic0jle2ES68tyP2e2P0R/DxzTTLgeoJO869NDlpNKEbA5ioTePg6x8LFkXOIr4t/
         j5ZjSkCsnWLBZ0v91SnNMEaclUZfoZ5a8UJhQ9D4JZqPG/bqbz+ThJdNSwcKnu/ScfVp
         7m6uskfP1G5FyMYkGGc74Ird9iekLQUJxQzyss6b0bFrAy9YcXHAPVPkLns3sMSZf1xI
         /hRxDrUxwjCbZG8y/5Afn9f3bEBq6eCRhkOVAMUeqrmHfML1klslrzpd3DVBNHs+a4Il
         aPY5FFIYksH+bjSDfBp//dBcDAEM7i3F6g+02sOzftFIQvckDMz92U8SxcvNoKl1wNsg
         XVig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NKuM+jtVFLfZVcVKg6kbrg0atkxIvcUrEpQMeeRVJXQ=;
        fh=tJN1swy8n2gvBFtdQQr32Dxm4fIYdNtcvz2Etb1P7HI=;
        b=itdmJJKX1ZKQt7mU0j8ffzRDkafsViVqM7qccYx9TBYdcgC1aZSrsZgkUNSXV99lEU
         9+HfEbnbXXM5PeOlRWL+YrUETD9rI4JDjm3vNvI4cleBgXFOjVg1mZ9y2r2OnK5rg+af
         +93KTACG5FgQbwB1/TiXTjRivBglXebwJ0LtAQRlB/olxqMA4puQjZ5ZUhXzWPpg49tq
         el8slMbqzLjjdgQvNIrmE3VmQw04aeceVdjCmmdPsRVuMtp7ZmBSZ4RpA7kkAU8vZLgb
         nPUpSUzFPTVGU41vn8piuZQy3zMA4OK4/f3BCS9QgqkMYP1VdyzTGUKr7dB29Qr44LtL
         52uA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792151037; x=1792755837; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NKuM+jtVFLfZVcVKg6kbrg0atkxIvcUrEpQMeeRVJXQ=;
        b=I/SVNt7pr86tQOAOQgXPynlgsxsIiunTOaCJpVqF4L43B9x06fYYjmHDUqQztCkxdc
         EtXuBsdmIQmGXkYNXcBRymIQIrlblW/fEWFEpINPqd2c9HE7fv7S8kKgWfn+fiNqSkxj
         6kF8AXSb0y15/8ThoRpne3OQliL8e6EjZY39SAtDRc8nEW0H3aXsL0Oy5U006uhVHdWT
         h2oCNklbsF7xsGFe9ivj/vE6z3njIXpg216IMEXzduoM9KOP6CKALzsXev6sGvhy2CHI
         KIcODEU2J5Y4uEB61wEbvOTu+nR7gLDj1M0BwJkwyG8N4gIENUFomDnB2ATblFtHcV80
         xNRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792151037; x=1792755837;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NKuM+jtVFLfZVcVKg6kbrg0atkxIvcUrEpQMeeRVJXQ=;
        b=hXn2Le1t2q5XB5Wdlk2q0DWVU2C5I7gSuj/oXYtYfqUuX3P9Ch91VVu9BBAVP22qFg
         /95dBfOtSHnU04h2RhFHD/5AfWIBaE6GCO7Kyrp59Xo8356VM80FJK/wtqe8bBvG+M7m
         zGK1L4ytaxGnwl/yCqZBsYSk0DzycfRLDRzBipBhZrMk8Nujw1r1B2w+QKx4tO5ZqWFF
         r84F8mI/CcHv34Kn02LB9tQeaqLD7/Qhn+i38o/s5sPmgcUBNjADlPlpNESLANeT0LrF
         PLQbPNcvBcCmOX37KNCsr3ttCeMDC6Qr5s2iHlILdl2Ii4Q9MPoYWpkVIWLWk0oCr5Bb
         kEkg==
X-Forwarded-Encrypted: i=1; AKwUvBwHf7O78KUfIvX8PZDiIk+vxyWYLIPCTJrthzWApODs5mqEIFPpxgAx4ZW+eFL60tyKVYUWJEZj@vger.kernel.org
X-Gm-Message-State: AFq9FYKjaF4gYAznlROufGzmcNr3Z+O5biFjhYqSgEdSqkCSW6jEqFLg
	awnyJnyXj3577jOralso8jAlyUkS8NYdKT5fDHSv7eacgv+qYlHE9dT+/RxNy70erTXLfEbvGV1
	y+iSGa/op5AINS3wcfF110+FmB2ZyEUHp8DledH0EYQ==
X-Gm-Gg: AYBFou1xKZ3Ff3Bal6wERLb2LNxPXSESxBinRC2OR9bDHnni+Jc3VhGxA8O9wHZVZSF
	4kBv5dRZig5tNn+Z6BITxoXI3KqRES7Ona/pau4B4Jui/lvMFuJtx+haYRL91AlQroA+Z8K5Wy5
	HMOewHr3xFVS/xz2a9q5SL1tjk5V47DibTBSso3fGPCsM2T2SZjXohpeZKiLn/hYjSxc5UGZWhu
	FOL7bxtc5M/aJ5psEfaKm3AzphaIezjC9yvFPD3Je+HOSn0GgiIl8Zijv6LCl/dTMiGUxD0IUBi
	gDISRasduajxSfMyhwD5rtopEJswtN2YE63TRWRn6SqNgrMO4gUm6I49+WnsbJA08BMI4f1OAnV
	Ze/lZsCY8ky4G
X-Received: by 2002:a17:906:4790:b0:c25:5faf:b207 with SMTP id
 a640c23a62f3a-c31a9a10e7fmr2051644866b.3.1792151036607; Fri, 16 Oct 2026
 04:43:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com> <20261016084256.12955-1-baohua@kernel.org>
In-Reply-To: <20261016084256.12955-1-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 16 Oct 2026 19:43:19 +0800
X-Gm-Features: AclHuK_vD7Q6cJy-PpEfQtWOtckePrdQvkfJvtJJCDIcYrRZMuAvFqbDO7Y_PeA
Message-ID: <CAMgjq7AtuK22FsuqvGRLVZ2eWrp-N4qQ_MHoXsXDkVBprekdDA@mail.gmail.com>
Subject: Re: [PATCH v4 00/17] mm/mglru: frequency guided promotion (MGLRU-FG)
 and flag cleanup
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: devnull+kasong.tencent.com@kernel.org, akpm@linux-foundation.org, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, 
	cgroups@vger.kernel.org, chenridong@xiaomi.com, chrisl@kernel.org, 
	damon@lists.linux.dev, david@kernel.org, dev.jain@arm.com, 
	ehab.ababneh@intel.com, gourry@gourry.net, hannes@cmpxchg.org, 
	hughd@google.com, kunwu.chan@gmail.com, lance.yang@linux.dev, 
	liam@infradead.org, lianux.mm@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, liuxiang.277@bytedance.com, ljs@kernel.org, 
	mhocko@kernel.org, muchun.song@linux.dev, nico.pache@linux.dev, 
	nphamcs@gmail.com, qi.zheng@linux.dev, rientjes@google.com, 
	roman.gushchin@linux.dev, ryan.roberts@arm.com, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, sj@kernel.org, surenb@google.com, 
	tz2294@columbia.edu, usama.arif@linux.dev, vbabka@kernel.org, 
	vernon2gm@gmail.com, wangzicheng@honor.com, weixugc@google.com, 
	willy@infradead.org, ying.huang@linux.alibaba.com, youngjun.park@lge.com, 
	yuanchu@google.com, yuzhao@google.com, zhaozhengzhuo@uniontech.com, 
	ziy@nvidia.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 16, 2026 at 4:43=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> On Fri, Oct 16, 2026 at 2:15=E2=80=AFAM Kairui Song via B4 Relay <devnull=
+kasong.tencent.com@kernel.org> wrote:
> [...]
> >
> > LevelDB Scan/Get
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > I also retested the LevelDB benchmark from the cache_ext paper [5].
> > Interestingly, mainline MGLRU already beats CLRU on this one after a
> > recent change in lru_gen_folio_seq that bumps new folios with refs =3D=
=3D 1
> > to the second-oldest generation as discussed. That change accidentally
> > gave random reads a higher hotness level while making sequential reads
> > much colder as described before [14]. However it's unreliable and
> > incorrect because it depends on LRU drain timing, and hurts some worklo=
ads
> > as reported, or where the sequential part is actually hotter (any workl=
oad
> > involving hotter large file and many small cold files will be affected)
> > which is reproduced below.
> >
> > This series improves it while covering ordinary workloads too and shoul=
d
> > fix regressions:
> >
> > LevelDB Scan / Get, Throughput Total:
> > CLRU:         4708.3 ops/s
> > MGLRU:        5026.9 ops/s (faster than CLRU, but hurts other workloads=
)
> > MGLRU After:  5179.2 ops/s (even better in all cases, and no regression=
)
> >
> > The hot-sequential and cold-random workload can be easily reproduced wi=
th
> > SQLite and grep. SQLite continuously scans and looks up a small hot
> > portion of a DB file, while grep iterates over a set of small files muc=
h
> > larger than RAM [6]:
> >
> >          SQLite scan & lookup time:       Grep iterate time:
> > CLRU:                       14.51ms               13281.37ms
> > MGLRU mainline:            567.05ms               13694.47ms
> > MGLRU After this series:    10.58ms               12930.43ms
> >
>
> Thanks, Kairui. I'll do a thorough review of the whole patchset over
> the next two weeks.
>
> BTW, do you think we need a quick fix patch like the one below
> for the above problem before this patchset, so that it can be
> backported to stable? I assume your patchset is too large to
> backport?

Hi Barry,

Good question, I think we can patch it first.

> From f9683205d2ab6e3b185022d7d5af3496dfe5f35f Mon Sep 17 00:00:00 2001
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> Date: Fri, 16 Oct 2026 11:48:06 +0800
> Subject: [PATCH] mm/mglru: fix using folio_mark_accessed to replace
>  folio_set_active
>
> Commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to
> replace folio_set_active") tried to avoid over-protecting
> fault-around read-ahead file folios by placing them in the
> second-oldest generation instead of the youngest generations.
>
> However, it abuses `PG_referenced` on read-ahead file folios
> for this purpose, potentially coupling their handling with
> normal syscall-based file accesses that also use
> `PG_referenced`.
>
> This could regress some workloads, as reported by Kairui Song[1]
> and Ehab Ababneh[2]. Many thanks to both for reporting these
> issues!
>
> The long-term fix is Kairui's MGLRU-FG, but in the meantime,
> we also need a quick fix that can be backported to stable.
>
> This patch reverts all of the original commit's behavior that
> abuses `PG_referenced`, while preserving the semantics of
> avoiding over-protection of fault-around read-ahead file
> folios by adjusting only `lru_gen_folio_seq()`.
> Specifically, fault-around read-ahead file folios with
> `PG_active` set but `PG_workingset` clear are placed in the
> second-oldest generation.
> Activated file folios and refaulted workingset file folios
> are still placed in the youngest generations.
>
> Build kernel cases in a memcg shows it not only perserve
> the benefit of original patch, but also even improve
> performance further.
>
> w/o fix:
>
> real    1m49.094s
> user    25m31.484s
> sys     3m40.959s
> pswpin: 662112
> pswpout: 2504415
> pgpgin: 4424336
> pgpgout: 10355273
> refault_file: 359626
> refault_anon: 670724
>
> w/ fix:
>
> real    1m48.913s
> user    25m31.639s
> sys     3m30.875s
> pswpin: 689815
> pswpout: 2689894
> pgpgin: 4422659
> pgpgout: 11043464
> refault_file: 326566
> refault_anon: 697138
>
> Revert original patch:
>
> real    1m50.044s
> user    25m37.137s
> sys     4m4.493s
> pswpin: 1349087
> pswpout: 4317933
> pgpgin: 7083597
> pgpgout: 17602735
> refault_file: 337676
> refault_anon: 1368542
>
> [1] https://lore.kernel.org/linux-mm/20261003-mglru-fg-v3-0-cbd4546a5bd9@=
tencent.com/
> [2] https://lore.kernel.org/linux-mm/20260901180704.168106-1-ehab.ababneh=
@intel.com/
> Fixes: 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to replace folio_=
set_active")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  include/linux/mm_inline.h |  8 +++++---
>  mm/folio.c                | 16 +++-------------
>  mm/vmscan.c               |  9 ++-------
>  mm/workingset.c           | 10 ++++------
>  4 files changed, 14 insertions(+), 29 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index ab69b9930893..7aaff4e06e80 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -311,7 +311,8 @@ static inline unsigned long lru_gen_folio_seq(const s=
truct lruvec *lruvec,
>          * | Accessed through page tables and  | Accessed through file de=
scriptors |
>          * | promoted by folio_update_gen()    | and protected by folio_i=
nc_gen()  |
>          * +-----------------------------------+-------------------------=
----------+
> -        * | PG_active (set while isolated)    |                         =
          |
> +        * | PG_active (set while isolated)    | PG_active (files|       =
          |
> +        * |                                   | fault-readahead)|       =
          |

This comment is not correct I think, faulting file folios are not
access through fd, we may just better leave it uncommented.

>          * +-----------------+-----------------+-----------------+-------=
----------+
>          * |  PG_workingset  |  PG_referenced  |  PG_workingset  |  LRU_R=
EFS_FLAGS |
>          * +-----------------------------------+-------------------------=
----------+
> @@ -319,7 +320,8 @@ static inline unsigned long lru_gen_folio_seq(const s=
truct lruvec *lruvec,
>          * |<---------------------------- MAX_NR_GENS -------------------=
--------->|
>          */
>         if (folio_test_active(folio))
> -               gen =3D MIN_NR_GENS - folio_test_workingset(folio);
> +               gen =3D MIN_NR_GENS - folio_test_workingset(folio) +
> +                     (type ? !folio_test_workingset(folio) : 0);

This looks a bit hard to follow. Does it mean that for active but
non-workingset files, they are put into the third newest generation?
It creates more divergence of file / anon but if it work for now, I'm
fine with it.

>         else if (reclaiming)
>                 gen =3D MAX_NR_GENS;
>         else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(foli=
o)) ||
> @@ -327,7 +329,7 @@ static inline unsigned long lru_gen_folio_seq(const s=
truct lruvec *lruvec,
>                   (folio_test_dirty(folio) || folio_test_writeback(folio)=
)))
>                 gen =3D MIN_NR_GENS;
>         else
> -               gen =3D MAX_NR_GENS - (folio_test_workingset(folio) || fo=
lio_test_referenced(folio));
> +               gen =3D MAX_NR_GENS - folio_test_workingset(folio);

This is a nice change, but meanwhile the LevelDB and cerain workload
gain are gone too, we will again have a ~40% regression for similiar
workloads, I just double checked it. But that's fine, though, it was
never meant to be optimized that way, and the long-term fix can be
done later.

A quick test on another of my test machine using Tal's LevelDB test case:

CLRU: 3098 ops/s
MGLRU mainline: 3035 ops/s
MGLRU-FG: 3233 ops/s
MGLRU with this patch: 2194 ops/sec (should be same result with
reverting 6cbdd9726fb5)

>
>         return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen=
->min_seq[type]));
>  }
> diff --git a/mm/folio.c b/mm/folio.c
> index 35e242b48870..2af724cecb31 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -474,20 +474,10 @@ void folio_add_lru(struct folio *folio)
>                         folio_test_unevictable(folio), folio);
>         VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
>
> -       /*
> -        * For refaulted workingset folios, set PG_active so they
> -        * can be added to active generations.
> -        * For prefaulted file folios, folio_mark_accessed() sets
> -        * PG_referenced so lru_gen_folio_seq() places them into
> -        * the second oldest generation.
> -        */
> +       /* see the comment in lru_gen_folio_seq() */
>         if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
> -           lru_gen_in_fault() && !(current->flags & PF_MEMALLOC)) {
> -               if (folio_test_workingset(folio))
> -                       folio_set_active(folio);
> -               else if (!folio_test_referenced(folio))
> -                       folio_mark_accessed(folio);
> -       }
> +           lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
> +               folio_set_active(folio);
>
>         folio_batch_add_and_move(folio, lru_add);
>  }
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index daa7e37c2236..e82ba737c028 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -952,13 +952,8 @@ static bool lru_gen_set_refs(struct folio *folio, co=
nst vma_flags_t *vma_flags)
>                 return false;
>         }
>
> -       /* Promote on second access */
> -       if (folio_lru_refs(folio) > 1) {
> -               folio_set_workingset(folio);
> -               folio_set_lru_refs(folio, 0);
> -       } else {
> -               folio_mark_accessed(folio);
> -       }
> +       folio_set_workingset(folio);
> +       folio_set_lru_refs(folio, 0);
>         return true;
>  }
>  #else
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 1504f91cdca5..10d4ce202cca 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -319,13 +319,11 @@ static void lru_gen_refault(struct folio *folio, vo=
id *shadow)
>
>         atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
>
> +       /* see folio_add_lru() where folio_set_active() will be called */
> +       if (lru_gen_in_fault())
> +               mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type,=
 delta);
> +
>         if (workingset) {
> -               /*
> -                * see folio_add_lru(), where folio_set_active() is
> -                * called for workingset folios
> -                */
> -               if (lru_gen_in_fault())
> -                       mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE=
 + type, delta);
>                 folio_set_workingset(folio);
>                 mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + type, =
delta);
>         } else
> --
> 2.34.1
>

The rest most looks clean to me.
