Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F0F388386
	for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 07:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876605; cv=pass; b=bRsEVkuQjLJ9gZSupEwUnVEalT01kciwN4R81RSMOyBU1+5OFib7cu87vQ4e262JFvOiNNXqtFkR46UxhrZjfOCYYmOxQTIwUG3S6M0gw7mPbTxpR3B1g9eNHd13MS4Lds0HncsRZbFDPL488fkoezwJRvngaNJDjk+Uk4D6UOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876605; c=relaxed/simple;
	bh=LMlaPCa3d/arWqeRwlC+t5cG3O6QIkmaLOfj2qxbG6M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DzUPGPa18v3ata5QGfVYV7Gk+Ef4qF1CXfcJExxPvI4vaCzERD+b/0sPBN0RCH8NB8tOlNYc9A/qY1ZxUTrHoY5ZIHmmW4KiJA9gaE/mzgY5mrGWSb+WJmX1UoxqyaYf91XSMdWxtbQ3S8k6LrXHoMfbNP5/LslHKuUy8bzCobQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com; spf=pass smtp.mailfrom=shopee.com; dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b=CQO6MmMn; arc=pass smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b="CQO6MmMn"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-154e9d2d979so1776520c88.1
        for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 00:30:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791876602; cv=none;
        d=google.com; s=arc-20260327;
        b=bz+8I5y+ER8PHKj+9dUVJ6ZPzWScqN3TDCfsR/LJkB4vBZnCK6Cy6MCUaJaQJC2Fs7
         c4wNyEuwhdefij1dPbSh5KZYkb5+4wBxETBOX8lL3A9oJ7kLw8hYp5zCAsfUm2FifGOa
         +fUbJ0nz5cIiyirNoO3TIDWI6JO9MEZQKxJXNmgFfJIkDHX5nOc7rXywyDsFGv/BvTzy
         /aIrrjm/6b/plniQjVedzvv4/bjX05R/5c/zy50dEed82u/rTCG4jf59UqlfON3lxAm8
         kt0kXTGFvF/YxSdmgzNQ2lMzvKVbmebOLTooZzG2dyJw/Sg+PqbY+F8wXkVuCch1pr+n
         kUDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tC8SBrxY9rjxL+sOaV51qeAfEaErpyiM6k+xmWhrmnM=;
        fh=tm83xfadGOtY+6uZqcjkZ5gaOARq3sNRaQApMiW94co=;
        b=e917mb4wWz8vSXVW3NUm3ROsH8i91L3fbTUcy4UaiZiPj5HTPxSNvJT5GSElT5q3UA
         ugaupWmt1qbv1cDkHMiDwqfjcpzXT780HjJ/d3ZaDCWAu2jPRaB/04ndmLRZjAQIIwtl
         5IcAS9oh91edrCkL08gVMobopo6wEf6Ragbjv+PEyKQ4crOex2paWrKytumpoWjRq+lc
         pegfRIzwg1sOjBgfld5KA4mkVpaT3lf74PW6jpnkZcz7A6I805Z+sWs87pkJsGJJ78rj
         uWD1IvdibHqK0bschD6XOVdh6R5+lWBKGakXO31nHoTtVyKSaQS+eL4eHPUrlG4LKrZP
         cqsQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1791876602; x=1792481402; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tC8SBrxY9rjxL+sOaV51qeAfEaErpyiM6k+xmWhrmnM=;
        b=CQO6MmMncnY8PyOJIiIOsHlAJcIqcNM8y/oywNg117GNamS4GJkntRJ9R2+kf46RAA
         5nt7pp4RI0yResrcZE1Frtl2Zob1+1ioFXrrb7xbU4kJEB+iSr5V9hUO88Udppsu8cE3
         /qe8nQYkcr3DUtE43bsz3j0XSfDgJm7COY9lYvc1OQ8cXt4CUIKl1ZzPc8gdedj/zzGc
         zDP9oSqJ56TBcyksWHBS2DKcLYsraNbN7jbarqFbTKGuz25BBC/StShp3ndJZ4s02Xp6
         Rz8bsb0peFGgaCM+5n2ZH++tauxxdzQDmJxzdIHCVbkDJF15OofKuO3WCNU0YywA2t9B
         oipA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791876602; x=1792481402;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tC8SBrxY9rjxL+sOaV51qeAfEaErpyiM6k+xmWhrmnM=;
        b=ELFIeBod5j9SSY4v32G2epaM9/FZ5DYRCRq3hJxXrfNRm77Y1FBnBvi8dXtLqH+wRw
         9G881IGQW5O7irnzjNhsJy1p6vi1Bjr98d2kJJcU+G4IxXs9g9gQARL4+zhRqmXjSIi/
         24pbm4GBBTDMZkYKIJv0aCQWbyTCvVmO1QUz8eBTl3wd7pSO9D62uIh5XumSZ4VaAn+P
         Hk7uvtoKQmzkNfNcLx+md7CuqpBEBRaXg9tFuFqD6YUZo6clprCClKJSVp2DqqGmPYLT
         I+SxqeRw2S0hLu2phppWCiu/hchYGAt9MSU/uGkOOi3mdTnobbg7vluKwVp0K8WTpMB1
         W6Sg==
X-Forwarded-Encrypted: i=1; AKwUvBwfZhqTD1c95aW6c2ygkXtURx0OYSTFmNLHkjkmNfF2nTAMi3yU5c72WeFL2JYTnLocJW1tHxOQ@vger.kernel.org
X-Gm-Message-State: AFq9FYLQQtHxFnHaJND8MM+yisMycvxsWPbxWHbcfa89VDKthaYxpyRv
	OrncO5xykIUzMfBpXapI89dASvoD9TNz0148bLOHweLZ9zlfph/DXN4kjUTkXz+InHmY7JKuq5C
	ivDxNgsD7PTMWBfh2JnUzuCHlTkPFBxbtjcY7XyZJhA==
X-Gm-Gg: AYBFou1hcazBW9k89T+ZPemtDlqoxyUUU0YNEFCGgNpdsBYoT4AapKMQRuEK0TtttEO
	FjJ+4KIrolQ/dpzQUzQPzsYdyIMmKZ5USDIrRicQFr0TmonKIIa57sDVXzqVSt+ornocZHtZL/+
	znqTf3YgMN62XUMCHBbEtlRBT8rmIMVbKcHrOdZ2QOWZVKw6LUNmtUzDX2pyJFgO6f5tY+VOs/v
	+lwJLsh4hTNTFvPzuNFCNYZMel9kzlsZSh31F5fHAcrbVlLc9TzYTvyJiHh8st3xJ9okAOSjjzQ
	lZYWnJzrHpGGOhxS1wU87GInW75ASzlvFAtryEAEaQgaAe/Q1r65tsEH4RfGeZTEMQ==
X-Received: by 2002:a05:701b:42d3:20b0:156:d588:c881 with SMTP id
 a92af1059eb24-16a0adc14acmr16130258c88.2.1791876602347; Tue, 13 Oct 2026
 00:30:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260911032905.63683-1-mingyu.he@shopee.com> <aqRXqcynCx88D2QK@linux.dev>
 <CAAoBcuS=sqOAPFr9Gda9aTwuCMHMPzBMEee8qvPNHtNxrRWKuw@mail.gmail.com> <asy_L2s1TNcN7bOK@linux.dev>
In-Reply-To: <asy_L2s1TNcN7bOK@linux.dev>
From: Mingyu He <mingyu.he@shopee.com>
Date: Tue, 13 Oct 2026 15:29:50 +0800
X-Gm-Features: AclHuK8tuWwzuYE6TAzFhuKrEA3w8k-lxLPcIe0Eb2-j98t5vXrnTNoFLto9mLE
Message-ID: <CAAoBcuS5VJwsYyw9=77SaBUf3N1hL8NfRtGwpBhmyUUhT4+T8w@mail.gmail.com>
Subject: Re: [PATCH] memcg: keep propagating stats updates to ancestors
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	littleswimmingwhale@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 12, 2026 at 7:08=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:

> Please share your custom in-kernel consumer. Let's not make changes in th=
e
> kernel for things which are not in upstreame kernel.

My custom kernel only has a few changes from upstream.
I just call mem_cgroup_flush_stats() and then call memcg_page_state() in
a kworker to judge whether to do a page cache shrinking.

> >   Regarding the BPF interface, the implementation in the tree I found i=
s:
> >
> >   __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
> >   {
> >           mem_cgroup_flush_stats(memcg);
>
> Let's make this force flush.

I am not sure what you mean. Do you mean that only change this bpf function=
 to
force flush, and keep memcg_rstat_updated unchanged?
If you mean that, I think this is a good approach.
But I think we also had better to add some comments to memcg_rstat_updated(=
)
to inform callers about this behavior ( maybe has a large data flush latenc=
y).

Thanks,
Runli
