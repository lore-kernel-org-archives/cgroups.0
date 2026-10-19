Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E674F3EBC
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 12:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792413337; cv=pass; b=khd/hhSYkvNivJlaw6LhBS4UAw5X6/FYHUqG52kJMYIZ7GeehlTvExGWECSNFFp7qzFarptq4SVNeb3znoMt80g5YqyOUpMGMq0gj7LbtbfIQRfgvOFiyhT+8varDoGeRwwjjY2kaMPZFvvgRP0XUVP6a2jobZS0jRoty+gLb/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792413337; c=relaxed/simple;
	bh=h2JbWnV9rUc1EeFvFy7Tjt14h2irL2wrPatMAzjOJ7w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AnP4WxxsZ2aSRjZKDSYffhvMl9ydIyGp6+uCLf/9+nTUEacs+zpc9llwUIpIG7Inw+q7vUMnidEVwZvW+ATVrtSmMXmV1wMrHRYLr374ZZfubVOBoVmLpsw9rJp44YeQXKT7z/+hCtSY2dBHi4r5Q438fxECphq2exJOtNK+e2Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lTvgTBaM; arc=pass smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lTvgTBaM"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48b0584ad71so1392201f8f.0
        for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 05:35:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792413323; cv=none;
        d=google.com; s=arc-20260327;
        b=lu88UoKmbcnB1E8jkYFCiQNOsBMqmB8YXXWTO1g2BiPudh7lkPveTLj3y77Rx/uO2L
         HSbHNlPRT611zGgTcGF7SbMvxaQP0+L1jrdoPxkoLwgaqE9SbAYmgM36BH8VnlYyrbpk
         /9pf70fqlEq79jPxlm9drhyOIvXl0jnik4JrDEP6KfS1qPbWGqfGkQ/2HGwfbPcNCvvF
         2RA10CIXzkPf/8B6/EfpbE4R07Qs0vUwWM6lO7nlo0vMU4yZmpzRhyfAhXd2KT9jO7Gp
         RHd6b2foVMS3Krm2mkNThdaA0OfRx7+e+6In0FsjKl2V6vG3TaTt3wFHUBerrU3ImWOL
         whlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h2JbWnV9rUc1EeFvFy7Tjt14h2irL2wrPatMAzjOJ7w=;
        fh=YFOtvYAloBBGixQdhati84XvdF8jyYEac0otnngo6VM=;
        b=KBa6YlceUuPddW6Qi5JffzJ4rWLDgV8MqDI5koRaR8Wd180MtKXgDvrDjXOBZXSLcE
         pdMptIfHo7a2zLNcsOf6yv60y7PE/D5n7Fi6Afp//8bt7Zi0ymn2xCDlkRKWfgYOlMU5
         eCzUeWtsQ4D/XFneUjEvRn9d6rvp1O5RMo6PnZ47dFhH2z3cVFauQ851GTFeF+Dva5GF
         Fzn4cQ3mzZK5FrRvYzEtEijT+fa7nmAwHaFXFIbYmPYBFRZ95yZPbARSkVkZw933yPAT
         c7w76+VjDIMb2k72MBeo4zF+bJBR7YHbJGQjnskCRhs8NTHp40PNo9OROr6wZO8FYU6A
         RCCw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792413323; x=1793018123; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h2JbWnV9rUc1EeFvFy7Tjt14h2irL2wrPatMAzjOJ7w=;
        b=lTvgTBaMCa4ZKG4V6wMLE2eP/d7WRz7sxcNslCTgjSzmzn7wxfsLAZGIw2FIkasboh
         06b5zxWkhCcKg2YQ4KLKKaPhfwT1CzyVn85Cg7RxE0qnE1K+OtJGicUqiByHoo2DPcKt
         2MZpI48UuoaK0crE+VsMbkHty1XqZ7gVlt4mWpA6LyCC+L2frjakQ7a5Fi/T2csjqrEh
         ISuIzLpLAdXyd0CjRA0x6B71oXWjsIYKJ9e1eCUT7bq2ndNSzQLNJ6/O5rYbDoyXnjvS
         6a7gFPZ5kDLxZtpqMJsSRzaoHTtUbUNa0Tt5mcu2kJkczGE9B9wYjxPC2UpRQFDzgCNq
         Rsdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792413323; x=1793018123;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h2JbWnV9rUc1EeFvFy7Tjt14h2irL2wrPatMAzjOJ7w=;
        b=fD9fxDhI9wLC+anpbIinaTSBS5ycyDxAoY8IBqB7nURHQEEXUYG3zC4gbtypg8tGzY
         6SmAT+65NFPTxu0xInbZBXG8A6FkUE9NJjfGgl15sLyFWj0iBfimX7cXo9O87lQtXvwB
         8jgn7uTiCHVVzyD5UiJz+oy4eGCy+AyoTNiuB8XCzB97Ron4tk+qPiZAA/TanOKygAi5
         QosKANF2DIGzdmZ13a+gc6LR8inIFA7wP2NG0UxF87oSlf0BdQUNbefwIqxqVBYbosaM
         yjmxw0MRfhwsYVTLy1opFI4ztg0deGQ8zmsBsw00i3Zuvkq4BgvlyuUNb9ZqbWi+7UCJ
         rXFw==
X-Forwarded-Encrypted: i=1; AKwUvByiyEP7gpgh4LO1VnUWe/Kso5yjBDoxiKbs0vOvZWPPj2oyBKjae3HilGAG0A/+/YLmrnJRkRvN@vger.kernel.org
X-Gm-Message-State: AFq9FYIn0gyPAD7e9vKZJ0jpIskK9o3qrx1Q4dtyTFdjaAEnjXrS7z3P
	HQZ0vEDvKLaM7QvhXJV6+IA8X4us5qaYq/3et9nEyka9je0Dt1O6mJH6xrt23YdwXGegYWoticJ
	oodxV3t1OShDiMHhp43i987qqjjUEtGA=
X-Gm-Gg: AYBFou3OAjGazR6WCudEhO+rGf9kGi6MQ2BAnJK3WD7sH+XWhM69eCeCyj2CC7S8Qm6
	DiDRuzhzygAZQ/+bkeMEDgpcgDuqy81OJWpI8zHsy/FtQb4d4QSRh6P7hqVf54OZRjXY3vu6w76
	Z1bP5qC+sD7RA/uR03eAG8k1ihElpvOzR9NdtQhZhc2KQomu7Sxw09xKoRUEFH0dIy9p6TxC/Ur
	gquuVSgf/EKywGFovCFiAw0xOPTtMxnFK1yciRk3WNwfsvVuMqcY5qIHuJaWH0lYbPfHvmHBgEc
	uDp65Gc9Wc7WBKXGoESmMf/Fh+smols4GBPjUxcNYJpnB/913XRx6ZqO5zstUN2ELtShv0U5sx4
	z+0YLH9bwHafohQfoF61F093b1Cx2WNclxF3Cze5YnRDHwzeh+4MCXUcAkSenvAmbrYjzY1A=
X-Received: by 2002:a05:6000:220b:b0:48d:ca32:e90f with SMTP id
 ffacd0b85a97d-48e07fb8457mr14720830f8f.55.1792413323141; Mon, 19 Oct 2026
 05:35:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com> <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org>
In-Reply-To: <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 19 Oct 2026 05:35:11 -0700
X-Gm-Features: AclHuK-Ym9EzJ2CIcu1okawbU1UiB-xvQtvgaUvkzS7VoDFrSu5HhWBluHPj1QE
Message-ID: <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 19, 2026 at 5:28=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 10/19/26 14:24, Nhat Pham wrote:
>
> I'm traveling this week, so it's a bit tricky. I cannot make Thursday mor=
ning.
>
> On Thursday I'll be traveling back from Cambridge. But hang on.
>
> My plan lands on Oct 22, 11:10 PM. I should be home around Friday 1.30am =
- 2am.
>
> I could just naturally join that day.
>
> So one day later would work for me.

Would that be too rushed for you? :)

For everyone's convenience, this would be the time slot:

PDT: Thu Oct 22, 5:00 PM
EDT: Thu Oct 22, 8:00 PM
Europe: Fri Oct 23, 2:00 AM
China: Fri Oct 23, 8:00 AM
