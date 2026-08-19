Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3AE304BB2
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 04:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787113493; cv=none; b=EICx5On/40vSb0AIA/oOQ7Zs2WR2ocRkLtNYMQ35GJi3jE5ECFDgJzQ+SMAWnDROm5iuvncYALJX10d0KZv2VB1ef0/374p5vxE96q0jwKYgTfF9AvbrkE30t5vrjbCqZ8qCCIDpgryCvdJBzfY5DkXQGKT2HtiUhwpS4QNkBMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787113493; c=relaxed/simple;
	bh=RYQTa1hrf7BHlBvXKhQUW1ZoCIiiUpqe4RbhABx7XmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gw68MItyXSQEfBlV7UJ1br65QqnrrflXYQlv685YRNAh4PyxCWgFqsj4YMvm6Ko0iUL9JTEzkIW+xrxDfJDUQYvWFmzNpANIj+gEd5vNBUVZ7jWgH+gft2hCsFagADocegni5Y8BRsqXmd7UNwx1foOeji3pCbq2eRm6Thibdzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CEelV7ms; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CEelV7ms"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7eb29ed2bbdso383428a34.2
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 21:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787113491; x=1787718291; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iexIkc1Tg7Z+y3wVDAMXzgQEyxhlozvlc08yKQPDJNI=;
        b=CEelV7msUaPx0YlW67F3EJZL1og3j28Vb5BeHrCADUIUpzrtXq9SmLeN8FYvlFn3Uz
         /DYsa3rk2j/iH5T2rpkM3uw9uPuxfMkRb5+hn33IdgURgWFbMKdKLUUTEjAISx74uj3v
         H0xLUjIlJPFFWxgoxPSDmaRLaaZM2x4LxtWefDQg8hUt2gYeHRdHBGZhAanH1WkcdKdD
         ++Od1HLL24sZX/MmR0ccJLy736seV9t+2qPs+gEptSjU8aWJp9ajfx8AGkYybGv/iF7G
         liLX5sXzGfjXpys/+fsBLhz3z/vw5CydHqyCtw/sYVsQNSZWUEYI8l8Sv4uwiSms+9On
         eDhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787113491; x=1787718291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iexIkc1Tg7Z+y3wVDAMXzgQEyxhlozvlc08yKQPDJNI=;
        b=PtkU1ssVyuYst0ka4246N+uZ1Of+st3ed10EhIIDG2NIPGK4tHXxwn3kcqvqQDzfKD
         xwrmckNSnQarA8w0GFd+mTKQLkNSZ5ioflTF4qfEnBopdf46Apdeuzmp8xFZaUP0sZAC
         zUJ5WQpUv8Tv/D/d7ZDz9t1nyyaZe93231vuHpQ0fmnPzJeJAHuq6uY5j4INJ9TU1zJJ
         ntJoYs1EMy7dDogwicxGmIZ6K3gYUPYf4Vf7RIk0YghnnYcafg5lYzmR0D8scpymlrga
         dxD4kAr/dxhDmh7sw+h4h3jTOfC2rK9tcOQCG0snogcTsT2ww+V+Lj4HMm7AZwTozzDQ
         hijQ==
X-Forwarded-Encrypted: i=1; AHgh+RoBPmXShpqKTmv44fVGuo5zXZN6F2DZjaj/a6LP4qnp2qApy/3h6a9rBzUKPFUX6Jcl/yODrXX9@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb8kXlMbQt0epkHzdK3fzdRSsGSbAblFUYR3S2vaYfVKsLASMJ
	CIUXZ6fIkdH7rguygjJgRo2JEuZKtcB4TxOrAJkEWn7PdYqqtR8hdNitDbLHkg==
X-Gm-Gg: AR+sD13eGRlkyNBerdq93BanG+Y2J+NsHxdJdYN0r/c/BPpLGexVm1D1Aoatkrpw1oK
	aeo81NYztGLIwP0g7OLO/RcDGnTwjctQ/gRJ8LvPLy/MMNP36eMm8Pm7Mw13x9qcC8q14WUuEqP
	GVwRawO+CCe/ZQb09Vbgnk++z+0drgAvBZX7Hr+H5qYj1YTcjnZbe6PUHpL7mCD8ZTCCTcHxVcH
	oHanq+pSN15Y04dF05JDjnGgiJg5lX20iOIr9ttTqg8l/uRaMjxuuLfFIXy4OZcpDIdZad/e9P8
	Y/PM8WL/oN2lQxRyjU9QHDeZxV4HVmLO1ZegKpwmt5mfNyLGFlFUTrMac6qZWV9eeHu11PBzs9r
	x6djrR8ZnXXOjJqAZqvm5WYXNtpdkYPYYGc+VXigEPZ19EzbuCfQeJX3TyqOPAgaIVU6FErMjD9
	4XNljZB8RefW6O65u/sW/1TtdBM5NVFKD0Wrg56sj4uqqvbLh0ZEhACx07ohKUye0AQwaGblo1P
	3LM+YXomqjTlR18rA==
X-Received: by 2002:a05:6830:258f:b0:7d7:fbe2:9725 with SMTP id 46e09a7af769-7f43f95b60cmr1996975a34.5.1787113491046;
        Tue, 18 Aug 2026 21:24:51 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:b::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f43fc6c89dsm654187a34.0.2026.08.18.21.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 21:24:50 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org,
	mhocko@suse.com,
	mhocko@kernel.org,
	joshua.hahnjy@gmail.com,
	willy@infradead.org,
	shakeel.butt@linux.dev,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	zhuhui@kylinos.cn,
	audra@redhat.com,
	bingfangguo@tencent.com
Subject: Re: [PATCH v2] mm: memcg: release the css reference when a stock slot empties
Date: Tue, 18 Aug 2026 21:24:48 -0700
Message-ID: <20260819042449.1209042-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818130135.154315-1-husong@kylinos.cn>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 18 Aug 2026 21:01:35 +0800 Song Hu <husong@kylinos.cn> wrote:

> consume_stock() can drive a stock slot's nr_pages to zero while its
> cached[] pointer stays set, so the slot keeps pinning the css
> reference that refill_stock() took.  The offlining drain only
> flushes slots with cached pages, so the reference is never released
> unless the slot happens to be displaced by an unrelated charge or
> by CPU hotplug, and the memcg lingers in the dying state - up to
> NR_MEMCG_STOCK (7) of them per CPU under container churn.
> 
> Keeping the slot populated past the last page only saves a
> css_get()/css_put() pair on the next charge of the same memcg, and
> costs more than that: the offlining drain has to know about empty
> slots, and refill_stock() cannot reuse them either, so a charge
> under a different memcg evicts a live batch through the drain_idx
> rotation instead.
> 
> Drop the reference in consume_stock() when the slot empties.
> Empty slots stop existing, so is_memcg_drain_needed() and the drain
> path stay as they are, and refill_stock() reuses emptied slots
> directly.  The cost is one refcount pair per emptied slot, at most
> once per MEMCG_CHARGE_BATCH pages.

Thakns for the v2, Song. This looks good to me. Have a great day!
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Fixes: d1a05b6973c7 ("memcg: do not try to drain per-cpu caches without pages")
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
> 
> Changes since v1: drop the reference at consume time instead of flushing
> empty slots from the offlining drain, as discussed with Michal Hocko and
> Joshua Hahn (full-stock drain cost, refill reuse).
> 
> v1: https://lore.kernel.org/all/20260817025917.66233-1-husong@kylinos.cn/
> 
>  mm/memcontrol.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 17da1f43b7d3..1271d390b617 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2140,7 +2140,12 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  
>  		stock_pages = READ_ONCE(stock->nr_pages[i]);
>  		if (stock_pages >= nr_pages) {
> -			WRITE_ONCE(stock->nr_pages[i], stock_pages - nr_pages);
> +			stock_pages -= nr_pages;
> +			WRITE_ONCE(stock->nr_pages[i], stock_pages);
> +			if (!stock_pages) {
> +				css_put(&memcg->css);
> +				WRITE_ONCE(stock->cached[i], NULL);
> +			}
>  			ret = true;
>  		}
>  		break;
> -- 
> 2.43.0
