Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793222573;
	b=O0F9CQyYjWOlFW2A6VvOioajUy6xA8Ab5PQxMF0BjSC1jF/xtt1ZEEahcM3wcrb0+mEG
	 PXvQg/YS0lGCwRyk34GjUXwe2iu1GrG0wJrZOcgS2st/+5cA3GAC3Cv4DfLW7351B1FGP
	 f+TueNN4virkl9hSK9HBxb7WCO6bFdwua4jhBbDr9MWgKrYfobGUxLab+9pDFIYOAFjAz
	 36ZuDwE/tq0zFoKoXv03ooROVX7/9lYU227Xgi7Hl6FKQAoEtaf+uW3+rB2sD8M9lPV+A
	 Gicb+hsPQ+vxET09CjF43EO/DYS38+WPxcBdxA+9gYQA6pIb8r8WErtXg31VqjVNenA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793222573;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=H9OWahcyc0RtO0+EeUD26bkvPuyjvUzZOmtjTnKMJz4=;
	b=FGTRtLNp7DGVWau9Sy50t9RjB5IYd7RVzbd/nFHNRd0aL9lanD1TsumV3CllZcU3lK0r
	 dkRYroKSVngfNaBs+rZXsBiOeYynR7D29pYtE8M0d/t5wYgIo6s/EdzSDM5ZyASqs5Oro
	 x4BVQDIib0Fcr4lRJHR/6Rr4+BKgWYmGht1SuiSr/VzzgO7A8LwEpzopLQ4q4mAhbumdA
	 RPOOF0NZ9V6rcTBZo2TFxdua4RlVG4rW58PwLdWsaW1FAkMkYq7TMPqd/y9IqnvH66jkL
	 HfvuNxAOchKUNlmico3QVbW8cpjNjXTJCzxu/vDZpD/1rpvVOcN+/QXmG36/w8oc+Ww==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BdNpiMdS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18651606A326
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 21:22:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18651606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BdNpiMdS
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a20d7a8984so5085e9.1
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 14:22:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793222571; cv=none;
        d=google.com; s=arc-20260327;
        b=elpCTZXaPiHyk5+nPniqg/tQ3XOA2Qu+twYFp/8HKNtarvq4WBZVASMGBl2s5fipEf
         qaqrba4C4dWBRMeWIOyo4IqFzgtWf6f/Oraon74deybvj0Eg4TZpowttRGL82bzY5sLd
         OvoqNBDQk521eqWTG+Ln+PZCQWtajtpTy19FckY+1hyU2GNLpMZ6UXRENtvO4SE+nMe1
         QYuZwtG60a/QOflyCg6oIpPE03u1OXyMUPW3Uw7XdkGN8uSOviZlrQGoQvsinbmmb4Ry
         U72BHnRivYr2wChxXZy0YJ5N+pDpBHYX1VsodggDnDyeT6iI0IemJ7NJAbVsRn+w3JWL
         RSlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H9OWahcyc0RtO0+EeUD26bkvPuyjvUzZOmtjTnKMJz4=;
        fh=OIvnahoafuz8YdAfNfanf2jThOnMj2HBNOFZgKXBif0=;
        b=VWpb1fK9HVI+rPY4T09lG5dinFIee+3vcXDtpen4DBtEmADge+cqhn8C9RAzWhXSds
         XPBvUv3OQCzTdVBCKZWdo9QfvlHL6djTeVYJYq7WaroytoL2KrMqfWBxleuyhe/tNRdA
         sJziSHnwWG62NreV+8L+ALVO2jdYZZlLJWBShM26yZfbg4cEixdLdcLViiFZK9oiWQ2u
         DWtUfyS6lO8B4PXEAAZZqPaCpFUhiSZ0PchGdOsKJlb9Xqz+X4u/Jmbi/fFzD/2dpMFX
         6FVPKYgkU1V/ucoGYSd3CJJCw3BHH7EAufhz5kmYSRYGjKHeGf6sfOK5IeU4AN1bHX1X
         1iPQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793222571; x=1793827371; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=H9OWahcyc0RtO0+EeUD26bkvPuyjvUzZOmtjTnKMJz4=;
        b=BdNpiMdSCff2liQ8tiUGDfLBx2qXWrVA+PVPjmF/gUh6+AQ6ARYk6zGtN2RDjM12Kj
         tIv1KztstgoyrA910VMkmt94SokmjkeDp9gLkyXR3FzhenIwJ1SHYMhws0/gUOjjPw3h
         rr9YslNsq0hPwRxAUKG5HBPou5uZcM7MfwBEPWRgIdx//15NmzTabuUB2/D72zSoAbOS
         QMKlP9MDnNezExJwNAH04+y+MtLnvBXEqrNDrYRdMB3OXs0rQWcK7IRGecI5nxAwgPwg
         fKPLd9qt6W+jsh4IbfXjTdfrH0SuaHTq4UdkBUwRWZ0No43M3RMCwxJpHoAmsmReBPZ4
         B9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793222571; x=1793827371;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H9OWahcyc0RtO0+EeUD26bkvPuyjvUzZOmtjTnKMJz4=;
        b=traSDN5Jc48p/qzG2/G+52AiesY5N7tSNunI+f7bXiJSB0EL8nXqplTnaOSYva6gPk
         duCF+beg/QGuxpusiE0l1XGoLsYrpA+O7kugmTqtAk3r5rl6UsCpoVfViXKg256OZD40
         I4lplKLLtcABpUmGFakPYxJyJgcqsjVq7Xd6OTJf/6ddZoccUG//0wtACn7kl5uAD3ao
         +Q9yx72XmopfCZmW8Cf8/C1UZ6I/GYZdfzbwnn5eSYelsLmvoljLAskVWdknBAXTRYeT
         R6eInQ9bUtJMAp19NVA1TO28dPC6bZmUmW/B8XFswB4DEmO8WABvDwnFKJ2hSIfim4Eg
         fvFQ==
X-Forwarded-Encrypted: i=1; AKwUvBx7g5WuU74E4wirtkI/jLQRK4osiP6QKUAcp8ARSVonFFHbCXI8/n3aZPRByzDUvpfsmwsdzsRM@vger.kernel.org
X-Gm-Message-State: AFq9FYLBC0HHSilD9q0So8ZQq/wE/P7JVei+vn+w2jSngLQdv8cTYw25
	KJmmvM8rXFsxvMqPy2wclmRTYE4dyh9FaHRffrMVcfr5j5ZyUgrbFU6s34zskAHoSPWYZLWPgUC
	UwnqeUxp7KcM8yBej2oxaQUJCUruSDGM1lnfe3aTw
X-Gm-Gg: AYBFou2xjumcp1hyT56TFZa46ScA2rf5u7RdHZQpaYWYYYi4Kwwjt885ECLibLy1WNr
	/1804G83drj48om4t5osLElYMnbx048HyKgn0Cf+MYZWJos0zkr2QfSjKz9ZCMkDa5t+lbBAxaM
	Az4rGvFsKKwMxXtzfnj84g8I+wTGbBhby0Oxt9um0Se6TOH9y9/d+keSSy74hTlOdXb4lOOf8tO
	NRk3tPSBaneG6F6ql7gMnTkPH5bbB+lFydVG4uf8El+VMqLXZAN742LwB86v20xEUeMHXtTkYx8
	Syfx31V61rV63HQU8nLRyPhFaDGgWqgOJJpSqrUabnaBc2o0sd05ZilYBD0VQti6VSJbwVgvXwK
	Lpdf+VschlMnMw2Uv81wxcuGGF37sCSTgNTp7IWhGX6umLOYwE4oquI0ElaJ1JCS4hZowpwALHg
	AXfUbLwYennFA0xzXoG8UWijI=
X-Received: by 2002:a05:600c:26c8:b0:4a3:5de0:19ec with SMTP id
 5b1f17b1804b1-4aab692b046mr61845e9.9.1793222571076; Wed, 28 Oct 2026 14:22:51
 -0700 (PDT)
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
 <20261028010611.3929937-3-tjmercier@google.com> <auHMXBwnwuRwHLmo@KASONG-MC4> <CAGsJ_4zuGRjH+=1JxH4BYEC-vJumKjkhXPse0jW_nKEzQXXVmg@mail.gmail.com>
In-Reply-To: <CAGsJ_4zuGRjH+=1JxH4BYEC-vJumKjkhXPse0jW_nKEzQXXVmg@mail.gmail.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 28 Oct 2026 14:22:38 -0700
X-Gm-Features: AclHuK-BDrgLvfZN_Z6mj4D7H_QyFDZWiVpmhu9KpmL6zRb0X5M1HcHjt7g6ziM
Message-ID: <CABdmKX1PvZjnJkqD48_Pb64Je_oZVO3F-oaxMsBYzHmY-GjbDQ@mail.gmail.com>
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

On Wed, Oct 28, 2026 at 1:57=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Wed, Oct 28, 2026 at 6:43=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > On Tue, Oct 27, 2026 at 06:06:06PM +0800, T.J. Mercier wrote:
> > > lru_gen_offline_memcg() moves an offlining memcg to the head of the o=
ld
> > > generation of the memcg LRU (MEMCG_LRU_OLD), so that global reclaim
> > > visits it first and evicts the folios it left behind.
> > >
> > > Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> > > dying memory cgroup for LRU folios"), those folios are reparented to =
the
> > > parent before lru_gen_offline_memcg() runs, and nothing can be added
> > > back to the offlined memcg's lruvec afterwards. Putting an empty
> > > offlined memcg at the head of the old generation no longer serves any
> > > purpose and only delays reclaim from the memcgs that still have memor=
y
> > > due to additional shrink_many() iteration.
> > >
> > > Remove lru_gen_offline_memcg(), so that an offlined memcg is rotated
> > > like any other memcg below the reclaimable size threshold until
> > > lru_gen_release_memcg() takes it off the memcg LRU. MEMCG_LRU_OLD has=
 no
> > > other user, so remove the op and update the memcg LRU comment as well=
.
> > >
> > > Signed-off-by: T.J. Mercier <tjmercier@google.com>
> > > ---
> > >  Documentation/mm/multigen_lru.rst |  4 +---
> > >  include/linux/mmzone.h            | 14 +++-----------
> > >  mm/memcontrol.c                   |  1 -
> > >  mm/vmscan.c                       | 20 +-------------------
> > >  4 files changed, 5 insertions(+), 34 deletions(-)
> > >
> >
> > ...
> >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 636152d8c94d..45a2c1021f4f 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -4538,7 +4538,6 @@ bool lru_gen_look_around(struct page_vma_mapped=
_walk *pvmw, unsigned int nr)
> > >  enum {
> > >       MEMCG_LRU_NOP,
> > >       MEMCG_LRU_TAIL,
> > > -     MEMCG_LRU_OLD,
> > >       MEMCG_LRU_YOUNG,
> > >  };
> >
> > I think there could be other usage of this LRU_OLD macro, but indeed
> > offline is the only user currently, removing it is cleaner.
>
> I'm imagining an Android use case where, after LMKD or similar
> userspace killers implemented by various OEMs kill an application,
> we may want to prioritize reclaiming its memory by making it more
> likely to be scanned and reclaimed, while the killed application's
> memcg still exists - not offlined.

I think it's an idea worth investigating. I had a similar idea which
is proactive instead of depending on reclaim hints. The code is behind
a currently inactive flag - it runs memory.reclaim on an application
cgroup before offlining it (so no zombie or reparenting), but I
haven't had time to properly test it yet.
https://cs.android.com/android/platform/superproject/+/android-latest-relea=
se:system/core/libprocessgroup/include_platform/processgroup/processgroup_p=
latform.h;drc=3D2ed7b05ab42dd67391ad2819b0ee399d89128ead;l=3D33-34

> Similarly, a foreground application might benefit from a lower
> chance of being scanned and reclaimed. This suggests that Android
> background-to-foreground transitions, or LMKD itself, could
> potentially leverage the reordering of memcg LRUs.

We are planning to use memory.low/min for foreground protection.

> But anyway, this is not a reason to keep
> MEMCG_LRU_OLD for now.
>
> >
> > And everything looks good to me, thanks!
> >
> > Reviewed-by: Kairui Song <kasong@tencent.com>
>
> +1
>
> Reviewed-by: Barry Song <baohua@kernel.org>

Thanks!
