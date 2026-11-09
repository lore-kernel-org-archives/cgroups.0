Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794211731;
	b=jK/pKXQ7r3FPkDtM8sq9z5//QBf+c/XXHo2/pknmm0FLqgyEdbfqgRRC791P3TxHcDvq
	 33cjlNCzFToYN84Oy0Gj7/QMAut4yVJyvjt1+EuOzyV4pyPBOjsPQiLdmy4fTaydO5z+T
	 aZkemGiVFzxRFbYOJ/hf5M4WA6MLlri8qg2lwGiBtT1MpLBNA1qep6fSma5e1G70gNglR
	 uCy/7oHSFLunk5vzeTOfoQBxPZgT9sou+hS1/CStsU8HJzFxasIuoGB15+DSOSkJTdE5W
	 QmGQNeVmp0hwI5ei4XlC03hcbLY4dnQ2mKO0RjvogM4e514T10JD2pX06wswhvnF2mg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794211731;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=LiMJF1XvwF+Qc5jdWubo4n2qJDpryfHhpNFCa3GO55Y=;
	b=dhFlZsSh+61lB4P7u+997vqKd12keUBtssBrkP/bmSeMYLvPWPakFL/evgK6O2I5ZePr
	 gjXqExqLecqhollmvaLJsvMlRnv1IHxT+oK2AHjA1u/wMPdjE/bJBXpDsA3QUu/CKqRjf
	 UJroS/PR4VK8LsAXWKR8QRuRghvs+mlECbPImyv1U3uC1DCvc/8MSO1Uj9vTLtI7zoOgy
	 UzfLAabi8LgbDOkq9bfKPVfU9TbK8q1l3xS5CsU3pMmCWH0t5R3hYlppTNSkF+DuGL+rb
	 O39QYha5LaR4NdAnbD2vMKhF+kvFKu1l3yiWf77ztiudqu0BxRRQWijdOg+wSoGN4bg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cPLD8fxg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.51
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7BA606A322
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 08:08:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F7BA606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cPLD8fxg
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c4682977f9aso64125066b.1
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 00:08:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794211729; cv=none;
        d=google.com; s=arc-20260327;
        b=mrH9cMKvchcSbsqzFnUpievfRhW+VijPGtB8nAjYfJ9DH7x5nhDfjrjOSDtcOWwZco
         gzkQJW2HNXTeaIU9d/jxUWvuiPGCU3BrbA3plg6ECuUZBexUzNjOk/VDpyjvgOp1t1Ay
         T+2wasRa7JdP7N2lHd0DjoGCHaGgCzv1gYHu9AuFdnGyO3e9TCLgdRmSamo7zxZlPyZV
         U4ApRl8jh5IGEocciyyI+kYIaRP2ciU4jtYZFJxNj7PXpuPM1mIFxSv/KV2i+rJPayxv
         6OUXUnfKBvoCxFrhHZs7ZSP1pNbOJVrWmanIBO4zGBVaWnbjnKh/XYSPg7C4/1HXSW9d
         R+fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LiMJF1XvwF+Qc5jdWubo4n2qJDpryfHhpNFCa3GO55Y=;
        fh=jxr/rAkaNS+B5e14IPHNK4K0TbAOdyfFhmocafKGhZ0=;
        b=R6gtswMn3bQv0AqEH81pd2A4zV9wXucuVdE9Arh5VN+h1OhDgpJLVKk5iul6xhT0Ju
         yXnwMMX9QLtVvApGO6QXaeuRWLGWKaGCQgPxGzXXyW/GMafe7DtpA5TZ7/JiyRFgcP8+
         VA35f0hI1bfYQMBreN41//pEANMC2uvMxKlCxpIB23gnl0/BP6aBwIZdR47vnonfQ9LV
         z+JgEDG0SGzMvUpGuQW5irrFTbcvqvfbmtr2QwI+wnSU1RA5L5CF4V7TNgm4mkl1m34i
         ORg5DzyV5Pux865Y1nTAjm7+IbVG76IsplQsl1EWq+I4/ETdXhhDZQ/OXsN7cdbwcdZj
         fgaQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794211729; x=1794816529; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LiMJF1XvwF+Qc5jdWubo4n2qJDpryfHhpNFCa3GO55Y=;
        b=cPLD8fxguKoynFlGz2OK6UmitpF7qDa34GHBjjK5CPLpCbqNyVHoPCCjxY4SX/Fu2i
         LY7icyhd+dhM035lPEX+xThVpk2/9s3VyfEkV4SvaCjy8Ro13ykNoRwFcQGz3rjmmHgT
         jt2NOS38q9UxK2Ag/afOaCNM61f9lgHh4DfuDXn5bB48CrR/mN4iNsEBV+0SN2lRriyo
         n6/A95FIil1AIcAc8WfZIv7WWXCd7WTwtJmoaI4mknRPHaDnT+GOTgsH1/nC/fXBiQ9B
         qGoCBii5YE+SCEIonRxTaL0oW8EQ1TsG0zF/DqzdLYN0c1iR6CZgiato2MxRAkN2bvp6
         6GMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794211729; x=1794816529;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LiMJF1XvwF+Qc5jdWubo4n2qJDpryfHhpNFCa3GO55Y=;
        b=cBIsfMXCi3tQCEEUUdFscuNiEVMpAMrdbjhklbi8Dzb01Y+S2Mt7JY2NByvYn2F5sj
         R8vffFGgwJV7jTzJKSEINd3sm/VFi+JvZ66cilonGToT0iQHP5veer8y1cOu3fchjP0c
         wEp7Oxzy03d9wq+QB3BGhR82c3ecfhMbLV7G1OUe4ijtkgp61GxxiTnBbN0dPSzI4mPH
         nAxpOKNfbW+6COTwIkS07m09MloJrjcGZFz2mhPddbO49oGhE1U8BeG8zcc6NfXuzYsZ
         DXqxZTxgfloAKnuIqX5qPh+J4bG/hHfZahNQ5ISTlGvDCN5vWFzAJ291PSt6WuvJ8F9w
         GM0w==
X-Forwarded-Encrypted: i=1; AL+hErGzHZ7vED2wRep3Ej+wRsrtxcFOvFFGOUFJD5ykudsSS4LRQtmJgSFkSnC74MoODp0nDSLRjfus@vger.kernel.org
X-Gm-Message-State: APuU4Z/yEhf6TAhQ+xu6qlDKrFpNU7OixeLKuxTRowFkwhcn7g4zC2Ij
	+UyJJ8pTb1WvxnvWLvzJgbY/HvE9jjyHt+tVTp9Mck5u4arJACsLooYMX5SDX19OHvzkj/rJ20Q
	45sw54W75ktx8vHtck4oeJgDxjz+SeNU=
X-Gm-Gg: AYBFou3gpuWQ3OoGEE9m0lY0UKM2Oll9TkQCXPLOBkDtLGZV33HZFe5x7Zjb+PY5p9h
	KiEuHePpDFX5DVjsVsALFQ+Z/Do09xyptYGl9duJLOA+2gjpaz4R4Lwts3bBEjjpkVwnexeviT1
	7oYMFZzA0xtptf6+TedgA7vPevZZNarW7fNMmYNkQd0xXbzarZ5mw1Z67TnZyxuf34gyCDYW0Bf
	kdgpYeJInX1RXtQs3RHly5l4A1IkQ+Fch7CwXSSUI7a/UG5uAWiyWE0W7wO8oSNyN/32cWNcTCa
	3zAGxc3hirCD++JaLKor0slrYd0+ELCCzW2Ndk0KzGU9b9wpb+e31DJT6iW4e9VelMHrAOWCayQ
	mHYbUmgQALRpiiZD/XjgPSfO9DwIe9SFK26axwowK4Nu1dizygnUnGm2HeoSxcyNHp0h5
X-Received: by 2002:a17:906:d54d:b0:c42:4750:8d33 with SMTP id
 a640c23a62f3a-c4d6d79c9e9mr220208366b.28.1794211729178; Mon, 09 Nov 2026
 00:08:49 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-15-2106750c0bfa@tencent.com> <CAGsJ_4wTFHJxzuiRDBcuevdULMcD+se6SuPbzWKA8wsUAG80_w@mail.gmail.com>
In-Reply-To: <CAGsJ_4wTFHJxzuiRDBcuevdULMcD+se6SuPbzWKA8wsUAG80_w@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 9 Nov 2026 16:08:12 +0800
X-Gm-Features: AclHuK-rg_Epjx8c_oIR5RKRDfprNqzR2T_gknTk1R87bd-Y63IPVOAg_lUq4r0
Message-ID: <CAMgjq7Atry0zRc_-xbrL_VubxTBQOT8R2_aumghXQaO9uTANHg@mail.gmail.com>
Subject: Re: [PATCH v4 15/17] mm/mglru: make folio_inc_lru_refs lruvec lockless
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 9, 2026 at 5:48=E2=80=AFAM Barry Song <baohua@kernel.org> wrote=
:
>
> On Fri, Oct 16, 2026 at 2:16=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > The lruvec spinlock in folio_inc_lru_refs was only taken to keep
> > concurrent aging from corrupting the size counters.  This is no
> > longer needed: the per-generation counters are atomic, and the
> > active/inactive ABI counters are updated per folio and linearized by
> > the CAS on the folio flags, so concurrent aging can no longer corrupt
> > them.  The same argument already allowed folio_reset_lru_refs() to
> > drop the lock.
> >
> > Use folio_lruvec_live_get()/folio_lruvec_live_put() to hold the RCU
> > read lock around the lruvec lookup, and drop the spinlock entirely.
> >
>
> Yes, this is cool. We have two paths calling
> folio_inc_lru_refs() or folio_inc_lru_refs_walk().
>
> 1. folio_mark_accessed() from syscall access
> 2. walk_update_folio() from page table walker or look_around
>
> For the latter, we can't actually cross multiple
> lruvecs/memcgs, because of get_pfn_folio() as shown
> below:
>
> static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *=
memcg,
>                                    struct pglist_data *pgdat)
> {
>         ...
>         rcu_read_lock();
>         if (folio_memcg(folio) !=3D memcg)
>                 folio =3D NULL;
>         rcu_read_unlock();
>         ...
> }
>
> Consider a common library file used by 100 memcgs, with
> its folio residing in the root memcg.
>
> When walking the 99 non-root memcgs, even if the folio
> has been accessed, we won't get a chance to call
> folio_inc_lru_refs_walk() for it. As a result, this folio
> may eventually reach the eviction rmap path. With a high
> mapcount, folio_referenced() could become quite
> expensive.
>
> That's what I was trying to point out here as well:
>
> https://lore.kernel.org/linux-mm/20261102213915.57805-1-baohua@kernel.org=
/#t

Hi Barry,

Thanks for the review, I saw that too, very interesting approach! And
I believe it will helpful.

> For the former, you can get the lruvec with:
>
> lruvec =3D lruvec_live_lock_irq(folio_lruvec(folio));
>
> I'm wondering whether we could eventually unify them
> so that both support cross-memcg inc_refs.

Definately, actually for that link you posted, combined with the code
snip above, after FG, I think we can further simplify that, no need to
check mem_cgroup_is_descendant, we just do:

- folio_inc_lru_refs_walk: if the folio belongs to the lruvec being
walked, the batch stays in walk->lruvec
- folio_inc_lru_refs: if the folio is a remote one, per-folio, no batch

non-descendant folio sharing across memcg are actually quite common
e.g., libc and shared mapped memory, this could be more helpful? And
it seems fast for the walker.

folio_inc_lru_refs_walk follow the same rule as folio_inc_lru_refs
(with MAPPED flag), just faster, skipping RCU and the speculative
check afterwards as the walker owns the seq it is advancing, and
caller handles the batch update of counter. While folio_inc_lru_refs
only requires the caller to hold an reference to the folio it heavily
relies on RCU / CAS conventions, not easy to batch things there, but
it's still accetablily fast already (e.g. the fio read test showed
almost no performance penalty).

And I think the main reason MGLRU can't operate cross memcg was, lack
of a protocol to stablilze the memcg's gen and holding a lock is too
costly, now folio_inc_lru_refs handles that, and FG
 lives on top of that. So we can try that out right after the FG series.
