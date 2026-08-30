Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F042E1DF748
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 04:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788064965; cv=none; b=u7t72g+yAK5hBtAVqHIuOwaNb9RnrR0meWHyx0bBdj+DekA0LAhRpmk0RV7n7J8T+Esg0MEAiDJRK6IZBTvZK3jbmB7m81dgJ+RevYzllQ/3AiFKHisYs33Cch1iJ0BxlkPp/pkX+w+6Bm9s4S/o7C/Pt+TxNrHrcgzwdjqkTqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788064965; c=relaxed/simple;
	bh=fOjBJBo57fGr8gG7BviDgI81hpL2BRksULaXPOEUsUo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J5icLDARRW7rFXJ+XgZcEv+Yw6g54QpqvICg4To+q5dmtjtQKWtDxycHHbKzABCIazqbaeb3bt8Xn3guGBGDDOFNn1XBfuN21bRAgv20rMcHq8OSzQ8N59vpnFPaL8dEjxv+iKG38Ygx/cEk4GwMYLQAw6JeJCi25wjkZNmqvX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WXL6crpH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WXL6crpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1ED81F0155C
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 04:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788064963;
	bh=atXEPa9UAnMS+WEK+D2z1APgofzXdx+YfnDKm8SmTWk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WXL6crpHf4qLMx7U0l0mbpkhCHkDbNndDnhwawkm6rfHW1E2HhPZI9Fr0FtuiUKO9
	 r2k3VTZmK3B25DOKGGRf0s3Jt0yx/1CnslCBcrGCj9VaDMtEIR2oCFKQx8vbPA6hgw
	 rETJziXVcOXnOn2gCVeb9HEmUH78SDNW+E5a6smY1vLdJ0PqzCLTvnfjxRygz+yBzC
	 68V2xyLNoDQCWoPpMAPurrVF4wNdlNSajsrnPVxdGqmwn+iTYZ7o1B/+9UWjQz4wz1
	 M6eh7zVlQOliBwVlKcoDYj6FFCj7qwuc/iwnugGkpdjEiZ9dIu4KTFzHXaW4s2bm78
	 9RXRN5NDdoaJg==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-938cd95b06eso194685085a.1
        for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 21:42:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp3/KYCC12bJhY6AfrjBylujMKMnEZtgwYYfuexq9U7irYRA2UQqLWXqDL/Qqna0jgucF0B68GC@vger.kernel.org
X-Gm-Message-State: AFuF++nUgCPkzza8J9v6C3qnlzMAQnfe15zTc6rAVOdnPtoZ/N/n2L8R
	TvUbkb1AXubphsrnv6ehSQgGCevgKrthG3S7xRlOIVKQo8ivhoUyFngoqUcFTuwj/zabalt6ImO
	vVF6SzayFnnh+jPxNSPzoAdp4m7a/SvI=
X-Received: by 2002:a05:620a:8388:b0:937:1b42:c949 with SMTP id
 af79cd13be357-93936bd569emr25376785a.4.1788064962983; Sat, 29 Aug 2026
 21:42:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260830042920.2280454-1-xueyuan.chen21@gmail.com> <20260830042920.2280454-2-xueyuan.chen21@gmail.com>
In-Reply-To: <20260830042920.2280454-2-xueyuan.chen21@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sun, 30 Aug 2026 12:42:32 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z8Yikc6UhHsHVY2cWcjcq0zej+20FOJAiumPUrpXxCQA@mail.gmail.com>
X-Gm-Features: AcwNN1UcWf3lsTry6wH4EtqhXnPuQtp450q_InQVv-OuUEkbZ_FBtSJFcs3Tl4A
Message-ID: <CAGsJ_4z8Yikc6UhHsHVY2cWcjcq0zej+20FOJAiumPUrpXxCQA@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] mm: add page_counter_margin()
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	hannes@cmpxchg.org, ryncsn@gmail.com, youngjun.park@lge.com, 
	baolin.wang@linux.alibaba.com, hughd@google.com, chrisl@kernel.org, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 30, 2026 at 12:29=E2=80=AFPM Xueyuan Chen <xueyuan.chen21@gmail=
.com> wrote:
>
> From: Johannes Weiner <hannes@cmpxchg.org>
>
> mem_cgroup_get_nr_swap_pages() open-codes the remaining capacity across
> the memcg swap counter hierarchy.
>
> Add page_counter_margin() to return the minimum usable space from a page
> counter to the root, and use it in mem_cgroup_get_nr_swap_pages(). This
> is a pure refactoring with no intended behavior change.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Thanks for working over the weekend. I've been waiting for this
resending for a while. :-).  LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>
