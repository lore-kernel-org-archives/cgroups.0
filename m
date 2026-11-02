Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793640915;
	b=hX8Mjb+OhRd7vUHSjtIylGuuk/fuVv5qVHDmcivr8/orfQJO4coY1PQxYWN6dY31YR4s
	 7azWwMQVPCVRN0GUM5JqsD+XFrUv/SmcdcKV82cwMgR4tqWFW2pHR3L55FsqjEivjdZL+
	 XCCUXz1teuju34EbdBTsx7LcMViAzXQMLZcLSP7eC7LAAPBctHJt0T67jZzLNzlCkXVnV
	 dbgteobOwZwB8kjBaxrN6RG2C/ngbZX9Zx8zW0vDGGKnL51Nj3bk5aO7mCJsz9JM4Yjho
	 FaOSgTFV4OZ9boEwC6qm6TrS0Pqlw9EmFEM5gwffKwhEfZ6fG/ODwE4Pbgf167RkxfQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640915;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=VnBhs1QNRjF1grEs77jlwblGRfEeujN01d/Qt9621rs=;
	b=1fcoDK+go1Tdam7BGo5FWeCrIOwDgsojw7gbUnO/Av9zqJpWBuYS6Z835A+MPOzv71gx
	 EmkvzXCHzSpF94qHyALae1k5YqNsZr/Ryo+9m7sVz1LUha4cGRwA7/7hOZSFAOAGgZYct
	 oAuVmq/M4fC0GfbOixX/RGWV6Pt8Gu9HMOgho/COlxriKq8ejFJuF+GKZ3+HZ85RfKtaB
	 c+wcBz4bjJojSp4vf2oBTPaAUFLZBqFI7TzeqFYwPU7ncuaiQQXxxP6AjS42zSmc8QvGt
	 JbsUxMyO0W99RBSR2y3ZUG9YgrJPXCXEw/CWgQ+6vYM1V+dB1YNqkKx4UcAfDx8oZCg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DRIDPLph;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17756606C3FB
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 17:35:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17756606C3FB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DRIDPLph
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a018493d57so113345e9.0
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 09:35:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793640912; cv=none;
        d=google.com; s=arc-20260327;
        b=d7vGCGPTIaSvAjnSf2NrKqWeAqUP/i0VAkePGzWGRoDzNmIpFfcgA+P4Pjo1tGHV5v
         pY/flKr9z9LxFPMOvC6/blblNDk6apwMNYrX9AMWS8SR5WttKjUtdjRpBXo+XTVncKuD
         iPtgQyEgEJbUIaoNOfH4cR8T0THWBVRytlxgyD0I7Ve76iuCc/LkZW/JWnntJWp4VrvT
         U7AcCleEJ1S6ddXB7KQPO99/T2gtk6fgEzvWXPmcna79kCh1ozHGTTNt+xV0NWrJxO42
         ZOOT6cC4FwmBcBlnp0DdFvitb1VmWv0oZJEarfCk8xQibCt5v+LbxNVddngX+6sz1y6W
         FUaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VnBhs1QNRjF1grEs77jlwblGRfEeujN01d/Qt9621rs=;
        fh=5Rjt4iFLdQ8T8jZMDhVP9TU31Bq8E8aNElkltMFSOPU=;
        b=bWk/sswPTb7m3cYvrz7TUKOzxHHMj3mJZjJeJg1gkriZsOfd1o9LpZ8pFw7yARsTZB
         dgBk/Z5YSQLkFhmNQZSFAxXtGn1Q2davhq9vRMYIzS/89dfEKjWqYIYEMwUSvspfkBCy
         VPF9Cn4DYA/ZCqAnyD9gIrUCDtFcsIUGt90B77azI/Ko/7+Odl6JMGDgCPj4gKC1X81M
         J+PqtRL9OFQo/vG1p6jiZ//4ISEekSjsTBOcjEj5+Wxtm3p5zyfj28aOwr6NJs3WH1Dn
         k67VNojjDNzDFHQ70CKDi3YoAovSYHnq1S4rJp9mNcIAFC/5CSwkg+m/cIo7OecrGJZa
         mTlw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793640912; x=1794245712; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VnBhs1QNRjF1grEs77jlwblGRfEeujN01d/Qt9621rs=;
        b=DRIDPLph/lguA/rSUZf1caJpDBqkcoxGpAcCBv+EgFTzkpEor/Yqg//nc+FmPvDOBf
         ZjbWdjsBoW3joAzgrPToaz3e2DyamggT+yHvnSo8fL9WLfTgUdhczNJAwMeJjG2S8cD4
         SIAoaOVUswyON7/m8cKvSVgGa7YYF/hqCEyZHe1cgvFwOLjYIySxhnLH7ax6/oDaYcSm
         FVCXQ1AsO264FYWSSoXoka3aO7ZBNR6qrDRDE+LCqGNrRs9btMiH95l2U/S1IpbUk3Er
         X0qn7xmTgoIdZZzT0dGPz3Xe6oYvg3/lMPNG7zl3ThJhMYV8f2TEkrLBKdHCggvo/jCi
         HeiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793640912; x=1794245712;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VnBhs1QNRjF1grEs77jlwblGRfEeujN01d/Qt9621rs=;
        b=kkd7ABcZSj/kpH7hpKvgDGEDxXlLs6GuCzIrcSCEb+vMGn3RBWPpG09sf7pEV/bfAt
         Dy70jliKfMDO8dsO9Z0rDcax16fU3tKm5e3e1Ant3xAt3G4Z0vu8kkvFdMlTjavLdccv
         LIz8pXspK3XiY48VO0Qoz5ByStDAynbvrPW8fvuJs0cI+tpTvz8HZyE95qoUpxxVKcff
         wiEgAepPlSqsDPyiOdZorqPtJ0JGDmoYaxRAXfjMsV3Vt5dDBjA2K7fZYh/L4ZDW6G5o
         wvmtPVQiiOkSeuPUVO3AZyW03KZVHeH0gHRXq9casF1rucnS3jHOb8zlpahHSU5NaMMo
         +cgg==
X-Forwarded-Encrypted: i=1; AKwUvBxhTZM2jjtf08au1zyVzPCLDJHErjdW4YBigYtwhzxWrLMxPnO3ie7MSxlGOywEMaovwaJybipL@vger.kernel.org
X-Gm-Message-State: AFq9FYIH741zMi8C53krpN+1i10cJwB4Wpeo50oonQhgxGg78JAdv6pf
	05K3ihIuT+AFeDt+xzv04cQsqT/3jrPpFqyrOyuULXGRonryzVcD13ZrVd/ZgupwoI/CkCgmzgb
	ekyitCrXtp2vPJ1Y7fXLQeRiW55XAHxQNztTegbup
X-Gm-Gg: AYBFou3irj9hmIH0yAVq8zTK04NqnuxnLAGeGBDc4QB+ob5XWNZVZS/lCQ27DyqNsn8
	AzReT9OMbE3gFCJ1nhUJs0eezzAj1RbIBt1rY/ISwaXmgU8hfu6auMpbvYiMQcvq7zOrHNOKdav
	j5YcdpJzMF5912WrZgYQybUyAdaDCbBoM5RN8BV0HPdra2VMIWs4q/BQgoE1zZp/jlW989YPQfD
	+SwPIKeWtZySktYqyitNaJeHctz31YM5S1iWKCQYNVTgnQBRtQUxNAuz2A0KOuyW/+Yw5baIgSR
	D/OHjfqAgP/C4phvTEj3G8hA1aeQxzVSz4jjo2Ovwyi+erT2i0wAg7BdMx4W/Q00P8nXLOr9+JZ
	ShTowvx5UixiDJ2CSBFJnyVU8OGQ/I86IVuqF5vTnmghhmx/zpdlJibqTYERROhsiiNJnhdY46J
	tAUiFhnIIbvGIUaHabJddC6qlYYfu39WJ1ewb/F2yRSfia
X-Received: by 2002:a05:600d:8:b0:4a1:e728:2915 with SMTP id
 5b1f17b1804b1-4abf8764faemr3392105e9.9.1793640911875; Mon, 02 Nov 2026
 09:35:11 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-3-tjmercier@google.com> <auHMXBwnwuRwHLmo@KASONG-MC4>
 <CAGsJ_4zuGRjH+=1JxH4BYEC-vJumKjkhXPse0jW_nKEzQXXVmg@mail.gmail.com>
 <CABdmKX1PvZjnJkqD48_Pb64Je_oZVO3F-oaxMsBYzHmY-GjbDQ@mail.gmail.com> <CAGsJ_4xggGnAhguPkCJ5k08v3QYKUv07_MhF-acXdBczMAEpdA@mail.gmail.com>
In-Reply-To: <CAGsJ_4xggGnAhguPkCJ5k08v3QYKUv07_MhF-acXdBczMAEpdA@mail.gmail.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 2 Nov 2026 09:34:59 -0800
X-Gm-Features: AclHuK8o-leCSnae7wNuTxaZ91TaEx6wKMCDX7_41RuiJN7yC-g4TVBlixhIwdY
Message-ID: <CABdmKX17z8146_dTxMuBT5_rKtdvGGHdYvgNg-7eSqobEaCyqg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/mglru: stop rotating offlined memcgs to the old generation
To: Barry Song <baohua@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 2:03=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Thu, Oct 29, 2026 at 5:22=E2=80=AFAM T.J. Mercier <tjmercier@google.co=
m> wrote:
> [...]
> > > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > > index 636152d8c94d..45a2c1021f4f 100644
> > > > > --- a/mm/vmscan.c
> > > > > +++ b/mm/vmscan.c
> > > > > @@ -4538,7 +4538,6 @@ bool lru_gen_look_around(struct page_vma_ma=
pped_walk *pvmw, unsigned int nr)
> > > > >  enum {
> > > > >       MEMCG_LRU_NOP,
> > > > >       MEMCG_LRU_TAIL,
> > > > > -     MEMCG_LRU_OLD,
> > > > >       MEMCG_LRU_YOUNG,
> > > > >  };
> > > >
> > > > I think there could be other usage of this LRU_OLD macro, but indee=
d
> > > > offline is the only user currently, removing it is cleaner.
> > >
> > > I'm imagining an Android use case where, after LMKD or similar
> > > userspace killers implemented by various OEMs kill an application,
> > > we may want to prioritize reclaiming its memory by making it more
> > > likely to be scanned and reclaimed, while the killed application's
> > > memcg still exists - not offlined.
> >
> > I think it's an idea worth investigating. I had a similar idea which
> > is proactive instead of depending on reclaim hints. The code is behind
> > a currently inactive flag - it runs memory.reclaim on an application
> > cgroup before offlining it (so no zombie or reparenting), but I
> > haven't had time to properly test it yet.
> > https://cs.android.com/android/platform/superproject/+/android-latest-r=
elease:system/core/libprocessgroup/include_platform/processgroup/processgro=
up_platform.h;drc=3D2ed7b05ab42dd67391ad2819b0ee399d89128ead;l=3D33-34
>
> Thanks! I know Minchan Kim has explored something
> similar: releasing exclusive file memory when processes exit:
> https://lore.kernel.org/linux-mm/20260421230239.172582-1-minchan@kernel.o=
rg/
>
> The idea probably wasn't well received because Android
> workloads are quite different from typical server and desktop
> workloads.
>
> The fundamental assumption is that a killed app is unlikely
> to be restarted shortly, so its memory is expected to lose
> recency. In practice, this is usually true.
>
> There are some exceptions, though. Some badly behaved apps
> have monitors that keep restarting them whenever they are
> killed. We might regress these cases by reclaiming their
> memory, only for them to restart immediately and have to
> read the data back from storage.

That's just abuse and I do not care about restart costs in that case.
I was made aware of one of the strategies apps use for this in 2022
and closed it by freezing the app cgroup before killing with:
https://cs.android.com/android/_/android/platform/frameworks/base/+/79825c6=
f2f8b46808e4b431fe52b3be78f1e8ac8

However there are also cases where apps are restarted by system or
vendor components after kills (quicksearchbox comes to mind) and I
don't think we'd want to zap all that memory proactively. Arguably
they shouldn't even be killed in the first place, but if they leak
that'd be a problem.

> That said, this may not be common among apps on Google
> Play.
>
> >
> > > Similarly, a foreground application might benefit from a lower
> > > chance of being scanned and reclaimed. This suggests that Android
> > > background-to-foreground transitions, or LMKD itself, could
> > > potentially leverage the reordering of memcg LRUs.
> >
> > We are planning to use memory.low/min for foreground protection.
>
> Thanks! I guess the challenge is figuring out what value
> works best for different apps. Should we collect data in the
> lab, learn the appropriate value dynamically on the device,
> or simply hardcode a relatively large value?
>
> Any thoughts on this?

Yeah per-app profiling doesn't really scale to millions of apps. I
think our approach for foreground apps will probably be to use a
large-ish memory.low value that is scaled by total device memory. For
system services we're experimenting with service-specific values
closer to their actual working sets since there's a limited number of
them and we control the code. Even there I think some scaling with
device memory will still be required, since more RAM and heavier
device use mean more state for system services to manage.
