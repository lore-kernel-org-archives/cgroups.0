Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167FB370AF8
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 21:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787175070; cv=none; b=TRu49fIPAGr72MgMH7+EnICL988q0Kpz7zMwDb5qU4m6o48kxuO9SI2wZgF1QdtLBpD3LnR7lg+zrVx9piBQJxLU1ErqcoOpADNBIf8C09wU2R3qtR/R1YgrPPAnVnNIKlC1Ri6oPDFdqkuvF2NIP2h/uY+flAcef4xUDgiFCTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787175070; c=relaxed/simple;
	bh=ghs6iPSRrZGeJwUGIyYt5eVaUbmSLLAA1KH//Wk5utk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ba7dVFFDq0WrS1pEA3rmWxjqMIRsYma1LmqfmDECaEYo/wchHqrnbvgNhid2DjqCIB3GBHUf3hq0/dm7wEyFdQydYbYVdasetoma+ewJLYTdywKTS7A+QmD/V8cKmEznL4hN6tOiRtlBLTqEN7NEKQzxwRCBKfiXvOJygyO0kfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BYQfE0qB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BYQfE0qB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9771F00ADE
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 21:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787175067;
	bh=ghs6iPSRrZGeJwUGIyYt5eVaUbmSLLAA1KH//Wk5utk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BYQfE0qBn6RQTOJEi/H5ED7wk4DSJu3aU94pOT1Ga3wT9ZlVjFXZz66cHn/I6HI6U
	 gXkI80jZOhcbS8ofV9XsokHHtoW6uK5HUpY+WeC+3clBY5wAd/SP38zgm9C/0o0O8e
	 zhkVBzKH3CbLe9ZQgK+JfaIGSbG47BlPa58qgl6EmMCbBfp6j6d+3ckmn2h0TxXRiv
	 r2kM2SeSfWg91KwMSWTothUM68f6KEbl7atEnG5y3bW8ypnzzJ2jxqInVGZs+vKvT+
	 eQnk3S0AeDx6HynmdtoB8lq1KdAmFkOJaw5Ai4CPzw/hG3nP1+3hMCMKfb2bcsDEG+
	 R3K70Ysw19s4A==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-9349ad9c857so148453785a.1
        for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 14:31:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpUHQGnE8TDNzDhnpVC6SIK09YQPybeuPTbXgR9E/c/9qn/bc3mZM27AMN8DofUPin+pENf44US@vger.kernel.org
X-Gm-Message-State: AOJu0YyWImGbrM7UXKOjGvZ4GtTs0OVtyaPpzZVFmfZ2psarPrWbuNqK
	EoEERDgBJLVBYe8M4Ufvm+GPHPnPdLLLC/pEiMsNZtHmWQxbk1zhcqPg/r3DSDmIvRzneTTMFqO
	oDk3bFB6w1aUduwSZoIHv8+BS3FVIgu8=
X-Received: by 2002:a05:620a:404a:b0:932:d9c4:3bec with SMTP id
 af79cd13be357-9371e74b03cmr764971685a.38.1787175067210; Wed, 19 Aug 2026
 14:31:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com> <20260818-mglru-flags-cleanup-v1-7-8dbbdac0d28c@tencent.com>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-7-8dbbdac0d28c@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 20 Aug 2026 05:30:55 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zNZLOs_w1XazV471d66BVaNq9bVj5=2ZjT2u_NX=XmAg@mail.gmail.com>
X-Gm-Features: AcwNN1WZoGwAs-dfgWVX34j6qNueiuUcgi24sPh1f1Z4XRF1e7IHP_M-JHHISY4
Message-ID: <CAGsJ_4zNZLOs_w1XazV471d66BVaNq9bVj5=2ZjT2u_NX=XmAg@mail.gmail.com>
Subject: Re: [PATCH 7/7] mm/mglru: improve code readability and harden folio_inc_gen
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 1:38=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> The helper should never be called for an off-list folio, and it always
> expects the folio to be in the oldest generation before doing any

I'm really not sure whether that's true. Could the folios have been
found to be young more than once during the last two or three (or more)
aging cycles?

> cmpxchg. Add a sanity check for the off-list case: if it is ever
> violated, bail out and keep the folio flags untouched to minimize the
> damage, instead of silently treating the folio as if it were in the
> oldest generation and promoting it updating the flags to an unexpected
> status.

My printk shows that a folio can be promoted two or three times.
If a folio is promoted too many times, is that the cold/hot inversion
you are trying to fix?

>
> Also rename the variables to clearly distinguish the folio's current
> gen from the oldest gen.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Best Regards
Barry
