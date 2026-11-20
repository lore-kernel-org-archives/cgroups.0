Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795167012;
	b=MPO374Y30GUhq/hy+Znbdrw77JSr+o6n2L58urIT3TD7rowaPAnsXngASxdOsumv94lJ
	 8SoTrIKvtmwzsUPaGvshIy0y/kSUP+/m8K4X8Y8X/qMUSyM3sqCYoyUQpMskn08MV9xDZ
	 iODmO4CSWIPVYT4g/KhStxz9cNx3EpOTAbOtlOf2tLZbeyR85CP4Zuj9oziAsWdJksQzf
	 gjK5UEDy4GFDrBZGfQVbZcHiDaDrJ1bBNikjnjNhy0qxvy0kTs8iKw5XLVVCxj0jl1dFk
	 oIxCVHoeYW5Iww7i2HL+Forab40aMxjLqx0cWejme4v1oaQ8Ongh0y7l+LeEsHotJgw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795167012;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=l1LP11PvLTI43VOxCxt/momCmpYyjZj2ekQQAZOy1f8=;
	b=PVasDoE6y2RuKcL+F0Vbgzv7RNpsli3o3zLqCZbd0Vi6xAPb7INHoF4eMm9OTRduaPwE
	 WGPpPaSv4BNM/p+WpJc2z94Y/kdm6ljoo2C1ABc83+VR9jh/WatYvbRWsr9CF1piY55mb
	 3x5qWx84qWQWXRdWR3EqGL6yWtMNtDEzwH9X+k6azGnXBO3OL/OSlyETQcsB0aXWFqCio
	 pV9RuSr1u8G3ygX53EC6n59rZW7vllUZ6RXQeTe8aK/l/yWxL+kvbJFhymqSX/GuwXYIE
	 LkAfn/yoEtyzZhYdbxGw974EoKIV36dAHRPetb0JbNjftuPyfjZdWFKt2MBdAlq2+Kg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FbVrmngC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C719D606A332
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 09:30:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C719D606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FbVrmngC
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb6ba3b244so5508925e9.3
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 01:30:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795167010; cv=none;
        d=google.com; s=arc-20260327;
        b=E4vXSZWl1hqScbpyy2dirjaR0C95T6wl26pbRAlEjqjo/eC61xPAg9/5o+BfXa2Isj
         8TykTMqF68FCYkj6SryD+34JLSm86xNbcwFJXF+BMzyW+FoLM65waZK28xXQz9Yb34ba
         09ab9PT+VHETj/3X4hd/nBB1HQyUBVf7eiW6uBeTFrFCEv/nlciwhSKn17FYl9fgVRDi
         jd7uZ5PGg2ozf21BvsGrXNzvxIhG+u/zAEBDwtfa0ogxBYiT2LKbtqIzUsDZBEiU0uCu
         TOFbmU1sMijPfcms5ve8db3Y3AMkbYJT7BfwjupPnkpJ9I/4c7EnuVaPCzpzENTOJcID
         SnAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=l1LP11PvLTI43VOxCxt/momCmpYyjZj2ekQQAZOy1f8=;
        fh=Rh0qlQcPqlV/xj9BR6x5uffJvxvfE3PgKSmtDuBx5Qk=;
        b=ejPqNCvrAejbSkUe2U1aVd+ownu6WssPDMx/bTJyWUjPwjFjPvyaKHFCrS5Go52IYv
         UO3r6kel4JfxVwB87opOSHEswF+SIbh509VJyG4FYL/Aj/Cp58Z4tFBlQi6Ort0pRalQ
         q2uq/SBEV3dXXqeLVz7a1QiTrVfcejqtu38ub3Dca/gu6VSaLkLd0MGerPk9WQ1Pp4jf
         KjOuhpo+xZLmMaQUm02LIsdBUpANufxW8Lbkveql5xAH/i2GLlc2xLhOTVHDhVw4nioY
         GHyV0iyYfboHE4X1hUoBdZhj2okUD5DOUGF5SQw8OTAD5gtz0g7V7P18h/WDQXvBK6Q7
         3ouA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795167010; x=1795771810; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l1LP11PvLTI43VOxCxt/momCmpYyjZj2ekQQAZOy1f8=;
        b=FbVrmngCjHhG8kTYzX6XR1H2Mq+ObwPiUZhQOo/L4YQmNldbx3ML2SV1i/+U0K5zFG
         /jadL2DTIwO/fFdUeXfdtX+mjyknWPrvOBpNngETinZ053cVaDftU3exVKk44x4o0o2t
         jxcVzGvCGEn/FcugYgwggc2KBADaf/k87gHcPi65BKNZyomcNUO2xL+xXInz7CsFwFff
         3wnPHREurE1ZJJoNlGSzO0KLhjphGXi2yNkKm8JRvRErbLsDQ6wQ5rd2ypo+hHkaMrq9
         xdkZvDLMm3wpfDUhrKbzC/HhuzeO/XfuYHmzVM90BsU4sN6jDzEMjxjbPjvE7kURncsJ
         xBBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795167010; x=1795771810;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l1LP11PvLTI43VOxCxt/momCmpYyjZj2ekQQAZOy1f8=;
        b=fub58hC7B43cj2j9mH4IrPqusp1rfWMZrAp2xz3NOJaCphENY3K9iclKFsFb+k8KOB
         NcTJbxPYXFIuRHiTY2mLDm1WF+0CWPYSAXMNk/M6H89XcNsV5sZasKR1Qrb0KH+4YqNP
         HidKM777EjcPeHFaQ4dFvrc0usl+au8mxGmivnTgNkllVyWksaplzAwFp9DTqrTfa3ZG
         K2qq+HvVoYMlGzBSYyBnkhJ6cdZQyqmyXZ9otnPqImobEsJtWPjfVqPs7nNq6p6t5u5L
         XB1HJ5TQkQq5haiJgYxH3U6nnWYM7KmcoUWeGfqkRl2DuKcQjW4/OYGHzFRIJ2nIwKys
         G0iw==
X-Forwarded-Encrypted: i=1; AL+hErHnIcxNNkDgeIj90KTk0QnAB9qa/o8of0X9vwu4tCHeD14qDDDAdmLoTKkwEgzdWgXdaaQYwFKM@vger.kernel.org
X-Gm-Message-State: APuU4Z/IfOgeCe5xZeOFT3wFbeoY2EIB1wqke1wpREofcAMf6gmJLqaA
	0JA/l0t928EOZ9sEl2qDVOEktBS2y9DWcjazTg6X/+SWEsW5v0bIQysKK2of9/bVhrBfFn8r7h0
	G9twr7Bmgk/ee3fRWqpS5E6UZrG0w6rY=
X-Gm-Gg: AYBFou006De05QT21sr1bnauOrDQI45EAxog0hEYNU7l+oRMy/SlyELOTLmferDS3EG
	ovHce+0o86gojzkmzwmdSnZKWIhcmjTmkmKfvv6YmiL5Ni3lZthA7jHl3TED0sHodZ3ztAzEbO9
	IZ66Qvw8Fjj5Hr02hJ6GbkDmkUzqxkfDbQcaXVlpmwJ3j4sJ+kvvHlJ4ZKAoA3J29bsxeSJcpnF
	ndk2qpxjjH0XUVGMFWivw3OEowX09ItYgxvs8WnZ6S62fr3IwY27LlJnkLRaTsK/CB/lYCx2Z1P
	tnM24J6FTKh7nNI/Xtb3kHRgr9Ns8fzbBnKFIRGaiUViovym1IWTqtftbxTEZk+MHaMZwVHQbyN
	MbkDhG1f+zqELEsd3tCCmd+6YQpOK8VJbPLMuyHdxUkg=
X-Received: by 2002:a05:600c:b8a:b0:4bb:7007:4a5a with SMTP id
 5b1f17b1804b1-4bb88817772mr51604115e9.23.1795167009565; Fri, 20 Nov 2026
 01:30:09 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-15-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-15-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 17:29:56 +0800
X-Gm-Features: AclHuK_6yXmPKisO2emCryLIHFK-JxkWQduG4AamvuG_bhbUWmcrrLBzH5IxNjE
Message-ID: <CAN_Opa8jGstV=s9S=c842XFJ_H8m5txc6eJDH2AF=KuJSHAe6Q@mail.gmail.com>
Subject: Re: [PATCH v5 15/17] mm/mglru: folio LRU refs based active/inactive
 number accounting
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
> Currently the active/inactive LRU sizes exported through /proc/vmstat
> and memory.stat are derived from the generation window: folios in the
> two newest generations are accounted as active, the rest as inactive.
> This causes several problems:
>
> - Unmapped file folios can stay in older gens despite repeated use,
>   so active files can be under-reported, unlike classical LRU.
>
> - The reading is jumpy: on aging, the second-newest gen, previously
>   active, becomes inactive all at once, causing a huge drop of active
>   folios without any change in use.
>
> - The reading is reversed on swapless machines. When swapping is
>   disabled or unavailable, MGLRU ages anon by moving the gens directly
>   without walking or touching any folio, to reduce the overhead. So
>   inactive anon folios can suddenly count as active, or vice versa,
>   despite no change in their hotness.
>
> With frequency guided promotion, hotness is already tracked per folio by
> its referenced count, so we can do folio level accounting instead: a
> folio is active once its refs reach LRU_REFS_ACTIVATED (currently
> LRU_REFS_PROTECTED).
>
> On reaching this threshold, folios are accounted to the active part.
> On forced per-folio aging or PID protection, refs are capped at
> LRU_REFS_WORKINGSET, dropping active folios to the inactive part.
> Note that on swapless machines anon refs are not reset by aging (the
> shortcut skips the per-folio walk), but the counts no longer oscillate
> as the generation indices wrap.
>
> The accounting is now per folio and lruvec independent, so no size
> adjustment is needed when reparenting a dying memcg: the hierarchical
> stats keep the counts in the parent automatically.
>
> folio_migrate_lru_refs() also gains off-LRU VM_WARN_ON_ONCE checks and
> __folio_set_lru_refs() warns when the folio is still on an LRU list.
>
> The latter uses lru_get_gen_flags(), so that helper now has to move out o=
f
> the CONFIG_LRU_GEN block and is built with the option off, where
> LRU_GEN_WIDTH is 0 and LRU_GEN_MASK is zero.  Keep the decoded value in
> int so the subtraction of the one-off encoding cannot fold to ULONG_MAX
> before it happens: that is -Woverflow, and fatal with CONFIG_WERROR.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  Documentation/admin-guide/mm/multigen_lru.rst |   4 +-
>  include/linux/mm_inline.h                     | 118 +++++++-------
>  include/linux/mmzone.h                        |  23 ++-
>  mm/folio.c                                    |  39 +----
>  mm/madvise.c                                  |   2 +-
>  mm/vmscan.c                                   | 218 +++++++++++++++++---=
------
>  mm/workingset.c                               |   2 +-
>  7 files changed, 230 insertions(+), 176 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/multigen_lru.rst b/Documentatio=
n/admin-guide/mm/multigen_lru.rst
> index 9cb54b4ff5d9..808d2e97b3f3 100644
> --- a/Documentation/admin-guide/mm/multigen_lru.rst
> +++ b/Documentation/admin-guide/mm/multigen_lru.rst
> @@ -149,8 +149,8 @@ generations less than or equal to ``min_gen_nr``.
>      ``- memcg_id node_id min_gen_nr [swappiness [nr_to_reclaim]]``
>
>  ``min_gen_nr`` should be less than ``max_gen_nr-1``, since
> -``max_gen_nr`` and ``max_gen_nr-1`` are not fully aged (equivalent to
> -the active list) and therefore cannot be evicted. ``swappiness``
> +``max_gen_nr`` and ``max_gen_nr-1`` are not fully aged and therefore
> +cannot be evicted. ``swappiness``
>  overrides the default value in ``/proc/sys/vm/swappiness`` and the valid
>  range is [0-200, max], with max being exclusively used for the reclamati=
on
>  of anonymous memory. ``nr_to_reclaim`` limits the number of pages to evi=
ct.
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 14aab2b1ed08..77f514143266 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -105,6 +105,22 @@ static __always_inline enum lru_list folio_lru_list(=
const struct folio *folio)
>         return lru;
>  }
>
> +/**
> + * lru_get_gen_flags - Return the LRU generation number from folio flags=
.
> + * @flags: folio flags
> + *
> + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
> + * -1 if the flags indicate the folio is off the list (e.g., isolated).
> + */
> +static inline int lru_get_gen_flags(unsigned long flags)
> +{
> +       int gen =3D (int)((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> +
> +       /* The gen is stored offset by one, so zero means off-list */
> +       VM_WARN_ON_ONCE(gen > MAX_NR_GENS);
> +       return gen - 1;
> +}
> +
>  #ifdef CONFIG_LRU_GEN
>
>  static inline bool lru_gen_switching(void)
> @@ -168,22 +184,6 @@ static inline void lru_set_gen_flags(unsigned long *=
flags, int gen)
>         *flags |=3D (gen + 1UL) << LRU_GEN_PGOFF;
>  }
>
> -/**
> - * lru_get_gen_flags - Return the LRU generation number from folio flags=
.
> - * @flags: folio flags
> - *
> - * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
> - * -1 if the flags indicate the folio is off the list (e.g., isolated).
> - */
> -static inline int lru_get_gen_flags(unsigned long flags)
> -{
> -       int gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> -
> -       /* Exclude the legal -1 from the unsigned MAX_NR_GENS comparison =
*/
> -       VM_WARN_ON_ONCE(gen !=3D -1 && gen >=3D MAX_NR_GENS);
> -       return gen;
> -}
> -
>  static inline int folio_lru_gen(const struct folio *folio)
>  {
>         return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)))=
;
> @@ -247,12 +247,21 @@ static inline bool lru_refs_is_workingset(unsigned =
int refs)
>         return refs >=3D LRU_REFS_WORKINGSET;
>  }
>
> -static inline void folio_set_lru_refs(struct folio *folio, unsigned int =
refs)
> +/**
> + * __folio_set_lru_refs - Set a folio's LRU refs.
> + * @folio: the folio
> + * @refs: the new referenced count (0 .. LRU_REFS_MAX)
> + *
> + * Set the folio's LRU refs.  The folio must be off the LRU list (e.g.,
> + * isolated), or use folio_inc_lru_refs or folio_reset_lru_refs instead.
> + */
> +static inline void __folio_set_lru_refs(struct folio *folio, unsigned in=
t refs)
>  {
>         unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(fol=
io, 0));
>
>         do {
>                 new_flags =3D old_flags;
> +               VM_WARN_ON_ONCE(lru_get_gen_flags(old_flags) !=3D -1);
>                 lru_set_refs_flags(&new_flags, refs);
>                 if (new_flags =3D=3D old_flags)
>                         break;
> @@ -261,12 +270,18 @@ static inline void folio_set_lru_refs(struct folio =
*folio, unsigned int refs)
>
>  #ifdef CONFIG_LRU_GEN
>  void folio_inc_lru_refs(struct folio *folio, unsigned int flags);
> +bool folio_reset_lru_refs(struct folio *folio);
>  #else
>  static inline void folio_inc_lru_refs(struct folio *folio, unsigned int =
flags)
>  {
>         /* Should not be called with !CONFIG_LRU_GEN */
>         WARN_ON_ONCE(1);
>  }
> +
> +static inline bool folio_reset_lru_refs(struct folio *folio)
> +{
> +       return false;
> +}
>  #endif
>
>  /**
> @@ -280,10 +295,18 @@ static inline void folio_inc_lru_refs(struct folio =
*folio, unsigned int flags)
>   */
>  static inline void folio_migrate_lru_refs(struct folio *new, const struc=
t folio *old)
>  {
> -       folio_set_lru_refs(new, folio_lru_refs(old));
> +       VM_WARN_ON_ONCE_FOLIO(folio_test_lru(old), old);
> +       VM_WARN_ON_ONCE_FOLIO(folio_test_lru(new), new);
> +       __folio_set_lru_refs(new, folio_lru_refs(old));
>  }
>
>  #ifdef CONFIG_LRU_GEN
> +static inline bool lru_refs_is_active(unsigned int refs)
> +{
> +       VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
> +       return refs >=3D LRU_REFS_ACTIVATED;
> +}
> +
>  static inline bool lru_gen_is_old(struct lruvec *lruvec, int type, int g=
en)
>  {
>         unsigned long min_seq =3D READ_ONCE(lruvec->lrugen.min_seq[type])=
;
> @@ -294,23 +317,12 @@ static inline bool lru_gen_is_old(struct lruvec *lr=
uvec, int type, int gen)
>                gen =3D=3D lru_gen_from_seq(min_seq + 1);
>  }
>
> -static inline bool lru_gen_is_active(const struct lruvec *lruvec, int ge=
n)
> -{
> -       unsigned long max_seq =3D READ_ONCE(lruvec->lrugen.max_seq);
> -
> -       VM_WARN_ON_ONCE(gen >=3D MAX_NR_GENS);
> -
> -       /* see the comment on MIN_NR_GENS */
> -       return gen =3D=3D lru_gen_from_seq(max_seq) || gen =3D=3D lru_gen=
_from_seq(max_seq - 1);
> -}
> -
>  static inline void lru_gen_update_size(struct lruvec *lruvec, struct fol=
io *folio,
>                                        int old_gen, int new_gen)
>  {
>         int type =3D folio_is_file_lru(folio);
>         int zone =3D folio_zonenum(folio);
>         int delta =3D folio_nr_pages(folio);
> -       enum lru_list lru =3D type * LRU_INACTIVE_FILE;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>
>         VM_WARN_ON_ONCE(old_gen !=3D -1 && old_gen >=3D MAX_NR_GENS);
> @@ -321,19 +333,6 @@ static inline void lru_gen_update_size(struct lruvec=
 *lruvec, struct folio *foli
>                 atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][z=
one]);
>         if (new_gen >=3D 0)
>                 atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][z=
one]);
> -
> -       /* return now if not a promotion */
> -       if (old_gen < 0 || new_gen < 0)
> -               return;
> -
> -       /* promotion */
> -       if (!lru_gen_is_active(lruvec, old_gen) && lru_gen_is_active(lruv=
ec, new_gen)) {
> -               __update_lru_size(lruvec, lru, zone, -delta);
> -               __update_lru_size(lruvec, lru + LRU_ACTIVE, zone, delta);
> -       }
> -
> -       /* demotion requires isolation, e.g., lru_deactivate_fn() */
> -       VM_WARN_ON_ONCE(lru_gen_is_active(lruvec, old_gen) && !lru_gen_is=
_active(lruvec, new_gen));
>  }
>
>  static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruve=
c,
> @@ -376,7 +375,8 @@ static inline bool __lru_gen_add_folio(struct lruvec =
*lruvec, struct folio *foli
>  {
>         unsigned long seq;
>         unsigned long flags;
> -       int gen =3D folio_lru_gen(folio);
> +       unsigned int refs;
> +       int gen;
>         int type =3D folio_is_file_lru(folio);
>         int zone =3D folio_zonenum(folio);
>         int delta =3D folio_nr_pages(folio);
> @@ -384,7 +384,7 @@ static inline bool __lru_gen_add_folio(struct lruvec =
*lruvec, struct folio *foli
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>
>         BUILD_BUG_ON(BIT(LRU_GEN_WIDTH - 1) !=3D MAX_NR_GENS);
> -       VM_WARN_ON_ONCE_FOLIO(gen !=3D -1, folio);
> +       VM_WARN_ON_ONCE_FOLIO(folio_lru_gen(folio) !=3D -1, folio);
>
>         if (folio_test_unevictable(folio) || !lrugen->enabled)
>                 return false;
> @@ -395,10 +395,12 @@ static inline bool __lru_gen_add_folio(struct lruve=
c *lruvec, struct folio *foli
>         gen =3D lru_gen_from_seq(seq);
>         flags =3D (gen + 1UL) << LRU_GEN_PGOFF;
>         /* see the comment on MIN_NR_GENS about PG_active */
> -       set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active=
), flags);
> +       flags =3D set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT=
(PG_active), flags);
> +       /* use the refs from the atomic snapshot to avoid raced update */
> +       refs =3D lru_get_refs_flags(flags);
>
>         lru_gen_update_size(lruvec, folio, -1, gen);
> -       if (lru_gen_is_active(lruvec, gen))
> +       if (lru_refs_is_active(refs))
>                 lru +=3D LRU_ACTIVE;
>         __update_lru_size(lruvec, lru, zone, delta);
>
> @@ -425,24 +427,33 @@ static inline bool lru_gen_add_rejected_folio(struc=
t lruvec *lruvec, struct foli
>  static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio=
 *folio, bool reclaiming)
>  {
>         unsigned long flags;
> -       int gen =3D folio_lru_gen(folio);
> +       unsigned int refs;
> +       int gen;
>         int zone =3D folio_zonenum(folio);
>         int delta =3D folio_nr_pages(folio);
>         enum lru_list lru =3D folio_is_file_lru(folio) * LRU_INACTIVE_FIL=
E;
> +       unsigned long max_seq =3D READ_ONCE(lruvec->lrugen.max_seq);
>
> +       /* Keep LRU_REFS_FLAGS: refs carry access history across isolatio=
n */
> +       flags =3D set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, 0);
> +       gen =3D lru_get_gen_flags(flags);
> +       refs =3D lru_get_refs_flags(flags);
>         if (gen < 0)
>                 return false;
>
>         VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
>         VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
>
> -       /* for folio_migrate_flags() */
> -       flags =3D !reclaiming && lru_gen_is_active(lruvec, gen) ? BIT(PG_=
active) : 0;
> -       flags =3D set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, flag=
s);
> -       gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> +       /*
> +        * See the comment in lru_gen_folio_seq.  For migration, compacti=
on,
> +        * or any other isolation of a hot folio, try best to retain its =
gen
> +        * info. Ideally we would keep the full gen info.
> +        */
> +       if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_GENS)
> +               folio_set_active(folio);
>
>         lru_gen_update_size(lruvec, folio, gen, -1);
> -       if (lru_gen_is_active(lruvec, gen))
> +       if (lru_refs_is_active(refs))
>                 lru +=3D LRU_ACTIVE;
>         __update_lru_size(lruvec, lru, zone, -delta);
>         list_del(&folio->lru);
> @@ -499,6 +510,7 @@ static __always_inline void folio_inc_lru_refs_fast(s=
truct folio *folio)
>                 return;
>         }
>
> +       BUILD_BUG_ON(LRU_REFS_REFERENCED >=3D LRU_REFS_ACTIVATED);
>         old_flags =3D READ_ONCE(*folio_flags(folio, 0));
>         do {
>                 if (lru_get_refs_flags(old_flags))
> @@ -534,7 +546,7 @@ static inline bool folio_check_lru_refs(const struct =
folio *folio)
>  static inline void folio_clear_lru_refs(struct folio *folio)
>  {
>         if (lru_gen_enabled())
> -               folio_set_lru_refs(folio, 0);
> +               folio_reset_lru_refs(folio);
>         else
>                 folio_clear_referenced(folio);
>  }

Can clear_refs race with disabling MGLRU? Once the static key is
off, it can drop refs from 3 to 2 on a folio still on a gen list.
The drain then subtracts it from inactive, though it was counted
as active.

Thanks,
Kunwu
