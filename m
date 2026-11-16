Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794850804;
	b=Bs8Aainr+fyQ5N1rBZlTrf9FSHEjKEQndPC+EW/CPZAQrhJrZqDdfCdJiufWIpu2z7o5
	 WdTNZkP/k/+Cd5oeqMMeAHyMLHpnLYvASlW+RtmH6+LKmmVgq0tJLHWLNvEbG09jqNEht
	 zfApB++P0HZcug0fqELAdf+/h0VheqHPIZD+gJNUtrt3u9z3u5NQX1IlOR86ltxBL6EOa
	 ACCwubt6W6/yjvL511LrNJqJ+uMCaX5ToHjRVIUoQSAzzF59PNyqGSOjASiT0Tcc+0fFb
	 WKeX3FvhU+9rLxFOUo4Nd7ZmmQzGNnFa0LhSj2Zrgs39tOb69k26YKo5cvQK0DKBPdA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794850804;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=WSwHlQDyP7wkj805UeQxgqOCUOA9IwLfucPHoVu5Fz4=;
	b=br4TQLEJ/WhaFHxPRSWJynh3mreRi/XzBc3m2gss/qnuz0N6/HaEH5CpuePd5ndMUCW1
	 bBvRjTd7SeC2qkGEG3EB2VuVocAofgJ09BXh0t3eammXHnHNPM8a9u9+QkDqWomOztscY
	 63Z2SXsP7BbXlwC7rrwbZIqB4Mhtf60HLDAHURqc59ENLTEzmOgWJ+t+lM7GRcTgPO5uP
	 3nMn3x7aaFT4BazrQVkvVSednXAPxUVBW5NdWmQyopilKyihwR/LlhOhbk2pjfmQWlAao
	 KksSe482fp7cAySKXrSrt8emzcJKwu5jhYnpXN/j5EMNsPQg4WzLaBU3LT2s99q7BHQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pAmCf9RH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE0E606A31C
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 17:40:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FE0E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pAmCf9RH
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4bb5b33e2ffso72615e9.1
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 09:40:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794850802; cv=none;
        d=google.com; s=arc-20260327;
        b=invyh4lqVb9oanf4LVhJts53nGdxwQQpbCRAzvLXaqtIPphKjk3k+ksp7YkYPVj1zk
         4oFMg7DEQNDkTItqxudfKtpJyGvznwtpoSPbUlffweUVAvkjICDX/RawN8n7MZrMOouL
         FS1M6fvnH+/boBz3VXsdaMw+DLuw1diV+dfs16CqRCCwmVfgaGnOWBZClVm38iIfXPCU
         0jGLBvGSyDcUyCbztCeRRhogAF7qor1TCfDlG/3HB9EynGi0TvVeoEsY5snLVg+HtFj8
         QNirPN8T9vWk90Ek139Jqbvk/awfgjOMbermgaV70xe+iekpWPOyxnoP2cpKlmhkYdZ8
         kh1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WSwHlQDyP7wkj805UeQxgqOCUOA9IwLfucPHoVu5Fz4=;
        fh=Vnq61meG3U8dmmUYP6Fw2HdbSEz3HSc4OooAf0fpnSM=;
        b=aspBDOFGZ2OBOTvy+OqjeMTu85c4gjIBacXSIztWw2nzCCiCJKelptw3GoAs58PTts
         5SWyA2nqH5BJHzfnTWP8RNpTt3/9gwYu0/Z2M7VyD0KLAqBUBrgFU6zJV1Fq+bO8Ycdh
         3c+J+ixBt27kEufVVUvkmLvQjTa2bI4jVIpclDbAMC5dGN9Li8cjxC72QUF7ILC6D65w
         MzbXlcuOpP464D7IpNpqAJTCbz3q9tqAOwXBiBmRHp5bIGdhfAZOf/0rtxjiCEVfFITM
         b7OLfBMzsDTWYRGHVXZnhQ8+ZOtl/Meki0NSLDYOkh2S317KMLE8bT7EE/PvxzYqhac2
         +0kw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794850802; x=1795455602; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WSwHlQDyP7wkj805UeQxgqOCUOA9IwLfucPHoVu5Fz4=;
        b=pAmCf9RHbl2KwUyAAVewo2WjbZRAh2HOr7FNyPBl4l/12kNZfD2LhakZ5nnxyT5HhD
         FgjcUOmkskgWf5f5EGxJqU3w0YL6QAJv8omqnF9CvY+xEvh/MSvotKnY0WSC2+K1pF0w
         wJE3Q8orKiH4HHin1LUveC5aORu3GlWyQOzO1OdXtIWzeleFyYBfmt+3sUXj3rsotZW1
         yKKy3rts8VM4Ugl3Xk7w3JGfLlM8F8UFz3fLC/Nm3CRERqIVPhJ3D961lhd8/QNU3N9s
         CIR4BBjZ2sFifwtRHL7tM+zUGQAEderELWl9WlYTbqKCsAdHHw1lcFL4sNCLasFO6t5P
         UfIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794850802; x=1795455602;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WSwHlQDyP7wkj805UeQxgqOCUOA9IwLfucPHoVu5Fz4=;
        b=17ws06nM/H55sJvY4xnu6iFhiUUcyVwEOxfP1591kSE/TwcFXHaBuyLt87BH+VJzwq
         Km4XxihcoF71QYZioVDBNTlbDVteQ8GO2aLt90nKv3tm067bI5kgWYenkPeL5Asxx2BT
         c1ULdPUx1WS8JL8fuWG7CY2R0AteSm5npSfXoL8OGDya9T31I/w7RiXxVbPSMSLLqFBg
         cb+VKXghunlO0xAL60dbgK6I0g3Bq4bJztBc2kgtzSAr32yP53xwxYk5iE7jYPNC2sd5
         dg4ej55F3SUDKpahK2HG8XS9g5sVSU/E6cDuT7RDVZxO3mrqijmyjn1dK3xKRWofpy5a
         2tzQ==
X-Forwarded-Encrypted: i=1; AL+hErH7Lr/wG/w5MSD5gq5mYYR07qwIJuxWw51e0gylfG0EbEDNVq/H+otQG4MgQWa08W576Ieq43Wh@vger.kernel.org
X-Gm-Message-State: APuU4Z+bksX7fz6rZuIZimPvP1MO4Zo0rppL98n5FnGyWiei3IBp4wvH
	vw7X0uspJVyasiyPSWIKCWiqRJH9wB3DaOXNkZ/6EIC14hJaPBMy7IDkG7+mV0+9M4NcnyqRGOH
	PTFCtuP/bwGqVhHsTGGeXpfehJxzJNyD6SSTjyjNw
X-Gm-Gg: AYBFou2ZWeOvYd6jKkGVhZyP+13ZoriyKjgZwSofuNK4phi+67FzxrkjEG6c6nRXcXM
	NpuJaYSIdm6r6fH7HJ4jtCDnNxRHFi8Ph6t3jJBN4LsWS2XSNcRooUdOVDr8a93DNWgCPAErJ3H
	gh8pH5xXNOWENBRUYsOyXuRvoYzqFvYs5F6IDnu66bNgU5m10OK7HeYCp6Zs6DsPQJ1VZ2jc4mv
	6GmfdNRLdRuMAVcxJNAVTM5DQLLUU8FXAThS4eatqc2XVFLl+awQCbTtHr+lmoyjJu0enJC/Rfm
	eadv0qSJhqoAt6QFNh5HvMppe0eAaWBxedxpRBvHtGIdBnE/kRbkE50/dlRygyZ8C9kfYQ1os53
	jJcgGWaHPxH5ZqiNXdaDl3ng0AH3plXUxJdciXvFKlNoT0j0t4/XfdHgmNxMRHFWtsxC1J+XfUt
	XUjQ9o+4ysC9c2ubJS+IE+XA==
X-Received: by 2002:a7b:cbd8:0:b0:4a1:fb0b:1c9c with SMTP id
 5b1f17b1804b1-4bb62f74fd6mr2275405e9.10.1794850802012; Mon, 16 Nov 2026
 09:40:02 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106235904.1092712-1-tjmercier@google.com>
In-Reply-To: <20261106235904.1092712-1-tjmercier@google.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 16 Nov 2026 09:39:48 -0800
X-Gm-Features: Aa3M54oxYc8a6LIuSto1TMcfd-6pEIfEVrjDl0LEFJ6mfcOIGgTGdyYmUpGfP1M
Message-ID: <CABdmKX1gdOH8R6qyjw6XN5VdpAZKVR8NZ=R7Y9Db-BEhUrX-1Q@mail.gmail.com>
Subject: Re: [PATCH] mm: workingset: compare shadow nodes node-wide without
 kmem accounting
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jaewon Kim <jaewon31.kim@samsung.com>, Jaeseon Sim <jason.sim@samsung.com>, 
	Youngchan Kim <ycshark.kim@samsung.com>, Dmitry Skiba <dskiba@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 3:59=E2=80=AFPM T.J. Mercier <tjmercier@google.com> =
wrote:
>
> count_shadow_nodes() limits the number of xarray nodes holding shadow
> entries to 1/8th of the pages that could be using them. For a memcg, it
> counts the LRU and slab pages local to that memcg.
>
> With kmem accounting disabled (cgroup.memory=3Dnokmem), shadow nodes are
> not charged to any memcg and __list_lru_init() makes the shadow_nodes
> list_lru non-memcg-aware, so all shadow nodes of a NUMA node are on a
> single list. shrinker_alloc() falls back to a non-memcg-aware shadow
> node shrinker, which shrink_slab() only invokes for the root memcg.
> count_shadow_nodes() therefore compares every shadow node on the NUMA
> node against the pages local to the root memcg.
>
> When most tasks run in child memcgs, the root memcg only holds a small
> fraction of all pages, so the shadow node limit derived from the root
> memcg page count is far below the number of shadow nodes on the NUMA
> node. Since the shrinker has seeks =3D=3D 0, every root shrink_slab() cal=
l
> trims about half of the "excess" shadow nodes. Most refault information
> is thrown away, so refaults of recently evicted file folios are not
> detected. Refaulted folios lose PG_workingset and the workingset_refault
> and workingset_restore stats drop.
>
> In testing on devices with kmem accounting disabled, moving tasks from
> the root memcg into per-application memcgs dropped workingset_nodes from
> ~37,000 to ~900 and raised workingset_nodereclaim 4.6x while
> pgsteal_file rose by ~12%.
>
> When kmem accounting is disabled, compare the shadow nodes against the
> whole NUMA node, as is done without memcg. Behavior with kmem
> accounting enabled is unchanged.
>
> Cc: Jaewon Kim <jaewon31.kim@samsung.com>
> Tested-by: Jaeseon Sim <jason.sim@samsung.com> # Galaxy A18 LTE
> Tested-by: Youngchan Kim <ycshark.kim@samsung.com> # Galaxy S27
> Tested-by: Dmitry Skiba <dskiba@google.com> # Pixel 10
> Signed-off-by: T.J. Mercier <tjmercier@google.com>

I'm guessing there aren't many other nokmem users?

> ---
>
>  mm/workingset.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 1504f91cdca5..87d5e55dd684 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -682,7 +682,16 @@ static unsigned long count_shadow_nodes(struct shrin=
ker *shrinker,
>          * PAGE_SIZE / xa_nodes / node_entries * 8 / PAGE_SIZE
>          */
>  #ifdef CONFIG_MEMCG
> -       if (sc->memcg) {
> +       /*
> +        * Without kmem accounting the shadow_nodes list_lru is not
> +        * memcg-aware. So the count above covers the whole NUMA node, an=
d the
> +        * shrinker only runs for the root memcg, whose local pages can b=
e a
> +        * small fraction of the node's when most tasks run in child memc=
gs.
> +        * Compare the shadow node count against the memcg page count onl=
y when
> +        * the shadow_nodes list_lru is memcg-aware. Otherwise use the NU=
MA node
> +        * page count as is done without memcg.
> +        */
> +       if (sc->memcg && shadow_nodes.memcg_aware) {
>                 struct lruvec *lruvec;
>                 int i;
>
> --
> 2.56.0.455.g6c5a503b38-goog
>
