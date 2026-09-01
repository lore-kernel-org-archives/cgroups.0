Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EDD495500
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 18:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788286325; cv=pass; b=VsnjcbI1uSdVaNfWFvZRKr642W8/ldtttZ+RCRtWEBPFW9xNXu/ZO2yANPigJv2mgGDA2F8gXJ23aUfe/vVFXum95po6s6nSM8WuoCv4bEtB8FheEAtnI3DllkFubDhOp1Rm/mwhccS8pq14nOtX4yzDUH23wu42H86bH04+Osg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788286325; c=relaxed/simple;
	bh=OYDHwPtRS/urJTrcJcJyVU92g7dRNXopeu0W3B+ow1I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W8J00y+pPRJzklgZHZhn0cNwsWIrfFfPbohWzqnduhlnFcoE1nQBzgUXElddyZkojno5f8YFcfSqOS/jDWt9TXe2lD66H2/1vrfOnB2vfqMqIBgRzsn1mLZltB2jQjSvk5VkA0tYlc+VedAKMlr45QPd8F/gVoE6CujRBVRk+UQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q6NALGms; arc=pass smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q6NALGms"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c15e2dab83eso11312266b.1
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 11:12:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788286322; cv=none;
        d=google.com; s=arc-20260327;
        b=QT4OYCt0zNf1oIoP5zKNvn7zUBAraNn6V/6RsEVdoGKVbjMEUdpnYQbl51DOXwusRz
         evwwJqCG0i84Wxhx9PqmmWh0SxZM91SDBVH+fE1S+0ZENtJN52sD+l2SL/sG5KAQ90s9
         6faaMdWyglYeK82tje5ggikfoy/1Lyb/Jqm58I3/L58bvQKg0pZe/EzcHZrabmRWKLT4
         MRhRVS2GsHdolIg6Zox9WLs3xgM+x6fK4JGUjX929+ULGjCyuPtNMdCudjRqtWLp/bGF
         1KZYeKaDZaPh1TD8Aj72BdlZ28A9FD5i3zYoazZ6hSS7z3jZfu1N7jerbACpuA3lMZhN
         hvTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OYDHwPtRS/urJTrcJcJyVU92g7dRNXopeu0W3B+ow1I=;
        fh=FOethAWVBNLCEA3CTUXiAqoC2ktl77pc+PHLBjDpNDw=;
        b=Dbia3eXCOkYcvm+xvZ6Z86M74sNeggtyGF++5YhckOuf2JcrFGsmrdvlD+45SZwCe4
         wKA834wViRUZ3wsklv/I7N/oVfvUk5BEPj1PpSiAbHc/PdItcxomluV7VdQz8bA8ozmO
         hg5tVvHSrMF+YMQEhmrqQ382dbCNTEtyxtZkeiy3Iqxv8zu28kImjNmeVenS3mx68+Bz
         s91scrdzwiDPQGLAeRqGh4yxV3qWaHCKV9N7b2CNoCwSFrOvlKs26doywCjDCkuyYePM
         WeySUgdhCq0Ul945OPm/h1zd2/N7qtCN4UgHi6NZmCVho5cGB4TBSQ82KxOm1w2gM49S
         D4Uw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788286322; x=1788891122; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OYDHwPtRS/urJTrcJcJyVU92g7dRNXopeu0W3B+ow1I=;
        b=q6NALGms6T+Hl3xT51OPayJ9cR0C353JJdFnmPqjBvIOXdis+14TwmXDCRyboFeGtD
         El+GAxOZ9DDN6wjUvoYerSCJRjkxF3Qaj7XEnhAhJ/wrFSPqMsKnN1TaY2S3ZCNxeXu/
         gBtl/wvPGxuKMw5htJ5ZasTdsEOSuXfCD6Lap0DFTghUyT6eQtKiGTPMU4IliwcMRPsM
         u37f/ch4KmJhi9o7GsTRrrvQTquai5mA8v0PmNhmUQgYRH75YlZYg+j5dgwbcEGBQBMF
         hc6wlF1RQPdMeRfeZUwkZdYv9UoJTU4eklhY0CifG8Syu3N7M1FwYLtymiMXoFuokr4L
         ZzPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788286322; x=1788891122;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OYDHwPtRS/urJTrcJcJyVU92g7dRNXopeu0W3B+ow1I=;
        b=dKz2DKQqb2DL6dQUxpXBPioCUle1D024YU7BJe0lgCQkb/nVwxL2F2elisCGwEW6Rx
         9laG3KbcPRo4C82rXh0WCYJUxDHOBK9zaaa0oE/KfJoKihpURBChocz/w3LF37Z1Tg7p
         OYc4KXhzq+W3lqsQQ3qNUTcNQakWrpOSI9vpKJfdcHiq5eKO23xfSYfxDzWAyBDOGhA7
         mc4G9VtWMB5+Omz35IZMJ3vrRlqmzY5n+51A7lGPxizfyX/r0IdPXv0qmaVYznlDiZzf
         wJiud1Dfo/LNuoUZWfq5AXT8kLzeKMWmi2BQkxFcweMPKSUkkm/cIFyIUdY2c4/xgY6L
         8p8Q==
X-Forwarded-Encrypted: i=1; AHgh+RoQDDisAD3AAVyf5XfM1JRr4Vey0MLEkM2i02wDjpqVn19TADiHdvk5wnSzmR6tfZTbOtq3RC5p@vger.kernel.org
X-Gm-Message-State: AFuF++kHOVHpCt+m9owN4B9xE+vDACAszTPuxQXjk+1IQHTlJdf+Qw0N
	RBALS9230D7CQ+SsTO7squbsyCke3zP/UNWAaZNQ5LR9K8xtT6bFumiRTXpLxf8X0lAaZGhQ7yq
	dblONWbp9pckb1noHvOMCLCpqrWKyZHQ=
X-Gm-Gg: AR+sD10LcizPZllQm+OhVdMsP+KZRmc9quJG0hIml1pBCiOk3j30ZCXGwWKrzQD5TsC
	oiAgx9YvIZy+/aZ9AIsJghZWYGRXxJtP3kRzt1fsER+t/WqQVF3ysSPBRwyAp9yPy3j/wvAhsw4
	0Zu/QpyHic8aNmBZH2aHsSGVIFfNqbMHEu7ILrNZ71FI+zXmUAO4wV0tYhrkAU5Ho/W6jWVn4YM
	XRrpsZrULV3iABEQQ/T6vceNEwvc/8jECdW1l0S61MXoNsX4SEFNL/x2kWwwZpmqfp4KVZigpuM
	ONDPm4AeNHSc5Cz0jkcB8Sqh2AOLynaJLKucR/CaWlifxtl1MI45HhfaBr6m++guEG2/VjLtjZG
	3
X-Received: by 2002:a17:907:c714:b0:c24:d6f0:2071 with SMTP id
 a640c23a62f3a-c255742f97emr2437697666b.12.1788286321995; Tue, 01 Sep 2026
 11:12:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
 <20260831-mglru-flags-cleanup-v4-1-2d15dde0d7ee@tencent.com>
 <apZVe8UHZ1CNo4r1@linux.dev> <CAMgjq7D6V4eTZJ1Q1Xf2J6yTCq=JjvzT-W-HHX6EnMfzm3BK1g@mail.gmail.com>
 <apcJgcFLHKZfI40m@linux.dev>
In-Reply-To: <apcJgcFLHKZfI40m@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 2 Sep 2026 02:11:24 +0800
X-Gm-Features: AcwNN1XLuero4S-u0uv2ETgMcz4JXom2ZmkXeiEroEYDvMkv4dB11HBSW6z7Bos
Message-ID: <CAMgjq7C=k_nzwiM_MTcjVjWMTGf=s8oRaUBY00dCvLbP4EiHnQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] mm/memcontrol: make lru_zone_size atomic and
 simplify sanity check
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 2, 2026 at 1:37=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.dev=
> wrote:
>
> On Tue, Sep 01, 2026 at 01:20:33PM +0800, Kairui Song wrote:
> > On Tue, Sep 1, 2026 at 12:38=E2=80=AFPM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> > >
> > > On Mon, Aug 31, 2026 at 02:43:31AM +0800, Kairui Song via B4 Relay wr=
ote:
> > > > From: Kairui Song <kasong@tencent.com>
> > > >
> > > > commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_si=
ze")
> > > > introduced a sanity check to catch memcg counter underflow, which w=
as
> > > > more of a workaround for another bug: lru_zone_size is unsigned, so
> > > > underflow wraps it around and returns an enormously large number, t=
hen
> > > > the memcg shrinker loops almost forever as the calculated number of
> > > > folios to shrink is huge. That commit also checked if a zero value
> > > > matches the empty LRU list, so we have to hold the LRU lock, and
> > > > handle the positive and negative deltas separately.
> > > >
> > > > But later commit b4536f0c829c ("mm, memcg: fix the active list agin=
g
> > > > for lowmem requests when memcg is enabled") already removed the LRU
> > > > emptiness check, so handling the deltas separately is no longer
> > > > needed. And if we just turn it into an atomic long, underflow isn't=
 a
> > > > big issue either,
> > >
> > > Why atomic long and not just long?
> >
> > Long is fine too; I was just trying to be defensive. The original
> > check was a defensive design for leaks or races, and atomic long is
> > more immune to race conditions. See below for the other conditions.
>
> Unless we really need it, let's stay with "long" for now. As you mentione=
d below
> this is busy/hot path, no need to add overhead of atomic here.

OK, no problem.

> >
> > So checking it in the reader side is much lighter and cleaner code-wise=
.
>
> So, one motivation is cleaner code?

Right that's one of the motivition.

>
> >
> > Checking in the reader side also tolerates deferred accounting false
> > positives: if a folio is added to / removed from LRU but have the
> > accounting happens later, that's fine, but might cause a temporary
> > underflow (there shouldn't be such usage right now, but cleanly the
> > oldest commit I mentioned is trying to catch something). It should
> > just proceed without performing extra operations on the counter or
> > raising a warning on the updater side.
> >
> > The underflow won't affect anything besides the two readers mentioned
> > above (reclaimer and reparenting).
> >
> > Besides, I don't think warning on the writer side will help catch the
> > real leak either, it just adds overhead to a busy path. The folio
> > triggering the underflow is very unlikely to be the one leaking the
> > count. And if that leak is actually caused by a race, the atomic long
> > change should cure it.
>
> I think you are going and looking too much into the history of this warni=
ng. I
> think you just need to explain that the current warning in the update sid=
e
> already can't always catch the actual leak and is costly. Moving to read =
side
> make the code cleaner and warnings will be at the location where the cons=
umers
> we care about are going to consume it. Also add couple of sentences on be=
havior
> difference it will have i.e. warning on flipping into negative vs we will
> continue to operate even in negative but only warn on negative consumptio=
n.
>
> Another question: why is this patch part of this series? Just some orthog=
onal
> cleanups or are they related?
>

These were all part of the MGLRU-FG prerequisite, so I sent them
together. I can split it out.
