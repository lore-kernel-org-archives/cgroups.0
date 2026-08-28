Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5908237DEBB
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 17:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787937261; cv=pass; b=ayjKn4JS31csYbUxTJ5u0lrndSePVeHLTbvZ8Hf78q2H//reXznL7pVyBEgaUiE5QrdTBHzjF8foznqlOURzEf+Z6lkiRlLxSGgpUt5zG8tzv2xDbpnIUsUhz5CxmVct3gHHvzAbetQxKgfCCA76xhQtdJLoNioGO3/KK923ApU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787937261; c=relaxed/simple;
	bh=RTw5eZPViX4U6YbuomM2SMnBYmpA9Wuf4cmaoazLpuU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GlRM4Excyu7lSr4NBsRjdQjcgkb2cDo+DRp2YxLxxOJuv5MtTg3ecuG7DieDKYTSgXsqglHhMYX8vbTMg4bpaFOA0Dfpe4ai7/x8Fc2dBXy/Ks6D9jYlWXfQK/zbYsT86rycX1nebSjv3YylSuEPmz3Ha6MUI/rBKxxZFJK7Bkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IgXm3bgY; arc=pass smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IgXm3bgY"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47fecbb7000so451491f8f.2
        for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 10:14:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787937257; cv=none;
        d=google.com; s=arc-20260327;
        b=ZOZ7veac5xzhi0Ycj+CfN2rolHWHFg/gQBHFtjO+YjOjloRXtaZl2E9XvBvd2iL7AE
         SpeXuVDJT6qpUUdi4Jop5BlhMiSSzZxiDmNlvfyqYTTkFQWEV4CwjSxm7osSFifH9lFu
         x6/mz420qrWVwvy3qCKsa+KpzTjcxnAhWZDMvKN1o3g/NJWnH3qC76FiKWqGf64nm3BM
         PKII84zCUfR9cVvne1mr3H/cPOpc3NuaWldnoXTxQC3qKCaS3BY0sROP7f7TDGAHToS7
         1J65ukfPJ7+GeWaZolbJPk8RIebTjUWqzmHPbipU9ADduIK2pnd/2WC5GyFM41so7Q6s
         yiBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fLW8KjG+1iJkxaiPEbmpBvUr0x4Qil1Zdzs/J2jlauI=;
        fh=W0q4Y2ki/dv8kWW6kInJMXXdpHrC8Aqx6fSHKfVxmFA=;
        b=RruthghGU3Vbt7cv9pMltfRHuxvQDwbVokWLM4yVrcOP2Ho6RNfdHgTrz8zEuMVAiU
         nu3iQ/ojrUEzJrmVqMrQNPDu3JnS/7U5XAdY0Kr95MkMW0UD8TMPAVyvr88teVG7PiqB
         TLUMJQAozHFVn+DPHF2QGUkIKpU54wFgH03CoLKHliBgJLmqgdOxvgKtjgvip/Z8QfLc
         mdofXPpB0b0xEPipN3aQWLlKr9kGqNxuHzWIPwIFtO/7GkE2zFqWTd27swuIJ3EUVLWS
         kgwOA8FzEYEJBAjlTLs7nqs5KiSuqNrWbBgsFz1VrZn6cpReLOhdJylFwLQoXkDGU/df
         EiKg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787937257; x=1788542057; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fLW8KjG+1iJkxaiPEbmpBvUr0x4Qil1Zdzs/J2jlauI=;
        b=IgXm3bgYaZHU/OuEB1CzwJkJ4T4UWKXbz6YQbLI46gKQmEHEo1o215LFVMzxKR8127
         mS6sZj/27figRw+OMbtn483mFrmIUKDzMmxPDwreFZrPi1PGs8eFsba+Pqa/msqvYB/l
         9QXsDDryEa2wFMQkKinig3EHpBelkorPntQlaf4YHywD8EdO7dCu3diSQNS0oPxbYQ6P
         /pnia78JJjKtVgusvSacam1uEnZfo5mwnNoJKeEJlg+xs4GVaBDWtaciy4jIiVh8C+9H
         bHJKCTe+zEKfkxL8F8t11h/jtEhoDe5JJkPoFKV33Ib2zZ6Kf0zBc0NyT+YACEhI9I4D
         1uNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787937257; x=1788542057;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fLW8KjG+1iJkxaiPEbmpBvUr0x4Qil1Zdzs/J2jlauI=;
        b=DLd20JBfVEJZqUWbws5wMJs6DArwpkkBc7oit9/GNVHbQ4tIzZRs4nN7gcMlAKMdF0
         g+/7O5sXhGOIrj0J0EBmzV/iORcVPWPsodaLL89fdXcs6sWGZ3oyBKj4eetKVsPd7XE/
         7gaeAebIu/1RP96DmhevkW3SOXgVg7wUPcRFIALvPorMcIHBYKrbBz5hSAfsTxFTubmt
         J/FirgYXkkB9iOiculEDY6iQzYXBLKFyOxCq4j3BBIy/p33mo5CJvK1pmb4T6H3jeZ+g
         rcrV6w+mm0zxw837XNSdAYJaJ3sP3GUEWuZ//c4QbFsBqeWdXYKNCm0KWzFqdRZxPU0+
         7FYQ==
X-Forwarded-Encrypted: i=1; AHgh+RrFIr/s0RKbakfIPr1+5QyN2g5nI7y1C86SGfcDJbMd/X3Vl7KWRwXQ5VsRO8YZYV9iWDCHShdY@vger.kernel.org
X-Gm-Message-State: AFuF++msI/lNl+w3+QLVNKBugNuOiZl6k9eLfN80kr9XvHNKzyg+KWmN
	9wU47+naVHaMUPj4z6N1PzOyyL9EJFmDJpzikaIJ8DstUpXYdRagEXjLwGHhtMzQGSY/x5GntSZ
	USRAvaIEhGiO0tA+jdBkrPgYtD/L6a+k=
X-Gm-Gg: AR+sD13VWJba0FwZHArfXIrYWKCm7zEf+gwFahxjZvrSPvwohMmkm7aed5lU7rozSwf
	KijKxxd2KrnIyduuKr9GfWyXwWxkdHfSHpWqeu9b6kfctcYOZJyRd+Rm3bAs0HsoXNhx9Aa5lC/
	zOrz+MlZ2ccJ2HamyJEjrZcS7O5q4LVGZc9c1UN3zlSsDAXL5GffIgmFp1UJkDFqTTx2yeGNDEv
	tQ95xJO72JQ/zuQpdTIdlfnjrorzuW/FIcHxKv7k7waFMXxmkjMGzGDZFF67DknHmAAGwkdB4cJ
	QYKL4stPmPzQMRLPX3+NSgC4MpI7Os+9MIycg5FemV75jFRl5mwinMjKHn0y0Oysrk4fwCF10LT
	9
X-Received: by 2002:a5d:5f91:0:b0:482:fbb0:a262 with SMTP id
 ffacd0b85a97d-482fbb0a404mr7651916f8f.20.1787937257283; Fri, 28 Aug 2026
 10:14:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260825153238.2695446-1-nphamcs@gmail.com> <20260827200716.97881447f243c4afd275144e@linux-foundation.org>
In-Reply-To: <20260827200716.97881447f243c4afd275144e@linux-foundation.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 28 Aug 2026 10:14:05 -0700
X-Gm-Features: AcwNN1VqRctLWtrJqo_bsUXm3dQvc_4Ji-SS_KiORUhzWLUsKtjvYyQhD1-JmPo
Message-ID: <CAKEwX=NdnBM7cqbO3rSsUB7JFZK6DBxNMFbpGWgLh5m6M7yRXw@mail.gmail.com>
Subject: Re: [PATCH v4 00/11] Virtual Swap Space (Swap Table Edition)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: chrisl@kernel.org, kasong@tencent.com, hannes@cmpxchg.org, 
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

On Thu, Aug 27, 2026 at 8:07=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 25 Aug 2026 08:32:26 -0700 Nhat Pham <nphamcs@gmail.com> wrote:
>
> > Currently, when an anon page is swapped out, a slot in a backing swap
> > device is allocated and stored in the page table entries that refer to
> > the original page. This slot is also used as the "key" to find the
> > swapped out content, as well as the index to swap data structures, such
> > as the swap cache, or the swap cgroup mapping. Tying a swap entry to it=
s
> > backing slot in this way is performant and efficient when swap is purel=
y
> > just disk space, and swapoff is rare.
> >
> > However, the advent of many swap optimizations has exposed major
> > drawbacks of this design. The first problem is that we occupy a physica=
l
> > slot in the swap space, even for pages that are NEVER expected to hit
> > the disk: pages compressed and stored in the zswap pool, zero-filled
> > pages, or pages rejected by both of these optimizations when zswap
> > writeback is disabled. This is arguably the central shortcoming of
> > zswap:
>
> Thanks.
>
> I asked Gemini for a tl;dr and was told
>
> : Introduce Virtual Swap Space (vswap) to decouple swap entry management
> : from physical disk slots by using dynamically allocated virtual
> : clusters that back swap entries on demand via zswap, zero-filled pages,
> : or physical disk.  Eliminate wasted storage space, remove the need for
> : static swapfile provisioning, and enable in-memory swap features on
> : diskless systems without degrading performance.
>
> I'll take no action at this time - let's see what the other swap
> developers make of this.

Hi Andrew!

Thanks for taking a look. I'm also waiting for review from fellow swappers =
:)

>
> Sashiko was talkative, as usual:
>         https://sashiko.dev/#/patchset/20260825153238.2695446-1-nphamcs@g=
mail.com

I've been going through the sashiko review on every iterations!
Hopefully the list will keep getting smaller and smaller.

There are a couple of false positives, as per usual (the first issue
for e.g was intended behavior, at the point of that patch at least).

That said:

>
> There are a few pre-existing things in among this, They look legit to
> me, from a quick read.  SWAP_USAGE_OFFLIST_BIT should use
> BITS_PER_TYPE(atomic_long_t)?

I think that might be pre-existing. Maybe we just have not seen users
who used 4TB+ swapfile yet?

Might be worth just putting in a quick fix independent of this patch
series just in case.

Let me see if I can quickly whip sth up :)
