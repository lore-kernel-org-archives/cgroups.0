Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D41443E5F
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 08:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784621736; cv=none; b=F94qGK9LPUVqudwtUxAcJJ8tRm7dFZDfhyivXD3Vo3dz0N02LeCl9HY+s2eVNA05SUQAYZztWs9EHXlwemcDvDyUdhTEhdanK0hA+ERBmUd41kwziMpJS7NRl5hU0v+2ENHT5s3aAzP1/W4jQwJgNMU7i9QUUheXksHLJZISGWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784621736; c=relaxed/simple;
	bh=/kqMlFpa3DH8uu2+N9Z8MWX5mtoM/86thU2mifGB5N8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cTpHtZEpAdBHG0sxrObBsqJPOnkfezx4TN8gisHdvjkdIgbY37o2oVe8rcdmZAM7IMpIu4uhRgXBil676YuW1czjgvcoYgR2t8zoqhjOPAIPFkAPnCCt6qYrG/rxg+aDRVeXY6N1LbjCkoEkDM3kLa10lG7D2GjtYS0/i+zB4ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nCun/1IK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nCun/1IK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D96A1F01563
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 08:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784621726;
	bh=k6GIJgFDTy/vqDnytZl/JyP3muRYfZ+Zlb37RJw8cgk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nCun/1IKrput9L6BJRQF82f66aGzVksi06wOOL9IFsA+jE5oaZ2+FIZtdu9cigQcc
	 EmCPD4r2sTdNYZShrl2Nm/psCu2Mr03ip+5/zDcPF9C/JRkeusszyYH5Y/twrRzp5n
	 LaD4V+E83ACDDM9cgEWHIfIEAqQ69N+x2aulXbwCYXjsqIWQrk4byX1J9df4FaHSLN
	 +y9mYL7i37i3Tb6CDN6r3yNRFkROEhSpQqsF3a9NX5NG8xHpVANl3NrypPKtD8WX5G
	 lMbLelPHPGnwpO3nxCyMz8iBjtHAVJnIhgwuVBMZmhdpophnZDDBg6wQCyw6uGtFGE
	 LxfvOE/6+vztQ==
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8eeb4508f29so111975176d6.0
        for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 01:15:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrdPhC1wosoiDV+M+VvwIoG8uEHD2VFyE6QuHKlMrjNHp9AzjPnZkFq/QBnc/Y0b9jAxdRQ+GqV@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc80EvG3ss29konDIRN8t+qQB/W+RAsr8pR89AnijO4qYSzGTB
	Xq8pVU0yHL36yAnWjK+d9rzopTj5D6zV183N2N97saFDi6Qp3WBOBj2aZfkIUs62hfuUbGBkV8w
	eTXh5oeB+jmL41kexOMRvUn0mvOwYUQc=
X-Received: by 2002:a05:620a:a489:b0:930:b867:4c9a with SMTP id
 af79cd13be357-930b8675a97mr1453716485a.56.1784621725297; Tue, 21 Jul 2026
 01:15:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260717122514.51514-1-xueyuan.chen21@gmail.com> <20260717122514.51514-3-xueyuan.chen21@gmail.com>
In-Reply-To: <20260717122514.51514-3-xueyuan.chen21@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 21 Jul 2026 16:15:13 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xv2AGrLY2PBA77fZiqctPEt_ERcUXUvFOdOG72LD_usQ@mail.gmail.com>
X-Gm-Features: AUfX_mxDnJFvZOXGyq-1zLN4DNo65_cLn0W0QN8SJWGyzS-He2qedvUT5lVMyN4
Message-ID: <CAGsJ_4xv2AGrLY2PBA77fZiqctPEt_ERcUXUvFOdOG72LD_usQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/4] mm: distinguish large folio swap allocation failures
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

On Fri, Jul 17, 2026 at 8:25=E2=80=AFPM Xueyuan Chen <xueyuan.chen21@gmail.=
com> wrote:
>
> folio_alloc_swap() reports most allocation failures with a generic
> negative error code. Reclaim cannot tell whether splitting a large folio
> could make progress or whether there is no backing space at all.
>
> Track the global free swap count around the allocation attempt and let th=
e
> memcg swap charge path cap it by the remaining hierarchical swap margin.
> Return -E2BIG for large folios when a smaller allocation might still fit,
> -ENOSPC when no swap space is available, and -ENOMEM when the failure is
> not helped by splitting.
>
> This only refines folio_alloc_swap() return codes. The reclaim caller is
> updated separately.
>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  include/linux/swap.h | 10 ++++++----
>  mm/memcontrol.c      | 10 +++++++++-
>  mm/swapfile.c        | 21 +++++++++++++++------
>  3 files changed, 30 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 7a09df6977a5..0695ac56457f 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -571,13 +571,14 @@ static inline void folio_throttle_swaprate(struct f=
olio *folio, gfp_t gfp)
>  #endif
>
>  #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
> -int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)=
;
> +int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry,
> +                                long *nr_swap_pages);
>  static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> -               swp_entry_t entry)
> +               swp_entry_t entry, long *nr_swap_pages)
>  {
>         if (mem_cgroup_disabled())
>                 return 0;
> -       return __mem_cgroup_try_charge_swap(folio, entry);
> +       return __mem_cgroup_try_charge_swap(folio, entry, nr_swap_pages);
>  }
>
>  extern void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int n=
r_pages);
> @@ -592,7 +593,8 @@ extern long mem_cgroup_get_nr_swap_pages(struct mem_c=
group *memcg);
>  extern bool mem_cgroup_swap_full(struct folio *folio);
>  #else
>  static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> -                                            swp_entry_t entry)
> +                                            swp_entry_t entry,
> +                                            long *nr_swap_pages)
>  {
>         return 0;
>  }
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1e10f493d2a9..7c9e7072fb39 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5472,12 +5472,14 @@ int __init mem_cgroup_init(void)
>   * __mem_cgroup_try_charge_swap - try charging swap space for a folio
>   * @folio: folio being added to swap
>   * @entry: swap entry to charge
> + * @nr_swap_pages: optional swap availability to cap by memcg margin
>   *
>   * Try to charge @folio's memcg for the swap space at @entry.
>   *
>   * Returns 0 on success, -ENOMEM on failure.
>   */
> -int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
> +int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry,
> +                                long *nr_swap_pages)
>  {
>         unsigned int nr_pages =3D folio_nr_pages(folio);
>         struct page_counter *counter;
> @@ -5495,6 +5497,9 @@ int __mem_cgroup_try_charge_swap(struct folio *foli=
o, swp_entry_t entry)
>         rcu_read_lock();
>         memcg =3D obj_cgroup_memcg(objcg);
>         if (!entry.val) {
> +               if (nr_swap_pages && !mem_cgroup_is_root(memcg))
> +                       *nr_swap_pages =3D min(*nr_swap_pages,
> +                                            page_counter_margin(&memcg->=
swap));

This looks a bit odd. Could we decouple *nr_swap_pages from margin and
have the function always return margin instead?

I don't think this function needs to care about the initial value returned =
by
get_nr_swap_pages(). While folio_alloc_swap() may depend on it, they're
different software layers, and we shouldn't couple them together.


>                 memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
>                 rcu_read_unlock();
>                 return 0;
> @@ -5509,6 +5514,9 @@ int __mem_cgroup_try_charge_swap(struct folio *foli=
o, swp_entry_t entry)
>                 memcg_memory_event(memcg, MEMCG_SWAP_MAX);
>                 memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
>                 mem_cgroup_private_id_put(memcg, nr_pages);
> +               if (nr_swap_pages)
> +                       *nr_swap_pages =3D min(*nr_swap_pages,
> +                                            page_counter_margin(counter)=
);
>                 return -ENOMEM;
>         }
>         mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 9174f1eeffb0..53a921ca099a 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1690,12 +1690,14 @@ static int swap_dup_entries_cluster(struct swap_i=
nfo_struct *si,
>   * swap cache.
>   *
>   * Context: Caller needs to hold the folio lock.
> - * Return: Whether the folio was added to the swap cache.
> + * Return: 0 on success, -E2BIG if splitting the folio might allow swapo=
ut,
> + * or another negative error code if splitting would not help.
>   */
>  int folio_alloc_swap(struct folio *folio)
>  {
>         unsigned int order =3D folio_order(folio);
>         unsigned int size =3D 1 << order;
> +       long nr_swap_pages;
>
>         VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>         VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
> @@ -1706,7 +1708,7 @@ int folio_alloc_swap(struct folio *folio)
>                  * the caller should split the folio and try again.
>                  */
>                 if (!IS_ENABLED(CONFIG_THP_SWAP))
> -                       return -EAGAIN;
> +                       return -E2BIG;

We could also have the case where we're running out of swap space and it's =
not
worth splitting, even when THP_SWAP is disabled.

>
>                 /*
>                  * Allocation size should never exceed cluster size
> @@ -1714,10 +1716,12 @@ int folio_alloc_swap(struct folio *folio)
>                  */
>                 if (size > SWAPFILE_CLUSTER) {
>                         VM_WARN_ON_ONCE(1);
> -                       return -EINVAL;
> +                       return -E2BIG;

Similar to the above.

>                 }
>         }
>
> +       nr_swap_pages =3D get_nr_swap_pages();
> +
>  again:
>         local_lock(&percpu_swap_cluster.lock);
>         if (!swap_alloc_fast(folio))
> @@ -1730,11 +1734,16 @@ int folio_alloc_swap(struct folio *folio)
>         }
>
>         /* Need to call this even if allocation failed, for MEMCG_SWAP_FA=
IL. */
> -       if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
> +       if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap,
> +                                               &nr_swap_pages))) {

As explained above, we shouldn't couple two different software layers.
don't use nr_swap_pages() as the initial value of memcg charge.

Best Regards
Barry
