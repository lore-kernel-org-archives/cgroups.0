Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10AA409286
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 07:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786691966; cv=none; b=A2JxtqJ0z6ArD4toGYLXpC9KIPw8K8gjXCx25hYahZ4dUpaHpSo4f9orXHDup6h+VdCnavBg5h5DvGwwpgKhLb+z/th3Y3uoIfomOqoSbOtmrNnUc48PXq/Z73ddZrxz7+/k8Z7+BNQIbyxcLV2OqovaMnyvJHJwleg0eOlIeu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786691966; c=relaxed/simple;
	bh=4q031WC5EBVLwKa6MI3sKwBac5U/JZ2v6p8q5p3t/gs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G5IotwePPA1q6TxCluOEpaDSJId2bs8VeT1hwP6Q9PqbqthTqruL04h4dqI6IYeYJOQqPYf8UtFt9jhUqhCVxG6whhQ6t44Jx3kB7RR/Q1XqchLnc6nNdebpCqkLnvX4uL8DxEZMyfna3CRNRq/KzwKv9zqj6F3azMmRabeejnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EufttVzY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EufttVzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC061F00A3F
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 07:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786691963;
	bh=Od/M0sS38B/IAHXIIur4KlaDShFpToMSCwBEwlqqN4w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EufttVzYSD4hOq2ld3LMwDFdOYGxvuwOB3FBSW6GFLaOcLMWHpHPWBcjrfGvynUGb
	 UGj2Ljd++nUZslpco8vP8EcpCqcnLXxVZ4kjfzTqSZhMGrnyUtdtp4g2iLTb7r8hPb
	 rVXLmpe+OWDrLXj3KL7hmveNr1tb+IhElZbifanzSXFheJTXiGpTTCl7klVUKYSnJz
	 lNEF0vlm/bnpgZdfcZ6OtI1qr6NRN9E3brVOaTJVuk9ovCH6py9iZMj8+kuz9G6PTL
	 16XkV5kJVADwU8R3/EbvYfaOq9ePgBoukw5WKCl+C1b+B33EEuUSJtVxxwtkqtVtQY
	 uScdEjx3s9Hgw==
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8ef1dc934d1so4629346d6.0
        for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 00:19:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqguVyeaEvpXHfWga1Tihqr0Uobnb1sYXGssQf/d7MdrIjjDL+2UcWrLyXUpi8yxnrnYCdk9Bbn@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0YbB6/bG9eq0n9rsnzyZ1Tav2m79rkcAKcGx6O9ndnQU5EcE0
	sL7UL2+Tqop4OffLjIgXw8G2bpU58p2bKV6MGDUlHGS/fYWN0l3KkoSecvdmigiYGVSACvGx7DH
	l45ZZkFMNnJor126WIBsWoijnD7VLmd0=
X-Received: by 2002:a05:6214:459c:b0:90a:5779:d30a with SMTP id
 6a1803df08f44-90a809e7e4fmr129248456d6.6.1786691962682; Fri, 14 Aug 2026
 00:19:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com> <20260804-mglru-fg-v1-9-4d8dad39dad6@tencent.com>
In-Reply-To: <20260804-mglru-fg-v1-9-4d8dad39dad6@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 14 Aug 2026 15:19:10 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zVhK9SvHEd+OFAHSu-OgTiAtk-ZU5OQVx5RwBYmc9r7w@mail.gmail.com>
X-Gm-Features: AUfX_mz2XV1v1iX3UNY8IBmbo0jYMTf1B8XkecPKEj6nl8GXRPWB8QN2pO8GcTc
Message-ID: <CAGsJ_4zVhK9SvHEd+OFAHSu-OgTiAtk-ZU5OQVx5RwBYmc9r7w@mail.gmail.com>
Subject: Re: [PATCH RFC 09/15] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2026 at 3:47=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Complement MGLRU's eviction-time tier-PID protection with access-time
> frequency-guided promotion.  Introduce a unified set of helpers built bas=
ed
> on referenced (access) count of a folio.
>
> Each access increments a folio's referenced count stored in folio flags
> (refs), refs still mappes to a logarithmic tier just like before, but wit=
h
> more formal bit definitions, a few special thresholds are introduced:
> LRU_REFS_REFERENCED (1), LRU_REFS_WORKINGSET (2), LRU_REFS_PROTECTED (3),
> and LRU_REFS_MAX(7). When it reaches certain threshold, the folio is
> promoted proactively instead of wait for the PID controller to kick in.
>
> Also simplify MGLRU's usage of PG_workingset and PG_referenced, now
> these 2 flags are purely used as the lower 2 bit of refs for MGLRU. This
> doesn't effect classical LRU in any way. This will actually simplify and
> make MGLRU's certain metric reading more accurate, and reduced MGLRU's
> original tier / referenced count bit by one since only one extra bit is
> now needed to record a max referenced count of 7 (previously 2 extra bits
> are needed). This changes make sense because MGLRU doesn't have demotion
> so these 2 flags are never separately useful for MGLRU.
>
> This addresses several shortcomings of the old model:
[...]

> + * Update the folio's lru refs indicator without taking the folio lock,
> + * isolation, or lruvec lock. Used by both page table access (@is_fault=
=3Dtrue)
> + * and by file access (@is_fault=3Dfalse).
> + */
> +int folio_inc_lru_refs(struct folio *folio, bool is_fault, bool is_exec)
> +{


This is really hard to follow, especially with call sites like:

folio_inc_lru_refs(folio, true, false);
folio_inc_lru_refs(folio, false, false);

The reader needs to remember what the first true and the second
false represent, which makes the call sites quite opaque.

Could we have something like this instead?

#define LRU_REFS_FAULT BIT(0)
#define LRU_REFS_EXEC BIT(1)

folio_inc_lru_refs(folio, LRU_REFS_FAULT);
folio_inc_lru_refs(folio, 0);
folio_inc_lru_refs(folio, LRU_REFS_EXEC);
folio_inc_lru_refs(folio, LRU_REFS_EXEC | LRU_REFS_FAULT);

BTW
