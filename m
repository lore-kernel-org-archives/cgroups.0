Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795157212;
	b=PCKEY8SuMDcZwafg+fymGOEGwFvlaV73hBlhsjAJWH0AWuu4B5V6OBfpP2bgRCrwEXbJ
	 dWXV2J3uWtLUB05Vs37kVaaX29a7KtPLr3ZP1VY5B0bMXQL5rR2Ecdik9f7IeKmNn2F7c
	 dkebJTG/UZh+hom9PkuFvVSQOduiyyFWFz5+tnU6RRzpnDsozujxRq4VvF6jUuIuq91wS
	 SD69MVXbzTQhcwbgb+v2qEWOMmiFdN1pDHB6ekNeuJJKLee7e8c8WbATnisis8yZ3bbzg
	 Sqm8p85PdEnQngNh9Mu0zpxS2k2SfuM4TePpKfNAkzt6Tzu8BrTeLvMyX20Tm1ksrJg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795157212;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=yh5Pw6Ns7Cwi6C95SoPvU5P8PiEbr6Awtt6kTXpPyU8=;
	b=bq7hAfAPZ71uDQ8euSBpmEdJaP0sjiBgzojuuxN4ujPaV+3ICxaF6shkBDczYj7/84Z0
	 PrnXBxXF3g9Z/WZTug+qGaHLHi/TSbP5Cb0KADfStC/pb/hp5IowfASRhyLhiTKXG5AuY
	 n5fAP3D4mT4EJiBGbeAWR331iFR4xofuBU+bWFJu0YdzOhB8IfeH8ZdOOqM0NQvbsodOC
	 nGNrAq8B5VAHcpUM6f0I+Kuvsbv9NhfhXXE3OGMrLJvaM6J6C0ku9GdIwBYLt7Duk60Eg
	 RMpVgHX5FtJbenmiVBGnFKfg7z6q3N6ODOMmKZ+xVyPCbgUyKDqLxbVfNoja0Zt/Pbw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zivbYnhf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E1C606A332
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 06:46:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09E1C606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zivbYnhf
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb61185057so3727925e9.1
        for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 22:46:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795157210; cv=none;
        d=google.com; s=arc-20260327;
        b=EeoAo1MtLrZrGcsEH+iGREEVYIIr264h7QnFa244ZWcCo7s+MjEJjU0uJ244QeeU+1
         k6Lv7OjHd3Y8InH5l1MnVhrEfSZ15tbJQ0X6t5kXEAu07fRTiT7RQBvCRcRbf14tEH4i
         w5FuHRjMaRKDCheuC0roUGPWyf6S/htfkKq+wYyOW10sSoaGji7u4EjJVdsfVOAxAajP
         i0dmMvuKq4dHe2snfvPWGBzwuydlM/jiwMyT0/Wt/U8T2U68NDoWfhGzQJ2DtZ2tnd1V
         imjen48wQCNBGrQIvvb0RKRBTUqa4HVDUeqUIKw5tHE4qCs3B7WBEWhgd1QRKEypbP5G
         9zhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yh5Pw6Ns7Cwi6C95SoPvU5P8PiEbr6Awtt6kTXpPyU8=;
        fh=utx2N16ws8NUvsnadVxtzP9SbC9qlpVfScOew5Pffy4=;
        b=L3KQVC9RrEHxO0ssq+VIhtXIuyJj8PDArb9FGXW3qA5VSkwDl+IjTidks2nwKmWW2z
         arpcempOeq4ania/0TK5FhzWDggN5KYwyFxu4WQ6lHZYNktATjt2taldv8w21QHaYXR8
         3KCzV3Nc7Ad7bpjVqtGB1UHFyVgw9xMgTWEqW+ASdzFXofhHjJTdGrs48wlsIeHDmTH1
         durmkU/+Ca7Xc6/VyvnGjrMaD3GAaWcT/1bSYgB1nvEVdIbYdcbyOGj3iAevfysRoFe9
         RgLtr9Hyvb2Hb+gqEdxuKZFb7s0oOueSvIg2ZxlpI27uFx91rogJks471/xs+dkXDcUs
         kxYQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795157210; x=1795762010; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yh5Pw6Ns7Cwi6C95SoPvU5P8PiEbr6Awtt6kTXpPyU8=;
        b=zivbYnhf7owyhLTE/5r/3aaw/bfE0rS6phVAheDTlD1J2Z6uqpq4g6KsP58ymMF2Zj
         TIXryv4Hy4jvD3EM5bKVHmeE60oQ0ynXdNGs9wSf7TZz2xm/1scPEl2sByeUr1TASlkt
         rhAD14HyjDHTkyeO5pjjVRBjaqf0aHqRUIXqoRdhsioFM8Emw6BpunKijQDt/PlCA8nM
         22W6PdeMWclJF1fChbGE/+yGZMH/Tu/NB/Ivty4T020IcszE7Gp7BRCMbWGz4ra9kqdX
         DK9xzcXlSv65x+g/bA97b7VzBTFz909LQr2+v/uTns0prBkmHAmY++7fqhmk0ihKVXWa
         4l9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795157210; x=1795762010;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yh5Pw6Ns7Cwi6C95SoPvU5P8PiEbr6Awtt6kTXpPyU8=;
        b=RF4VhsBMN7ASbPy29ZggUyURAIVwTjipqIr+IslzdTeYfRA+cU7wOSMjLy5Le0ABSN
         BjZW28LmoM1Y5SbXju9GOpiGrmM4tXdy6FodUnOMg0KpJMBbLl8d7i9biCAh44Zk5FA3
         LWTAgRJrGFnv8YUlcuRXlfHNUp1lW3BVldlr2qumjnVhgU+1zwKs7vgpcRNu2Hl3hy2r
         47S7ROS81H7MW8LvLCCyYdKfGOxmGrw72fC/G4+Js8ETJw8R12mWR/bXliBbdw68tqBQ
         NsTUY0V1JvH7QkH5HHGSJymO39irLVR11RhUgLCZpcQ0GU7I+rM4rpeWSxD5cr6FD+Dd
         y1sA==
X-Forwarded-Encrypted: i=1; AL+hErF9kgvRd9yFaX7W/qacAvHtTxfx/dkiyc6PLbc8W4d4MBxx4OhNNPWqP6udhuKxC2mHPCZKVOpf@vger.kernel.org
X-Gm-Message-State: APuU4Z/K+C6TfpXZTh5iWP8zE4h9lTl8D5ZLgX0IORnaiCezZzxUP6B6
	qCrHaSAPW4NP8p+Hs3vIq/f/wkf1OYUyAz6XyQpBDZyKzkuBdnrH1wAAtIp3IsayQ/Tl9kL5/Cf
	+phctQKcMwvyLLiKlj57TtWwPX+rTGRE=
X-Gm-Gg: AYBFou3ZwHc/6cNjsZ0mt5zMo+TipTJ/LRLNqWLd0CuP8IikQGoFUA9f8g7WQUUkzp8
	txk3Ao1vcGqZNXZK7BBHL//wwiEU5jkY8khxkAaDatRtZZ97rRfFJm+uCug5y0dcuAAOHSalVKT
	axF+ABkKhVUwdpvUHoORpS1rNUpfPfQhmKjnUSi4httUhJpUbrdqExAnsARR4gv7o9O19M3rk+B
	zXeL0VbHcMlNIC9NYOilHJF1uDO4P3mTQqFD1pAEhcvY4irXxxNlkJ4a8XyhANzHzhLU7LHC/VZ
	i6fYQ1OUeWqNtcEeNYy9A5JcC1gesJDBHTYMXuzc3lgD1PWNNYu9uLfVDcQNibIe1vJHMY1btG+
	OIDzSE0oAXJrmKfKKVVCRnLE9qkNJ2TULMT1PQp/ar0slZpa/IPQNXZh+eOSMB/GK
X-Received: by 2002:a05:600c:1c08:b0:4bb:7757:fe6d with SMTP id
 5b1f17b1804b1-4bb88804c5fmr50882955e9.11.1795157209745; Thu, 19 Nov 2026
 22:46:49 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-1-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-1-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 14:46:37 +0800
X-Gm-Features: Aa3M54q6diJBPt5X49YJ4xjQARO39_f1G-0YmFpyFCjvJebbL7DyzQ2TCjNUNR8
Message-ID: <CAN_Opa9Gu56Tdx2WVrYZU95BrHdGg0+gf2mpv25gM7WCRULJ0g@mail.gmail.com>
Subject: Re: [PATCH v5 01/17] mm/mglru: rename the generation offset in lru_gen_folio_seq()
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
> From: Ridong Chen <chenridong@xiaomi.com>
>
> lru_gen_folio_seq() computes how many generations below max_seq a folio
> should be added to, but stores it in a variable named "gen". Elsewhere in
> MGLRU "gen" means an index into lrugen->folios[], i.e. seq % MAX_NR_GENS,
> so reusing the name for a relative offset is confusing.
>
> Rename it to "age", which matches what the value means: the newest
> generation is age 1, and a larger age is an older generation.
>
> No functional change.
>
> [kasong: dropped the comment table part, the series rewrites it]
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index f6f4bc9a704f..2395ca8ee305 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -302,7 +302,7 @@ static inline unsigned long lru_gen_folio_seq(const s=
truct lruvec *lruvec,
>                                               const struct folio *folio,
>                                               bool reclaiming)
>  {
> -       int gen;
> +       int age;
>         int type =3D folio_is_file_lru(folio);
>         const struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>
> @@ -319,17 +319,17 @@ static inline unsigned long lru_gen_folio_seq(const=
 struct lruvec *lruvec,
>          * |<---------------------------- MAX_NR_GENS -------------------=
--------->|
>          */
>         if (folio_test_active(folio))
> -               gen =3D MIN_NR_GENS - folio_test_workingset(folio);
> +               age =3D MIN_NR_GENS - folio_test_workingset(folio);
>         else if (reclaiming)
> -               gen =3D MAX_NR_GENS;
> +               age =3D MAX_NR_GENS;
>         else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(foli=
o)) ||
>                  (folio_test_reclaim(folio) &&
>                   (folio_test_dirty(folio) || folio_test_writeback(folio)=
)))
> -               gen =3D MIN_NR_GENS;
> +               age =3D MIN_NR_GENS;
>         else
> -               gen =3D MAX_NR_GENS - (folio_test_workingset(folio) || fo=
lio_test_referenced(folio));
> +               age =3D MAX_NR_GENS - (folio_test_workingset(folio) || fo=
lio_test_referenced(folio));
>
> -       return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen=
->min_seq[type]));
> +       return max(READ_ONCE(lrugen->max_seq) - age + 1, READ_ONCE(lrugen=
->min_seq[type]));
>  }
>
>  static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct fol=
io *folio,
>
> --
> 2.56.1
>
>
