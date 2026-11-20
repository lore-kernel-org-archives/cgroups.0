Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795163787;
	b=s+GJ5GI5Sw2jeuoq3xsTj4oOpV2rgNBzjPDolNPJ8SejTyq1b5MDsWSmaeyA1YXsQZE8
	 F3mK8RboPx0hFUpgeqBuJHJgDDcPsf8/3CD7IMuwUp2NG+T3hFalLqF4Cv/e4eLOBNKvj
	 qPgpV8A86h0TXJDAwowo0RgudcY2xrs4lKGXpmfmy8+jv/o7rYwEKP9yrvIXqfxHhO0Fs
	 VSl8qzVn0UMMXHKocnnJ3EBSemQ3JmcUrsI9a+fI84b0KZ1Xv52iXvhHHiknlHseeturT
	 +PsKiABzOUkqJqp7tw33xUa1JjGMoDB2N4Kp7+z/8IcRhhdDJZ03Dv4afoFDLuEEy9A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795163787;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=3PBPgn34gFSzs0WFCPqDxaDrqwWGqL5ASuJDkNQ3rM0=;
	b=j6jdsT1aOsS7IlBhDMvqy4DQBQJtLtY7RgDDK6dOfvvftwfEuH5GCyT6xqBoD3Tjs/xs
	 LOs4TXDADbZjJxMoyNzGiJDWko6YXRznv/0ImhyLmT1XzC2eFKhOXglChScR6pPerFbVH
	 V47foObdTEFK+IGWhTyXJIkNibwSbEIJu4fLqivczt36xTk2JuaM0kbLkMEMSZ5vM1DWg
	 BOR9a1DFKDZvdAcDn7Pjt1DWvEpG4DHfUAvpxSAXJOtMqQ7RQiI5GDBL3PgjTo51IC4Kt
	 MuOHKwSsheRWYyZTDXCjnV6KAgoZ3HDsIpVNUn+xkC8wbsnZ8G2jKA6Jh/1WGu9w80Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ImBMdazn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD22606A32A
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 08:36:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBD22606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ImBMdazn
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b8977f2785so906577a12.3
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 00:36:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795163785; cv=none;
        d=google.com; s=arc-20260327;
        b=M9frmWnacn18Dzfb1FfzgPQo0IdjFYR5WGyD2V4qTi+ouLMobYzrSLftH5Psk/HCau
         umgJeXMM6wx6Wm5NIzHWGXVSBLNBEj6gXhm5YQIkeF51qKhbcttTHCzkL2uhgbtjq36N
         nJHBan9fqllDh2E+9JdvNfDV0UFpE0Uuj4G3jp6IKbSF9xMLaUccDiMAZIEbQgPlHKUC
         TZ/bG/eKkPecBOt2qp2XF8lVcUcqRZ3ZL3tSXbV2x+f8FW6xvwSdYRB8exW9OUKqQRZ7
         IJHoKizfWFPMHJE+vXRLC9KyCuoX1BhpzDPGUZVKbYvOaONIt7eS71OqLLVcvPdcVIKi
         Pjng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3PBPgn34gFSzs0WFCPqDxaDrqwWGqL5ASuJDkNQ3rM0=;
        fh=BiExMWoKlkzKjwi6iVywuNIp6uqcmreOcFoZtEoqIH0=;
        b=EroSdRHM3hIiYEwD0QMx5cMiZyqv3trdypN2kHnzAErRL0Fje5BZ7eO8hXHlyvHm1b
         MC85/VtP/MsCK6ukVLIeAeSJwxTWVIWfOlhCXCMXWyVI0ZHJO2FyMX9NlU89zSG48xnQ
         5XtwA6+I9Li4LfhDXswAzfI+eLGry+Tduhy6q3muRnL7mtK87D3UM8SMLxS86b+GLOXD
         ns//G5xHi+wj4dAkAKoGfwfgPQR6d00UZLTcH4y8N0ANG9B79GBmautq9wx97c0CJG0g
         oAX2I3zIhhkUBG3Tln2FmeTNm7Zp06VpE20ZrHyzCFqQRd7G0Seyu9Y+cwwhATv8rkwa
         y9Fg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795163785; x=1795768585; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3PBPgn34gFSzs0WFCPqDxaDrqwWGqL5ASuJDkNQ3rM0=;
        b=ImBMdaznztdlFHVgcK3gAMDyyV0pcNV7fvYhgBW3KV+noAu2vzpbNhdEvct/3ocLVI
         lUwNtGAJOm8lKtewZ2mFrPYC7XxbTwFfJJQdPxXRENuA2KJjo7pGWQG3UDBfWccSGGcK
         96aqvTSLdBcrlnSk+YdVHvfAfvd+C0oQrQlnxb+dWeGHfKaxawFiYKDiYo9M+Dc3acB2
         VbfAz/6ecV5RU3JVc9LppKR8ykF2xQ4KrB95a4d8v6yleQ9sG15xD6vmnFmZvcJEsGg5
         PdCoE8pOeNlGAZ9T+txgl533cKpUJIkxuG2K/GiQASzc5wF41xFNnvyafs+tLegcyFTl
         wU2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795163785; x=1795768585;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3PBPgn34gFSzs0WFCPqDxaDrqwWGqL5ASuJDkNQ3rM0=;
        b=V8pMcfRxYcFSnEWo0+8VEYXH+CowMve6z1lMpJk1/o920DrZ+yMC40Gr3GbhrYVNCE
         Bh2UGere7kUOjLYHvSOctnEYcqH0w5vz/EEYqtG8Nls8q/2oP7k/vBcfKqSYiMYL2Uwo
         hIfRMt0HONWPYFhbWr/9yQ4ByxEBzhBzWcdWFUAQWbUzIQgOEYffRWTyrldtrLtY2F4u
         cvgJSJqFm2VR++B8cfrEoTx0BNOrA3QtvTjDF3ORK7r0rWTjp6KIIZ39BqcALxm2J78H
         S+Wy+WSmPmNmAmOWmW+/yEcBJGlCasgsZ/qwzPSRixMYNl0clILQpgfskATjOpyLbYTj
         iyYQ==
X-Forwarded-Encrypted: i=1; AL+hErGDqHaZAppVlSbiZEaK1nDb407hkmwcHwAFUt6x1v/Z0xugl4MBSZrnRffoFImZSPdyb1G9ytfH@vger.kernel.org
X-Gm-Message-State: APuU4Z/qNkC1ID1TzKtzTF96cjAy5wf6eXuOQ9ZEFGT/GwhoswlV2geq
	dIs7LzajlKjnyHSfBDk1VsVGEQvDYvNEwPS6fFQd7g+6E7QgQnynHpuENkp4iGI7VSfk5nR7FzM
	aML8xYvBeBTVIDEbtIW3uTOiLPfrAol0=
X-Gm-Gg: AZFdTZdweVfCPkKBSvbBS+Mfo9r7yCAEv30Wijtng2sgDbpBADTjgkp3K5TOTJNyPQE
	PX6mS5S9EcUQZHqoKEkiELZOTPdwXhERYK4goJ/qYOy9qEmBMaLNYP3tfh0wCENSIF+KjBMriJS
	HukddqLZwm+jY2tYsqF8wqfNMQ3CPyHiXZMO/3LVCu0LvNimZqJ+73ed9Ni3tgNRq7eTiYVLidc
	qz0ifOL1wz3NmaAW1YTB5hmkcTRaVZkLAOjm4ZVkbRsitGNc+Dfy9aUHNQBfnpyb3zXMgHx0AuG
	ZX6Co+ane/1w2pMU2MqgzUJTRcKFruJ8E1zJF4pmt2NX9Y+xsgVJ5Mx+JeTu0KeiLBodZAZXAJG
	XPQdyIhuHXKwojYNk91BEuEsZnkv8S8aaBiQnlupZgbIVhif3P0Pe8AIpvazmEnUu9A==
X-Received: by 2002:a05:6402:1512:b0:6ba:12e2:46f2 with SMTP id
 4fb4d7f45d1cf-6ba37d18d2emr1237841a12.8.1795163784752; Fri, 20 Nov 2026
 00:36:24 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-14-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-14-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 16:36:11 +0800
X-Gm-Features: AclHuK9a_uzFGbOjQzRBvuGpHT7FEd2GEgizUKayktzr9rLjRf8PKuN-UHaqZ64
Message-ID: <CAN_Opa9qsHLGSPUjUJB5rCfD8T_zE8R1YpipcmYCqv3tGYuO1Q@mail.gmail.com>
Subject: Re: [PATCH v5 14/17] mm/huge_memory: mark folio as accessed more
 accurately on split
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
> The behavior of updating the folio's access info isn't consistent for
> huge mapping splitting or ordinary unmapping. The page table's young
> flag has to be translated into folio's access info.
>
> Right now it only checks and sets the folio's referenced flag, which isn'=
t
> enough since folio flag updates on access have their own rules. Ordinary
> unmapping (zapping) calls folio_mark_accessed(), and it also checks
> if the VMA has recency to avoid false updates.
>
> So first just use the right helper here to be more consistent. Keep
> accounting the young PTE as a cache access, sticking to the current
> behavior.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0d589be136d2..1a415a6704be 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3104,8 +3104,8 @@ static void __split_huge_pud_locked(struct vm_area_=
struct *vma, pud_t *pud,
>
>         if (!folio_test_dirty(folio) && pud_dirty(old_pud))
>                 folio_mark_dirty(folio);
> -       if (!folio_test_referenced(folio) && pud_young(old_pud))
> -               folio_set_referenced(folio);
> +       if (pud_young(old_pud) && vma_has_recency(vma))
> +               folio_mark_accessed(folio);
>         folio_remove_rmap_pud(folio, page, vma);
>         add_mm_counter(vma->vm_mm, mm_counter_file(folio),
>                 -HPAGE_PUD_NR);
> @@ -3227,8 +3227,8 @@ static void __split_huge_pmd_locked(struct vm_area_=
struct *vma, pmd_t *pmd,
>                         folio =3D page_folio(page);
>                         if (!folio_test_dirty(folio) && pmd_dirty(old_pmd=
))
>                                 folio_mark_dirty(folio);
> -                       if (!folio_test_referenced(folio) && pmd_young(ol=
d_pmd))
> -                               folio_set_referenced(folio);
> +                       if (pmd_young(old_pmd) && vma_has_recency(vma))
> +                               folio_mark_accessed(folio);
>                         folio_remove_rmap_pmd(folio, page, vma);
>                         add_mm_counter(mm, mm_counter_file(folio), -HPAGE=
_PMD_NR);
>                         folio_put(folio);
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu
