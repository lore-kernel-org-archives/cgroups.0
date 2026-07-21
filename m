Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFF135E950
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 07:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784620661; cv=none; b=nEVZZC/b0H2gI+xTF+w2jrRnLMW6bH952EfJjQclKwp80SNY9SU196sVGBiNkuNbsKiVovdYG0L5VUmGBPN17wUBxyLDjzxWtzzVpKJPq2Hvri1vghOJNYSp82I8toMWLdxGVoYhtlrV3F/7fjMhKjM58Yy+AFLeQpbdQ68CT4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784620661; c=relaxed/simple;
	bh=qzjkl3/1P8rKRZoynl0fXgu1+D718eC3IelA9LqFd2w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l5DvV/MgmUzVQInOYEIqPdtH3cb6vVimUhQFknG+xT87gid1lpCZOsJy5E+dsdDoJV9bNIU7hNP6eDu+dHiOdfjGccOQHd/YakO6I3Zaqid+7q/tXvpEKxFZMu4iSKGoljIta26FZr/GEtB20c2amKnqPcQBp3UwZiHmwFvxVAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=otTSCgQq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="otTSCgQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B7F1F01565
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 07:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784620660;
	bh=67VeInvfg2059N6m643qkaKNMdL7mnmvi+qBizbLEU0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=otTSCgQqMLlbrvW2m893eQvJObUlIZJUTdI03GPpxD2A4rMXYHt7QPUh1NEo76K+3
	 XsCuuN6Vgm9nheplVYdhDDRorMNF/cHOvDV+EGgIqjaFSgJRZ807MdIxAYSwDdI1my
	 WXAMvycApGnVXgocZ26TSrtWVpqkEdz+IgGNZAofk0xCU+N6CRiLye0M3I2Y2vFaYP
	 B9JilmWmBx4Fq9Tz0+h/XPZ7hQKAx731y0Uqg1Fn/GCvhqsnnrb0lNiC1m9rVRO2Lw
	 Z1I0ZDzNVMau9zk8owbVG9ICdJXT3z2jEkVnE7NdZwU6boid6+76DRkAl39S26WB35
	 xUUT+fCOmeWSw==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e5cb052edso601002585a.2
        for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 00:57:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq4itRrcMaLBM0YlqxfR37kuYhhS/eOK/Ru7Lc3mE+750GgZR4qdqDTiaPuDTuumdfzEYQ6kikc@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4jY0iJ233UXPJVPY4a3gpBENd6v7p4MCJWWMjiam/hslTaiIU
	hX4mOiihw6TBLpdJwjbrEtDaSibi5dz7//QUSdetpzXzlAv1t5wXeQphjygI4ejWn657GXCHkyy
	OwpbT0I4ShO4phYQQuSqmlWMKrC2tdyw=
X-Received: by 2002:a05:620a:4011:b0:92e:604f:909a with SMTP id
 af79cd13be357-930b3ec8d71mr1812555785a.29.1784620660059; Tue, 21 Jul 2026
 00:57:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260717122514.51514-1-xueyuan.chen21@gmail.com> <20260717122514.51514-5-xueyuan.chen21@gmail.com>
In-Reply-To: <20260717122514.51514-5-xueyuan.chen21@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 21 Jul 2026 15:57:26 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z+uw0YdWMwJzxHA6kbV1wPaqSXhFzwT65ffj1drSmnbw@mail.gmail.com>
X-Gm-Features: AUfX_mwXoCUVj4Q581J7mLiAo59hEPI1kMXrhwsYQcD6VlJcdSV4gQgQI9BZuCo
Message-ID: <CAGsJ_4z+uw0YdWMwJzxHA6kbV1wPaqSXhFzwT65ffj1drSmnbw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 4/4] mm/shmem: split large folios only on -E2BIG
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baolin.wang@linux.alibaba.com, hughd@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2026 at 8:26=E2=80=AFPM Xueyuan Chen <xueyuan.chen21@gmail.=
com> wrote:
>
> shmem_writeout() currently splits a large folio on every
> folio_alloc_swap() failure. With the refined return-value contract, only
> -E2BIG indicates that splitting might allow smaller folios to be swapped
> out.
>
> Enter the split fallback only for -E2BIG. For -ENOSPC and -ENOMEM,
> redirty and reactivate the folio as before.
>
> Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/shmem.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3b5dc21b323c..d76812dd3cef 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1599,6 +1599,7 @@ int shmem_writeout(struct folio *folio, struct swap=
_iocb **plug,
>         struct shmem_sb_info *sbinfo =3D SHMEM_SB(inode->i_sb);
>         pgoff_t index;
>         int nr_pages;
> +       int ret;
>         bool split =3D false;
>
>         if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
> @@ -1679,7 +1680,8 @@ int shmem_writeout(struct folio *folio, struct swap=
_iocb **plug,
>                 folio_mark_uptodate(folio);
>         }
>
> -       if (!folio_alloc_swap(folio)) {
> +       ret =3D folio_alloc_swap(folio);
> +       if (!ret) {
>                 bool first_swapped =3D shmem_recalc_inode(inode, 0, nr_pa=
ges);
>                 int error;
>
> @@ -1732,7 +1734,7 @@ int shmem_writeout(struct folio *folio, struct swap=
_iocb **plug,
>                 swap_cache_del_folio(folio);
>                 goto redirty;
>         }
> -       if (nr_pages > 1)
> +       if (ret =3D=3D -E2BIG)

I'd rather keep if (nr_pages > 1 && ret =3D=3D -E2BIG), as it makes the lar=
ge
folio case more explicit and easier to understand.

>                 goto try_split;
>  redirty:
>         folio_mark_dirty(folio);


Best Regards
Barry
