Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CBF2D949F
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 17:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788629523; cv=pass; b=ngwSJ4Zze5/JfNn1uD5ZbisdmMBJ2ErKCl1y7yZaZzf5cOqAWXFjJ6MgCQS5V9nZHu6DbYoa2SL0v0bz+6ZbX6NpWCIIN96RNMPzab5N8Bru+wjO8FkMuK93RlK/Eg0IyZ5EkNoomkKqDuV158LIrGvGSfBo/BFvLP/Q3sOYrns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788629523; c=relaxed/simple;
	bh=6SqWxQUNqkycziFg1GQ7wJboenSDKgNq2op/2w7iabM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o55cOocOp1XLT6KZx5worTPbZRz8Oij4j34rR1IO6LI/T7eoJ8ekDEWh3wyCAiXU3hwYmViDWPRE0/1IlrkFg1sgjqTHbv2jg23FhmDeUzNc8fmXb44TF2qk1fR6w4ZcO1GrSsCR9AvVeOWoox1ApCw3c5Ve9rnqx6jJLKXr5e4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=drax72qJ; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="drax72qJ"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c20e70a0962so262763266b.2
        for <cgroups@vger.kernel.org>; Sat, 05 Sep 2026 10:32:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788629520; cv=none;
        d=google.com; s=arc-20260327;
        b=pCh2FdVPvJuILNCtkBFt88SW3jKGSxurItLRCEvg6xqmF2jqUOgv1OjlBddTyuL4yF
         xDksbnVaq9cQKLrFjVudSC2hMDWCoHy6MBHFARZPdr31JymQnuIO0Pwm6XOr3RMwLRJO
         ISX9/dBDtktuwM7v287zP1wM2Vo8y+9qP4POZKCAbyTUcEXGhP4lIbJZKHeVamoyZJ4+
         uhXDrgAH3elAGs9tJuH3LYwWqbtTh/fbcTgy+kOH6yTGd908JdmOBL0LJWjhY5/ULRuV
         5XTxbKADWEoOEqheLkA5CWp00j3yk2jpZp6bnIne6tRoseqYB5XyzUNqgR2S+36xTrH0
         fBqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=JOW8XuwLJiAY2FOtXpU6W0erUZewcmKtXhsLrPUNiVE=;
        fh=eoy/vDAMfzakqEVbsUNtqNUu7PaHAfI1MQmvxuhFqMU=;
        b=iBE0br1lKSmXSv2OYZdPx9ZkNl2eKVPi7BPeBbhktSWqKWOsdJQcUcAPGvmgKigbq/
         qnYPM0gA5cNcs7dyHhIxsUtyYUySf0a79bzywvzD0TYJ3z3mundHld+bJwO6wdOqCh+y
         L0SIMOgTIofS4keLiITaejVtm/RrGOB6Nl4T6q+IP0JrpCn3juxdo1GIyUAFfaQlby+W
         J7hASqBdDpoBD2H/NyKHkbUssNx5OzQpU1TO84Dbr/geaUPaN+fSEaI5NLjPae9uWsmN
         t8fK27WBepeC/r0YAc3kSd/EznDeoQey5+bIdDIKdf3rnEO6bCjuAdT9UqaKXHAH6rQY
         uRKw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788629520; x=1789234320; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JOW8XuwLJiAY2FOtXpU6W0erUZewcmKtXhsLrPUNiVE=;
        b=drax72qJDld6goBKj+BAhYBiU++KNynPrfyhQH0fjgI+VHEaGX9fwmzK8cyG3xTsLJ
         lWVUmEVg5I5N1tq7rWFmBAHP9tLHXO4n+pQCIV87/ASCr8xrEQDqvvRTVYkPBgnGuM2B
         Rccdu/5lIIdipKPBH038dGgpqI44AVo4aTQ7gIOMoo9mNJyQJM4RC55f6oNlUYKr2Zkv
         Yu9Kpzapct8mdb6IcWk/wNoPjMu8pAy1awe4Zuc41O52kI6zlItDlwIPZRdzazbB4dvT
         I38cbuHVHHpCu4hWbIciTT2TUUyznFB1dXHJuuppt3vJg2LOjrf1EaxQ0FFHP3vnnG6y
         hy6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788629520; x=1789234320;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JOW8XuwLJiAY2FOtXpU6W0erUZewcmKtXhsLrPUNiVE=;
        b=HaGUaylwGl/8f/oKSEXLmyiH+fsiJK7v4ie1cwHdE788mSwaUja5oEIAKQCGomm4rh
         W5sFyUJD8VI737Mf8QYJtPNPN8gQggl2iGP5S9pDS34/UaPUqNElQGJPW/vlZ2MDBiJF
         F83CJdXPx0AIMvcotHIyoKoBvMU5JsKbzzFQkoeQhM1lriUzGgAARNXiLCfi9y2kxUmX
         K4sl6vXGpmyYXjkr59yUx9o8DynITT1FW8yLQ3MFGLXW3L5wDq0BHdDbFfoIZ+D0VDw8
         aaLgPrGb5bDMkNAyKmz/WXHoZZFZGFcIek9mYTy5ssl0rrfoRM5OFAvwYB6ZDYP9NvRS
         kgIw==
X-Forwarded-Encrypted: i=1; AKwUvBx+doFh41xpyVBZRy1D0dIkPxukB2h52x3Gihb2MWZxns0uZBWlpnTiALDkrVlOYgqA6ehTBc0F@vger.kernel.org
X-Gm-Message-State: AFuF++kAM0MctpWP2tsmzIEtuLt3ntoe/E//lY1GaEXwrKCrqkDGa0o6
	QPAqMnDxF2XzkvyfiadQBCXzc2h3C6fKkcIhVxrB2LD8NTV1miA3zZ9zBfvwcGvy7yS/AK2ZyWp
	1NWxCxLD9fdxmc3ZbGmrFCKkJmB0u92Q=
X-Gm-Gg: AYBFou0Ns5bBa2PEecyRHXvrFoh3+kbwaIjmyKwTnLqwLE1swcTyErDPYBezPukBfFX
	zM8UykkrF93L5d28QAyFnjJyrUb+tBj+O4Q8L+VAn0JsQ0Wr10QwjKaiTINdmAeM7Mm1M19CaaK
	OKJBNayvvNH6k07T75tfzQ+ZIdYSlaH6AadIRcUqffMV2p5NJDiUIcpcuQO+FNtz8zgV4B1YlfK
	m2wl9/POFS58pbfEtZR49QD8fw0WLkyZUriuZXuOHIoegIsdqQ+hfmoNNzECv3xLvdf0edfaug2
	rGs2VwDlsvdWMFuoLrSR57mklHlQxfJ9qS2bZi2TWQWvAT6zOyIt71XpKVNy90WiSFGCvUfPaxk
	Vy50=
X-Received: by 2002:a17:907:c16:b0:c25:2d27:5652 with SMTP id
 a640c23a62f3a-c260c9d1affmr910733066b.11.1788629519742; Sat, 05 Sep 2026
 10:31:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260906-mglru-flags-cleanup-v6-0-9aacbd77d4ca@tencent.com> <20260906-mglru-flags-cleanup-v6-2-9aacbd77d4ca@tencent.com>
In-Reply-To: <20260906-mglru-flags-cleanup-v6-2-9aacbd77d4ca@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 6 Sep 2026 01:31:22 +0800
X-Gm-Features: AcwNN1W6XiAA7KV5jUk181yU-Mg2q-AQY3I1lcI5rPzfroqnvUHhwkCK3HoP1Y0
Message-ID: <CAMgjq7DTmBQU4D95J2ur2CUYPohx1ychRV=vKvLjR78tNFJwOg@mail.gmail.com>
Subject: Re: [PATCH v6 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Sashiko reports (please ignore, false positive):

commit b3b2fc9d5285717c3d36754aee77477780b76245
Author: Kairui Song <kasong@tencent.com>

mm/mglru: introduce helpers for manipulating gen and refs flags

This commit introduces helpers for adjusting a folio's refs and generation
info instead of performing bit operations directly on folio flags. It
splits some combined atomic operations into two without intended functional
changes.

> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
[ ... ]
> @@ -270,7 +339,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
>   gen = lru_gen_from_seq(seq);
>   flags = (gen + 1UL) << LRU_GEN_PGOFF;
>   /* see the comment on MIN_NR_GENS about PG_active */
> - set_mask_bits(&folio->flags.f, LRU_GEN_MASK | BIT(PG_active), flags);
> + set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);

This isn't a bug introduced by this patch, but does lru_gen_add_folio()
fail to clear LRU_REFS_FLAGS when updating the LRU generation mask here?

When an isolated folio is added back to the LRU using lru_gen_add_folio(),
its generation is updated but the stale LRU_REFS_FLAGS are retained.
Stale tier bits can inflate access counts and severely distort eviction
decisions, defeating the purpose of the multi-gen LRU tier tracking.

===

As it said, it's not a bug introduced by this patch, and I don't think
it is an existing bug either, lru_gen_add_folio isn't suppose to clear
the refs flags, or we might under counted refs or workingset.
