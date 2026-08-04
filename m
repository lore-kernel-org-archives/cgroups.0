Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24A440F8DF
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 08:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832775; cv=pass; b=QHL9rwZoktdWKmqJcdVv4P4zdcbrGrAUyNQI5xkGghUCKAqeKovGkhUAkk1eLwJ8Rk74A1xNUv9JlZtL4muOTXZqPqFTCApv6ZLyzL6MhrkWOT6r/O2he+IZiJSEIMJvrsYPYrPckGqCVPwv1XWGY/w0HtlGpKIC4/6JTi1ESdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832775; c=relaxed/simple;
	bh=mENm2CoEk5ok6+yRCQNL7LUAeaMU/MRXHGpuCu5mqow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FWAT6qqNsgJskViQBKOSzoDHsZ0BUhrtwvqYPeoVVpkvbmwwCiZFOuPeWRIFFm7i8WBUsIYqaYdrjEil4rrIyba0dSjnRC1fgOfZIc5nKFiLBXcgMbB7Uf2oyMToRoAGuu/5UnLB8MxX6KheCixkqz5yqVt6wky4XfqIx0U90DI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M4eLz0aj; arc=pass smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M4eLz0aj"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c15cb6f5c12so708059666b.0
        for <cgroups@vger.kernel.org>; Tue, 04 Aug 2026 01:39:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785832772; cv=none;
        d=google.com; s=arc-20260327;
        b=RaUXFJbrAFrvs5HzEOpa4APe01Wih91S0V3ZPKdouZM9oeFbTwP9HIZZdcibAonSzo
         ys7EbESgL8v8v2mIxoABD282qC/O2UxhRwXk30jS4koIaPbDazCDWVTLr+hnSJyJrgf4
         V3pEAEYUkwiGbBaROL8BywnZUH5A7C9NsyTDZzDzOdc3bl0W+uTQFFL3Vv8hpwJuKeU7
         T7JOmUR08ohAKXZaG9W0oZW7qKsm/MQnvwX0ZrE+HPoE50PFVHh2V2U8rpR30Jv3z4ql
         ojUN4svL/z8svmURgWoO3Sb3VkfgJvnDY7bGzlpMeiQkNU+KHHJk1NzJduANa1SuqH4I
         PGMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mENm2CoEk5ok6+yRCQNL7LUAeaMU/MRXHGpuCu5mqow=;
        fh=1PkCvT/hI5o6wBL74uavLfJdJIeJLWfXGr70mX8A32k=;
        b=SIbctILYkIKHLS3ZOuNkAMjgYy9UZdoi3EikITP4CAUbDjs440GeFB9XVGP6wWGckb
         EFIalAzm2gGGuCHA2cb59NvEiJcT710GzUUVtDmfG7QfbECLJKIGm26jg24lysOnOe1p
         NLP+NLcpAw2do5jYHaIUrummMPgFh3fBP9uGnVSwS54rROAge1g78/d/DkdLq7Qs71qI
         l3MAwRhdelABRTFPBGrXXOvosvrerW9JW528h735J7yhhRYHulB4Mof/wZvv9nmr49Wn
         h/t6+n5NOaR/UJobLNEkOnY4zpsx+Ltx8J18Pq3lGH+fjFeVAGkppF5+6WP9IzEl06Bd
         eJXw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785832772; x=1786437572; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mENm2CoEk5ok6+yRCQNL7LUAeaMU/MRXHGpuCu5mqow=;
        b=M4eLz0ajZc+eZlAT8PdM4JwbiIfDnGkn6Uz4PihG8pvJNFp/uE57qe0aSujKXCnIVH
         ZkHDiY6X5Neiuq2GJeWJzMHJhC0o1H4QDy1+PtJPydK3m628ILPN8bswbvVxjo3w07HQ
         evv63tLbyhEIRAbx9zf3aq6eE/nbNrV11rZP9z1aFPgGuRJ81mFQCC8NRMLC+CRi9mDw
         BuEOtReAZIuzCoA6/92Q8MnDK6vWnZOu9egGcWKrXYk41/0Qlodswa9DA4koZOxEl5Mr
         Y23EmdP5mOiOUbqI8Gz6XCNaAbOl26PgMfT/YuyWd1GtfvmWf/6e8GEX6IJ0qKAWV7Wr
         e2+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785832772; x=1786437572;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mENm2CoEk5ok6+yRCQNL7LUAeaMU/MRXHGpuCu5mqow=;
        b=leXl+62TkQhCYlYClx3bSMYupwnKlsvXckIznJCt176nhyvNCy32JJ2iIPrzHDWwyY
         ziD+d4jQL/X388HrbU63Jm0Xcb698SWc5un5oT0blxjX1XBL0gcyzeSCKcUDYKBlp3Vd
         JjqBWZADnaxs5/o8nYc+PrMG6vEb5BX1GWaMfxRgkx3lCga0jfdlHtKWVxGkddkMIcr/
         GEuse2tyjyaZdPRCECE9JVQ8OIpYwt+4DUUqVPsbHycOf6Y2k0XvIiBMzAG9L4vtDLmY
         8SCtYx9rPGoO3gDborK2lN3AYvfyz4XI0NrbxGALtqlfuk244LyRlNPHQrRgKJVziIX2
         ZEJQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr+SCnW6xQ3QcC4DjN4R7mR1adNqhU63SeZrzJPgvcoStoLkMsIdF09dACEAh9atpjOIPwFRAcs@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/JPNp2uUiLJxKg/Ua4deX1dB+3uGy0cNleCYcatqdumiy3bxU
	t8VUwwnIz0x312b1a2ahNtZbAYd8v8Ngv9XSlVmg4j35Le1UyxjcTAoKhjtPEMtOLwL9IrTWrAJ
	qmyO1kRfZspOeUhDpYVN15o4emhOHgGc=
X-Gm-Gg: AR+sD121jSaLomzvAtU7qdwbcRK4KPkAbArU54DklTF2MuVlVwAgP61AD4BbSPWPGak
	sska8YNlCVWlyD8AEiZn+LQOvEIOFbbdWqyK8k4Fz6OFAsgNeTD/sp2Q41QFhX6UnpfQFVdrG46
	760u4Vz4OdMIQCGHxO2zm8tMgDbLve+nmitrbOOHEgHCsQ2NtnLfxFzvZWmtiS8LGNYqDEIW7SY
	DnbAvrECf9aj9Yi73s0ShUfoDl5qgu0fEoKn2roSU8x1A8j/NzhhpyzmKnxs/2eqMU74Xm9Bhec
	aI8cZzYCbcfs5cxQIyVljQvxcwPTpENePpNt2acWvNV6hR2Yyq1XJgFptbnlHt6NVsHajKxeT6O
	k4Q==
X-Received: by 2002:a17:906:ef08:b0:c15:dbc7:a6c1 with SMTP id
 a640c23a62f3a-c1fe7c55bf1mr1196713566b.0.1785832771739; Tue, 04 Aug 2026
 01:39:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-8-4d8dad39dad6@tencent.com> <20260804074844.99770-1-lianux.mm@gmail.com>
In-Reply-To: <20260804074844.99770-1-lianux.mm@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 4 Aug 2026 16:38:54 +0800
X-Gm-Features: AUfX_mx2d-qJ3XB_GcrQ4XmsTWGRWEWoE7Yw4A7WC524wIpFCYwh0LWuPW4G24k
Message-ID: <CAMgjq7BMrwX2JCFLkeoWZoBFYm+hf=vvWqsKQndo-yi0ph8aFw@mail.gmail.com>
Subject: Re: [PATCH RFC 08/15] mm/memcg: add folio-based lruvec live helper
To: Lian Wang <lianux.mm@gmail.com>
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>, linux-mm@kvack.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2026 at 3:49=E2=80=AFPM Lian Wang <lianux.mm@gmail.com> wrot=
e:
>
> From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
>
> Hi Kairui,
>
> I am trying to understand the lifetime and accounting guarantee here, and
> would appreciate your guidance. My understanding is that RCU protects the
> lruvec lifetime, but by itself does not stabilize the folio->lruvec
> association across memcg deletion and reparenting.

Hello,

Thanks for the coment and review!

Yes that's correct. And this helper is just a copy of
lruvec_live_lock_irq without the lock.

See https://lore.kernel.org/linux-mm/20260710154318.75388-1-qi.zheng@linux.=
dev/

> Could folio_inc_lru_refs() obtain the child lruvec here, then race with
> __lru_gen_reparent_memcg(), and finally account the generation move to th=
e old
> child after the folio and its counters have moved to the parent? The oppo=
site

Just live the patch above, we are fine as reparent of the
non-hierarchical counters itself will fix it.

> ordering also seems possible: this helper observes css_is_dying() and sel=
ects
> the parent while the folio is still accounted to the child.
>
> Is there another invariant that closes these races? If my understanding i=
s
> correct, it seems the helper guarantees a live object, but not a stable
> binding, and the lockless promotion path may need validation/retry or exp=
licit
> synchronization with reparenting.
>
> If I have misunderstood the intended synchronization here, please feel fr=
ee
> to ignore this concern.

See the example and explanation above, I think there is no issue as
long as the final counter is consistent. Some comment could be
helpful; I will add it in V2, thanks again!
