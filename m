Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843DD374726
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 03:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787196205; cv=pass; b=fMuZiYw8mMlNdZvX4TWEFHkpiDSigukQwuB5FKfCfeEWbekUO4oY1Dd9IVEgPc3GYyFInlv1oUz8JIzL/nEVfnEJWEpScwvvo/A8eGQV5wwC0BKV1fj0znfdqKzVXeAAjaYhra2qFhgtIr+7vRQIY+tPgY90lthX+cZ4LZI65dA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787196205; c=relaxed/simple;
	bh=lTKYawY4FhFxs7+6HfszcGLFpA/7x6z49ywwelgjzvY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rIJ/VQGFhfRcEsaRT53drwNELJuqmJtnWI2XYXDibp/YD424uxem9MCocH/h0c+UTzWaPmMM20VezdeDum+HwWEKGLuAMVALddC+YfdRL5+v/mJ5SSq2iJayeUS5CdYYKDIRJssvR8DoNQrGqvcSYtEriG7bM0a4nh+OZLudNJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G/rC1Umq; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G/rC1Umq"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c169ae1cb26so105074066b.1
        for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 20:23:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787196203; cv=none;
        d=google.com; s=arc-20260327;
        b=sgPOvaxQYk5RgM1nfmixOhrcPLtEuyjXiSFs+L99M98gnN8M252jTejivbLPn2405O
         8QEJIpYsziWQBYcvRz7zwPLH01esWLKXqYRVc0b8ltNaS/itMUrNUxxV1WwwAhLFm13u
         MxDgBT84Ivixyrm+VBl8rdkSSZxRvxTbKpfnKrkNbwguIhj87TKS5S/K+f/BR82wq3MI
         0HJ4D1WpCDCy0/VNr5CnqkhnIo1UD1icbROTHj6VhjJZCbh8yz2pDn2pnsIWvGA2jpLp
         e0AzYY7gECGXwMOsU2DXOQwwqkzl78Z9rjfk8jTj8+OzdICUU9ITLx2OP0kcPJBZvBiE
         RK+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NaO+/BiFdeJlDm8qbSuChFr4r9AeOPUCQhHHi+406fk=;
        fh=XAFAOhxNJnkf/NELmhYZgHx2LvKaCQbgoVo90OEPjIM=;
        b=evSrSZyy1rBr0nnp+ROfxqW5xEk6h4mVlw5kSPOHMlAEHGFFqxmem4Yb2/Aho+gAZB
         Swu3PpBEZRWrexs5PSZd8gvT8ODL9sEibcxGY1KPO3mBQ6deEg/yvUUvEc/IpQY09o/o
         Dn/SYvcKu+k3c2wSVAXNV90SHG0B6kSbdxE1kEXujF+NiHpCQzJEMQ2fLleg+VjnNg4f
         d2M5fW7nYZFb5L0RlroZ5G3vMftMN3oUtwugUs9c7zuPIz6fArFo4VehSmHAWRQB9irJ
         zMQieVr5hxO9DOAwnWA1wFWmWrl7PnFJxosHkUAay1O5jFd2D7vZj37agH9iWJ3DdoSc
         obsA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787196203; x=1787801003; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NaO+/BiFdeJlDm8qbSuChFr4r9AeOPUCQhHHi+406fk=;
        b=G/rC1UmqEo8/vknEAFesBTHTrnj4eUj7/ZC8yqPwyPCRk1kwlzEKffnSQRRu+Ugl6A
         SZ3Dfg6tYggsvJUFLRZTBdr6yZKSJUKoE4Gc7UU6CYfg6cLeaLvxU03jlZJGLQJ/bcwr
         UH5v8NNDz3kwqoxDuJbbgLO8S7tc6Dfht9fKusJcV6n/D7YwKBgXFPzwEDpgvlpWklBQ
         b0lZ5RzJS01i7+8GTAxg3PnMipXQHy8iHoU8gmiW4QqkMJ0iEhww27GvHGAokvOJuAJ0
         BR7/i/47SSsp+uzsYvm/OVlTWiedcWIQEJhd0eBxdYZB6MfU4qsKHth8/8xLt6MhCi8U
         1t8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787196203; x=1787801003;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NaO+/BiFdeJlDm8qbSuChFr4r9AeOPUCQhHHi+406fk=;
        b=Bc8e6Qu42GtCHzqFDVJrUYobba572gZsMl1xFMRuhjU+9j0/PGOieg2KXMg2WnHCqZ
         Nssmc9A5dw/y1H+9DAQi5CWi7pKBQbMnDTTQ81h6EPGbrU8GHJxD5W9GekMwm/kxxTOb
         jSa7gQsdt0mBK3n2Y3Dv2H0dYtcrqDvOrXn3NRMwbnFZHvyYFlIE8nQaQjCou+EJOKqK
         +JE3itNUwj/03EGuQQkPjEZ3Szd0IWZHMHWhvnXubt1AVDKI8k1ZkYP5M0fpyTNdcDnq
         lJs0xIxToVhhEI++7V8WKKP7qntScTSQyB2BBVfo0QsvUqSDOeCa66ZpxffZU5o7hEb4
         r2Kg==
X-Forwarded-Encrypted: i=1; AHgh+Ror7AhnGAVT6c/4f2rV2bDrWh7PPJlmk8AYk1sa84hhbcLTG8H156rBU9tB241Toop1diZM9Iac@vger.kernel.org
X-Gm-Message-State: AOJu0YxOjCg7+NRLpaOI5ynAD/yhJidAlUeMDVW7n9tqrlhV106I1Zxv
	+VZnwJwa9D+fEwkJayHy4OoGeieTCe5BDqU8agDHWlukHXI74+mlZW5JC10FAOn6GZHD7aS09dZ
	QBghJp1ben8EoamS7R+nkl+wiB9zCr8I=
X-Gm-Gg: AR+sD10MbgKQel4+juajHKVbPB4vd0//aRNh83sTQBTOtaNpEfCjmfNzD37z1iQ8Pyx
	F+V4yqVMsZNU7WqlYRTVhvHsNYftzUuYGRQsv7VmL2AHKAPGacU1cGvrSPdTXg2y5Y45rksRpZy
	JYYyb3SWtJdIddGVynlbTmtWW27ym4LMsFtYaM8MuhVrFFd88c2Tdpot99Iu9+0H3POyUl5FtUg
	Ws0ClEsVAyRwhFMHPg2RrJ4nfqyDIrL32AyXTaCdA8Kn37iIWDo87tnxGYOF8tzvBWI7/yTuA5b
	Rh/S421cPoL77r6uNq7CVp12Qzl28tc0cXAa/K13N3xVNpSvBTbT2YnaxPQpNWACuLPBl1GDq8M
	q
X-Received: by 2002:a17:907:d1b:b0:c20:a243:9a52 with SMTP id
 a640c23a62f3a-c244cf04a75mr196665566b.0.1787196202653; Wed, 19 Aug 2026
 20:23:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-5-8dbbdac0d28c@tencent.com> <959366ca-4a7d-40db-8f56-0a35580dd971@linux.dev>
In-Reply-To: <959366ca-4a7d-40db-8f56-0a35580dd971@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 20 Aug 2026 11:22:45 +0800
X-Gm-Features: AcwNN1WCT__niubxoW2MM5CPEOnCDEew3ZBP0LgkE-Yxva-umwbqX3qWyGq0Udk
Message-ID: <CAMgjq7DOAazz98uM+qXqgka2Y6ZzshjBnQ1N5TJ7=gCR6FttBQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] mm/mglru: use explicit tier range in read_ctrl_pos()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 20, 2026 at 10:34=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev=
> wrote:
> On 8/18/2026 1:38 PM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > read_ctrl_pos() encodes the tier range in a single "tier" parameter
> > via "tier % MAX_NR_TIERS" as the start and "min(tier, MAX_NR_TIERS-1)"
> > as the end. This is hard to follow, maintain, or extend. Tier values
> > 0..3 select a single tier, while tier =3D=3D MAX_NR_TIERS selects the
> > full range.
> >
> > Replace it with explicit (tier_min, tier_max) parameters using a
> > closed [tier_min, tier_max] interval, and add LRU_TIER_MIN and
> > LRU_TIER_MAX for the tier bounds. The call sites now become
> > self-documenting:
> >
> >    - get_tier_idx:   (LRU_TIER_MIN, LRU_TIER_MIN) for the first tier,
> >                      (tier, tier) for each subsequent tier
> >    - get_type_to_scan: (LRU_TIER_MIN, LRU_TIER_MAX) for the full range
> >
> > No functional change.
> >
>
> Just like LRU_GEN_MAX and MAX_NR_GENS issue.
> Why do we have to add LRU_TIER_MAX, can we just use [tier_min, MAX_NR_TIE=
RS)?
>

I did that previously, but reviewer suggested LRU_TIER_MAX, :D

I'm fine either way, it's really trivial.
