Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795168431;
	b=iPXENm86+hEk5GsGfueqwV3VMsY/We6mF7e4vWerCVSjeshhkRqFAnMM0+XuT23czMUH
	 DP52oDQhMnon4VYPV1800euzL4Wt32HHNdy/ZYNRf9YLrKXCFVy5HWwE7dImpY2z0Ccme
	 A71pd2DA/U8oOhvBB8KbW94dKXGKv9EpiuAs094LtAlKAoFUrwQXEb4rpnHmm+bixe61O
	 lpa5H8gQPIG6aVHWiXw2OrmChGjx2T0ktczNIrO+SWAemCqZMdVNEbd0DO14avGSe7FMg
	 3fYg+sXtWU3eEkt7f081YoisgXq9pWZIW8dEsJpk+KLEc8b/1/iOiubeoRKQiG6fTBg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168431;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=HAfymCHccjaSnDwBzcAFu1I4f93kNUDtOAKH0uubUTk=;
	b=1uZww7lyU5ExVHnW5KjQMe7X0hUTSR6yPZvt/kzljOL/UFMkBww7jMjiXhM6TiMje8Gy
	 QxvrErX9m0puzbmJ+/5j/NxhNnvvNNVulXrZp7+iAu2fkb18NdtIPTcP6R0el8uNeJyED
	 C2Pdy3ZwD7QIbliCiXAw9iT4AEpmFGwONuyuOT7MvOcJOzists81q5OXd555g1GHH6maa
	 penTHd3UbwTguPmu+vxIXvcVGDDr7xXLKYZAn/8bjLl1lFg0mvdZD41GIEZ+XmMoOuYNT
	 tqWqCWw8TNM0BOuLW6fhSd2g/XNpA89bn+XEjCiUd9sIdZNbrjbhu9xDb/aDabHmInw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T4CUfUx5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E001606A334
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 09:53:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E001606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T4CUfUx5
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4bb61185057so4795425e9.1
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 01:53:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795168429; cv=none;
        d=google.com; s=arc-20260327;
        b=YOCV2cWKVAXBED4lrCAvSJ6mAFgHDi5SkTxixad8rFA+0UWidxJhBIkZ9bJWofPdwJ
         wYFXi2AophRIIJWgma/42e7BuGzf2lp9sg6SY8RZKubdrxHjd+WDlLKcV5weSJ9h1JKt
         r6sCzGa8OnlxolJXsun42sp1qMv5JFczBY95xjp+unv2IQHgV5t9cKS+e4yTo+78xHO7
         ziNoZz+lcz4wCxn5X8VktFJlbmNcddA4WAVZELw2L3dtB2DKd2bNZgbH60U9T/4S46s7
         /qYo7jF5h4jOIIpWbJ1pwJHu0TWEAGVsgiN/nIUuFTyhgyyDcPDhDfqde/PF8k4+NrZW
         tEiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HAfymCHccjaSnDwBzcAFu1I4f93kNUDtOAKH0uubUTk=;
        fh=LIyqAboWMj8LpGr4Dnal82KB612nBW4+k8EMYtRlFN4=;
        b=I/zlH7URswX/5h1cJKRgZC3915IgE+jRL3x/Q2Y8dczmR4GCwYROBQRDyOi8eZ2eqs
         XQj5pl/d1xKvJFw5CO9TRH8RYc4KL13R5my2I7qZG/vl3bIFVEFDK/knd7rhdkA3S+bB
         u5VWRq5qkeF9NpF7Epr+ijSgCr8CsrBFiMhZTQwzWnaJbNrS7FP/+zEnzu2lfoC/9kmJ
         1ojPNPulwzHTfaXjRwNwOWiClnb3XWDS0Of9Uk9wkNzP/MVXeKj2tB/Tu4xAG766sanD
         12l4VBepPfu8SyywiJVDG52yHzyUKRgnt9NPzbaA0WfGeGHF4Pa3ORJ1BGmW2sxA8rkw
         f9SA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795168429; x=1795773229; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HAfymCHccjaSnDwBzcAFu1I4f93kNUDtOAKH0uubUTk=;
        b=T4CUfUx5X2P48fgeEdocDjjKguysbIGJf+fuslE1OOU5xtAM5vu6ZqLezaRizi6u6P
         QhPWe13gTOOzAcoRO2Db8M2eshFS551LjT94Pd27cgObUp0BtEzQ3eYSf1qFI+jIxngr
         Xmntdq100UtOkcPu9iHKSIZaUzAIXTlaaQ/F6su+mT+62PgiEvunfgvTbm9X+hnJskhI
         E3uI0BKgmRDJu0hKuBnH92FcuFf+WCOO4zM9jiW1aa6Bw5M82LEQMUyxfo5SXuwtZRKl
         n+VhgiSafcoIFl/FBZR+HRWGPn0icReCE2yYyHySjs1sNIB/NRmIzQlPgGxZZEs0qrzU
         oH1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795168429; x=1795773229;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HAfymCHccjaSnDwBzcAFu1I4f93kNUDtOAKH0uubUTk=;
        b=xi0jCUD+mK09eVH0q7YVhT3oCpX3DOCD2RVoeNZ2935Xb8/1t/cq4XvquZbTHp8py6
         lcN82gG55D4MCAjr9+DZWOKA7Cs1aDQ/7+STbmPF97CtewfEecs3ZXy71m695wbWTx8U
         c4iUVwYqwHXokzLmcQAKHi0lOamSVj+W0uksd+qFSoOJoZtgiKxv+I78hCy2oXGbTJdZ
         lyiuzlz8wwrGSoRD4VIBN05niCKM4KbRNdNdl8AxC5A8Yf+q1z1qBnfDwGjCQBI87g9N
         Q6PKfeufdx/edS4FdDRtzfLULkRT/D+L0XwX93YIN4An0jibPTUVQnRHl6qYtfR7aQXq
         upOg==
X-Forwarded-Encrypted: i=1; AL+hErFrJ0i00Ay5FvVrfap5jZkvH/ntB8bv6sXF83Z0yCkolady8vypfbfGS/JwPZDKjeJ/kfQaqR96@vger.kernel.org
X-Gm-Message-State: APuU4Z8OAm0sOBD2lqphPXYek9mCLZ01llPUD4+lTtfNoKgpEZx0nsix
	XxO2/L/Z/8UnYsZzclulu//WTZXQ31w+ZuAdCFCeqqe6H4koQ897CipGz7yNoKvo2kP0Tlnyho1
	01efYraaHSFPcliAlwWWzFnGZQAL+bPg=
X-Gm-Gg: AYBFou2D66iRI7CQ2s6JDxtV/pBUeneaqwkgpGp2oC7ZRGqiIkygIKtOXKvjuFss9Be
	Y34cDE+NHRQo/bJaDEO1RmiP9jyWiLw07hNUsdQrON+vjlnIlSRNTx+Q6weEFDynFB0Jr/tZ086
	raLDk/9nzgQ8v9DYM2ZVYIg7WjC2VlfocPO2Yduivgl8IC3iLE1iriWZoS6I0jk4EXRY1oQxcZT
	5yvzq34WZfphx2ZgRTCIDvZHVpLpZHA0qVM+BkvV6HdEdXk0cD6ItTqqJOAhvq/M8SpuSGBvk+m
	W6DEPiViGdnWnKTvxGVDVQ5iDTdvMbjoRT8cE57zuLQxlV7YXG7qZ7+f3NHj/tFbz94hV872FUU
	8/yDC21X7+W7qO1cvXBnk0s6OvfQJVNHM2kz+bvgtPj6h2owhUK98l0CbufVM/Wpi
X-Received: by 2002:a05:600c:45d4:b0:4bb:6994:abf0 with SMTP id
 5b1f17b1804b1-4bb88817d91mr55598215e9.23.1795168428776; Fri, 20 Nov 2026
 01:53:48 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-17-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-17-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 17:53:36 +0800
X-Gm-Features: Aa3M54qdUFU2sI5bnRLRApKXsgxmqqGXoOIYcRvpBXntBh5ayMnUgKn48bYdX08
Message-ID: <CAN_Opa9APLNic4cnohrtZ4-HcdoNvSFvnAKiC6nn+C=thbTAAA@mail.gmail.com>
Subject: Re: [PATCH v5 17/17] mm/mglru: make folio_test_workingset() work
 based on folio LRU refs
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
> folio_test_workingset() currently tests the PG_workingset bit, which
> is only the second lowest access bit of the folio LRU refs count now.
> Folios with refs 4 or 5 carry it in the LRU_REFS_MASK field
> and no longer have PG_workingset set, so the bit test misses them.
>
> folio_set_workingset() currently sets the PG_workingset bit with a
> plain set_bit(), which also over-promotes folios at a higher refs
> count: e.g. a folio at refs 4 is bumped to refs 6, advancing it
> toward LRU_REFS_MAX and an earlier generation promotion.
>
> Move the test into mm_inline.h as an inline helper based on
> folio_lru_refs(), checking refs >=3D LRU_REFS_WORKINGSET.  The set
> stays a plain PG_workingset bit operation reserved for the
> classical LRU: under MGLRU the refs count is maintained by
> folio_inc_lru_refs(), and now triggers a debug WARN when called
> while MGLRU is fully on (the switching window is exempt, as the
> classical paths legitimately run alongside MGLRU then).  The one
> PageWorkingset() user in erofs is converted to the folio helper.
>
> Under the classical LRU the refs count is not maintained, so the
> test is equivalent to the PG_workingset bit test, which is the old
> behavior.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  fs/btrfs/compression.c     |  1 +
>  fs/erofs/zdata.c           |  3 ++-
>  include/linux/mm_inline.h  | 29 +++++++++++++++++++++++++++++
>  include/linux/page-flags.h |  2 --
>  mm/filemap.c               |  1 +
>  mm/page_io.c               |  1 +
>  6 files changed, 34 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index ad90e14032db..127c5ee38979 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -8,6 +8,7 @@
>  #include <linux/file.h>
>  #include <linux/fs.h>
>  #include <linux/pagemap.h>
> +#include <linux/mm_inline.h>
>  #include <linux/folio_batch.h>
>  #include <linux/highmem.h>
>  #include <linux/kthread.h>
> diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
> index e981e371d6c2..34ee41e1ccdc 100644
> --- a/fs/erofs/zdata.c
> +++ b/fs/erofs/zdata.c
> @@ -6,6 +6,7 @@
>   */
>  #include "compress.h"
>  #include <linux/psi.h>
> +#include <linux/mm_inline.h>
>  #include <linux/cpuhotplug.h>
>  #include <trace/events/erofs.h>
>
> @@ -1713,7 +1714,7 @@ static void z_erofs_submit_queue(struct z_erofs_fro=
ntend *f,
>                                 DBG_BUGON(bvec.bv_len < sb->s_blocksize);
>                         }
>
> -                       if (unlikely(PageWorkingset(bvec.bv_page)) &&
> +                       if (unlikely(folio_test_workingset(page_folio(bve=
c.bv_page))) &&
>                             !memstall) {
>                                 psi_memstall_enter(&pflags);
>                                 memstall =3D 1;
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 2c6cbd0df686..a2442e49aca2 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -300,6 +300,23 @@ static inline void folio_migrate_lru_refs(struct fol=
io *new, const struct folio
>         __folio_set_lru_refs(new, folio_lru_refs(old));
>  }
>
> +/**
> + * folio_test_workingset - Test if a folio is in the workingset.
> + * @folio: the folio
> + *
> + * A folio is workingset when its LRU refs count reaches
> + * LRU_REFS_WORKINGSET. Under the classical LRU flag encoding,
> + * this is just testing the PG_workingset bit.
> + * NOTE: folio_set_workingset() must not be used under MGLRU, as the
> + * folio refs are tracked by folio_inc_lru_refs() with rules.
> + *
> + * Return: true if the folio is workingset.
> + */
> +static __always_inline bool folio_test_workingset(const struct folio *fo=
lio)
> +{
> +       return lru_refs_is_workingset(folio_lru_refs(folio));
> +}
> +
>  #ifdef CONFIG_LRU_GEN
>  static inline bool lru_refs_is_active(unsigned int refs)
>  {
> @@ -551,6 +568,18 @@ static inline void folio_clear_lru_refs(struct folio=
 *folio)
>                 folio_clear_referenced(folio);
>  }
>
> +/*
> + * For the classical LRU only: with MGLRU the PG_workingset bit is
> + * part of the folio refs count maintained by folio_inc_lru_refs(),
> + * and a raw set would corrupt it.  The switching window is exempt
> + * because the classical paths legitimately run alongside MGLRU then.
> + */
> +static __always_inline void folio_set_workingset(struct folio *folio)
> +{
> +       VM_WARN_ON_ONCE(lru_gen_enabled() && !lru_gen_switching());

Could shrink_active_list() still hit this WARN after the switch
to MGLRU completes? It can reschedule after isolating folios and
reach this setter after lru_switch is cleared.

Thanks,
Kunwu

> +       set_bit(PG_workingset, folio_flags(folio, FOLIO_HEAD_PAGE));
> +}
> +
>  static __always_inline
>  void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
>  {
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index b0ddc652e76c..f6625dc042da 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -549,8 +549,6 @@ PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEFLAG(LRU, lru,=
 PF_HEAD)
>  FOLIO_FLAG(active, FOLIO_HEAD_PAGE)
>         __FOLIO_CLEAR_FLAG(active, FOLIO_HEAD_PAGE)
>         FOLIO_TEST_CLEAR_FLAG(active, FOLIO_HEAD_PAGE)
> -PAGEFLAG(Workingset, workingset, PF_HEAD)
> -       TESTCLEARFLAG(Workingset, workingset, PF_HEAD)
>  PAGEFLAG(Checked, checked, PF_NO_COMPOUND)        /* Used by some filesy=
stems */
>
>  /* Xen */
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 648f783454c3..2939647940c1 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -21,6 +21,7 @@
>  #include <linux/gfp.h>
>  #include <linux/mm.h>
>  #include <linux/swap.h>
> +#include <linux/mm_inline.h>
>  #include <linux/leafops.h>
>  #include <linux/syscalls.h>
>  #include <linux/mman.h>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index a57cdcf2892d..12deab296718 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -16,6 +16,7 @@
>  #include <linux/gfp.h>
>  #include <linux/pagemap.h>
>  #include <linux/swap.h>
> +#include <linux/mm_inline.h>
>  #include <linux/bio.h>
>  #include <linux/swapops.h>
>  #include <linux/writeback.h>
>
> --
> 2.56.1
>
>
