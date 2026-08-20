Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23813299959
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 02:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787191940; cv=pass; b=SX3bo4C979tAlF+blacOnIF//nLBzdY2xNfaScmbhX+mKAy0Myv/KB83g2LMjW2hv/Tjpv2UysIiV6rQW+AU9TCrAFWv9UrE4X2N5Fulj12Qv9T/PDpdYYd5s8BXgMm/fYI6ybNuyi9TCizzkcQrZyJY3GUWNrdFmENmaJpWfGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787191940; c=relaxed/simple;
	bh=nEldG1sqoP3p5cl2m+fV+6MlyHuZ/G6IYzyUPIf4vRU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NJPF36WqT+e/M8g81zAW+wm32E9fiMqWZ4kzTh3kmSPQ70ngMM6yLzBpK/0qPnJmZS09g7TZ1scSWJ4C2IbRa9WZO4yviZQMZD4vjy5T4umlP80ME8TUROr3EeW98QlunmWYpJDUV63fvm8kHYBI4ZwM07mr+GnnzrC1QXu+BkE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kKehnTvD; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kKehnTvD"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a0a4a17f91so3036409a12.1
        for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 19:12:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787191937; cv=none;
        d=google.com; s=arc-20260327;
        b=rszHihSgZ59N5Hh2TXzmtxpTzzS9IpEi9tvH257TtLLK2yzmwg1FMLA9o3vAmDafmi
         ofRGUD2DvLjHHbiV9rxTDBu9o6rj8L5tcSPZgjhGEeqwnHGrWg7dz5/4h8mt4DBsIJe8
         KQFVTm+84X7HqI2HMU+fxrHvVCi3ySppP01vElryt21VVk+8SmXd9zbVzINFXsyPyX1C
         SIuZdoQ06XvDLf438XUeoWGyk4QjwAoxocfYJsnbWype3Xf7PUysTjP6ZyiqwbhwQVTc
         PnaCkrNsK3X87X94gYs/gGdZ2954zW4gN1CQ5DV8iXI0iVFeZq8Zb2MjoX2w18TsLN+K
         XXqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=graB34iLa0Kk0Tx7Qpqn2wsH9QXAWSlPPhQbARAB87w=;
        fh=P0zriSZLy9G8gIl+2Ye+BGGm4zVA2J1zE9ok3KrS+Ow=;
        b=WIEMm50e13mBytIwY7oX3p8UL+OxY2+7+1KzbWktwgxDhaaa4qElOwrfaFFiOuZn07
         0+AWCg7dRNkXJUuWCqQTC/2g7uny6VjAWi9T/OQgVvAcllBNFi6xCg5v2cyk6vepxs5N
         aEly7AFfkGVh4JtWH8BHXncpBVwpkDCOEdXlO8dXHroTknZmdoYvqMQHj08fVFZuf+tw
         J1eexUY38fUsFx3Inlev8tC/amC+pXcUB7IKTJV3JUwkKoyyCn6iJXAg7JDFGjyGRCVW
         t1xB2ZQEKnZpcAO+metoixTCSMM+8c00Q1nGHFeN6mAGsfrSG3lizVvLXJmvxaV8HVIe
         IjeQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787191937; x=1787796737; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=graB34iLa0Kk0Tx7Qpqn2wsH9QXAWSlPPhQbARAB87w=;
        b=kKehnTvD5T+2dOskzmzByt8WWoizebV2EobLJHmYdRqic6wRzrXQBrqgCnV9ju0cj2
         G0PKpbxnu/JMkWH1kAFsE97dPps4rsFelDMLieSWZIbaC/YE8gRzlwoiuXyHPcqPLGrh
         OHR1majdLl7gehdKmQ7tk3s9IO5yz8M/5ff8GLwt3jDnPOaR6dpGkiyZpENpfOJUAkv1
         RrLMW2O85VICoEOcNS7AJMLSraIX0ZvD+IGyd9Ob3xt59gV5ihjS8Ta32VQIqb6WXCOe
         GpB2TMGuoXSOJGgNpSCII4Yw+GvcnONUd3pTCZMeubJOSeKS5CE7J/o2UwvFuoSqDlhE
         ATFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787191937; x=1787796737;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=graB34iLa0Kk0Tx7Qpqn2wsH9QXAWSlPPhQbARAB87w=;
        b=k7RKa/b+xDx7dfjI+tYAxf+ftGO3lJ7XdQhyffzkIp3x3Q98lh1N0pfgeqoCUnhLP6
         SfuaoFN2RjRTSfJ3HL25jCNWlmXwrdriRguuSBoZMrdg7K11N0CGY1HcDOQnTxSKqiZ6
         z0v2Cud8X4Ht8NuiWGu/PdTLLm2eQm8zeYFJM3PslPqyiJekISXeW/gdgwo3y+5WN2FP
         VD8I/NLpg+PiffcydCiw1NM2O70a3ImDIzR+J6DjbRCfcqg/yWNjSv208Ws++s1jxONe
         GjuZSlTndeIn56CEkkgrP5tothNr8nkcWV54thxYucgx8rMDeII1wH/ZLlMSFEhUwSec
         3jZQ==
X-Forwarded-Encrypted: i=1; AHgh+RoI5JQaytb8+u/Gjg1d+yhYpnD86o1SN61B99vOk0LDMUWzAyaI1ywb+1uC9lY1bCh4ox4HaKra@vger.kernel.org
X-Gm-Message-State: AOJu0YzeKcUeQXlsveHwqbJHbJ9Z1TUjJQEcUq11J2QUrOISRBZ3ImBy
	XRZJsztLrg4S+LuM0UJ5rzmR8E5MBTOXCFMHvq/FSmmK2ck7xXVmH9vgZD4mczC9MRJk7sV7Dxx
	hlKIVltKUuhOl3FiExYEztCTfveT7Z88sNpaJv6CgGA==
X-Gm-Gg: AR+sD13Qynf+bTkLC4waebov48NI9vi7PhU3dbe6UicKfIgCrJv6Ph0qXdnFu5CQz7h
	wENOFyeCdJ9iIUFw4IsRRlhKQqgmotgKKCKYy+2Y4TtY/gaCY6NAllinG6bLj6LP6BehjbG4wE4
	1C8fiXaNhMmA62ehd4wtiF3dvcTn3K+6IQ2dbTe5I2b0Cpay4uO8QRqjrdix0TjogLIN/UxAElc
	6hbPIRPsBrCW/eOOU/sF4TE5inlT8mQHEMx6lOjMeQDSgkW9Wd9vVJnSM4qtYwVJ48+x5/EpuDA
	V9WsKPvZw8PZCK8Yhtr30tsm9u89fg6cByouxhnqz6HyTYy0cEEZKHrWDM0tjATE7aF5A5PaooC
	rgQ==
X-Received: by 2002:a17:907:3e0d:b0:c20:768:af62 with SMTP id
 a640c23a62f3a-c242e6ecba5mr624658066b.22.1787191937206; Wed, 19 Aug 2026
 19:12:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-7-8dbbdac0d28c@tencent.com>
 <aoZQD3b6q8s-pXU0@MiWiFi-R3L-srv> <aoZQ7oUMupCen5H0@MiWiFi-R3L-srv> <144f8a6c-8f1e-4793-9ed7-78f06b0e93c4@linux.alibaba.com>
In-Reply-To: <144f8a6c-8f1e-4793-9ed7-78f06b0e93c4@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 20 Aug 2026 10:11:40 +0800
X-Gm-Features: AcwNN1XJQCCoQ-p0IrCgrj25pFFXkct6vMiMz4ZC14CjFMzHp920L3uC49NVjkA
Message-ID: <CAMgjq7ABr1Km-BoM3o4dXZ7xdRHy=PdcB2q6rUtEhP84PXFACw@mail.gmail.com>
Subject: Re: [PATCH 7/7] mm/mglru: improve code readability and harden folio_inc_gen
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 20, 2026 at 9:02=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> On 8/20/26 8:57 AM, Baoquan He wrote:
> > On 08/20/26 at 08:53am, Baoquan He wrote:
> >> On 08/18/26 at 01:38pm, Kairui Song via B4 Relay wrote:
> >>> From: Kairui Song <kasong@tencent.com>
> >>>
> >>> The helper should never be called for an off-list folio, and it alway=
s
> >>> expects the folio to be in the oldest generation before doing any
> >>> cmpxchg. Add a sanity check for the off-list case: if it is ever
> >>> violated, bail out and keep the folio flags untouched to minimize the
> >>> damage, instead of silently treating the folio as if it were in the
> >>> oldest generation and promoting it updating the flags to an unexpecte=
d
> >>> status.
> >>>
> >>> Also rename the variables to clearly distinguish the folio's current
> >>> gen from the oldest gen.
> >>>
> >>> Signed-off-by: Kairui Song <kasong@tencent.com>
> >>> ---
> >>>   mm/vmscan.c | 14 +++++++++-----
> >>>   1 file changed, 9 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >>> index 7169cac60869..7e3ae0c6cba3 100644
> >>> --- a/mm/vmscan.c
> >>> +++ b/mm/vmscan.c
> >>> @@ -3308,18 +3308,22 @@ static int folio_inc_gen(struct lruvec *lruve=
c, struct folio *folio)
> >>>   {
> >>>     int type =3D folio_is_file_lru(folio);
> >>>     struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> >>> -   int new_gen, old_gen =3D lru_gen_from_seq(lrugen->min_seq[type]);
> >>> +   int new_gen, old_gen, min_gen =3D lru_gen_from_seq(lrugen->min_se=
q[type]);
> >>>     unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(fol=
io, 0));
> >>>
> >>>     do {
> >>> -           new_gen =3D lru_gen_from_flags(old_flags);
> >>> +           old_gen =3D lru_gen_from_flags(old_flags);
> >>> +           /* This helper should never be called for off-list folios=
 */
> >>> +           VM_WARN_ON_ONCE(old_gen < 0);
> >>> +           if (old_gen < 0)
> >>> +                   return min_gen;
> >>
> >> As Barry doubted, I think this change is wrong. old_gen < 0 in folio_i=
nc_gen()
> >> could only happen inc_min_seq() call it. While inc_min_seq() call it
> >> because inc_max_seq() need increase max_gen to max_gen + 1 and found
> >> get_nr_gens(lruvec, type) =3D=3D MAX_NR_GENS, it has to move the oldes=
t gen to
> >                                              ~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~
> >> 2nd old oldest gen. Here returning min_gen for old_gen < 0 means it wi=
ll
> >    ~~~~~~~~~~~~~~~~
> > Here, I mean it has to move folios from the oldest gen (min_gen) to the=
 2nd
> > oldest gen (min_gen + 1). The empty min_gen will become the new max_gen=
.
> >
> >> be put in the lastest max_gen. It may not be expected.
>
> But how does old_gen < 0 actually happen? folio_inc_gen() is called
> under the lru lock, so how can a folio listed in MGLRU have a gen
> counter < 0? If this can happen in any case, we should fix this bug first=
.

Hi All,

Actually that's the confusing part, the "new_gen" variable here is
actually the old gen (the gen number before the CAS here) of the
folio, and the "old_gen" here is actually the min_seq gen of the
lruvec, and that's why I'm renaming it.

The current new_gen (which is actually the folio's current gen, the
old gen number) or old_gen (the lruvec's oldest gen) should both never
be < 0 in any case, if it happens, folio_inc_gen will corrupt the gen
counters or page flags.

This change isn't fixing anything, this commit just make old_gen to
hold the folio's current gen number (before the CAS), and if that is <
0 (the folio is off-list), don't touch the folio at all which will
further corrupt a already buggy satuation (this should never happen,
so I added a VM_WARN_ON). And now min_gen will be meaning the lruvec's
oldest gen.

There is no functional change, except one more sanity check and defensive c=
heck.
