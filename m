Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795157343;
	b=tQX5MjlUz1K2azBmKQsXWgSWRGmicIT1syXml6AKWQkv+4dZvfXxOjhiHLLcSnjf3NTs
	 Ouy0MSC7w7K52jcy5S62meO2ZSpGwAO9fdqgMf20mLg1oHoPL40rJpAbi/7PQGUeaOblO
	 cFSo/vKAMCT+Cz0ZzDI/fozeCuPfpY0BxUj5Jkgup3Cci+7klrmS2IsULS+YL0R5foT5Y
	 CuZ/e+YNIAo8Mu735dOeGeq445WNJIVeznwH+GCEbGGa57sfIYF16U+wu0x/6bYB00zLG
	 gsaNigGdXIXuRkMUq4urdy5NAATp3pdfqNAZjt9Ph3GPoDM9hpDXW+a6sHpbcCH70tQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795157343;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=n+lyQHOp4KoneVTmx0lXKvEiHfZq/Kgi2CNuQIZ6Z14=;
	b=nujokC4v1tDWUgxHG+GoTKFpAeHPtdsCx0gNrUlBUtR5md0wtv9R5lCLGz1arwadZJ5F
	 Vw/c/K+tLTNmiAhGblI9bQweZsu8P4PIDuwFSDWfQRrQRUZGqMgIQj8VqKQ/rqbXbZ72d
	 cpzZ8Rzr7Di/bRyeEbex3znTCaZ3jrtYslVhxmEhfXwTnN4NCb4h3C6hX0Djm7UheC9Ch
	 B4XMUeybtI6ev34rUiMUQJ40uGX3zt10KNai7tnEZRQLgWU7NzSXB/mtUYfgSOlP9KNtk
	 kzZWN3D+/jyaBYs7559k68Exn4W/NC710tTkwKoEtmZC1qnkCsTrJdHHQpBLk95pPCQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iK4tFHA5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541DE606A320
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 06:49:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 541DE606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iK4tFHA5
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so3576955e9.0
        for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 22:49:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795157342; cv=none;
        d=google.com; s=arc-20260327;
        b=BycZjXxlXHt86rfv5QN4wY4cA2AO2H7z1gPM9m/BG1uTGDxUI8NhrksgWDg+sAisTL
         LX95nqtJdT8MlPaG849VvJYu0mUocnenxO7mzVijdlfqGarviaRAW+0lWoITR1D7nzZ9
         0wx45PYP/1u8Eh86Txhj2j0QvLKpAuD/D9pJclClbygctNVgkOhjPkC3kl4pmyjs8e1+
         jLnENNdmR4LiKxoi/WUaDUr7AILe3z3axFLhTaLMJ9LXVRpN4+u50Q+CFsVYujTe/X22
         gqwMEnNqoFmuT/SXWUgGv+5mMPJaCWggcfinjVR05LYvtOv12sLqkPAdyUmDThS9ZeBp
         FArw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n+lyQHOp4KoneVTmx0lXKvEiHfZq/Kgi2CNuQIZ6Z14=;
        fh=NJ5v0gvGx9pPaUWYNyCnDwyH+RdtsKcA+Qc8E+s5YH4=;
        b=dxN3OmOQx7tvhon1Qpwl40WLvNNPo1t572kYw50QH62Q0mVUUIGOIM9YKbAdNPmgdj
         AgQ1qCknseVGYHe/gUxX3HW2zBHRF6RWZ07PeM0eYRblMrRHbkbnNhj98qzqxxC30wHM
         E/fMVh/H8UBt4HBJjDnr0WB97iBvPvGV0FdZUyIqrEa+jKDE/sfpLnV1ICUtQCESt1Wj
         t5Qw3TC8okYobJkI2rDGpn9Bsb8+N7rwVSuSkwfVkcAVHhorthlBSDabfRUJpRmpuKPP
         vfZztMKOi3BitUuCNkmNIUPQ5z8VFwep0oE2xfvesE7vPMQkTfA9oW9h/Eg5XzPDjUcf
         imoA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795157342; x=1795762142; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n+lyQHOp4KoneVTmx0lXKvEiHfZq/Kgi2CNuQIZ6Z14=;
        b=iK4tFHA5Xdp7Y2lQSfMCqU2KYcvTQK8+4Nu0s87bvt85pOPJAJ1ILVdumwjVy3US9y
         5k8cHgJbnumhHajKfHN8yy2wxq9buial9Vcjv+L0RYe4JZMGUF7CE4IhZ7C7Le48HAEN
         5FOgUILuwNCW1Zqq2XE7uCM3HiYbLzO5MerQGNQUC0JL43nF3slvmscLkGTpe+dBbruu
         ONyOBu1c+VKr7wAO8Fc8ET7vtMmJm8+qbDCJjUVygKDhiyFPwsW3gYgKZEuoS9l7TxfR
         nwIH0oQhf9FNUl73+I5hxBJWeVDH+yyuRqnwRSOeh+iXizrQniF116r6vMtC8K91hcB+
         /91Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795157342; x=1795762142;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n+lyQHOp4KoneVTmx0lXKvEiHfZq/Kgi2CNuQIZ6Z14=;
        b=OoKhyX/n/+Jw3ngBuCj6olfACCGizz2qvHhkpTphV61K4s/tvylyIIgclVW1ohVoW/
         YLvCEqrSMXtSzaQsEdvOlL4M3t7NEMwNdcKTbiEolUKj8uzoUjJ2xqho9kTt4a2XlPLs
         5DmUFCe4XJZVTw4NZGTgefzqpxQHJH3zSsQ9N4pvraArFuaqOkcHkn6eqmWpQ0kS3UqF
         gKW/USv6Jg5qci9TqfFDyFv19ngEwB4Z4W0wbebRXZnNQGeILdF7gkBVQ05XWEjhG4IL
         uVqWcFea1nUF6/UVklh5aPgL9iOkDHTzvnidePvQN+Y6bIw7H8c9DkAVuKY5sz3cY3ny
         Eokg==
X-Forwarded-Encrypted: i=1; AL+hErFhK6pxhy/utuLmrAcYwiZN3tT34xxLKhcaOie99TtKA84RC14W35Wsyq22XyscOFfinGKP7Mbe@vger.kernel.org
X-Gm-Message-State: APuU4Z/1NIbPjiiNhgGElQcM7Ecq6O2plqdRa9oyXnWHpQC1mwotY15s
	UHrwjEJhGezuYLWNw6ZnRdG1AHt19Gj4tnAJc57iraBF5vCfI1uWyCPzzZ1fDaHd0S2uPB3BNxp
	4YPga4phY43OThRNON4H26R3Sf+Nx8IQ=
X-Gm-Gg: AYBFou0ovBTkaduN6FmJjOPg6t4w0A+EYRTEwgZZnDwcBjYm05CnimZWEO/9t4pI4zR
	2OUynEgWsLoNyeEWRatsLVp60cn6zl95g2eDwwSL1DZqNkClyH2buYRTktl3SWInTmz149eSjVq
	ETg7QpXuh7Km1iVt3Z1rrgMfD5S1ONfEzFYabolzQj15W1rSYP41me03fSEgl/dUJw5Jl7EJJUM
	YRRR/3ykE+811u/+TKw5nesS+pJpD2i+2aEJW5TZxGa7DQT5IMAg/fGgmbKEzUZ8pxzTwXyO5D9
	XdWONnRYWnhKPn5koNjVRSUFh86Lom08UHA6WQbkjbFcCKfFBM0zMr1K9Jy+GhXUD1pjNzOoX42
	yoHjWVIzxqY6lEwHTrtEtDggOYjSS7e3iWu40zuQigswobU7G7SeB3WBWEJUHPXTNfw==
X-Received: by 2002:a05:600c:3d05:b0:4b8:d17e:da27 with SMTP id
 5b1f17b1804b1-4bb88930872mr41310625e9.27.1795157341259; Thu, 19 Nov 2026
 22:49:01 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-2-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-2-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 14:48:47 +0800
X-Gm-Features: AclHuK_tpistnJ8n9EgGJGhoSv7JK71sLxGmAZ5e78h-Lbf9KixLF9WGl76rLxw
Message-ID: <CAN_Opa-7j854ph6e7Ckmq6UgmmQerxF8V-ikSr9JNyTAHZCxdw@mail.gmail.com>
Subject: Re: [PATCH v5 02/17] mm/memcontrol: allow update of LRU statistic
 without holding LRU lock
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

On Thu, Nov 19, 2026 at 5:03=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> To enable moving file pages in folio_mark_accessed directly and lazily
> for MGLRU, allow updating the LRU statistic atomically without holding a
> lock. It may cause temporary counter underflow, which should be fine as
> the counter is eventually consistent and only serves as an estimate.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 2395ca8ee305..2edb9beef6d3 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -47,12 +47,11 @@ static __always_inline void __update_lru_size(struct =
lruvec *lruvec,
>  {
>         struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
>
> -       lockdep_assert_held(&lruvec->lru_lock);
>         WARN_ON_ONCE(nr_pages !=3D (int)nr_pages);
>
>         mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
> -       __mod_zone_page_state(&pgdat->node_zones[zid],
> -                               NR_ZONE_LRU_BASE + lru, nr_pages);
> +       mod_zone_page_state(&pgdat->node_zones[zid],
> +                           NR_ZONE_LRU_BASE + lru, nr_pages);
>  }
>
>  static __always_inline void update_lru_size(struct lruvec *lruvec,
>
> --
> 2.56.1
>
>
