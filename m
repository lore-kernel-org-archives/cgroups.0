Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B4642C518
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 09:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787133005; cv=pass; b=AmXM7rNt7K6dHD5UtOaGJT0ZdAe/SjnFiPMAEjPnHswuMRxlQsp1Yilx41NL15r4ND1fFnMClYof4yoQOO/+0oYWjBdPyBC98+ZZy4zTlI8TCwk19dk5bI3TirvPmdh3/xSAjSvK9QD0K/Pu0nlA1TvY5iyhxRospClscwlzLKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787133005; c=relaxed/simple;
	bh=8g+Nqm06NdGIqd54ihXRC9kVcIvwEk/wAaFjG/2HcFo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dnubxMGxpc48x57xARKcfo25Q92Yp9cuZcySr5d9hufQ2y3nCHJm2ELub9btf/R3+cn2IPvykUixJvqwIsfI/TZKmD0ME6UxSlPJtV9SkoQz7u60SlamkpqY7LKUaUSBvJk+u0BaEwDDz9//Fjv0Of0qcTv9FGED4Pt6XWq43Uo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=huG5VzDW; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="huG5VzDW"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c169ae1cb26so365031766b.1
        for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 02:50:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787133002; cv=none;
        d=google.com; s=arc-20260327;
        b=aJ6KLx1Pv4YIYqEryxeLH7Q30HeU+ySeK+QrSDfGPtL8ZTB7+lcvadkqLsNa9hO2Lj
         VqsT4xZoDIK1sNwoI9v9tyvFHLKLv6XU2pl7EabgY1g6QISU5Sj4SQG7sw3uNnvxS9kM
         uBpJS8Khv2pWJZJQm7PNbERUvGinkYd0aGJw8igMr/wPVZ0dhkt8noUkpke2/pT7Ishc
         u2gUYI3HNVPl4cV7yv9MKY4zl+eMuxVXalCNhVxNH2seF5oswQlC2g5Ohyia3Oy9O7Xn
         y54oZ1zjw1xiJc2esFwalPKhVfNDAIR2X7smyAFhwuF06uclrOlYa8rEYRCuKh0E8PWt
         uZyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JYFAHLPwlY6ScFzK3+Wm2EDzKXa2eWFtHEeFKNFKOzM=;
        fh=oeX7J+C9igZJQbRkWG135ujuLk7pIA/LYWitrueE2r8=;
        b=W46ULlivPOJLK2K9pKXbIEsl6ckl5Q0J83YJ+2kLK/Bmrp2mhoFe8kl2/cmI9J/lUD
         dfLtFBYZq8iKbRR8JHYl0VGEArCkYpiUxPmsUJykvPOzDaGyrmyr5kT88ENZMVOeOvMH
         S33RBPAhFowOTmfaww3kmL3VYHe5ygxnd43Hgkhrw2xIGW7tAKzhUv68fRCD0R7Si1hd
         EfzZosEda2j8sWB1T2x92T0+qJDcpQp22cbQTNzvzQSkfQ833aZapJ/Vz4uPiTQtz47M
         dPspr/ca+GAlnvjLoMftXYbFy9eRj1Ox55clyaP36PiQlvsjA+rIvDPurQaCYLX+JoKt
         dlyg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787133002; x=1787737802; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JYFAHLPwlY6ScFzK3+Wm2EDzKXa2eWFtHEeFKNFKOzM=;
        b=huG5VzDWaEsIcTD+ooYLGHdK9ILEXyNpeyQDSl2l3FF+aqY54SolbfNAzCIdarh8k+
         ua12h47ajPyLi0tsgEdBQGXwJ/p4AwY93zJbVZwxGAlxlbGt4pCjh0KRLE4/avPmphTx
         D1/kFlMgZxPQPbW7RjYZYTnbWl7soxLofgr8ETtrB5Nz3b/rNxJLpGiYT6/+q9SYxp77
         T/rcUyupM3fx1Qvaqfl4Qr64iXR27NTkX0YTmtpqUW17F5npyMGkr+hwHb4EYPO5JN5B
         SL+ddUwNRlzm+Cl/qL3DQUMnrPifgjVUapADNmsWmLZhR+xJ5femQngfQr5i+U+r0GQX
         MZDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133002; x=1787737802;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JYFAHLPwlY6ScFzK3+Wm2EDzKXa2eWFtHEeFKNFKOzM=;
        b=pT6R28tA7QWWg+ZTcFFz8G0PAN8c3PRfcB5+Atdq63ZYv0qIPhb0XJ6h7YO/g+X+V5
         0cGS3vrZyTnFbqtL4vn5DYHUyJg99I7u87QBbNp+IsGtSp4MG2d+QqNWoPg1CTqjT8pX
         naFvEqsx3CwXus4LD3pBEIQnDx5HCW7L9UIwN9/lwuFhHMbYC+yNnuVXMYVKZ2r2UZOT
         0A18MVJjd2qoWpu3lzEAcsN7lZuiqAFBuEX7CgL7fShU+FhpmyGIbRJKJlSmDgiV+wbg
         k6T4zc+WaJ3GKVmzdyutodALSyIZd+2C/9bVif/FTvmUs6sFyzihq2cZSiEKGJHW9DYW
         IRIg==
X-Forwarded-Encrypted: i=1; AHgh+Rq5IYO7efEfVSooaUdm557fq/Q3Jd/9muOBpX/IRJRxeT0OreMiYygb3NUZ/f7r1Gj0ZVRJm9/+@vger.kernel.org
X-Gm-Message-State: AOJu0YzZjI+UTw3umIQCWxN6uJE4AcMPR2pyIrkK/wkK4atklbWDHSnJ
	KSX3v2bOz1JHhwcFr6E5e+E8s3ChKMqN6tA7Z+Xqs3LWbcozRxDk/S/fd+qbmUEPnsAKV2vBl/v
	5HNLkc7QYai9BKunA/1Ul0CpvyMq3qHQ=
X-Gm-Gg: AR+sD1052U8ASLw7mUgtIjyjbg49E6A8ZfxDmzjYONSA5JVFDJm9aqy0uDi+J0/Bhik
	Xwa+5kG1C2q6NGePx88LcNKblTKGEkf4Du0+u2BjAEE5Yid6n26IIXBXjyKYZmb0YkkUvVUNUvd
	eBNDaVTH5af6OFzkQelm5+nV33j0zTx9Q+SpcxOgQqbnZbpfHutyyM6Ykb57Qaei3xARYrx4zam
	rXoOvHWVlKbmvzAg8SZH0IczBjlRUFITLbNbMV1hVlVvV8tU8Om+XDJzLkKumnNfsFkXmd9Au7N
	U+yaFwZvIytpz83xalXBBAxOrnSGdUFUrFma81G2rjhx5KaExiz8481Z0KFaEjtOx7YyvTXftAF
	4boxlEbkkCpcDUQ==
X-Received: by 2002:a17:907:7b8f:b0:c12:8a:7d7b with SMTP id
 a640c23a62f3a-c237de42f5cmr223047966b.1.1787133002424; Wed, 19 Aug 2026
 02:50:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-2-8dbbdac0d28c@tencent.com>
 <167ad235-253b-4bfe-9b60-265262be34f8@linux.alibaba.com> <CAMgjq7A1nK5EiRvN-o1Lg_Q2+Ek7oj4Fnm1qAy5A=ULfLz+t+w@mail.gmail.com>
 <e143d790-fa3f-4b68-84e7-91199d8dbb54@linux.alibaba.com>
In-Reply-To: <e143d790-fa3f-4b68-84e7-91199d8dbb54@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 19 Aug 2026 17:49:25 +0800
X-Gm-Features: AcwNN1Xs-TTQ0U_BUnPy2CfQrpwZu5AEUHFSzTyLXWH--Hmcn3YTArEldekCBFU
Message-ID: <CAMgjq7At=z9dAJxM2MZcb0UKmVCfd+DRi9EbC3h0wYaUP-0wzg@mail.gmail.com>
Subject: Re: [PATCH 2/7] mm/mglru: introduce helpers for manipulating gen and
 refs flags
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

On Wed, Aug 19, 2026 at 5:46=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> On 8/19/26 5:37 PM, Kairui Song wrote:
> > On Wed, Aug 19, 2026 at 5:03=E2=80=AFPM Baolin Wang
> > <baolin.wang@linux.alibaba.com> wrote:
> >> On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
> >>> From: Kairui Song <kasong@tencent.com>
> >>>
> >>> Instead of doing bit ops on folio->flags.f, introduce helpers for
> >>> adjusting folio's refs and gen info, make the code easier to debug an=
d
> >>> understand.
> >>>
> >>> No functional change is intended: some combined atomic operations are
> >>> split into two, which only creates harmless transient states.
> >>>
> >>> Signed-off-by: Kairui Song <kasong@tencent.com>
> >>> ---
> >>
> >> Thanks for the cleanups. One comment below.
> >>
> >
> > Thanks for the review!
> >
> >>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> >>> index 94f9c3ff5416..32d9354a754f 100644
> >>> --- a/include/linux/mmzone.h
> >>> +++ b/include/linux/mmzone.h
> >>> @@ -496,7 +496,9 @@ enum lruvec_flags {
> >>>    #ifndef __GENERATING_BOUNDS_H
> >>>
> >>>    #define LRU_GEN_MASK                ((BIT(LRU_GEN_WIDTH) - 1) << L=
RU_GEN_PGOFF)
> >>> +#define LRU_GEN_MAX          (BIT(LRU_GEN_WIDTH - 1) - 1)
> >>
> >> There are still many places using MAX_NR_GENS to compare gen counters,
> >> so I'm concerned that introducing a new macro would make the use of th=
e
> >> max gen counter even more confusing.
> >
> > I think I'd like to get rid of all LRU_GEN_MASK and LRU_REFS_MASK
> > users, MAX_NR_GENS is fine I think? Manipulating the bitmask looks a
> > bit hard to follow for me since:
> >
> > set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
> > set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
> > set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, <number>);
> > set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_active));
> > set_mask_bits(&folio->flags.f, LRU_REFS_MASK, <number>);
> > new_flags =3D old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
> > new_flags |=3D ((gen + 1UL) << LRU_GEN_PGOFF) | BIT(PG_workingset);
> >
> > Things like this are everywhere and I found it really hard to follow
> > what is actually going on. And adding more operations to refs/gen
> > looks ugly and painful to do, and, it's impossible to add any sanity
> > check. With proper gen and refs helpers, we can ensure every time
> > gen/refs is modified, the value is valid (in debug builds).
>
> I agree LRU_GEN_MASK and LRU_REFS_MASK can be cleaned up further.
>
> >
> > Mean while, a "% MAX_NR_GENS" or "/ MIN_NR_GEN" seems not hard to under=
stand.
> >
> > Oh and this LRU_GEN_MAX is only used for sanity check for now.
>
> But my point is that people may not know when to use LRU_GEN_MAX vs.
> MAX_NR_GENS, since they seem to have the same semantics.

Right, I think let me just drop LRU_GEN_MAX then, there is no real
user, it's just sanity check macro.
