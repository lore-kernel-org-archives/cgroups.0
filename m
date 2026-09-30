Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC303C1D46
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 08:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790758673; cv=fail; b=sdPU6iWJz/1JVjy+cg9tNrM5H+Q/xaSifZzLrfo667t0arsLsthnJCD6tLBM2CHnW5Gajd199d2Mn+lW6r1EB+IAHOZTtCsgihxCyi2M5sk2V85m8dthAGvQQtfg0BuFQubCez0cGbFz3eBYApdED2p4Kv+fw6A77fP3j3SyFOI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790758673; c=relaxed/simple;
	bh=jjd0KEG/NBOXWmwGkt2V1dWNw5vceT2ola78j22GHAI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CsAT7XfYOwb2EP1CJaVI8gd2ERXoPdHJuiAAponQfRayBPeaAAKqQ7QMaPzvJ1cD6WaX2D7cjLwa2355/7FrucFGPrkrRb57Vwtmq9qKdM7M47oSvwLKjnwA+WAsVvVq7oU6rz4vzCzcsR3VHmYOcCPp7KFcdVgVcUMKWkYsRRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=MEbkSTuE; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="MEbkSTuE"
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68U7cfo73432189
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 01:57:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=FSbzH3J8GpCu3CO+DRX2zaPG7BxRBagXxEyW5
	XsxKiw=; b=MEbkSTuEtJDyWYMNO6YL71WnCSoBA2M2Ck/I1j+uuUHs9mx4xl1lP
	gEqVlxysJcR7edYasoLN4634LrDsZRUwbwdmJVoFzEjMQJrdc2dUZfzF+dZo469C
	5b186aQQR+hHRBosxnqh344iEb4SzDtTYD/teK309BdwlV2lRDorTb6kPJni+ZWa
	W4E/9CX0ofByb7dQQjPCOTa2hzmevHGcOwgw3KwZjp0bp4d0aaffmeV4b5S63UWM
	uLJX101Vdvir1zuV9/bkNFYr8hoPBW91pSuY/NMULyzKjf/x1DEgQ91XgiTsTBK+
	0Q34mZldvMxcKiDGUn9y4QuzYXk5yFVnQ==
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4h0j6aef63-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 01:57:46 -0700 (PDT)
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a615ab0c06so5989069a12.2
        for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 01:57:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790758665; cv=none;
        d=google.com; s=arc-20260327;
        b=UD9nFwsAAWzVjNm32+oj0Hbwgn6ztYuXVMVrj5U8VKvd3MIkj3pRgMUac7Vkq9NaWf
         Ty8LK2UkopXRWnzCW46PdHulIVn8Eb6nBHDdK6QgNp8DJCR7aTVSEQ9ex4Z03bVvQEwf
         oct3Zaq4adoF3uPg04hapbPNGYCmqc0BDr/0gPmoiAs5AV7os2OgeOeJEuaZxduHdsEM
         wywYsqG9lFPjbeRrp31UJ4qzHLiBQTXo3JUP/RoAcDT8QODif4jdskY+9YPwbKWHOPPT
         CNrM7BBUHD3pRqF8YPSnMKetRVbDTAly8FBbzAQcGNtkBotV4fAQ8jlgYnU8q6WQ/bcQ
         UCBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=tm60U/TGR2G1p40eU4sJMqqHLE9qAL4X5WQ6mS0UHeE=;
        fh=rne0Hz7pRlVvcVLa0Q1rcGTG3NmmOXVHQ7qUv1grpJA=;
        b=KvAkRHDH5Cp1PwqF6xJZHkN9weBSYC1neumUmp/5ix4xlZQtjDTP9XdKH/zb/W7pbS
         XUV+hslecv0v0guI4v8uunWJgTM8vLKzeKEt8ZmXcNV7wPPTVP5gLSm0m2F/YQZNiLkc
         JvWxM0TzBA32iS9ctduS3SSUVK3+nvfeNltaHBGWJTIk3+kDpixnasmZZmlA/GPToXSQ
         TMUloTQspLpaEkRNGk3dr2RG9Cl3XBZJw9babLdx12rn10FVYjPCY567/MEqIgIjzOb+
         Z3Zd3RN2hcOs6YrZcVOHwUyPN1fJozj5xI529PW5frNOD5l1hVMptA1oofFlniQmSnJM
         1sdw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790758665; x=1791363465;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tm60U/TGR2G1p40eU4sJMqqHLE9qAL4X5WQ6mS0UHeE=;
        b=kdvwN+x3pul+FFMU/p02LWqlzt6p3SnlI5svP1Jr+TmCO22SEO7TEiY9Sz4Sl3Foqt
         gEjWgHgKMGOtXM718JxOd9BzgRoSAAE7ltFBpwVf50NE3SUKAncGoiDULUPRkKkzWeGF
         Ss7zA+4L6NFSmu6PA201Q2CiGVi4wjCUVVP2/j2fNPHBLuBTjQDylJPt5T8zHw1uSjmP
         LiMdPNee8Y9FeAoZU/dj03U0E34rpOzFsBJy8pTlNNzIpUDVF0LZga0MYYMZgros9DXd
         vLohtITz86RO+l6JsmDXwesapxT723SzO6XTFYB9pDzGjltJV69pLsVC+DNEye3SZMY+
         oNfw==
X-Forwarded-Encrypted: i=1; AKwUvBwpS0IkDldxscyrs/4JHRNJt1lFuqx2oPI1jx1XjDFkQfmTJA5XWCzqC0W4j5hC4AEUD3X3wN1O@vger.kernel.org
X-Gm-Message-State: AFq9FYIQEqiMRVCUZPY+wrKKjAPpiZh2N9jVyRlil8SojHTlBpmgVKYN
	sGTu0dX7TCGG89nmGhfk6V13XTYqnAfN8Gx2sDLX/58uRk4oXJgnaE5PXW5Ax1Wk6DpWecVxfyO
	OnpAW1Rl/7sw4hJqC3gdv7fziHgVTbvuJ/df5shSgyhbqBWLS2PvqmUVetzhdrr6qz9/c2yZa20
	mcy0fMFTmXSNOMY5s6hgcJytofodgsHXDi
X-Gm-Gg: AYBFou2eEmMgPtH20Czt0+0fKa+QtCUqSu4zG7uuNVZrZe+Cwm0HvIyEDgz3cK7IlJB
	8GS5g+9F732XkQVA/t9iuxRifBbS3iay75C5pSyMq/PjPQY0clqdW8F+JYM2UXL6dIhUbJIIf4Z
	x3lFNIlSoWTxyx+HSM324iqpHPD/l/ojjXcGZb7Fx8G7/J9JuQ+9/DGm1FPRnQ6CJhN6cQzJv5h
	aK82ps0K+bGla8e0w==
X-Received: by 2002:a05:6402:24c6:b0:6ab:1c2:967e with SMTP id 4fb4d7f45d1cf-6ae1997603cmr348796a12.32.1790758664840;
        Wed, 30 Sep 2026 01:57:44 -0700 (PDT)
X-Received: by 2002:a05:6402:24c6:b0:6ab:1c2:967e with SMTP id
 4fb4d7f45d1cf-6ae1997603cmr348775a12.32.1790758664322; Wed, 30 Sep 2026
 01:57:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260928081900.4187482-1-alex@ghiti.fr> <20260928081900.4187482-5-alex@ghiti.fr>
 <CAKEwX=PJjGe3kjYCHwxijaZ+W8HvOiNQTTS-Da1R02hPW=kCDA@mail.gmail.com>
In-Reply-To: <CAKEwX=PJjGe3kjYCHwxijaZ+W8HvOiNQTTS-Da1R02hPW=kCDA@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Wed, 30 Sep 2026 10:57:33 +0200
X-Gm-Features: AclHuK8QO5DXy2cZ_qgdu0179rbpj5mlyiQ1Y2SMBWaoqm3aGlQoLCg7t0LKm2c
Message-ID: <CAEmasaWgracciCPNB-39iZ6RRCbGfQYFNiWSHsfP0qaaxCXCKg@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] mm/zswap: move reclaim-driven writeback to a kworker
To: Nhat Pham <nphamcs@gmail.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        david@kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDAzNSBTYWx0ZWRfXyyDpN4uMMmlZ
 Bcs6qO0KzQHHGuphUQLAIc0Awl+C/dl8lkyReer6cCPE4/2Scuk5AHeklzN59O3VG2+aCQ+n1gw
 nnsakAIfeGhORYklPmNYc3glJyACqpqqmQ4DETgWACY1DIM9D89S2WKlLX8/Fet8O7lycLoL909
 TD0tjuuytitktH1AcGfTK24uyLR1NcHD2ID7qSraZIDDwau26RCqOZkyjPo1EVYNbSFwi8znfGg
 sN7jB3cQehRmk55LAJqIYndfBF3HBnOGKclq+TVVsFu5nsDFqZ9UpkB7NsEx+MLQF+/l4uk+DeP
 JuzJXLiS1c9fbFux5tvgxJtCjpm/Qo/8dodvSCZHLYd1wbuJmNbcRy8oCpMkOhv+BVo5g5kqzJ0
 Bp5Qz4Yf3B6X4YuP2+Pc1V6ziER0isCHCYZc4D008TKYS7Rdu2Q1/vjg7leBC4DZWo39Lxzft2/
 3dSTf6UmKidAALYAGCQ==
X-Authority-Analysis: v=2.4 cv=T4oZ3PKQ c=1 sm=1 tr=0 ts=6abccf0a cx=c_pps
 a=Tczdrg5if7+wQeIJmxD/XA==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=PAz_-FQ8hEVmOPYdF0yf:22
 a=pGLkceISAAAA:8 a=Esfd6WMfZuu0XR_NPF4A:9 a=QEXdDO2ut3YA:10
 a=1oAhN8tkTtOBK6_UvoHx:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDAzNSBTYWx0ZWRfX44UTyLhBBbcW
 LNpvddc7fiSqpnz6XD7E2CZSBItxBke6NYMWjYUglc7B/cDv6ZBH0gAlTKbOauB/JAnq3m/OclT
 gz462UjJ0GtrIwv3E4veUF+D5EHSoKw=
X-Proofpoint-GUID: 8BI0qZlErBEztNDqqQ7xF-vYCR1Vn7jd
X-Proofpoint-ORIG-GUID: 8BI0qZlErBEztNDqqQ7xF-vYCR1Vn7jd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_01,2026-09-21_02,2025-10-01_01

Hi Nhat,

On Tue, Sep 29, 2026 at 3:43=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>
> >
> On Mon, Sep 28, 2026 at 9:23=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> w=
rote:
>
> I understand the problem this patch is trying to solve, but this
> solution seems more involved than the changelog suggests :)
>
> >
> > zswap_shrinker_scan() writes back in whatever context reclaim called it
> > from: an application thread inside a page fault, or kswapd reclaiming
> > for the whole node. Now that the cgroup IO controllers throttle zswap
> > writeback, that context sleeps uninterruptibly until the owning cgroup's
> > IO budget allows the write. Such stalls were observed on a large
> > production workload.
> >
> > So defer the writeback to a kworker: each lruvec has its own work item
> > on shrink_wq, which writes back what reclaim asked for, SWAP_CLUSTER_MAX
>
> Ahhh, so it's one work-item (added to the shared shrink_wq)
> per-lruvec, not one kworker or thread per-lruvec.
>
> Hmm, supposed multiple tasks in a cgroup enter direct reclaim. In the
> past, the amount of writeback submission will scale with the number of
> tasks entering reclaim. But now, it's just a single work item
> per-lruvec - IIUC, the submission of his work item is idempotent, so
> it wouldn't scale like that anymore, right? I haven't wrapped quite
> wrapped my head around this, but this sounds like a non-trivial
> effect...

It would not scale indeed, the worker does not accumulate in this
version of the patch. That needs to be tested and discussed.

>
> Also, do we need to defer writeback submission for proactive
> reclaimer? Or kswapd? Only direct reclaimers have concerns with the
> latency blowup from the throttling right?

Today the writeback bio is issued as root, which incurs debt to the
cgroup. The submitting task repays it on return to user or on any
other IO of the cgroup until the debt is paid off.

With this series the bio is throttled at submission instead, so
whoever submits it sleeps until the cgroup has budget:
- for direct reclaimers, that's the application latency we observed
- for kswapd reclaim, it would stall on a single cgroup's IO budget

So we need to defer for everyone.

>
> There are a couple more behavioural changes, without proper
> justifcation or mentioning in the changelog. More details inlined
> below:
>
> > entries at a time, while holding a reference on the memcg. The shrinker
> > does not queue more work while the worker has yet to claim the previous
>
> Why not?

In the large production workload I have worked on, when the shrinker
is enabled, the zswap pool size decreases by ~97%. So I did not want
to accumulate "too much" work to prevent zswap from draining "hot"
pages, it acts like an additional throttling mechanism. But that needs
discussion, hence the RFC.

And you're right, In the next version, I'll clearly point out all the
behavioral changes I made with their justifications.

>
> > one, and reports nothing freed, as nothing is until the worker runs.
> >
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>
> [...]
>
> > +
> > +static bool zswap_defer_writeback(struct shrink_control *sc)
> > +{
> > +       struct lruvec *lruvec =3D mem_cgroup_lruvec(sc->memcg, NODE_DAT=
A(sc->nid));
> > +       struct zswap_lruvec_state *zls =3D &lruvec->zswap_lruvec_state;
> > +       long old =3D 0;
> > +
> > +       /* Do not accumulate work: back off if the worker is lagging be=
hind. */
>
> Why not? This also has a non-trivial effect on the writeback amount...

Explained above

>
> > +       if (!atomic_long_try_cmpxchg(&zls->nr_deferred_writeback, &old,
> > +                                    sc->nr_to_scan))
> > +               return false;
> > +
> > +       if (!mem_cgroup_tryget_online(sc->memcg))
> > +               return false;
> >
> > -       shrink_ret =3D list_lru_shrink_walk(&zswap_list_lru, sc, &shrin=
k_memcg_cb,
> > -               &flags);
> > +       if (!queue_work(shrink_wq, &zls->deferred_writeback_work))
> > +               mem_cgroup_put(sc->memcg);
> > +
> > +       return true;
> > +}
> >
> > -       if (flags & ZSWAP_SHRINK_SWAPCACHE)
> > +static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
> > +                                        struct shrink_control *sc)
> > +{
> > +       if (!zswap_shrinker_enabled ||
> > +           !mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
> > +               sc->nr_scanned =3D 0;
> >                 return SHRINK_STOP;
> > +       }
> >
> > -       return shrink_ret ? shrink_ret : SHRINK_STOP;
> > +       /* Nothing is freed until the worker runs, so report nothing. */
> > +       return zswap_defer_writeback(sc) ? 0 : SHRINK_STOP;
>
> This will have effect on the shrinker control loop too, right?
> Shrinker API accumulates the number of writebacks overtime based on
> shrinker_count()'s output, and we serve that number of writebacks
> throgh shrinker_scan(). With this basically that accumulation just
> grows over time, correct? Check do_shrink_slab() in mm/shrinker.c...
>
> Feels like this completely breaks that control loop.

Yes, this is another behavioural change that I will explain in the next ver=
sion.

Indeed the work piles up in the shrinker control loop if writeback
cannot catch up but note that it is bounded, which is what we want
right?

>
> >  }
> >
> >  static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
> > @@ -1807,7 +1897,7 @@ static int zswap_setup(void)
> >                 goto hp_fail;
> >
> >         shrink_wq =3D alloc_workqueue("zswap-shrink",
> > -                       WQ_UNBOUND|WQ_MEM_RECLAIM, 1);
> > +                       WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
>
> This turns a single-threaded workqueue into multi-threaded workqueue, IIU=
C.
>
> Worth at least an callout in the changelog?

You're right, and the explanation is "we cannot starve other memcgs if
one worker stalls because it exhausted its memcg budget".

Thanks Nhat!

Alex




>
> >         if (!shrink_wq)
> >                 goto shrink_wq_fail;
> >
> > --
> > 2.53.0-Meta
> >
>
