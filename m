Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC35F55D88D
	for <cgroups@vger.kernel.org>; Wed,  9 Sep 2026 13:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788959910; cv=pass; b=kUkdzFHxxSn/rVI/GjYKnIV/3EVM09XQmaUMT3CF/eDwWZay+aLCTlKcVenudXyRjWdhuPBQeV3xAuOOCbAO84QDx0HTXwiA+kXWamypgMesiizW7/FavSPJisRLUpqn54+poF3gW+EvdJa4MtoYZobXJdHzGXBsutsSOYGW068=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788959910; c=relaxed/simple;
	bh=1lzX+47PLtI0a5fdd4NmDGDTIzRAcDxyP0vT2uPczU0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a/wjQviW6uBwwiR+1zMfRArBC/YcNJu6ia7pAp7854HGWBKeAAC9ykQ5AVBvqiCbXvxY1dFRRPEITfkxyP0jONIc3It5GyMuzS7I1ybUhN8/nTDNpjxmGRZe3Qy2d95Y1C4r86ZfqslUZYCDkCco2RpbWgvv7iFgxJ8pZYOSUKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=gfaEaMN+; arc=pass smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="gfaEaMN+"
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-86382f10801so13092087b3.1
        for <cgroups@vger.kernel.org>; Wed, 09 Sep 2026 06:18:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788959904; cv=none;
        d=google.com; s=arc-20260327;
        b=WLIHyrYG1ZHpYFA5kZZ4kwI+/67qwjUoM78ZtB5mq/29p2C4rE1//Co/Kl1/b70PiS
         auQ0oGbuYufHPXKaxF+F3dCJC6iH6fIDjfjFSGCFreVK5j0UUwYascYOrOjAF2hgUL3A
         2UYuEJTy9okZIe9WiLMQsWpubHhlKPhWTBrTMISFdfDg7NXYJGTvwEy/oMF2klEpvjzn
         EI1qwNM8hO+LvusGdwmsnuPtjf3oogC8tje2asxry4sqiQDJyl5B29EmLpIKdsPFBLa0
         h0tZ0KLN0Sp6Dd8JpWJCws3vWq1NnsDRSGqAs6ULz7/moCTnM90wNefn0l9giZKahCiC
         ucdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dB9s3FYZowUuXLZgEMY+0LbMoABpg3BhWeFIHXgpTgA=;
        fh=MS3rmbdsUabvIc5F+rR46igA+7yAVagQUzA+sZR016c=;
        b=DyPxAyWgk3I2bocCBcOClVe7uWz6D52J/jWl6h81Q0IsiKVqJpVmz7Heil7vnTDinN
         QrGrQobaSWRpMRR+hqd0qNihzE+cyuUIULRje3etKzUx1vWxSWcYx1subvCUMe+CYf+f
         h2FLhOjsGZOqxEI7QqTgL2cZmCWKd+JPeAst83qyBTNGQ4usRmRzjHThcrQgl43DVnzl
         JrqF95SKUa5FSbTNWjVN9OyCBtMc24EZbn1WK4Wsi3cEguZJwM0/qEJCrz94THtG9X55
         cVnIPAv6Hp4eOpIlEpiPFyPiNqVtaI8nCDE1PKFwp6AhoPzzO4T1XaTVB72xu7oGECod
         nUIw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788959904; x=1789564704; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dB9s3FYZowUuXLZgEMY+0LbMoABpg3BhWeFIHXgpTgA=;
        b=gfaEaMN+8RS97mz4K5PV4m78k1Kn/SPCe93jqRLjbG9UNFUXFRcdRktMjZznX95gbI
         rV4/ELOU8IAg9mbBvknMZpIiQ9GC9Kh/1WOQnwcz0Vv2Y1HH62gSB6Sx3Lra26nquF47
         0YZDV3IZlXF9gZZGRUVH9CH4BUXpncAdPPYoWXZ/KVRlCsUC07uwHGNNYfpJBZbw7Wel
         /ZsIB/u73/4GK104G+bn5kjZlm1dwJfHNsdvlcx58OQ9O0ddDh96PsZcuSWA1a0wTywu
         ibEHXLXU3HKz3sgxuvxd0O8q4SNKvXigYPku3li5IHmSOHSvZfie2y5da7tlpAT9n53p
         PhMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788959904; x=1789564704;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dB9s3FYZowUuXLZgEMY+0LbMoABpg3BhWeFIHXgpTgA=;
        b=CzVSG13sNPz9jAZ1VRcuCWP0ZXHwCBDMRLiD6Khe7VX+AATcm6+Iq5cIuvIOMoMv95
         R49iNLebvwCaGcoi8Udcpo68RiSFpp5vbMd1qdwAc25cIT/mTAE0c1InUzEcbGtUxxnR
         /JOqtMugndThY0Wm7T9E4OlzoKw43xPYielcD+NewwBMg0YlGxzoOVAq+w5hB1oWU+g3
         QgW6C/xbrQOwLnNmY8JWqyIb5LZJP7UPC1TVxYomd2pirRzexM/pDeEvAOLz/O+qxwNG
         iHpgOw8gOwUTvorZuB74hkq4HayJzcqHBBOmG6KNYUNTROPwItUlfZcZkEcN0/5z44/0
         CpoQ==
X-Forwarded-Encrypted: i=1; AKwUvBwip+ss8p+j0tvTaPWtgl1cKBq5J5KzHXr8nztkM+sN0OVx1JUUqEVuDrrAk+d7+9nyK/CML1lq@vger.kernel.org
X-Gm-Message-State: AFuF++npyMvu3or/GDefY4bJSpFmJIDv+sXWl5VQ/BOFxK7FNSG2LTcA
	YrKBZjTfdYW63TWsC8DJ7SrBFW+yWQYAJAMny3/5q7aRM/Y5PXBjyF1ToGv1Z5D1fxQZQD58ivD
	E6B5wRttyNnbH+CLnwmnzACHTIAfHoyPTKVr9wM39IQ==
X-Gm-Gg: AYBFou1aQZdce+fAbfSkl4pvc5mKB91Q02HFDswT1A4HWSVVANno4khTzGHATgM7Iac
	rbMFWJcnp0YTLmxeUuLw0GlaRojXWhh1DSdujKCwSMyz1xG7MseJ1MvVqcbEVX2IBpOo2+4DAGw
	ztwyk8RBWVLA+ui8MWXRglo8M+TUrsoLEtWoqLNN2gWPOVV6aQRI/wmCf8+aHcvYfD9LZfReI80
	tUSsUrtUZOr0EFXFelPitq+aud97JQib+65PS8UykDBPLshgbuQVg5I9JsVOji26w/ATht1R7T/
	boe+UDqmCh1g81dxZRFDWWzGM0Kjx4Im8d+k7zCVLFCGvIuME2EGNevSd+YG2vk0R8s6
X-Received: by 2002:a05:690c:a687:b0:873:5c6b:a329 with SMTP id
 00721157ae682-87c0f4ed202mr29037297b3.35.1788959903404; Wed, 09 Sep 2026
 06:18:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260909034343.340703-1-sunjunchao@bytedance.com> <iqvi6yo62ydxzshad2mhi55rxhyskfsoo62ji2curbldrg5cc4@z3wju4r6c3ab>
In-Reply-To: <iqvi6yo62ydxzshad2mhi55rxhyskfsoo62ji2curbldrg5cc4@z3wju4r6c3ab>
From: Julian Sun <sunjunchao@bytedance.com>
Date: Wed, 9 Sep 2026 21:18:11 +0800
X-Gm-Features: AcwNN1URoKkZXd_A9WMykFjRGrValQDMpxYfrhpq6USFcen05i6L89OzgmnMZJM
Message-ID: <CAHSKhtcvaWgGHY_NWW242vYHHiSet0v-qsj4MsXGiwZJFrdUnQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v3] writeback, memcg: skip foreign dirty
 tracking for bdev inodes
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, axboe@kernel.dk, 
	tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 9, 2026 at 7:13=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Wed 09-09-26 11:43:43, Julian Sun wrote:
> > The expectation in wbc_detach_inode() that "concurrent write sharing of=
 an
> > inode is expected to be very rare" does not hold for bdev inodes. On ex=
t4,
> > metadata from many memcgs shares the same bdev inode, so dirty throttli=
ng
> > in those memcgs can repeatedly trigger foreign flushes of the owner wb.
> > These flushes can also write ordinary file data, reducing overwrite
> > coalescing under continuous buffered overwrites. The resulting extra I/=
O
> > leaves less device bandwidth for other workloads.
>
> Hum. Are you aware of [1]? The guy is from the same company so I was
> assuming you two are working together on the problem :).

Yes, Xin and I are on the same team, and we are looking at different
ways to mitigate this issue.

We will continue trying to gather more evidence from production to
better understand its actual impact. The number of calls to
`balance_dirty_pages()` and the time spent in it might be useful
metrics for this purpose.

Jan, if we can show that this patch provides a measurable improvement
in production, would you consider accepting it? Or do you think we
should still look for a better approach? If you think there is a
better way to address this, we'd be very interested in your
suggestion.

>
> [1] https://lore.kernel.org/all/cover.1788836830.git.yinxin.x@bytedance.c=
om
>
> > Skip foreign dirty tracking for bdev inodes. Ordinary writeback and
> > foreign dirty tracking for non-bdev inodes are unchanged.
>
> Frankly, I'm not yet convinced this is worth the risk of regressions. The
> gains are nice but both the winning and the loosing loads are synthetic a=
nd
> none of them is like "this is definitely what most people are going to
> hit".
>
> I think what [1] is proposing is more in the direction where we might go
> (although the second patch in its current form isn't acceptable to me
> either). But what I miss from both your approaches is the verification th=
at
> the change actually helps your *production* workloads. Unless it is an
> obvious fix (like was the case of patch 1 in the series [1]) I'm very
> reluctant to approve any additional heuristics unless it is proven they
> actually help production loads. These heuristics are never going to be
> perfect so you can always come up with a synthetic load breaking it in on=
e
> way or another. The art is in tuning them so they work for the practical
> cases :)
>
>                                                                 Honza
>
> >
> > In a synthetic ext4 test with cgroup v2 (QEMU/KVM, 4 vCPUs, 8 GiB RAM),
> > device writes are capped at 200 MiB/s. fio repeatedly overwrites a 256 =
MiB
> > file in the root wb while four memory- and I/O-limited memcgs generate
> > metadata and trigger foreign flushes through dirty throttling. A concur=
rent
> > fio performs 16 GiB of sequential direct writes on the same filesystem.
> > Across five pairs with 9 GiB of buffered overwrites per run, mean resul=
ts
> > are:
> >
> >                                       Baseline    Skip bdev
> >   Overwritten-file device writes       5.60 GiB     1.70 GiB (-69.6%)
> >   Foreground completion time           104.2 s      89.1 s   (-14.4%)
> >   Foreground bandwidth                 157.3 MiB/s 183.8 MiB/s
> >   Foreground p99 completion latency     1434 ms      480 ms
> >
> > The tradeoff is that memcgs with dirty bdev folios lose this way of
> > requesting writeback to relieve dirty pressure. In a separate uncapped =
ext4
> > test, a memcg with memory.high=3D256 MiB creates 60,000 files paced at =
4,000
> > files/s, each with a distinct 128-byte xattr, and makes occasional buff=
ered
> > data writes. The xattrs use external 4 KiB blocks. Across two pairs,
> > completion is 31-33% slower including final sync, while device writes
> > remain about 524 MiB.
> >
> > With 64-byte xattrs stored within the inode, the same paced workload
> > showed no substantial completion-time regression, including at
> > memory.high=3D16 or 32 MiB where the baseline triggered dirty throttlin=
g
> > and foreign flushes.
> >
> > I believe this external-xattr-heavy workload under memory pressure is
> > relatively uncommon in practice, and expect the benefits to outweigh th=
e
> > regression. I therefore consider this an acceptable workaround.
> >
> > Core fio commands for the overwrite test:
> >
> >     fio --name=3Dhotspot --filename=3D"$dir/hot.data" --rw=3Dwrite \
> >         --bs=3D64K --ioengine=3Dpsync --direct=3D0 --thread=3D1 \
> >         --size=3D256M --io_size=3D9216M --rate=3D64M \
> >         --refill_buffers=3D1 --invalidate=3D0 --eta=3Dnever \
> >         --output-format=3Djson --output=3D"$out/target.json" &
> >     hot_pid=3D$!
> >
> >     sleep 8
> >     fio --name=3Dforeground --filename=3D"$dir/foreground.data" \
> >         --rw=3Dwrite --bs=3D1M --ioengine=3Dlibaio --iodepth=3D32 \
> >         --direct=3D1 --thread=3D1 --invalidate=3D0 --size=3D4096M \
> >         --io_size=3D16384M --eta=3Dnever --output-format=3Djson \
> >         --output=3D"$out/foreground.json"
> >     wait "$hot_pid"
> >
> > In the log below, base is the original kernel and skip includes this
> > patch. hot_GiB is device writes for the repeatedly overwritten file,
> > including final sync; the other performance columns describe foreground
> > fio.
> >
> > Full five-pair log:
> > nohup: ignoring input
> > [2026-09-05 17:52:10] RESULTS=3D/tmp/cgwb-20260905-175145; WARNING: ref=
ormats /dev/nvme5n1; 5 pair(s), limit=3D200 MiB/s
> > [2026-09-05 17:52:10] round-001-base: booting
> > [2026-09-05 17:52:20] round-001-base: running workload
> > [2026-09-05 17:55:36] round-001-skip: booting
> > [2026-09-05 17:55:45] round-001-skip: running workload
> > [2026-09-05 17:58:57] ROUND 1: kind     seconds    MiB/s      IOPS   me=
an_ms    p99_ms   hot_GiB WARN
> > [2026-09-05 17:58:57]          base    104.574   156.67    156.67    20=
3.82   1434.45     5.862    0
> > [2026-09-05 17:58:57]          skip     89.125   183.83    183.83    17=
3.62    480.25     1.656    0
> > [2026-09-05 17:58:57] skip vs base: bandwidth +17.33%, time -14.77%, ho=
tspot IO -71.75%
> > [2026-09-05 17:58:57] round-002-skip: booting
> > [2026-09-05 17:59:06] round-002-skip: running workload
> > [2026-09-05 18:02:18] round-002-base: booting
> > [2026-09-05 18:02:27] round-002-base: running workload
> > [2026-09-05 18:05:42] ROUND 2: kind     seconds    MiB/s      IOPS   me=
an_ms    p99_ms   hot_GiB WARN
> > [2026-09-05 18:05:42]          base    103.533   158.25    158.25    20=
1.75   1434.45     5.493    0
> > [2026-09-05 18:05:42]          skip     89.124   183.83    183.83    17=
3.65    480.25     1.730    0
> > [2026-09-05 18:05:42] skip vs base: bandwidth +16.17%, time -13.92%, ho=
tspot IO -68.50%
> > [2026-09-05 18:05:42] round-003-base: booting
> > [2026-09-05 18:05:52] round-003-base: running workload
> > [2026-09-05 18:09:06] round-003-skip: booting
> > [2026-09-05 18:09:15] round-003-skip: running workload
> > [2026-09-05 18:12:28] ROUND 3: kind     seconds    MiB/s      IOPS   me=
an_ms    p99_ms   hot_GiB WARN
> > [2026-09-05 18:12:28]          base    104.648   156.56    156.56    20=
3.96   1434.45     5.334    1
> > [2026-09-05 18:12:28]          skip     89.243   183.59    183.59    17=
3.92    480.25     1.824    0
> > [2026-09-05 18:12:28] skip vs base: bandwidth +17.26%, time -14.72%, ho=
tspot IO -65.80%
> > [2026-09-05 18:12:28] WARN: runtime diagnostics present; inspect each d=
ata/dmesg before using this pair.
> > [2026-09-05 18:12:28] round-004-skip: booting
> > [2026-09-05 18:12:37] round-004-skip: running workload
> > [2026-09-05 18:15:50] round-004-base: booting
> > [2026-09-05 18:16:00] round-004-base: running workload
> > [2026-09-05 18:19:15] ROUND 4: kind     seconds    MiB/s      IOPS   me=
an_ms    p99_ms   hot_GiB WARN
> > [2026-09-05 18:19:15]          base    103.565   158.20    158.20    20=
1.84   1434.45     5.497    0
> > [2026-09-05 18:19:15]          skip     89.124   183.83    183.83    17=
3.57    480.25     1.648    0
> > [2026-09-05 18:19:15] skip vs base: bandwidth +16.20%, time -13.94%, ho=
tspot IO -70.01%
> > [2026-09-05 18:19:15] round-005-base: booting
> > [2026-09-05 18:19:24] round-005-base: running workload
> > [2026-09-05 18:22:41] round-005-skip: booting
> > [2026-09-05 18:22:50] round-005-skip: running workload
> > [2026-09-05 18:26:03] ROUND 5: kind     seconds    MiB/s      IOPS   me=
an_ms    p99_ms   hot_GiB WARN
> > [2026-09-05 18:26:03]          base    104.567   156.68    156.68    20=
3.78   1434.45     5.830    1
> > [2026-09-05 18:26:03]          skip     89.035   184.02    184.02    17=
3.47    480.25     1.648    0
> > [2026-09-05 18:26:03] skip vs base: bandwidth +17.44%, time -14.85%, ho=
tspot IO -71.72%
> > [2026-09-05 18:26:03] WARN: runtime diagnostics present; inspect each d=
ata/dmesg before using this pair.
> > [2026-09-05 18:26:03] DONE: 5 pair(s); all test VMs stopped
> >
> > Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushin=
g")
> > Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
> > ---
> >  mm/memcontrol.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 1271d390b617..6e8f7ff7d44a 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -3898,6 +3898,15 @@ void mem_cgroup_track_foreign_dirty_slowpath(str=
uct folio *folio,
> >       u64 oldest_at =3D now;
> >       int oldest =3D -1;
> >       int i;
> > +     struct address_space *mapping =3D folio_mapping(folio);
> > +     struct inode *bdev_inode =3D mapping ? mapping->host : NULL;
> > +
> > +     /*
> > +      * Bdev inodes are usually shared by many memcgs so foreign
> > +      * tracking leads to frequent flushes which is counterproductive.
> > +      */
> > +     if (bdev_inode && sb_is_blkdev_sb(bdev_inode->i_sb))
> > +             return;
> >
> >       trace_track_foreign_dirty(folio, wb);
> >
> > --
> > 2.39.5
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR


Thanks,
--=20
Julian Sun <sunjunchao@bytedance.com>
