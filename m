Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2633FCB37
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 09:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787218852; cv=pass; b=Aq5iVv4z4EwqrCqRmnH0my7NRDNpqlCilvmqQ9aByzqK/KX29WrbfvB4by5E+f0gO7UG4CSmB8OpM4fJcTdrsQxOgjvAsxdbTOFBbkD0Q5636laNEaxaVW0Qm3SyyACnfNUuJ/NDzsQAQT16nUSpV4Awy5CY8BHlRhHz7FTcB4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787218852; c=relaxed/simple;
	bh=nanuFHVsBgqG7a7fke7k4nJlowtVRnvIUDcYf2o+0hE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G4w8Eo/gxHmuYikuNEos1wbG1lMeGA3154Pw1/Bsy7ch/hwexDaNlflFfP7jwVNmU/gFwVbKJlbR7YwuivQ4Kb8pLuuXqh0CiI8E2pU9XXPWpxbvfb8tmgdY7GIOyrkCPOY7Kft+e1ZzrOEKf+FUQjliaakGQgO3PlQBilxg6Wc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BtQOu2zn; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BtQOu2zn"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c167aa9500dso286249266b.3
        for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 02:40:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787218842; cv=none;
        d=google.com; s=arc-20260327;
        b=RKGfae6an+5GM5+8eq0t+SR+pqftcSfdNkCJWRykpHC3rqNzWFG255CFAGht7Wm0ZH
         gncAMXV7FxSTXwslloTGV9GrmJdVjH3Zcf6hVpIJSXLcNizFF1GJQUbLTzVOUByLgtZY
         D6+i5JjfZmYQW/jdY1QiyuizHLMo2fTl5xZJFcaQ0str+3GiDnCGbcmBLqj3Y5MsNUoz
         dHZoaPSj608TI2lR0dIqUp4eP6D7rsHF4I1aqcMKO3SO6gdKcLQRjvfrmtBoGkaH2zuM
         W0ZbJzrJOSl3ZyPlHsyvMQ5lt/SP5y28fNvNec8jx/tqwNgRqZQ8kY3yg7RC10TCrQC0
         awHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yBtmafbOayxaPZWLoQ+wO4hHf1gY8nYnCw9TiJ7qd/c=;
        fh=i/OT1g3wOUkfwaDBjWUhO/dDn++R80wKsfv/6JuWug4=;
        b=WTYAsmm9zLOKtnwi9Us+fq9YyzIYB2HrmEYxG4mjNmU7liS8sZGacMgbbPSPiyjndN
         THVFTLSUzNDoFkK9gAGbkXjMICRLCK6KtwmjtMcLG0k8rNbUNd1jt41AhI/C5vP4nMW1
         IBdBRJfNe0jgYs+hcg8KfcKVNb+ePDqtsOyV1gggl0ylctT7GgmGT1sTB25Z9gDLzW4h
         oKlY2aWqMKh6mnPPCN5W7BF2qrJ++jARsKYUgBJ2P5NwpdDw6kP+zY6NRF+j9JkIiF9K
         pUeD3tbQXrw1wTW1F4XYJ7Jdc5RuHhbGKmHIfyBPHZws1Vipv4ZX7g8LGRGAzKPOBm3I
         sAAw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787218842; x=1787823642; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yBtmafbOayxaPZWLoQ+wO4hHf1gY8nYnCw9TiJ7qd/c=;
        b=BtQOu2znA4k3SUW95AKCcpQvrJ8ipNRVz86r+ncjkfClpzgoZ2Kx0xOhp7ynxfBiN2
         8sCXSH7o/OoaydpQxFQfSa3GQ3GNQQq8YN7qmavD3mBUENA8JXtGI3W64oIGI6C5Q66t
         Nv6VLrsQbnSWOR2s7ftPRkzPNRNnG+XXK5vMrvRVAuv4L9g1ivdmZl7ULUDU8slIdzjx
         N3o5MrYCgNaFlbehEE5sRl1RV2cWy1MdBUYJfU+t8VmJZi3iyXpVNsHl93HSluR/XYb3
         +2smNcmmOIp5vLm9Ob4kA+kX3jcchVMRKQtAcBTaSg5gJTOuCAe4W3lm06gZdaaNj070
         VA3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787218842; x=1787823642;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yBtmafbOayxaPZWLoQ+wO4hHf1gY8nYnCw9TiJ7qd/c=;
        b=pE4pyhPG5m389TrRIf1wj4/u2ts+mhBH/q1KCYxwXMgvTEeAsjLFRyjCnDstbXLKpA
         wUyZDPJvmgEh51gzt3YaZjHPX7POuFIT/EDQQ7dUQmkjMKwxL0XHwYxzHR5iRLvpQLKY
         OpIOixMQVAMhjwSCFoo177ER2Ab3g3k5YrOe8Y8G+w9H03u+o7iPhiQIKTKwFFxBawbp
         zEFKDjyX6W/TcUhb1LhlrRLELLWu9eyg2vDIu9qUPoe+hfy3ow26KcWZCEsluXDMHwq5
         6+hfXuSUH5ugYZVkwzediEDkReN3bQIp21NlOU435jrQPzUpHuocmOTNQGnTroWYjnNA
         qJFQ==
X-Forwarded-Encrypted: i=1; AHgh+RovGDOHxdSv2jQW7EH56k6H1ExIgbZYwhNTzvQDqJDnIksuuIEKxtmBA/MKlYbMUevDYOW0kNwc@vger.kernel.org
X-Gm-Message-State: AOJu0YxhzSfx6HJaEPUWtSZctX8SrWAaMJriz+xmYoWhDqg5BuvXkTLD
	btvMUSOBwXRRXZkTWF1fl8XTOCN7do92n2psEGKvEQ7lX25ahKrwERAPqJsllbPJbvuA9JB+iN2
	SIVCx0nHezm8GZkf4wN1jO6c+uAxW2AU=
X-Gm-Gg: AR+sD12kvt/1tvjexCjydnEFuu7UoaPTWJOIfZpZNoU+ymOYqOrmmjRWhFirrohoWCB
	0mMTowFjalDpaD6nbI/2XUCH8w1f7JIvzUbKT32UtVRPvagb+Ax32Ijhbryn7Oj5fVuttmJf7aC
	w0eMi8V1c7coAME6phh7yv4Rw2TulpB/4NxzSE9lIfPkeM+PO1vbhydiEeBUyQAkSyqdBhL1EHD
	IJ1+D0KrslkZMQUNg6hJimtkQl1upuClmyse2UVX6/pKLYy7sp9oNlCpAAi+6Ol43vRcYkxAhas
	skDBRH0XRU5veAXvg4v2rZIQAuDRBUfSCgZ1p72FVU8ie4ZaRXCW64JOMMCiOwd4u9vXpn1w3VK
	H
X-Received: by 2002:a17:907:3ea8:b0:c21:3fa7:5a6f with SMTP id
 a640c23a62f3a-c242e3eadf0mr738216466b.24.1787218841867; Thu, 20 Aug 2026
 02:40:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-6-8dbbdac0d28c@tencent.com>
 <5db7dbfe-ec22-4a25-a85d-497e6ed1f8b1@linux.alibaba.com> <CAMgjq7Bz5Kz0YxFcVwbWV4bh_T4qQH0vZYbxFCXDtLzeX5hjtQ@mail.gmail.com>
 <43bbc1de-039d-422d-9119-c7392e0229c6@linux.alibaba.com>
In-Reply-To: <43bbc1de-039d-422d-9119-c7392e0229c6@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 20 Aug 2026 17:40:04 +0800
X-Gm-Features: AcwNN1VA46_KpTMs79ty-j9XeTd7zcF2C5_Wk1dEwysbQv0vrgYxQy3Z5NAPDZQ
Message-ID: <CAMgjq7DiEYvURA_jykn=s20mr-cOAtJcmdau+byJ_qX_+-YqXg@mail.gmail.com>
Subject: Re: [PATCH 6/7] mm/mglru: fix potential generation folio number leak
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 20, 2026 at 4:53=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> On 8/20/26 11:45 AM, Kairui Song wrote:
> > On Thu, Aug 20, 2026 at 9:52=E2=80=AFAM Baolin Wang
> > <baolin.wang@linux.alibaba.com> wrote:
> >> On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
> >>> From: Kairui Song <kasong@tencent.com>
> >>>
> >>> Each generation of MGLRU accounts anon and file folio numbers
> >>> separately. The page table walker's update_batch_size() derives the
> >>> anon / file type of a folio from its current flags, but the page tabl=
e
> >>> walk holds neither the lruvec lock nor the folio lock, so the type ca=
n
> >>> change during that period.
> >>
> >> Right.
> >>
> >>> MADV_FREE's lazyfree path clears PG_swapbacked under the lruvec lock,
> >>> so the folio is no longer considered on the anon LRU list. Lazyfreed
> >>> folios can also be changed back to the anon list again. If the flip
> >>> lands between folio_update_gen()'s cmpxchg and the type read in
> >>> update_batch_size(), the batched delta pair is applied to the wrong
> >>> type. The anon and file generation counters then carry phantom deltas
> >>> that nothing reconciles, permanently skewing lrugen->nr_pages and the
> >>> reclaim budgets derived from it.
> >>
> >> But I think the problem occurs between update_batch_size() and
> >> sort_folio(). update_batch_size() only updates the anon or file folio
> >> statistics, while sort_folio() moves promoted folios to the
> >> corresponding type's list:
> >>
> >> /* promoted */
> >> if (gen !=3D lru_gen_from_seq(lrugen->min_seq[type])) {
> >>          list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
> >>          return true;
> >> }
> >>
> >> If the folio's anon/file type changes between these two steps (e.g., a
> >> lazyfree folio), it would lead to what you described: "The anon and fi=
le
> >> generation counters then carry phantom deltas that nothing reconciles,
> >> permanently skewing lrugen->nr_pages and the reclaim budgets derived
> >> from it."
> >
> > Actually no, the counters follow eventual consistency (note the word
> > "permanently"), we are fine with a drift as long as it will eventually
> > be corrected. Lazy promotions creates counter drift from the physical
> > location, but that is actually fixed by the sort_folio.
> >
> > Now, for the type issue, use the lazyfree case as example (I think
> > that's actually the only place,), lru_lazyfree will remove the folio
> > form lruvec before marking it !PG_swapbacked, so during that removal
> > period, the gen bits are zero (folio's gen =3D=3D -1), so any lazy
> > promotion CAS won't touch the counter, and only folio_update_gen will
> > do it since folio_inc_gen only handles on list folios. The
> > PG_swapbacked clearing in lazyfree only happens on folio wich has gen
> > =3D=3D -1 (off-list). And it makes sense since update PG_swapbacked nee=
d
> > to update the counter and move the folio.
> >
> > And if the CAS happends before the list removal, the list removal, the
> > folio is on the anon list, so the CAS is moving a folio in the anon
> > list, folio_update_gen will call update_batch_size asking it to update
> > the anon counters, we are fine after this commit. (Before this commit,
> > the CAS is moving a folio in the anon list but update_batch_size may
> > occur on file coutners). The list removal will update the anon
> > counter, and the subsequent list addition will account for the right
> > file counter.
> >
> > And if the CAS happens after the list add, we are still fine since the
> > file counter is charged and sees a file type here.
>
> Thanks for the expalnation. Now I see the problem and I think your are
> right.
>
> (This involves the combination of the gen counter and the folio's type,
> so it would be better to have a diagram describing the race, otherwise
> it's indeed hard to follow.)

Thanks for the confirmation, I'll try my best but that's hard to
describe :(, will also try send a proper cleanup later maybe also
clean up and merge PG_lru if doable to make the convention cleaner.
