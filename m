Received: from mail-lr2-f35.google.com (mail-lr2-f35.google.com [74.125.230.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABCA577E22
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 17:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790097707; cv=pass; b=oPyCuQjzLMxvchaSU8A8S6W+um+oTvPVi7UNA3iHfSKZCiS8p55758dTNj8uJiIs/XrK0zyhw+8vPZiTKcNfFmuKrrGncTDqns6aMkx4ku3O14+PNKUnkDfcUytnU06yeuOiVG+K10WOP4S3A2H4V+R5+dolsfUoNtgy8Qq3Nj4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790097707; c=relaxed/simple;
	bh=DGo9MXIlX67r2Cpop8xwlzz7tKrHnevRykdbKRTrSVo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X0DzjP0Pqi1m/CBQRiAXOtb97csOO1VPgR81s+dVqkje7BpwEZgsHi9eePGs6o90558AhD4OGT4DIUYD2JmCEebcCQA10Rnv46UvFoTdVlAxf3zBIAqUrTQcAP6pCg2obj/ALMJQ516G2Ww8k9TfN2HFkSgTIPhKISEM2HCQI+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FM9MkeZH; arc=pass smtp.client-ip=74.125.230.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FM9MkeZH"
Received: by mail-lr2-f35.google.com with SMTP id 38308e7fff4ca-3a5e548cd7dso161161fa.3
        for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 10:21:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790097704; cv=none;
        d=google.com; s=arc-20260327;
        b=VA/JieM0E17BkfMOoLW6aPjlUFULFSQ3KuOJRvnhOrJm7Uvi6NRV8ATo3hCdMZayUN
         66Ejt5V3cvJ3xdvhbBozAuEt2sLQKjLmXmRIgT8Na/5Gu6rLlI6iUhwM98uk7Jr/srb6
         fpepzOYGPZiUyc3fxT7jb46KlfUzWxofYPtIHghThQpnh+vPK4U5EzvS3WfEQDW0D3gV
         1R9m3KEg1p/RhoXXzX2C9kAtBTmOkKHbFlQ/1dhLrwIvIY5G25N52ony4ORjY5R98Hch
         dh2k0jr93aL2ugHQgG38Oo8JyQIFKikMUDwgCiVEbBYtF8/IFYjgHxZUJD/rZeNSYnYi
         Fq+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DGo9MXIlX67r2Cpop8xwlzz7tKrHnevRykdbKRTrSVo=;
        fh=mx1ym1mRvJdeIxbZOmh/R4gos0TGBZdTEYgu7Eme2r4=;
        b=QKfd1D3uarXoM4BV5W3FBx630E+RxW5PnSkPAdnihQemGRTXlb+xhNzA9jDWDeqMV1
         96LUHPDUETuWZnZUiQjj2ELyX4QXn8YArdv3724BwwKj3jf7xnN3lZghOhmPCt7RT+Bk
         h5CTrqQ7d36Wxpyz2wGFNj9+KqE7wBCR2w+CCpT2xh4RaDnEZoeBoG02+A39T0gwHgRB
         vm0nVyqGk+Bbnnekbzt6QuNc1e4r1+4nu0xp9bMbudsp5zbDh6QbbGY7TmPkgP7Uq01N
         pJUFhF9HuVPle6OxbWKlI5HcMHrc9DhtdsDiGY16ejFoNdF/4JIjyL0TzDF0UyAAYmKj
         Bbrw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790097704; x=1790702504; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DGo9MXIlX67r2Cpop8xwlzz7tKrHnevRykdbKRTrSVo=;
        b=FM9MkeZHeBILypPfVgoyjNcBUMLCsBwc5Kz+oCuC4T+iPZG3ymQT7bV1tf6r7CfAa7
         lrzsZHUcbw7+Cp+T1e+Pn5wdqcklOw2XgtjZIPnDU8bx7alyIJIS9GSgnTmFc9H0+H5M
         gbJLWe2YommDcSTBvlvc+UN+j5422CWhMWhUV/n7S/kvgGRTbfsPYR6X2u/RefuFRbs4
         /iudxRQBLwjpzkDBhWV/Fi30zX/zLvOp+z+hpvdF/U0p5tJ2lAKEUcwBWNYxZe9XGWMP
         zlnWqBsemOcmAsIHjtUrHkTLcetDqhaIgw6DUj3UViCLP13td0UYg7Baj9gDbeqdOCsb
         h44A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790097704; x=1790702504;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DGo9MXIlX67r2Cpop8xwlzz7tKrHnevRykdbKRTrSVo=;
        b=Ex9HglD8xBcT/hh73aU6XO2ydXexWCpuoO0mXCEd6yv0TtS4QeDqmtN3Xyba7Rn7ag
         1KAThtEO3bz30n+5JC3rk0CkiO0AOkvAx+RbQAa2GkDiRmP0r0PMutmSGzEGjnY+i6Pg
         hUDanE4ZPN4R6duqwpM0SHxt48moRLCeV5B0gK9xqJvv6m0fJCulFS3dBLsW+8xLB0Og
         G2DX99pbch6lyEQbH/X4Rzg2oxANO2gKxSiKT99ujWbWwpJubd6rxibNvEaa63xQz52q
         Sh99YgkLGga22FKQyenRRTlE/bJrLELDMqKvyrGp0jLPDfRsHDcoZMM2T0dIw1lx/R+N
         2NXw==
X-Forwarded-Encrypted: i=1; AKwUvBzGnVZLG1FsFRkfRfSBwL4NS701prRrIBB0jOX9NS98J0E5HZ3KUP7v2LQA9JylLHjclyKYdFNJ@vger.kernel.org
X-Gm-Message-State: AFuF++lNxexjxoasaUm9DRHSHOLm0sKcQbouKb5jasD+tUWzSLsP3asW
	nAScA+aIpQbxJJjw+gG3voyc/r/46aCW5M4RbRG7gq5KG5M4ok7LAvwRxAx4G6AssksUPsQjJzj
	JTORRp+OQ97qfYA0t7sPfyBmwNLHkgRs=
X-Gm-Gg: AYBFou38caCtAlVywdXqtSE35lCan8ve+GFw5H3A6UE+rsDbh7F2kcDvqyqd3Q+3Sde
	EGh8v4kI104/bABAjidS8rObXNY3CZlOU1LxvBEulCDCYexJS/++uGAFhNe/nUkW6YWHIj6O4BV
	txVpImUHR3keiY1SKhBKGsoS2CFSWFK3qDkZtz0td/ug2NfMSLySdri6q02K/y5iw6sCfFJ8yZS
	EwWVqkhnBlmpmj1WtYE+h+A3fuQKAxsFP5kfgIssMuvlQxdn/xwrm8FYf9jWxPGBaBKOf356ZXp
	oz+O1s7pichCcPYBVv5oNOXwZJWApRHHUQnSt0OpikBV+Vxq0lio/V9pDl4lLeQhXidh/z4Xg4q
	LnUZI+x6sc2c=
X-Received: by 2002:a2e:a550:0:b0:3a4:850c:5900 with SMTP id
 38308e7fff4ca-3a5fbef79e8mr29852861fa.11.1790097703647; Tue, 22 Sep 2026
 10:21:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <arEVDBlfsUYKK004@gourry-fedora-PF4VCD3F> <CACePvbXG5kjZmRsdd0a4HfbnNa6w5s9b_1OCySbwvY+HuCqOVg@mail.gmail.com>
 <ad1c4de51f1fbbfc7345036af8f39fb450c1f3c7.camel@surriel.com>
In-Reply-To: <ad1c4de51f1fbbfc7345036af8f39fb450c1f3c7.camel@surriel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 22 Sep 2026 10:21:29 -0700
X-Gm-Features: AcwNN1XXWGuPHcmN1XUaSbD201MO3zoYy8czrwaKOr1UiYnCbEj6IM0vycSKfC0
Message-ID: <CAKEwX=NKC=N-YaiwZK7HPM4MfX-7JG_KeHukS0+vjHqMZTV4dA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Chris Li <chrisl@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2026 at 10:15=E2=80=AFAM Rik van Riel <riel@surriel.com> wr=
ote:
>
> On Mon, 2026-09-21 at 06:11 -1000, Chris Li wrote:
> > On Mon, Sep 21, 2026 at 2:53=E2=80=AFAM Gregory Price <gourry@gourry.ne=
t>
> > wrote:
> >
> > >
> > > You can't know the compressibility of memory until after you
> > > compress
> > > it, and requiring a user to predict the future by forcing them to
> > > limit
> > > the total amount of workload compressibility does not scale with
> > > the
> > > number of workloads of variable compressibility of data.
> >
> > You likely just need to pull a SQL query on your fleet to get that
> > number.
>
> This feature is not being developed for just one
> user. It has to work for everybody.
>
> >
> > > That should tell you that your model of reasoning about this issue
> > > is
> > > ill-suited to address the problem.
> >
> > That is what I'm suspecting. Nobody in a sane mind would want to
> > zswap
> > 100% of the RAM and maintain reasonable SLO.
> >
> It could make a lot of sense to have some default
> limit upstream, that says the zswap pool is not
> allowed to take more than half of memory, because
> at that point the compressed content will be
> crowding other things out of memory.

I actually am skeptical of gating zswap usage (both pre- and
post-compression), but I would like to note that for post-compression
size, we already have that knob for zswap, default to 20% of physical
RAM.
