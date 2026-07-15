Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AFB3ACEF6
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 15:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784129552; cv=pass; b=XdBUKt1cpe9MyQt5c6Qrxy5OFbn8WU0H8VWOBTjo/j71LPgF9E3iD7fw/0fBLSi4kz7+Haq/v/P+qEhs4J7j+ClFdVMr1lxQbXWHn5ThwkXfgS+lDW8XMOSz5Qhrxbh3XSaziN9eDOZjCKmbBUmpIzor7T5t5AAz7nAmkkx1qnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784129552; c=relaxed/simple;
	bh=Oc2wQrnGBdzNKBn+SnEwM9HLZncjNfHx+xJFt+jCvAg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dFtZiGEMOHsaEXFbSs+vT1iVx+jaO2KkaAXyAVrw+Keuhg6JrkkHEAo3fEwlaJ38LLAT8TX0/NFqc4lvO6kK/5zk3XQiDyI0FUcbNfGD94IXPvBK5NyhW1d5oQjI3g2a/i8DpGdup+1HejubtJXyfp/dXZ14B999mc7DPl+dg+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G6mPl5m4; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G6mPl5m4"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-69a19eb2e6dso11529a12.1
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 08:32:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784129549; cv=none;
        d=google.com; s=arc-20260327;
        b=obM1Jc10olT1k8uRz5C7QwmbybrCjoJmBT84hENUzgs00sQM7Jsv9NLhaV+H50zgvu
         qdMcRWI+4p9Nyx0u7/BjgKtGx97ZkOiPfENkjXE88owT4vxOS+sp5ZUvqBzH5LUIMp2z
         XupmzRdmlJlC+PFOlSWQVhl+XcoGJ6SxW65aAK7FsWui/OcPfBMAoh1cTvZaFZbO5XsF
         kUHlZLiKJaPr4MhyfjzWVJdMcSrVaUH+7lSccMaTmFjd5fkhqygKBXtn4pIFGWLMJDrQ
         wnUKuQrQSYH43MS2Zoc82935jN1H3A2ebym2QzjlfT1Zmm01vkJJd9Xy0H9YsPMRfUc+
         mN0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=o+EmL6ul0Mt4yc97Q5opSK0Zr5dXjXkyP7dXXPr3OPA=;
        fh=wyhPxoMqt/vGtNRJsnTYB5Tn7yhEe01zIvrFf19rJLI=;
        b=eX5LSEksF7F1KJDqvDfwILmqRDROFozSZYFpAIBFS63Tm/TLoftx//bMXbYQ1XBvq5
         bAXewyaJpkWAcBsdYWWABlIfn20EcCWLpNXujKNq2Lm2g8hz5rK6fpw/YzXbrkTsDSKh
         Z0uAycblZfnyUOQQWsdCTSVnWN3sBP3Lqooq+TrFSvhN/wZ3qi9jSPod+5HTqQiKQsx7
         os/MTn6UdkSWdDTGm7tGxrMoObnx+d2UjnUvARYDDR4RpCzw17ZpXm5ZytusG9gLa14u
         6zBtikjng24A9ipom1bKQdtoqsBjtgb8PclQuBCVJwShk9F0lysqMK9e/W4AOdffBI0a
         ozZg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784129549; x=1784734349; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=o+EmL6ul0Mt4yc97Q5opSK0Zr5dXjXkyP7dXXPr3OPA=;
        b=G6mPl5m40yU64Ume4KBhk9X4LqGQWIhjeitFPlngApRk9OLpcWBEC3N0vNhKv/c3pw
         lQKBrQbS59k0bL6o33qd2VkpyUPLpLvl4gDqYRNeGgdcb2xUTEdzFYfJkNJhhPTjEFtj
         i9k49BB2vA4h8JMVFtJ0TDkGn4w027dWQ2++hOKUzXFLuHwIRuX+QRe278lIim3fvY1O
         s9hWNMuNOqab/ziDUG5pIpmDyfFjTd5Cf4AqlHwxk4c6ac5lPbIbAG7hI6CWuqef+w+j
         4ZnxytPFlOWcauCSmd/uWqriWc1FaMrf35yKVp7Shysl4NOi2zlKPWiA9raZoKXeSpRX
         cBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784129549; x=1784734349;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o+EmL6ul0Mt4yc97Q5opSK0Zr5dXjXkyP7dXXPr3OPA=;
        b=o/p4OyduS8Q1YArydF1hY07TOGHRgt4wtCrYCOxSAF7LYMu7/SMvAoEmfaWhWxILOj
         US/se1jE3MesYJ9cMuDvKg/nN4PZ3nzIlzgw66YQCqMJIWlPhvYmlQnSNvg3n9lAil0b
         Q7KbyC33C8ZlwE6hWf82spT5g8ERI1cxc/SvAR+xuhKbkKNpV0/ZnfEwxRJWGkovRR/f
         r63anZiwihF6FgzNT8/fcDUCEpe5VWny6yPhIdIj1WkssvI8BY0Vsk+EJdjkuMFR4oJS
         y3WNlP65b2cFyM850WVxJjGWo7/GQzKBRObrSuDtWQCDxXbKZ5iHjAiKHk1gwdR4mavp
         88eQ==
X-Forwarded-Encrypted: i=1; AHgh+Robyo9Fagh6fm9eUnfFdXWDG9RmmX/EcftuPtcOmpwgfUE8Tow3kf/tMtOWDtYBWOmyLnT47KvG@vger.kernel.org
X-Gm-Message-State: AOJu0YxBPjxRmKf+7XDIDOqr82J8h5myI3e9lEty4HDNyaQ/vQx2RfOK
	CHp1rSjt/jLBj3k0DmFGuZqPjdo5oA0a/SeiWKHTqKfpG+0HW8g5tMpF3kHBRpRCAieT1Qwg10D
	t1+Une5jfSIgtfRW2os9apoH300L3gm9TgQY63t0O
X-Gm-Gg: AfdE7clJyCTti3zkuPG3Tq3VPf9YE5m0kUfdoKBqIimBGPhpGXJ3Aofi9NwLWB9b1UH
	uf+oloSPspeDi28HWgI68GM21GlUThWoXAgAthzcVXW0xeRUeKhTIivj5oySPkWtHjV5/ZBRMtj
	drrptOaXHPLn0KMK0yH5NNSs4ohKuupezqWMUARElaERXaiaTYm9e1Qfd71iYWpsgodPdsznhrJ
	+lQWr/PsNHINvx8eprcbsq987aZFo8knchIVUdKHFyzntVf0EecMztRbhkD2DCpWMtMbKGPAQOR
	Xu9qe80Zf4hTo3gsy1E+ROC2WMo=
X-Received: by 2002:a05:6402:a39c:b0:697:e82f:e4f2 with SMTP id
 4fb4d7f45d1cf-69ccf08bba4mr183091a12.4.1784129548768; Wed, 15 Jul 2026
 08:32:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 08:32:15 -0700
X-Gm-Features: AUfX_mxQK59tgAAh8WBIpXQKDElc_jbLM3NvO9a2ZdZbwnoad_i4PU5FH57YufA
Message-ID: <CAJuCfpEVQU6s58s9XWCVDUXzr=7bbatmCi35vxnSiyA1pe1P6g@mail.gmail.com>
Subject: Re: [PATCH RFC 00/12] mm/slab, alloc_tag: reduce obj_ext memory waste
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 15, 2026 at 3:10=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> The recent fixes for objext array handling inspired me to look into this
> finally. It's been bothering me that the memory usage of struct
> slabobj_ext depend only on config options and not whether the fields are
> actually used. So with both CONFIG_MEMCG=3Dy and
> CONFIG_MEM_ALLOC_PROFILING=3Dy there is always objcg field and codetag_re=
f
> field. And thus:
>
> 1) Having memory allocation profiling config-enabled but not
>    boot-enabled means wasted memory on unused codetag_refs. This makes
>    it less suitable for a general distro config and the page allocator
>    side doesn't suffer from this, only slab and percpu.
>
> 2) Complementary, with memory allocation profiling enabled, there are
>    caches/slabs that don't need the objcg field, so memory is wasted on
>    those.

It's funny because yesterday I started working on a prototype for the
same optimization. But your patchset is much more mature, so I'll
focus instead on reviewing it.

>
> This series should solve the point 1) fully for slab, pcpuobj_ext
> handling can be perhaps improved similarly, haven't looked into that.
>
> For 2) it avoids allocating objcg fields for KMALLOC_NORMAL caches where
> we know they are not necessary because kmalloc() with __GFP_ACCOUNT will
> pick a KMALLOC_CGROUP type.
>
> The named kmem_caches are tricky. They can be created with SLAB_ACCOUNT
> and then we know objcg fields are always needed. But also they can be
> created without SLAB_ACCOUNT and then some allocations have
> __GFP_ACCOUNT and some not and we don't know that in advance.

Do you know how often this happens that a named cache with no
SLAB_ACCOUNT is used for __GFP_ACCOUNT allocation?

>
> A possible future solution is to introduce e.g. SLAB_MAYBE_ACCOUNT, add
> it to caches where we know __GFP_ACCOUNT is used, and only honour
> __GFP_ACCOUNT for those, while warning for an unexpected usage
> elsewhere.

I wonder if for such caches we could create two separate caches, one
serving __GFP_ACCOUNT and using extentions containing objcg and
another one for non-__GFP_ACCOUNT with optimized extentions?

>
> Only lightly tested, need to run at least some microbenchmarks to see if
> the now somewhat more complicated access to objcg is visible or not.
>
> Based on slab/for-next-fixes
>
> Git branch: https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.=
git/log/?h=3Db4/objext_split
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> Vlastimil Babka (SUSE) (12):
>       mm/slab: skip kfence objects in allocation profiling
>       mm/slab: remove objs_per_slab()
>       mm: move struct slabobj_ext to mm/slab.h
>       mm/slab: make slab_obj_ext() determine object index
>       mm/slab: abstract slabobj_ext.objcg access
>       mm/slab: abstract slabobj_ext.ref access
>       mm/slab: replace slab.stride with obj_exts_in_object
>       mm/slab: change struct slabobj_ext to a union
>       mm/slab: introduce slab_obj_ext_has_codetag()
>       mm/slab: reduce slabobj_ext memory with allocation profiling disabl=
ed
>       mm/slab: add slab_needs_objcg() helper
>       mm/slab: stop allocating objcg pointers when unnecessary
>
>  include/linux/memcontrol.h |  13 ----
>  mm/kfence/core.c           |   5 +-
>  mm/kfence/kfence_test.c    |   2 +-
>  mm/memcontrol.c            |  41 ++++++-----
>  mm/slab.h                  | 169 ++++++++++++++++++++++++++++++++++++---=
------
>  mm/slub.c                  | 162 +++++++++++++++++++++++++++------------=
----
>  6 files changed, 267 insertions(+), 125 deletions(-)
> ---
> base-commit: d9e6a7623938968e3752b67e37eaff097e559a54
> change-id: 20260714-b4-objext_split-da82426257d5
>
