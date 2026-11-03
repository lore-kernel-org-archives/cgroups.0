Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793730540;
	b=vDOkKZgnJKsvIi5E+NnR46AznxL+PSnbBpHbZDuY25e52GsYOx+Ek5C/C/NzxEGJbFyi
	 e0c72rY5CLEY9mAGkBQprS91k3t11HDJfEh/9PazoWYALKKXJcSKBoLpDmhqOJdTvB2WJ
	 6ps8AZ0uTDTnF5gktv4crifD7cBaM9SXhWHwZDsZP9ZACQunqZHJsVr/i2XNiW6/4uR/G
	 WJRnpqCrc5zN+8W4nMfoNK4SU+0dXZ9Qx7eWZa9tKX1cK0GHqCseM8CA3j9vzAxshwBp7
	 ujPcOrtE5UfS2MtF8e1D5UXGfsSR1JMENlOEF2qbsdjoek3OBUZmTOglvSQDOkFs7aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793730540;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=A2SxbtdInviKmhuZ6qhITPKihTTKCU8zqlv1zCWXFFY=;
	b=IA/6HzXGMHHxnD0LwO+dNuEXe4kk+ax/MVmNrb02risZQxtEVstVAJmw7kPONFV9ER9r
	 NT5lBfLFUNUdRG+24yiMVmYAgRKg9o2swL7uLOXFDg4drms8rNMB5CBix3LowPuWHEwQe
	 WsieerBapvLCmtRFk76ErBALjQqVfiKZKHNMS50xhKGcuDxLi3VQnJlCioPBjzLhATgpH
	 G38KBhLX8PuX1XOoq98xPoeSS7bBYqMO/V42qZbzfJhX/ApwpjIaDZzUXEUY0ylEQo59z
	 ddFf1hF1z18uaenXOKLcPL0elflWt0+rjQJklCbcga/bQxqbdrPWCdvMnWEmtLEKhcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DDktR5oa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DC4606A326
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 18:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DDktR5oa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF971F0093A
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 18:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793730539;
	bh=A2SxbtdInviKmhuZ6qhITPKihTTKCU8zqlv1zCWXFFY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DDktR5oa1crRuyfuFtCMXUU+k3OQICXkZMzNhtqUWIUnC+D6gpAMnTCG+3xL8tQ9h
	 IyfsZZmGsReNSr7/nnuAHWF5Mn478r2mULPN2L+rH6Q3YqgBtIy+SCpylEZn5g3NdZ
	 /z80fsdCVKdRFOmpfO0U2owkg7PiT4fGszZdjTrpCDmRHl1Wto/C/vV/7ZMjhEGNAF
	 rsTwgck41zXLVg/9ZT4ruE+tmYJSkqMg3Umnc45jj/04V9JT1Z+FHOOc6UKKMqmJk3
	 aNgBu84nKY0A6Eor7WoiC/jusDJrj4pyJLhjdleXxLbtGjGgaTwvn293D6wEzUIPs5
	 dW4km++/0Ghmw==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-93cbc3ab2fdso219141385a.3
        for <cgroups@vger.kernel.org>; Tue, 03 Nov 2026 10:28:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzIdaTW/LYqKQVwUo+ljdS5ZZNjnShUnv8F0hXuX9aQCm97mGlMJigcFNfMn4y7daEcgNrSSbHx@vger.kernel.org
X-Gm-Message-State: APuU4Z/g7HfS1AQPft97h45up223B3fsINTqs3mhoMau8V8Sp+kwx1BF
	qDBmjdjNsNfCgoP+oPlu8AI494tQBCDBcUdw/T4+bD3Hqe7T4z4fQ1D9UoKRb3TgP5qECpMFx9e
	bGoefG6ClxoTzXa5vmgr0UfPrqOTcnRI=
X-Received: by 2002:a05:620a:3196:b0:93a:824:ac8d with SMTP id
 af79cd13be357-944216b1afemr2371370885a.27.1793730539153; Tue, 03 Nov 2026
 10:28:59 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103025610.3738894-1-ridong.chen@linux.dev>
 <20261103025610.3738894-8-ridong.chen@linux.dev> <CAGsJ_4xCTSctcPcC7X6Dx4zYaOycaPqs0DG7AaxB55wx1Afwpg@mail.gmail.com>
 <9cabcddf-d807-4a36-84f1-5bb06ea72aac@linux.dev> <CAGsJ_4xXDZjhN+NkvtN+vAp8Bokack_JdNgP=nGPQtHUX8_rqg@mail.gmail.com>
 <f5137dbb-b0ed-44ea-a23f-5c848315a68a@linux.dev>
In-Reply-To: <f5137dbb-b0ed-44ea-a23f-5c848315a68a@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Wed, 4 Nov 2026 02:28:46 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zNZynkZn1mb+nT1n6dq4n399VC8Lbo5Sv92gioDfPxUg@mail.gmail.com>
X-Gm-Features: AclHuK8ocj8au7qeT_BVvieNJJ4o0s2vwCrhyBoxk-38BXmuY8mPvZOfmLABhGE
Message-ID: <CAGsJ_4zNZynkZn1mb+nT1n6dq4n399VC8Lbo5Sv92gioDfPxUg@mail.gmail.com>
Subject: Re: [PATCH v6 7/7] mm/mglru: add tracepoint for inc_max_seq()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, 
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 8:23=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev> =
wrote:
[...]
>
> Hi Barry,
>
> Agreed, I'll go with option 2. Two things I'd like to confirm first:
>
> 1) To report the reason, should_run_aging() would need to return it
>   instead of a bool, e.g. an enum like:
>
>    enum lru_gen_aging_reason {
>         AGING_NONE,
>         AGING_NO_EVICTABLE,     /* eviction is not possible anymore */
>         AGING_MIN_GENS,         /* better to age, eviction still possible=
 */
>    };
>
> Or just report sc->priority, swappiness, max_seq/min_seq and the
> per-generation nr_pages, and let users derive the reason from them?
> The former is more direct, the latter keeps should_run_aging()
> unchanged.

Right. We can let users infer the reason from max_seq,
min_seq, and nr_pages in each generation. This shouldn't
be difficult, especially since should_run_aging() may
change. We don't need to spell out the exact reason.
Just present users with the overall state of the lru_gen.

>
> 2) try_to_shrink_lruvec() has changed quite a lot recently, e.g.
> Kairui's reclaim loop rework, and your swappiness series also touches it,
> including the aging part. Is it stable enough now to carry a tracepoint t=
here?
>

Yes, I think aging will always be needed, regardless of how
we change the code, so this should remain stable.

Best,
Barry
