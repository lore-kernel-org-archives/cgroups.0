Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794194444;
	b=nqVmdRCPe2eJ3i94euF7bqAb+3eFwK/0OfW2xqQZiWrZTJvnIDf3jrO6r1+wxLuIpb+H
	 4ASj2fLqfTAJoPV8O62vvCO4ESTx5YdIfPc4wapQHbQ0BvT13+9miJOOQA6A+i+6acrYU
	 pIoL+NatTWk6tB5aZ5wg9yTOyiaHNXjS72ohH9FKZw9oUAL4S8bWK2ibPgTzuf3Er8bJp
	 OwB6PQWh5EkYcXqzkGEfxSzfgMoRWAK/akimvL1Lv+K0qFQ6cqvBUaimJoNUJSHUQX6v2
	 6ZfwrORpBK2hOOehQmdfAay2qKCPDfJIzldIO1KzIm3e6W7NK+AdivqgZmKFvJibeLg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794194444;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=sE/fNcXhZCFYoGckzt8mvo4VUCyVdxTAKOyI+l9fVSA=;
	b=HRgdusn3dGqLd08QY4NBEjCoxrd6HrG+zQ3Fda6AI2dKCA9m7kF0GiqpAPv0B5R5uJU7
	 23o6S5p2bHWI6dLFYH6V/SY8rPr/vQbBC1BtPhScFB8lVx912j6FOrNO0Cej+jO2wqIP9
	 inElC6N8fC1GKcRswX+Tx0B5JIetJprMKjb9cegoJXhNlhl0bkaiOWbyYs1PtD7qT3/md
	 4AiGEMoQEA5bxUamquF7fP1xt6h85AvfnaYQXVBNLaAokUXyY5t5LEAdVbEkFO+moobUg
	 fYlBQC/fnTY+oKG2dL6ZkZzLfNGcy4gKIrvN7Ut1G3sDBKKWSisfEwHe3OKvKGYrxtA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UcxeBNj7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D6E606A321
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 03:20:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24D6E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UcxeBNj7
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c4d5b2db4bbso74540266b.0
        for <cgroups@vger.kernel.org>; Sun, 08 Nov 2026 19:20:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794194442; cv=none;
        d=google.com; s=arc-20260327;
        b=eKh3hMIJnG3iWyH/84OeJt5cAvdkeq2APTGRVWjScoeuMAosKLQPUGezkqa23oOZaV
         B20087/5KoDm2Hi8YqRVrzybgWAh6jIHpVMkm6jtlHuSTFqjqOvW8GY64vjGVc99EIw4
         qe2iTGx8souzYA0Mu8Td1UVXuZphmRtuNbzmuyu3n5UVkZesAVrHaC6cBLpZ/ZJyxnTt
         f0ClLtPPzKQJQyfLAbkDktlB8XJE8EIvxpBKb+IaMhFnx5BE54Gpj3zDYKZL5Vc59gV9
         M9klqs7gIymE+MBfy3FNpOno58pNXFP1aM0fqzBaGmbwaSvEZzcQSgAJ1QQZVCAIzBYc
         q3Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sE/fNcXhZCFYoGckzt8mvo4VUCyVdxTAKOyI+l9fVSA=;
        fh=G9B7Hz0fKgNCadV7rRRjfvWQiCN4dF1hMgiwpfz/KJA=;
        b=FeBux5RO33LfhPG74hA/1lgzVBo6aef5RAWKpQJLwB6L+US8cbubwPmZmDeM95DCjl
         KaeSm7RcEwqBFBq2ZEPQ3Y+u5VjxN4Hy2zbTtG1Cqmd3Tt13EFDBMNG8HV0jO47X2273
         GLu2yFlbrIe7aHl26Cz0CqaVXGAqZNKqaJeL4JSqKmIz0hRasFSE+ezFtTrIcbk4bhZd
         VYvwplkQMwAqswRJq99J73vwS+Fy6u/id70TeHFW6KzCoORYfiD6dVCsxIpzRkN05E+V
         9BFBlZTRs/oCvHZWddHdokYwEa8tdn2TCsRocKjpckGKGXpDgRJrgpuy4vtEL4BS4dxM
         fVpw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794194442; x=1794799242; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sE/fNcXhZCFYoGckzt8mvo4VUCyVdxTAKOyI+l9fVSA=;
        b=UcxeBNj7YdyF0xz0sXuviGdjsvtnSxlpUUJWrGSHJtJTOoBy+J0FOj4ll8ZP9bOvxo
         vik1WTHEF1/YoLmDx3GvJVqmffUSEmDeVfGpMCrrLen5tprNc/re4CmgVpbL5zXZDi+s
         JcvCGqKPXWptq7MQZ4t7Ghty4NEbRrShdtDq+R96tSv1NDPWGnPsoJheMo3eykWQ05ll
         LnMBGXMrRl1VAgwh/+Q/i6vWvTiCvsz0ub39e/9oYPWqAV4f3Ihf49jvqNA29pNa0B03
         tGWjj7myt/Ws5vWFct2n+evt96mdg/4I7PgOYXFIMxqmSNlEuj5uMPayKtP2GaNXE7hG
         utyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794194442; x=1794799242;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sE/fNcXhZCFYoGckzt8mvo4VUCyVdxTAKOyI+l9fVSA=;
        b=sruElLAUiGVCGRLyc13Y4EE7tkLFyvpjqIv1Zvy74WlpYT4u81XBeIcqGq4A3x5Fe4
         vKCAwbXnPEznn0T4bZExy8e1e8ABlHcSPaqtfdRDmE73nQde5MRwaNPsnwBKvZ945BY/
         SKS5XLnsr+KO2KcynGYU4XrLq+ntcP1/gsrjpURgJ66uX5kT39g52SxH5fVg/divT5ZX
         4+xi8CaIqvCggdxRJEUAe+CO2QENAMdxtXQjE2vj/MnlwP8YC8FcvyGVOvCtDAw76vtR
         GnfKjjb1H45rNZrFLvjtNy+ByNelwRSkcXccV0j3jRX8tYVXoGmEQ+93WPqjLlIOgygI
         Zldg==
X-Forwarded-Encrypted: i=1; AL+hErGpyCJ5j7IGTROsm8eEV3exTBGxcOSx6tCaRfagDP88ZGnJdPQkEBK1+hnM3AU3pTWwSJ+ULgGc@vger.kernel.org
X-Gm-Message-State: APuU4Z+pJ0E5d+2IAR2s1lkViwZkQ1hEiiy2s6N38oWlZyd6sFqZmCKn
	hfGc5z2RD5Ig1a+ZUUzOVhy9ws4PyNeCIpdY4nTGObfixC/AJ/axtENv5XG/npuSbFxrO+UCiFZ
	bnqzBLhEPPl/exZlAml0u5+s14NKZCLg=
X-Gm-Gg: AYBFou1JfCC+uGYz3GktWW629dY0oOKVgFhZhv0SUxoHj4XneBT9fW86ik/bLXtZ94x
	qALZZUwyHXvtm8cTLymsE6EFht2Q9XZC8p6YfS1G0Ysgyft+G8Fs/tMQ04405MumE47vGG9NMCQ
	s7Bl8cJrVMG4yGTGYjDuZwpYH7HcRK8XkHMRmlvPC2lpPcGeo+c07gd242DPfYICjAMuSAOLd8F
	FmbQpZYnrKm2u2mnRQIhEaityh8feubfpfZXU4xJNRJSOwUh+SqzlH+pEc1L10imFwhj6TlBz8A
	nRrYv7b3MU9NGKENf7yEoPSRYAGRCpwA6Ir23CUbr0F9KR9AcsF28FsTcIG3YAhALR+JWTzum30
	g8qYfCRfq5culT3a4jcy/HzAxl/M1QAqQXFd8tEzhsoybsZPKVCPxqBSG2cMvcKgfvtCa
X-Received: by 2002:a17:907:94c9:b0:c26:1cfd:4244 with SMTP id
 a640c23a62f3a-c4d525794f8mr366547266b.11.1794194442101; Sun, 08 Nov 2026
 19:20:42 -0800 (PST)
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
 <20261016-mglru-fg-v4-12-2106750c0bfa@tencent.com> <CAGsJ_4y-7R07wFJTY2a8tMQ1xvG2kjuG0Q1rLjx8DOg4u3UwZA@mail.gmail.com>
In-Reply-To: <CAGsJ_4y-7R07wFJTY2a8tMQ1xvG2kjuG0Q1rLjx8DOg4u3UwZA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 9 Nov 2026 11:20:04 +0800
X-Gm-Features: AclHuK8iUb9Dq3WsbSIlLK65gh2Lc8G5m0UCp-qFnn41-FIR3YsEFvqlSwVsNTk
Message-ID: <CAMgjq7Cj3dvJf8JCkLacGP0=2bPv6WR1sjOD4Ese7XeGP5VhAA@mail.gmail.com>
Subject: Re: [PATCH v4 12/17] mm/huge_memory: mark folio as accessed more
 accurately on split
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

On Mon, Nov 9, 2026 at 6:15=E2=80=AFAM Barry Song <baohua@kernel.org> wrote=
:
>
> On Fri, Oct 16, 2026 at 2:16=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > The behavior of updating the folio's access info isn't consistent for
> > huge mapping splitting or ordinary unmapping. The page table's young
> > flag has to be translated into folio's access info.
> >
> > Right now it only check and set folio's referenced flag, which isn't
> > enough since folio flags update on access have its rules. Ordinary
> > unmapping (zapping) calls folio_mark_accessed(), and it also checks
> > if the VMA has recency to avoid false updates.
>
> This might be a bit off-topic, but I once proposed
> recency fading for the zapping case in Android workloads:
>
> https://lore.kernel.org/linux-mm/20250514070820.51793-1-21cnbao@gmail.com=
/
>
> folio_mark_accessed() might not be ideal for Android
> apps that are being killed, as we expect them to be
> relaunched only after a long period of time.
>
> But for the splitting case, I guess there is no doubt
> that the accessed state should be set.

Hi Barry,

Thanks for the review.

I agree with these points. BTW that recency fading patch seems
interesting too, but perhaps we need something stronger than
folio_maybe_mapped_shared, maybe folio_maybe_shared, and do that when
"current's cgroup matches the folio's cgroup and have a ref count ~=3D
1"?

> > @@ -3216,8 +3216,8 @@ static void __split_huge_pmd_locked(struct vm_are=
a_struct *vma, pmd_t *pmd,
> >                         folio =3D page_folio(page);
> >                         if (!folio_test_dirty(folio) && pmd_dirty(old_p=
md))
> >                                 folio_mark_dirty(folio);
> > -                       if (!folio_test_referenced(folio) && pmd_young(=
old_pmd))
> > -                               folio_set_referenced(folio);
> > +                       if (pmd_young(old_pmd) && vma_has_recency(vma))
> > +                               folio_mark_accessed(folio);
>
> We now have two inc_refs paths:
>
> - folio_inc_lru_refs_walk() for mapped folios;
> - folio_inc_lru_refs() for syscall accesses, or possibly
>   mapped folios with the appropriate flags such as
>   LRU_REF_MAPPED, LRU_REF_EXEC, LRU_REF_FORCE, etc.
>
> The interface is:
>
> void folio_inc_lru_refs(struct folio *folio, unsigned int flags);
>
> Here we call folio_mark_accessed(folio), which is the
> syscall path with flags =3D 0:
>
> folio_inc_lru_refs(folio, 0);
>
> Are we somehow applying the syscall access policy to
> folios accessed through the page table?

Right at this point I'm just trying to stick with the current upstream
behavior, and not promote these folios aggressively. The results are
looking OK for end to end benchmarks so far, maybe they can be tweaked
further like a LRU_REF_MEAN so it won't promote them, just inc the
ref, I didn't find any oberable differenence at this point as THP
alloc success rate is very low when under pressure so sticking with
the current behavior seems not a bad idea.
