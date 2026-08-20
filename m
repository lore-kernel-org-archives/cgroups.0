Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6044A18DB2A
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 03:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787197599; cv=pass; b=fssQFk2Z6/goX2HrDmw2sZjMFVL0Vhsi17PLNPPx4e0K2SyLvZnEQbCA7aSIiWoPl99z5pcHb//BoUqjwZpAkBiVaQKJHTFXCEDCBonWQYbs4ej2Vn8bo7/OI25Scot+N11NkMC5MDkeKeH810L65IdcAtYh0M4j3nrwxjtHRaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787197599; c=relaxed/simple;
	bh=jPOYo4tGUzzo2c7GtQONFKrQdV1HgGAZBhYQofY6kyE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ddJfgoU5rP5bcPZTBr6W2xca/0wyiy2+H1uF3JSyCDe0f3dQXMWehOH6KvWIF8gnMR3/Fa1IOiNjms+AddejgZtuX9nxBax8dDBMX1nCHLEXz9UqWazdiqUUC4mZja0SjDr9tW/4LRJj3Hd2bc5HEZELsW2VSOXeqLj2BdRRR3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YGIP/ZP4; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YGIP/ZP4"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-69f7fa1c548so3077600a12.2
        for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 20:46:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787197595; cv=none;
        d=google.com; s=arc-20260327;
        b=d3UgNJOt08yPHh5qvuwgf4nYXpfJA3gSwZsIH4okWUCct3Qma8DnSD6O4CoSE1jUhX
         9ToIA37ZnIyyg6NTNemg9uhBlUN7RkSJxjdp0AjXCFvbWc9vPT4wVvaOqYOkgOwkIY/w
         mMTNjxpgkuT1vGbvfs1Mjt7IklMzyHVgvmjt7Sq/RhxFJMsjCiKrAQv9GG9U+8TB+3Eh
         EeUZ9u0m1hcO1kDJfeffzQgB1atOrdNFpNKfIWgP9uWARjL/Qj5wQpnZonsXwE20P+RG
         Y0KT50P8wfR0mYl/x9bLC0vh2PJcHXlWynNS3pMtquNT9VS3rBQq/O2eEbVvgwrAATB0
         CT+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jC8fCaKvIcrP9K//y/TQg06sbF5Whw3fEjhEvbmxngs=;
        fh=7HQBG4gTQpdFluurP9GJJE0ruzeDArFYupSb9hcQhiU=;
        b=afZ+xMgtGdrMTftjil5MMv04h5P5Jt5di2vavU+GQAmF4QyTPJJFOpibMa/e7MTiVn
         IFXs9KierAKx+M6XYLOGZ5YJ82qP+M0bGz2G4wIHrEEVg/3UcqUnX/agHL8NxbtM283f
         b4cjvtbHysal7O9PoTj5Ec3UOr8+J1/kghjH9OwQmkXcXYNQgHMdXyA61ezHiugEq+Na
         B7bscQ8e2c68sARQrhXkw6WfvvmaT+GL3jveYfaQL2WCjEXBCQ4eiqisW7c8V9zS4ZCl
         jWickbeyeQQCsQuQfe7X/0qptkvjfGKFBy2e5FnHTDCVc10YeY0FhN48k0rFa5GwV49Y
         4MOA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787197595; x=1787802395; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jC8fCaKvIcrP9K//y/TQg06sbF5Whw3fEjhEvbmxngs=;
        b=YGIP/ZP4nA9v8DO/dVEQLvAdehhyCF9RL45q8zibuTZFstRTIfOmtygAf5++JmK8zE
         cYn/d48FY2BJh1QhLl1qcftgcHgxKNKbPrvpk+a8THxhlpJ/SRwmdDXJcIDfrGD2kbA7
         5nEHH88yVX4HlYOXROTRugTtWwAXSYrJEXQh2+CMavXBth8fwdvFZsNysM3aW036CJCN
         ZOGK9J/b06jdirlbKECTEM6U5tb4id7Bm35Vf8hzFQzMh1aPV79sXD2BpRsctU2/Ra86
         OACr3+IDbtbtDcxE65ERFUW7u95TuzErMECNs2NHks1oIeCvrl4gDIaHMBvltyUL0nf/
         cqog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787197595; x=1787802395;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jC8fCaKvIcrP9K//y/TQg06sbF5Whw3fEjhEvbmxngs=;
        b=CRUUSyBn6p3aMrPESoAaW82DX2rHqvWgn4MQfZnuKJsGaNRqyoe+i2yAIRn5tMeNFe
         t9J6WRxKdExysp1grPrY90rHzCGtj4R6rcJjCnsTlu0c+d+bHMpEgLPfc0uHgr+wm9by
         joGWpJUYZM02N8NB/1Uq31x4WG+6732ttB0r+BP062nM1cejNM9ozpVuY+QI2SYZVYmR
         9Kk27zmePscKE7u5WeS5v0qMUqXFYDyRt32GzfAFCdYqu0rvt63+ivbCqijT/sw3xdtC
         qtm+QRKZCHGkwInHAndLJvUUb9VaMazAkwj8ZFe8jW+J5ZEnFkfEheG6gWWmGXnS3TwO
         DcGg==
X-Forwarded-Encrypted: i=1; AHgh+RoLP2OBsTJg8O3f+ZFQRPZF+xOy9KVK+5zwgEtBRje1iuqSYvTGLJFiwJ2gukWXzSVPXpLxgxBV@vger.kernel.org
X-Gm-Message-State: AOJu0YyKu+W/7Zc9IWs97igwiddcPXnpyYHBekiNBvTg+qMRfODlGuNG
	wjgQutlyXEZNVPzHyQz+4ezj6jnMqKLGIvYfZyQud1GTm4pL1URBwcXfLoqRueLvQH5hEQyRNjp
	sgLA3rakm6g7tpmhsn4YK+vyDPFhYNueaavTYGjk=
X-Gm-Gg: AR+sD137mRcih2+mBxvP55QcJjTRgLMunwDDgfjwHLk6wZCpxWXffltYhgMabWyO2cc
	h1fNi90aRAWHkx2JUJB0Q3xqcMP1pWd07s+l4Db+CoqsNU3VCtFT+IZONtQ244UtcQuupn3BSHB
	34suQ4gVHhypg4r2OMO0UTxJloJKl1UPUJEWXN30GK7K1WNGtKI56q6N1vMKx2IVnUZ5eAkAmad
	DXnFnc8OhlyPF8CNYOz1NgQ75sXGfGJ80DfYHf+iJp2KQIXJ19d5VkqNrvHr7ghscor7TF2ZNMJ
	dTsBUBmO74hZlqC21JpI3+gk7dUvqQ+1lNzTUOniGb8komEMjCSmn+6ibt5ElAb1951eeHplfYM
	6
X-Received: by 2002:a17:907:3e8a:b0:c20:f871:1018 with SMTP id
 a640c23a62f3a-c242e3f1f87mr631019766b.21.1787197595256; Wed, 19 Aug 2026
 20:46:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-6-8dbbdac0d28c@tencent.com> <5db7dbfe-ec22-4a25-a85d-497e6ed1f8b1@linux.alibaba.com>
In-Reply-To: <5db7dbfe-ec22-4a25-a85d-497e6ed1f8b1@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 20 Aug 2026 11:45:57 +0800
X-Gm-Features: AcwNN1XL5ZeMYmgyzc-pNkBGMiqarLr5xzciKiSSwUAgpFOLuAjN7e42AmOrbIA
Message-ID: <CAMgjq7Bz5Kz0YxFcVwbWV4bh_T4qQH0vZYbxFCXDtLzeX5hjtQ@mail.gmail.com>
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

On Thu, Aug 20, 2026 at 9:52=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Each generation of MGLRU accounts anon and file folio numbers
> > separately. The page table walker's update_batch_size() derives the
> > anon / file type of a folio from its current flags, but the page table
> > walk holds neither the lruvec lock nor the folio lock, so the type can
> > change during that period.
>
> Right.
>
> > MADV_FREE's lazyfree path clears PG_swapbacked under the lruvec lock,
> > so the folio is no longer considered on the anon LRU list. Lazyfreed
> > folios can also be changed back to the anon list again. If the flip
> > lands between folio_update_gen()'s cmpxchg and the type read in
> > update_batch_size(), the batched delta pair is applied to the wrong
> > type. The anon and file generation counters then carry phantom deltas
> > that nothing reconciles, permanently skewing lrugen->nr_pages and the
> > reclaim budgets derived from it.
>
> But I think the problem occurs between update_batch_size() and
> sort_folio(). update_batch_size() only updates the anon or file folio
> statistics, while sort_folio() moves promoted folios to the
> corresponding type's list:
>
> /* promoted */
> if (gen !=3D lru_gen_from_seq(lrugen->min_seq[type])) {
>         list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
>         return true;
> }
>
> If the folio's anon/file type changes between these two steps (e.g., a
> lazyfree folio), it would lead to what you described: "The anon and file
> generation counters then carry phantom deltas that nothing reconciles,
> permanently skewing lrugen->nr_pages and the reclaim budgets derived
> from it."

Actually no, the counters follow eventual consistency (note the word
"permanently"), we are fine with a drift as long as it will eventually
be corrected. Lazy promotions creates counter drift from the physical
location, but that is actually fixed by the sort_folio.

Now, for the type issue, use the lazyfree case as example (I think
that's actually the only place,), lru_lazyfree will remove the folio
form lruvec before marking it !PG_swapbacked, so during that removal
period, the gen bits are zero (folio's gen =3D=3D -1), so any lazy
promotion CAS won't touch the counter, and only folio_update_gen will
do it since folio_inc_gen only handles on list folios. The
PG_swapbacked clearing in lazyfree only happens on folio wich has gen
=3D=3D -1 (off-list). And it makes sense since update PG_swapbacked need
to update the counter and move the folio.

And if the CAS happends before the list removal, the list removal, the
folio is on the anon list, so the CAS is moving a folio in the anon
list, folio_update_gen will call update_batch_size asking it to update
the anon counters, we are fine after this commit. (Before this commit,
the CAS is moving a folio in the anon list but update_batch_size may
occur on file coutners). The list removal will update the anon
counter, and the subsequent list addition will account for the right
file counter.

And if the CAS happens after the list add, we are still fine since the
file counter is charged and sees a file type here.

>
> If you agree that this is where the problem lies, I don't see a good way
> to fix it, since the state of a lazyfree folio can change between
> update_batch_size() and sort_folio().

That's the tricky part and I struggled a lot with it since MGLRU-FG
will rely on this kind of lazy promotion very aggressively :)

I plan to do a proper cleanup of MGLRU's gen bits and PG_lru flag, and
introduce a cleaner convention later for all of this, and I think
maybe PG_lru can be merged with the GEN bits. But for now we are still
fine. The CAS change always explicitly checks for gen > 0: so as long
as we don't touch PG_swapbacked for gen >=3D 0 folios, we are fine. So
far every user is following this. We can fix that if an offending user
appears, and it's not hard to add a sanity check to catch
folio_clear/set_swapbacked that happens for gen >=3D 0 folios (maybe
check PG_lru too).

>
> A simple approach would be to skip checking the access flag for lazyfree
> folios during the page table walk, and let shrink_folio_list()
> reactivate accessed lazyfree folios instead. What do you think?

The thing is it can go from !PG_swapbacked to PG_swapbacked, or
PG_swapbacked to !PG_swapbacked. Or maybe lazy free isn't set the
moment you look at it but it got set the next moment?
