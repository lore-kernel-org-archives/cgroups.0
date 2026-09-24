Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C5F3C37AF
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 16:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790266837; cv=pass; b=gU77TpVkMx3B9BFzFB6b4Ol0+eSTw0MhI9z/X7m+QcQoYRrx6xEoQKaRL976TAJDZv2RHfN8WnQjccIljqRWi/QeP1lZfFL/OtTNcs7NqIDfCSU0+eLKmNKuYbB0yVwswa6598cs54hiGazllvyJC5eifFHitty2uut29Jf97xk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790266837; c=relaxed/simple;
	bh=RSp2l1x3VML/TUH7NBwrx8HvLT3W4YMiteDUtD6oAoM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EacRfWSzYiGQ0LOKyYPlgQBeMAawE6aphWiL1fT0mRjCWapsmvirIM0PkszKkBTtTSV4q8E1CzXniZKHY1ZL6uGFyjJFbczLxk5stoqz6u5TxoA0IeDFNzwz2DMuyZni2IEQFcJa7FPnD+m+ThCJQiLg4veNhS7P1AsGbWbw+Gs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PCpCDWgX; arc=pass smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PCpCDWgX"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485984ebf5cso741f8f.0
        for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 09:20:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790266834; cv=none;
        d=google.com; s=arc-20260327;
        b=PBYxqBiqQ47ZGYrH5FSrTiYZFbKhU8GFgDoATHocjmpp0+m+K/Ng3wSnPvUwtJ+RT2
         ecIVTe6CmPteqfPn7w58oSQAS6AR+t9xlGuiyvTVWKYfGzdquIxMQahRC1LM0D+NrETC
         yuRL+gDFGCOAjGkmbF7ESynnNMv+jqepMZaJAaYHh/RP2tsYb+PaILcdqOL2dIAFmcxq
         Kq2RsMavaVTU0h5bJo0T1trvq84e9ZHgGqOL7Gyn2JdSg6gsf4NAb4YE6RWDT4MMjmr1
         7UHKbA4/fT6I6nEt0FWRlBQGhkg9Di5k3YLHzLdBjQXpPAM+8/d6WnSYyYB9nLIr/IB7
         WdAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Y4C/eEY5hpNw6IZ6GmmYyn13brOMotH1yARGM3FuI/E=;
        fh=R3NBfq9ERlgpqUURAR8R+pxRVc4/q8IOVpHNHnuEzaQ=;
        b=Qz86dL78IaeC4d/0kE+8DHvdaKMOGbSCeco/500Q31ZwmAx+UO5SAvRn7KRFDeA/o8
         +odCTW7fRdDxtrPunjBC9Sq07nTs6ut0A+CCMim2Q7maJYaGoNeJbsLD3kW/HX+DKHJK
         Y/pt4iBKUYt+sHgmdTk0KjwVLt9NGCmynCzxLgb8PNruFY6cNN4/SsO3NqD7TAQbIxk3
         zuKERDvltwA43PwtVgQGEjLcuSLfY62G6EHUDhEg8QSEVJW0iTiKBiRdWWngzCdwR3k+
         YGTAhSArw4pcyYA292jOuWaER0LcfL/MHXtICzcuOtH7sO6PqW2KTeYDzzbDe6U15Xag
         0fZg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790266834; x=1790871634; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y4C/eEY5hpNw6IZ6GmmYyn13brOMotH1yARGM3FuI/E=;
        b=PCpCDWgXouIzhtlsM1Cz/m22yXk3HLuDl/7iiEUVUQXb8dalyr/v+itsCLjAM3YU8m
         eAMbllXGH9dncQnIF4y35V3EnJCmKQMF+QGLHyoo0Ck102zKYF8l+O0RoUXq4VHWKKbw
         feTuDO9Fm1PmhpuosM75c04GnAmPGH5oybiaHrPFARtpdYKKeQMtf/Y/aV29/vw15BTJ
         mkNc01PHDd7BU1nNWb9H0b/1SAFbJspaTY1+K/roQqc5iJmL/9W3ByrRj6OtXjWxhOhT
         cE+KkUwWavN6PvWKvIseyDn/w0JfNWH2F5OzfnqP6zIclBexkEMQOicMq7P8nbnorDM6
         yrJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790266834; x=1790871634;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y4C/eEY5hpNw6IZ6GmmYyn13brOMotH1yARGM3FuI/E=;
        b=i/XHVPK40g35ssxx1Je03JrLVXyEC1CtB8y5MkVU6u2MdwhdktxD4ftJ/j630pU5wJ
         /RXRklXntdMbQ+Q4Pl2JxnXePJsW8ePW802X84f/iTx2XDDah6eAoVNYtOPV5xus+49z
         nwCTSYQYH/nE4sqZU3YFSlv3Qbapq24P41dB6RS19wYEIiFbLt1a45Ur1FepRWBlmvsF
         0fI1Khzbk7NyLg97gvNj7mi2tkxRoCNgarawikLskaqkByqf5nNOIBtlagMa7umfjMgb
         Wp48O1s6tlZ3LDsTCrGSgkELUBoNKYfOny8YF08yNyKWl/QpPEJCCxJHnVDI8PsLSWVL
         fsog==
X-Forwarded-Encrypted: i=1; AKwUvBxql8xI7tvs5v6iKAWvHVD1wUee0DhiGbaosZ8JfAeVKMm0etFs+x853PdqVsCGAXBIZQN0ykCJ@vger.kernel.org
X-Gm-Message-State: AFuF++kbv0VhILiuU6xFqitQBDNgcShOyF8TsI5ur01nmqvLx7RSNZ/G
	pBH37fGXs2ru1hRig11/sLG+SFEX768CrHXiRQC8fiba6wuDik6d2IxDVPxMlynn8So+5rtMw9D
	N6wCsDQCeLWre2g5C02gEZYAhEUXPq5Q=
X-Gm-Gg: AYBFou3NOU9fcKZ3EpEqsBgAnskA4jpDNDycdqo2fxT0DFpC+6mR/rY2LJZ0+tJ3vnw
	FayXcQEHWPutVCLoUjwSGpEnV/NLrcuFCzhY5Hk53rC10lqTgrU/U7TR81gyISgmEvwx9NvgZQJ
	Y+ehNFT7bKe76hco+mJJEDhPa2jLtZ7J9KSUWjXvLCdj488BMYOhiuV2cqu7EiUCV6TeyrFeisn
	cl7kzx0qiuymVsb6L5pWDsEG1lxA/fJX7btTF5jD4TjI0qCQwBQ6UQLzlD/Xg4ltiNSOjnOh42+
	DIEJq5+Tnxn/V535bAi/2W+pyvvUZcssTZ8SOTDaWs9ZFLR7OdWZbHD5bcPhfhXq09wihxErg6K
	1Hk5DU8k8fA==
X-Received: by 2002:a05:6000:26cd:b0:486:fe8d:298e with SMTP id
 ffacd0b85a97d-48872ad7729mr4973566f8f.53.1790266833368; Thu, 24 Sep 2026
 09:20:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
In-Reply-To: <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 24 Sep 2026 09:20:22 -0700
X-Gm-Features: AclHuK-lGJJsKLxr6Qb-y2IvmlUpoUB7yhNg4AVw4NM-rENBoqlMKdnr9zU6afg
Message-ID: <CAKEwX=OP3Gb9sVOvch+p4j7quzgy-rUY=UTZau5ztMj7heJJoA@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Chris Li <chrisl@kernel.org>
Cc: akpm@linux-foundation.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2026 at 2:18=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
>
> There are too many swap_is_vswap() in this series. It fragments the
> code path, making things harder to reason about. Esepcially around
> locks. I count 22 in this patch alone.
>
> I consider this the biggest drawback of this series. This
> fragmentation of the code path.

This will mirror my response at [1], but I'm responding here for the
record and for your convenience.

It is needed because vswap *is* a special device, with its own
requirements. If you don't special case-it, you'd get undesirable
behaviors.

Let's take Baoquan's patch series as an example.  It treats the xswap
device as just another swap device, without any special consideration
for it. Which creates several problem:

1. At allocation time, cgroups that disable zswap might get an xswap
slot, because you don't do any check that the device you allocating
the swap slots for is xswap. At swap_writeout() time, it is *stuck* -
we already do the unmapping step, so we cannot reclaim the page.

Ironically a physical swapfile backend could have bailed us out here,
but it's not in that patch series yet :)

Vswap both has swapfile backend, AND allows you to bypass it if the
cgroup disables zswap. Both involves a bit of swap_is_vswap() check,
but I think it's worth it :)

2. Per-CPU allocation caching: since all devices share the same cache,
xswap will invalidate the caching of other devices, and vice versa. It
would be fine if the these devices are interchangeable, but as noted
above, it's not, especially without physical swapfile as the backend
option. So you're forced to taken the slow path more often.

Vswap gets around this by adding its own per-cpu allocation caching,

So by being too lazy and not carefully distinguish the swap devices,
not only does xswap not work for the writeback use case, it cannot
even work in deployments where some workloads (cgroup) select zswap,
whereas others select disk swap. It can only work if you intend to
have a single class of device - either virtual/xswap or disk swap -
but not both.

Maybe instead of just grepping for swap_is_vswap() and throw your hand
at the complexity, read the code and try to understand why it's
necessary first, then propose simplifications if you have good ideas
in minds.

>
> This is questionable. A vswap device does not go through swap on.
>
> This changes the behavior where swap devices always go through swap on/of=
f.
>
> I wish the swap device went through swap on to be able to start swapping.
>
> Chris

What usecase would necessitate the need for swapon/swapoff interface?
Other than just trying to shoehorn it to an existing interface?

I've expressed why I dislike the interface in [1]. Other than the
sizing aspect, which we are already discussing in another thread,
priority also makes zero sense. You are literally exposing an
interface with only one correct answer - what's the point?

Justify your interface choice with real userspace use case, not just by
conforming to the status quo.

[1]: https://lore.kernel.org/all/CAKEwX=3DPEEkYiNRaVhCuM4E6mxB9huPKfkDa4m62=
VMTzedg1oYw@mail.gmail.com/
