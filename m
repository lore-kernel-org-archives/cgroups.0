Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795162923;
	b=j7B9e/gGd2gLR82pjq46O2FGa3VH2i4PjNquVAtdvwDTKE8Wf7XtNnhHkkLu4Wv4wnjz
	 11BJMXfI9CGd8htOFlM2BHbmitINjT/lzYUExm6zAq2DbFHXcTsY3rS770dZaS+1uA1bb
	 /YGLgEzGcAbhTgLqjaOTGH0KoB4V3uG8xG/WxeKEcWExSH6Y928NLoEDZsxUq80qJpGdH
	 WX5QbyiukZq2O0LHxWX7AYRp5ZH/0wHjo0DQUf1Lt7doGNLoX97Drlsj/7Ppl4tUgBbRq
	 JhNcD6GqfaGuQ2My8STn+h5Y0nqVXtmymQbtgpciN8C1VyOp7tSlsYqbX3rW62F+mug==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795162923;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=6qaWnWddVt0MJiy+92iRgvW/WkoPo1PC7CtoH61AXG0=;
	b=rozXclYIjXBi2RMeah96AoOJmXkZU9BS9kiH+2OM5lBir2MXEzTTm9D4cl5/9xZW5c0H
	 vBbYGhJHGLODabiNGOY2lt3q2vHnKq80FQVZ+Kn2JhB9mAuoJGwhI+pMG1l70qDlV9RZJ
	 Rt8BPJ2K2oG7ATx16hEuK48Dj7LQ+CqqecFMPAaH8xpmaTFht5whCVHYgHpjPF2qCNtKw
	 BYYgjrfdhmsld0v2LsvdkF8yd2rtxqspQJkNq0zI/CtiG6VjuXBBFhsDT1VBRIIKatY23
	 ILBMqRrxIFwe94usOyjGOYULVdXCuEB1lwhUr0/8mR7s8s7Xn5ukbse/QLSogSZgPwA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="lfmZvxA/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB87606A32A
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 08:22:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCB87606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lfmZvxA/
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b887ca9f5cso892207a12.0
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 00:22:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795162921; cv=none;
        d=google.com; s=arc-20260327;
        b=Yd0NGnpwoXM/kZhRCUUyaKjlQlpC7Ud6In9MaV8rrOuL8F5JLcNID3+EDaxT9b0iFp
         /PJf2rIy6Meb1s053THzRcH1XMHGj3an4hyuwG8chRgrsarPHHH4oOIoHhSK4I0gRT1P
         Xes8cRBSEbQmfQesHhc5tDHP6si5v9+olwsjwkdUV0vdPxjYdMsx5QlPOPAro1TVF9xW
         zlK5tDV0QTDozqfUtVSh5K5G25ifKnhTEyfquaUI4Fydjr2DNBAnkNLvSVX5JnbOZ2RD
         nFUTpG9HDMv5rBIPoGySt5OpNvb06Jya+yLGNoSyoisSchM5nF0b6LKyo9EV1B4UenFP
         nWuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6qaWnWddVt0MJiy+92iRgvW/WkoPo1PC7CtoH61AXG0=;
        fh=yug4YDXrNCmGd1sINRX1Q2+AdHYSAWgP+e+LadLMuPY=;
        b=CopweSP+EDn7zGVlNZAFRfKiBA0IzqEBCt0PDhnLzQVz3/30DwXnl11cDmgsW3b7dF
         8URv4lgAs2N+l+Y9RjhGgFRwigGhThB37lqvlNL/7nwWK258ThVVmttHh0wGiX0/LbFa
         BNVP2giFODHz/3LnEYC3Bg/aTKRX5mY5DL0hZ1U235RexTfVzIGmFfyae+pQfxoC822B
         opA2KxFtlJHCMOYkRlEpp7h8923lYahEoOzSqPl0sRcmSpnuJ82DE/Jw7714tPS5mamP
         nFGDXmaOYkJ4ZzMvyw19vI/It2wKJrvhpjm8Umpp7vezLyWG0EcfisQdakEA4cHlhTc6
         DcNA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795162921; x=1795767721; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6qaWnWddVt0MJiy+92iRgvW/WkoPo1PC7CtoH61AXG0=;
        b=lfmZvxA/1HGejNGMYWP3y4EqkZ6pBnz7SLZBv3rujos7mJOt7yAdi9yA+9b6S4jk+D
         ipzGPH9AnJr9Lqj/mvk32vCLkbD+rSP/a7NmQ7Dljdvin4dNwDXjQlU7ei+YYomRNWGI
         90F2j7LYpKCgJSjIXyqCm8QOtOLplCl5bbWN7HZWLDXyutGBAlMc1WTKyM1wyO5bhBn9
         46YL8OYmDmto9N+M94yif75del23Y6bMpTINzOjQDDII/YdtZD7ugq1c0AnEhrXdUfnN
         vUohWs7UdgYxVJUj1GtsmBRsCs2g0B/QliBO4iXaaSJ5yPmpynI27gB2rgJm+q24d2SW
         wMbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795162921; x=1795767721;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6qaWnWddVt0MJiy+92iRgvW/WkoPo1PC7CtoH61AXG0=;
        b=XWX03i76ymcv7XeNhqQi0KJbszTDzZX9GNbaRzD28IyqU0Bi2Axk57p8rEQ5Xxxocg
         GJ+XR2rI9BQWJ5y/CReMXDwyMAecbLWY5VHX7TCPxQUrlHaPzbwnz66N0p99tPeSFutr
         69mbBOgdfc00yPXVCuAID65APm6+AYnl9DZXI8YSekloPrYTrqj6w8ZVjuSIW9pVrwEm
         oRGHfuk3WNUBQaJ/JmLI+j5R1/aHMUicoMge+Vdym0MCSfiL8jh7V5AsxpJYtM0HJrZc
         jLka6u2mtQvkvN3DK4a01O3VAeDR5X7QK0O31KTgizqJ9uI+oE4jepqFXUfzwyV2q8RT
         i0vg==
X-Forwarded-Encrypted: i=1; AL+hErHn5X9BjzdH/jUdV8yu25cFu0eWCqOkb3hA7PhuUpQG32LiF9Z3UQWazehZt3vjqsxTODKPINzP@vger.kernel.org
X-Gm-Message-State: APuU4Z/EB1gbH/K48OTQtZAaow9ijS+OsL0PUqj7ddcz3ZLLBkqMJiDG
	ZwezrUI64h26vEBTVR2EIhReE4eVKxCASyB5XIkkSMqBwwYzf3j1Ia48OVY8KLx83RwhYyEvCXa
	YVxtjx9g5+RFtJ3yy7L+ClkFdk06foOs=
X-Gm-Gg: AZFdTZc3twlbwmn/QvCb+dPa6Ga1frNw1xxOG9eRlBeXql76pmFbLTQAx45gh4RwQp+
	hwo+ZSBWnLlJ5aXj7jmR08Lwq0OEww9Xbej6C2oFpUhhXrw6xb6a0hDxkDQ6YT4H+5c488V2DvO
	GdJ8h3fRd+Jtn2ZIKbRYzAYlLyVyg67neeqg+CEEyOluFfX6FbyfJsV2uyZqTXajYqF3vWN8DBZ
	hk010GWYwC+zQAXJjNy7zoZQKeAdL/yuGPF0unBe3Q8afr2HTIvbwJdmz3bLpgFSb/DMSQhl8F4
	zXWAS+IV7hM4jZYLm7/gRd0txIrbE4YMMc2tMPVznp9z3nZsvEWHcwEjP+UfQykn5Yd3nftsgk8
	rGVMAEeincOwuzeH3azyp83CTrV2SBB09/ksejfGkl1tpqpSAqr58UahppKfGjmc=
X-Received: by 2002:a05:6402:2105:b0:6ba:3738:aa76 with SMTP id
 4fb4d7f45d1cf-6ba37ec713emr1520051a12.28.1795162920798; Fri, 20 Nov 2026
 00:22:00 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-12-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-12-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 16:21:48 +0800
X-Gm-Features: Aa3M54oR841ct7toroFKb5-FMop-YAlKT3qgtmdkpn6S2_l60VC8mi_ZrcEbsCc
Message-ID: <CAN_Opa8SFEzeu93GpJY7OkOUP5AeB3P9_8MGuhi6JJnBQsA4Vw@mail.gmail.com>
Subject: Re: [PATCH v5 12/17] mm/khugepaged: convert to LRU refs based
 operations for MGLRU
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

On Thu, Nov 19, 2026 at 5:03=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> For MGLRU, PG_referenced is only the lowest bit of the folio LRU refs
> count, so folios with nonzero even refs no longer have the bit set.
> folio_pte_referenced() testing the raw bit misses hot folios at
> refs 2, 4 or 6, under-counting the referenced folios of a candidate range
> and aborting otherwise good collapses with SCAN_LACK_REFERENCED_PAGE.
>
> Test the refs count directly when MGLRU is enabled, mirroring the
> smaps conversion.  The classical LRU keeps the plain bit test.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/khugepaged.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4bbe319ef86f..68f7a30e36be 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -579,7 +579,9 @@ static bool folio_pte_referenced(struct folio *folio,
>                 struct vm_area_struct *vma, unsigned long addr, pte_t pte=
val)
>  {
>         /* The folio was referenced previously ... */
> -       if (folio_test_young(folio) || folio_test_referenced(folio))
> +       if (folio_test_young(folio))
> +               return true;
> +       if (folio_check_lru_refs(folio))
>                 return true;
>         /* ... or the PTE mapping was recently used */
>         return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, a=
ddr);
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu
