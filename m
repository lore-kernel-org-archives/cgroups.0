Received: from mail-wr2-f41.google.com (mail-wr2-f41.google.com [74.125.225.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E6346AA8D
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 17:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.105
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790099694; cv=pass; b=L9ICq1hoxOrIhSgZai349p0eh3zZSpcXfwLT72ijIH9qu2D5xwuOpOD6Fih1LmC8U0oU0FLS3jX8Ryzk9XtNlNZ7spqNm5HB8cBrRwqUa38N48n+VKWRkbTqGbVFyJA8k8Sh6AhFA3BSOmru7oXg5icBuzQPZlSf+VfGkU6Bxhw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790099694; c=relaxed/simple;
	bh=vCKS13b9L1ieft7U9s9r3sFPnYyRl2ROpAv1bNkHIlg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kouSGlox+/1GXuDLZE9UimmjRPSWrYrdH3ZPWTWANKPVgiHB/tre2Bt33sucJmC1J36hZ/kn25EW3781a5/S2dAWteePSrUuTgy2vEKVDoprPOin3Vy07ZAPsN6ef/OBAiWoSrkeP44qYa/jKmF199xesF+mKahd4Xxh/39MiLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WvOsGxFs; arc=pass smtp.client-ip=74.125.225.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WvOsGxFs"
Received: by mail-wr2-f41.google.com with SMTP id ffacd0b85a97d-4834977ae75so158072f8f.3
        for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 10:54:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790099691; cv=none;
        d=google.com; s=arc-20260327;
        b=gh0wezgzC/JosTlPNMawfXuaK5NRj5tXgp/8wfK4Xf1ZxT7CgCBNHkNosUDrC4H2ew
         Lf4B6jycOahz1Z1M2RvhHcIYYVuyvjZvsn2EBlS6Rxlyqh7yZ//vlkTrhuntRSIoznHA
         sfifbywSC6AEJ16fVOVXB+9KVF4GFigWjFt1f8XV80hJx0OtAznx8C2RVlKhqfpeKdUy
         MCOflDeSUkgavM71+K3EN7iE31ZsWjxHht7MBk1jaMGtVsMKzim2Pb5i2AdzD9Ye8yJq
         wh67Yhl+wD5ffz5jTCBC+vp3wJMUhjimEYHHYImTTMc0iEFGL1XGgLbFk1pmeca+/jEr
         +B8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vCKS13b9L1ieft7U9s9r3sFPnYyRl2ROpAv1bNkHIlg=;
        fh=jIVv7aOBgfelFJEAS7kJPbguhQQWbCKc/JPDRcHLAuM=;
        b=pR0LFOsCHPMT0t+Ona8kg/8JRjb66i1ZUt97SWQwnstWp7sPjSNSWWXcaW9uJz43hs
         rsmraumRt6BQ6BcoffUNUiHXOgzFisPLzeozar7FEl5YHM1N1YhELdWOm7vjg5BRaDM5
         EZe3nqlS85gHlW1zSvaJy8NS36t4ob7HNwV0Prrm6oP23QFNib0lkMku6OzsKL7YBFnA
         2HSWBWp8yKWtBeScbjqeCpnGiYL6O4i70LSN1AoGWLKfXA1tALNWalc+L62ZwLLJLr6S
         uQo+Ns2W2omPvdGe3/c5xyNaH5MeC0YHCi1oiuQxXLnr5ck6V0nM73KzVzs0Cdcdnv7S
         10hQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790099691; x=1790704491; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vCKS13b9L1ieft7U9s9r3sFPnYyRl2ROpAv1bNkHIlg=;
        b=WvOsGxFsgJVCXhWCniB1+1/fUPjCCoob1j2KIT5KSLgafnkGlqAumAOIkqNN5K0Oje
         4WChBV7Ygz0z0SlMQrwUQcZkKC6LwqgRgpKEUJ7KUFA3dPCKOo7sOesofTM3mNDW/8In
         OkyX6f+EIY08ieRYBsAr+bCIjfRK9rwM1FwAg5Zwkmf/4QZqoMVxhYRHGxnZbwjFf7IF
         A0DU621cRSLkt3Dunu5Fk7VoJFbiUcPMetHIIq5zkiBBKgWNp+WSHt8PPPtwe1fcKT7a
         AjgsJ/febG9jVdkg4MB/ZGYyoNBQ64yuqYX2B9izEYj9Za4Qfqeih2cLp13s9rlNI2/K
         dbaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790099691; x=1790704491;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vCKS13b9L1ieft7U9s9r3sFPnYyRl2ROpAv1bNkHIlg=;
        b=hk918iJgPvVbFroLbJLEZNaoa7KBHdXvxVm2sSvYjYTq3433W6cC/Wj8Kz+YLk5IbE
         d9X8EclzgtVrNkeQLFPtQQT6b3GzRacqYI6jnUiqh85p8dycUtVfL4iL6E3OzVDN/l5K
         2zMUlkCOxd9lXPVDuvmrafNa2yLwGI3Zz2HaWo67QviRb5c0YVXwh+HnFERY6DW1mE3/
         pygkdCWt1q4dpfI/pf322q0JnXi7d8q5QdS8k5QKGCZMXk2T87PeVNg8bu001Zz/uOTF
         w5g1HcN4+htFCEjDR7gk9BduW4DqyueTyrDZiaMxKN0MeEsltBzHlL7F8a0w6iMKJtv+
         Pm1A==
X-Forwarded-Encrypted: i=1; AKwUvByPl1nPw0oeqkSAM5+k7FE+0qi3vt8APVa7zAj2TXx4FsYZjEI0wkKFX0VzxPRjQciwPR0Eq7x6@vger.kernel.org
X-Gm-Message-State: AFuF++m39dwQZBkdF9BNP4wvisEd6B8950lzIyzTdOILvcpMz5Yn8yTI
	zHVSniIK757DbKDF62lwRxjLTm29mIZutfQH7v+sJMzBrg97tn0UL8TYKrq64YdrOi4hVNU5C/q
	Vr2DiX6Z9MiBNAGyYNPvv1vs4Q5FsmQo=
X-Gm-Gg: AYBFou0O3HsANkXNzVPq/jovH+u0Jh7vouavHuVOhrrdwnG/KxZglgGajaTPWrSVAMC
	5VTyff3D3KGQBiYF7MwzQN+8cRo11goZHeYMrFIMEMhGhVUuwJzaBqRNuQi8T9UN+UZyzB26Zrb
	Yuns5MlwfBdQrBNMap8MVeSKa67dr+4eUfBGRldiF2ahzREb1g+WQ0Xl4DhE0Sfst2dyZriOtEQ
	2W3lOrpVs64L9XbnwTCT5posaHyOw75GQtTvXgJACX7PVtWDSNvUJxVTO3+I6IU7BWBlPoLQi1f
	WfvbddX3yE4AJ4OeubOP1NN6uqoE2Av+9zIqBLHwuMrPoTtYsVMvlxzpl383tR6OfJlRuJzdDdu
	wz3/Jcg4Afe4dqjZ9CkXPvA==
X-Received: by 2002:a5d:64e8:0:b0:487:40a:5ba8 with SMTP id
 ffacd0b85a97d-4886704c06dmr682814f8f.15.1790099690760; Tue, 22 Sep 2026
 10:54:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLZ5TVDAqEbIeMN@linux.dev> <aqP81aqNbwAbs2P0@fedora>
 <aqQrPLPXHXiuKup0@linux.dev> <aqjcFb6MFNiA6n4V@fedora> <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com> <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
In-Reply-To: <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 22 Sep 2026 10:54:39 -0700
X-Gm-Features: AclHuK8GLbQTZvdEds8LwHBLJi1-Hgl2pSvGmQlVhhpHqGOi40_tcpI9Kqsywu0
Message-ID: <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Chris Li <chrisl@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 20, 2026 at 5:13=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> That is not what I have in mind. The example I have in mind is that
> zswap is charged to swap counters. Changing that behavior will break
> our current deployment and that of many other. Kairui give some
> example as well. That behavior should not change.

We already have a knob to select vswap. Users can turn it off
initially, and/or update their software to handle the transition
based on this knob.

Otherwise, you'd never be able to introduce any behavior into the
kernel. Hugetlb accounting/charging is a new behavior, and there were
softwares written before that assumed hugetlb usage is not charged. If
it's not a good argument to block the implementation of hugetlb
accounting then, it's not a good argument now.
