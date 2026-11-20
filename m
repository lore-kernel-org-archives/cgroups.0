Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795162905;
	b=15DNdS/spXnTPAAMUwYzShcn4rWEIpw8Y7gTBl7JHadCcsTA5K2uBwVGKN+lrVuQ/G+n
	 bEEezrc9iMPnQnX+wDDaqOt70r5rK31SaeHdout2U5mslHMtp6Rw0RsO3gyu2IJKXX79Z
	 LQh51NCFsgoL6odgmo4gDLibTSQHXeKoPlelBwG2i5P9blX3wUwv7lS6/APxeztElchW7
	 WhD+soVBPDvbkiIxR8XIzGVok3i/iXpO+FLor0p28/h9HTCooEPPeOw5hzkZ0s8/Z/rrJ
	 uS5IULhLGbwFK6xG11NmfoSpqc6xXPEvOxtMv7l8QTwRP4SUltd8Qf3N02GNRaLC8WQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795162905;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=8xqDAnMgRLbQDaXY5Ss9Yx0LPWinqLCRy8RnRx2MnMk=;
	b=YDlwFGMVO6jUIoW0KOdsBhn4lHwPtCEd9iFW2Uid4/HGExrfbdTL4NZHelBdq+goZNOe
	 C6OCVdRFJ57gUgzJvBwV4yLWIOHTGKeVjzSzPq1eJ5IeGhSP/Z/gkf7btfRRdUiudPRin
	 lrzfliKO3hb9rQpAnIgs9tEuJwsKPUdFf9UbwPUxaUR7JrGRz6ycYroxiuxKH5iGfwqw1
	 zfYnje6hWJuihGeIPd30la1rwvI5ytQ7ffiMg69dgdXgkuhPTV+dGOBlkYhB4eyS/Qheh
	 tB08IPvoZgutS6h9NlP8lZRlOXFK2IPzhj0915Hefpqe5MjRIuTFvdk73YmFDA1VHXQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZFdDRG0E;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9948C606A320
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 08:21:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9948C606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZFdDRG0E
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b408f2d936so907503a12.1
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 00:21:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795162903; cv=none;
        d=google.com; s=arc-20260327;
        b=spdF+I1KDOsdLM38hAPZx/tzE8LzKs1Vod43gZhwo7KHLbLYNPHajHQRmagBpsH0Le
         H95d/8YH4O3HQ/9j9s8UGvr6XABFU4nQhlRjyK8wTy1o2dOzW2EVu5GY010WPW6E2ZZM
         refu5k7TfkzlMKoVON34BAy1mPmHasxzmXT6Iu5Jj1N9kCBfvnOwxqNqcMrG9uxiAA39
         iCNaMtzzy2kJXhwt/NW+lu9P/OargMWfG/aY+JEx8TF6AoM+gtH6tAxznep14rFG8O0U
         LbCUOE3mcqHnXyE4BWU8S5Vwz20g+SDyQVpZr0YHcxOjZdLCARuNGkscNdl003aC/kCY
         OZJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8xqDAnMgRLbQDaXY5Ss9Yx0LPWinqLCRy8RnRx2MnMk=;
        fh=eYPgHrbCBD1UOoz0XKWBPJUUyI5VODHU3O0l9U28/xs=;
        b=EZhsPdGdaP/zoiqMiTp8XMMJxX1VskRjUVfogd4cikvpUO/LkDRdxeNLqfiWBOe14B
         vgH0vfmhwJdKty/lAcKsl5V0lDEFMRd6FwUNNwhKks7d2HP0UIP8sobamSFeSZ5xf+uZ
         jdbyhAJ1JfdDmWPTBo/2bkxO5713EDAGtH7Lk6PhQN0HsHJf5bj4MkRXRtkh/sauXeDj
         YxskPWICFrtpVL/U3YoEJNanvcqoz9GJlIaEK5JFbFFRGsvFI845rKVx4bdX2HpBbrGO
         bPIum04ptZdmK5HfdV+glLrCHGN+ILNHYQijZ5A2JpaPb8OUq12UZGIosSMB6ybUPrxm
         QUPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795162903; x=1795767703; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8xqDAnMgRLbQDaXY5Ss9Yx0LPWinqLCRy8RnRx2MnMk=;
        b=ZFdDRG0EqOKGceQ1Km4+2+47QBEfmhYNPT4A797uBI/TBR/Kkivy3g0qg8fc2N6/jp
         kLlfhSekCufAUuoBnvUkH2yH7oNLlcwolKgHqbx2JWuH14fFpC1eN0kAh3B6VcUhHV11
         JBpoJ+btwvCpN7fv66NLJ57uTS/fpCoRm17SF2C9tzwS/fMhuqwSWqyYeiJas1Ep1Jv3
         PaOLtTk1HbnuM9Mkuj1h1iEKwnA6wdDkVpFqTL8Nho8mhdoKgvJ0Dd2EWyFw1Cp7BgX9
         ABX0vXiTiYvxjQ+fRnbqU5S1yv0kn5l44sNvmXyvAhmhlfeBH5BNZAO2X/plsC9ggRXm
         wlTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795162903; x=1795767703;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8xqDAnMgRLbQDaXY5Ss9Yx0LPWinqLCRy8RnRx2MnMk=;
        b=GaWa5aCSYmOSgbqbbWmfmsGJlK+0ePVxsIDmEGtLlGpyENGqUNo/tYtz3YZrwKqQ+F
         IjpZb7qbk8Wqim5SIpaTbZ1X/hrMYbnd0WXMMY8RyYUXJwnRkLyMblOOUQnqj2L26hcM
         hWlFlyawPpop8+loDWpzzWW8CHyX9CL9o1UUYkvDRasm0U/wCBYyrZIua2183xLK6Zyi
         R7SYN6AikpTuHw+iQQ9A/P0T1YoW25op5IEMPqbVrwz6orqMWAVyV6PFWZTilhH7ByFZ
         SMtvJDR2IjwEudP0LUwVOpNH1vW2kpsfswsydNXeIs8dDEQV+u6c5bBSOky3G5osNIZ1
         eNKw==
X-Forwarded-Encrypted: i=1; AL+hErFSmh4UBiYuC7dBaKWyRu04mLUwkKDzcHOGnqZ2krpfIAP8kEp976Lyj4PR+Q9SB0vRrFo/RHBr@vger.kernel.org
X-Gm-Message-State: APuU4Z9xvJAX3Ghf2S7Xkf9AQ8FS5GfUkgKQnc5rDuKMcyqs9Mt/vtC6
	Jq+Hya5iU1zUiOT4fwnWwkWv4U2ZBCQqg02dpLTFc4QStg+LKSH6+0ILDg1sQLFVE2Tn0naWATy
	Gj/4NYSBjgXRXWXcQBbGFzcaLd1Mit88=
X-Gm-Gg: AZFdTZeskz3T7wKWOhGR+nXA+TPsWeir5LY5M63srV7AF+gip4B6XqFSQ0OvK0VF+3N
	xyNfHFdu9yS82ubuuArlixJm+QLFEeTYdpsm9zL21klf/ii7ucY3N5p0t3PEkZx7wlo6Tb+BOLY
	FK+TXcmUl6GQyMFyW/FaVLXliczfonunPBSz2UeTaVgjVvWL7k/rW5xM31Mi09wrvmMtGrPS/by
	rvAwykKr8/fef6fVo3rquMmp132XIBBR7z8tl0+SdtGCObrqjzV0wJL6Q/Up95ih4tZrNRpHJvn
	80bTMQg1Ofck3eTCqE8NftUc+elZDs2KqYQfVn2WaQ0Pl5XcXEehrCimRUjArHOydjt/fQHfq4P
	f3k2Yvh+bSHcOC5ftKLcdYpNhA0mDZWLur5hMJXLLPgJWBgWxeJ4YJJ3ccU8GLcA=
X-Received: by 2002:aa7:c0d0:0:b0:6ba:144f:ae43 with SMTP id
 4fb4d7f45d1cf-6ba37c7b138mr1084173a12.6.1795162902503; Fri, 20 Nov 2026
 00:21:42 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-11-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-11-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 16:21:30 +0800
X-Gm-Features: Aa3M54qin3mQjFf5kqOfy-EjZ2kR5w_yWqv5wLaUrnSsLRk4SMbzaUhZRRw7xMY
Message-ID: <CAN_Opa-DxzvggsGKMXJWd2vSKjbztttBHx3uSzJawbiiEOa2bw@mail.gmail.com>
Subject: Re: [PATCH v5 11/17] mm/damon: convert to LRU refs based operations
 for MGLRU
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

On Thu, Nov 19, 2026 at 5:04=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> damon_pa_pageout() cleared PG_referenced directly, which under MGLRU
> corrupts the folio's refs count. That flag is now
> bit 0 of the count (LRU_REFS_FLAGS).
>
> Reset the count instead under MGLRU.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/damon/paddr.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index e89cb14ee17b..411e1d557ba3 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -279,7 +279,8 @@ static unsigned long damon_pa_pageout(struct damon_re=
gion *r,
>                 else
>                         *sz_filter_passed +=3D folio_size(folio) / addr_u=
nit;
>
> -               folio_clear_referenced(folio);
> +               /* The region is cold, better drop the hotness info. */
> +               folio_clear_lru_refs(folio);
>                 folio_test_clear_young(folio);
>                 if (!folio_isolate_lru(folio))
>                         goto put_folio;
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu
