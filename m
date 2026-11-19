Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795109651;
	b=g7GPxRnVNGkr+F7I3CxjUwZgryNwErL9GDgSAkJ7ueGn8l9f4QGqZdTc+PuYrNmZIuXb
	 5E4ElkWE5A+AVYcbnMZHOZNrIUkgKyQlp/dPYkTscR0Q2j7wx7c0Q3GDcxfUDfH5mitSf
	 5vKQp43wJMBwJs9tYqZZ2sfA3LTdqKOXsR/oUsLcyTMqUzSGHla0ln7CJjrFM/y0mj3O/
	 EaiZsK1BNN9NJiUwKZ8Iu1jxH7Br5BU4oLrh+GQYoyPVqMZlfaV+fskbjpiY6IF2CGT7i
	 K4MhW/kmcBFD4Gkj4h2AC6HoqHvOlF0zKWNk7l0qfviyCHRzAQ4QbntC5ecH2+Jx6XQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795109651;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=GU/DHzsJXxqhMdzOYAA9Okmyib9cC+TRn+DETm5eoNw=;
	b=QFA22Xv1wMQKCF+XSq+2K8g5LXhbAyiesE8wKPuapiY+QV0IWxXtalua78qu3+MY01Xp
	 MtS1D8Y/c1R4wRwHYNtGmoaAHgmueA8d6a1cgnyo9AwriezzGtI0Wqh24FtagiBXEOupV
	 APBOWJwO/clFkSUvhC2TvchWt+W0YRGUlBJiKiKgBgy+wZgcserMx6PLV2VNPpptOBUP9
	 DuZUZxhyxZJNM4KVGJbDDpo8xlTebvnO2ZxKffQCch1iznp4UMQOIPa/Q1y3I9MxYwQUq
	 eUw26/2BcerWn26//R2f98FWSQ8+YRr445gd+d5io/KVxSS6LA8fIaZAbNpAIuiVTjQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=O+L5h3Xy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC48E606A32A
	for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 17:34:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC48E606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=O+L5h3Xy
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c4322d310e7so6501766b.0
        for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 09:34:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795109649; cv=none;
        d=google.com; s=arc-20260327;
        b=eV8DX4j7x+BpHKE40xfv65GAN1iChfERXSax6xsK6gtILXwVSDOHJdPM9U2psHiNWA
         YMAbLTrZYRR4rk6VYIU0q1YZZxrpI8V9c5FPcwhBhEsRhlyS8CWefjyj1Z7ngd60a9fW
         nA2gY/sDghpb8KNP8tNcg/X0P4DDQm0QG1WhZq2xuUDoIVtM0OXibbsbSRdcVCVn+U3A
         sGWrRpFSICS50PD4/RqHGybd6fTAidwqLtsdFmZrxUjqapIIAWdP0JTRpm4BB6WPCD7v
         sRo14tWWs7kZpANoQF06qHO4Hl+OnGfQJKWViTdrOTd8EzyRnS9b1jmeiqZXWXmXKM7H
         cOYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GU/DHzsJXxqhMdzOYAA9Okmyib9cC+TRn+DETm5eoNw=;
        fh=Q8WQQvSRj7mWnxvnGggdO0ohJfDxgrRAnCAYqm8qfy8=;
        b=C7jB545p+uZTErQVOJqM2qeiafxafe49xjYrOXAzJ6bWGQj9rJB7unT/HfFDjfizgq
         FY7c9uB0VVbLPS0sIfsTAfRZLkwaqEouqC8Lk09u4Q75qWPGydXUNwDDk31i+QsEdkB7
         jQznZ/cTR9VZx6oikFg+Of1cD0bCFcbtnKsiKQwE6bhGQm8GGMd0yG5VkeDMbszYgkVo
         4drtyEwsJ6gt4UaUEsYq2IkEdUY0+QrL8lldhjGQfv9HevEDUQwoL48B2z0KUAFLK/xS
         48ITX8qVNQdHW25rInu/azc15iFbtn+nC6CMRiosCvP8tA4tldIaql+x1znZYJsD492t
         35iw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795109649; x=1795714449; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GU/DHzsJXxqhMdzOYAA9Okmyib9cC+TRn+DETm5eoNw=;
        b=O+L5h3XybYIsmgG2hb8qYCFSsW2v5laMXHxWHrF13TvzQS6m9eRprosdnH9bf3Gm95
         C/3gMIoqlYuW4gmh5lN7yxzWOD5OUmkVRv5HKYVUcLyz85Nt60YHZY2g++2ZZ4kIrvd0
         7VxZ3rFOLfIBf1K0sNt8SoWzw1EXnlzJ56k36et68eNdQPBrsMJ4cCNVumCcCA5+YYpC
         Q4MAiW/mVRQWanUfBYyq4Behcvk2xN3JDaJtdM4YowIK0w2i0reveSuWkEGCZQwGqZm8
         PWWqX1LgKq2agjIlEmwwqaNNFQpM+IgBPqtdqW+X1UuE2zOo7UZpomBsraTprjdGxjkY
         v+cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795109649; x=1795714449;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GU/DHzsJXxqhMdzOYAA9Okmyib9cC+TRn+DETm5eoNw=;
        b=FAfRSmAoT5YrybExVV2tbdJROfPWOxwufvoJBZECvyOYX0BhRLAkKJtBC8ggoU15CB
         6hIcysmT5ToyE5c9QnRnsI/R/PvopGobHYd3qX9HAG52N7y+ZPVF/TyGhM8342xg8PyA
         p0xHmz7cEZicaneNAA7ub6IVlfaXjaoDx3T5GsgVc6r9MbmW9UuUXEs9h0M+z0FD69Jv
         do0Uj2dsqWDSppFCJVsWGeIVxO7+KF491aYcaJr+jzysabMxn24Hof4ue1P1ciJ+3mQ8
         h9j2bk6uJxCFkROd/8z/PdhyS2hSxbIpmikA6cHLa1bwsJ5DR7wS+KbmZ20RsoHQjhF7
         GZrg==
X-Forwarded-Encrypted: i=1; AL+hErFvsbRMudogG9BTae+huikX7TwV+UanrsgLtnX9ehVJHSob2PoCLcqP5Y5ZpEvEBuCuuxc7wBa5@vger.kernel.org
X-Gm-Message-State: APuU4Z//P1yxnOXOscNbkVZig3i0RJU29uS7QPW60++0Fc2DNCFl4WzS
	jNWvG+dndi88LpONIYAGo42rgpo7WujEStOPCbcVQRosQtuzKsdRi2dUG6bONWqrZwyJtlAU4oY
	rAOV231p9TFzlDtVwo3c2LicGra3K2mA=
X-Gm-Gg: AYBFou3TYuq43KXyjO1HTgcT0zydMGdhpknnKoLuuf1Syd1eA+LdHMVlw8dHIve03Dm
	Ge3sOWUJDPvv0rP6dFE8bdh2JCM1cuB+HhRXcfuWGInQUuwvxB4bHTvqTydH3FUKFpJu6ayWBVa
	CM8SPD5WyYrpl3+Ew2j92ovDb45gsDqwRPKuim9nL9hI4sDbSgeyJMhA5Gki8fcUwOaGFfontkL
	bAAwYXmvDiyKkRQsN4Gt/rWZHY8/5FN9sDNfLKAMphzK29jXhDDngM7UMQjAHhB5Rfhs9s+KbPi
	+xm+pubmScvS46/oO5U3HBYkmDVwbeL3hH9YH8TOSifCKmbPjZjT92gusDF3utPAnJz10GZR582
	ZyyPxZKt/4N8ry+Qh4SKXKbi6mZRYmx8nznZej4P7CZziepIY1aLp6WPKsyZoGLdNTJylFiI=
X-Received: by 2002:a17:907:9693:b0:c4d:331c:2e97 with SMTP id
 a640c23a62f3a-c513ab47f5fmr64354966b.36.1795109649032; Thu, 19 Nov 2026
 09:34:09 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119112357.275352-1-hi@tychen.cc>
In-Reply-To: <20261119112357.275352-1-hi@tychen.cc>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 20 Nov 2026 01:33:32 +0800
X-Gm-Features: AclHuK_14i71TxMIEATGAgIqE0r8tCGaC_TLqpyybte_WVRWpRVBP4hHZoQKFT8
Message-ID: <CAMgjq7Dnjsq4vid7H4usOB4f5AS8XzhG75mvf4-Y=an95gBERw@mail.gmail.com>
Subject: Re: [PATCH v5 00/17] mm/mglru: frequency guided promotion (MGLRU-FG)
To: Tianyi Chen <hi@tychen.cc>
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
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, 
	Maxim Muzafarov <maxmuzaf@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 7:24=E2=80=AFPM Tianyi Chen <hi@tychen.cc> wrote:
>
> On Thu, Nov 19, 2026 at 05:03:32AM +0800, Kairui Song wrote:
> > That's because MGLRU deliberately disables hotness tracking for
> > MADV_RANDOM areas while CLRU still has refault distance.
> [...]
>
> I ran the OpenSearch k-NN test from the RFC thread [1] on this series.
> Its .vec/.vex index files are mapped with MADV_RANDOM, so from the
> paragraph above I expected no change. With FG the gap is gone in this
> test.
>
> Setup: 25fee5b1762b with and without all 17 patches (they applied
> cleanly), the same .config, and a fresh 4 vCPU / 5 GiB KVM guest per
> kernel. OpenSearch and a one-pass 96 MiB mmap scan share a 1 GiB memcg
> with no swap. 5 seeds, lru_gen enabled=3D7 vs 0. The script is unchanged
> from [1].
>
> Medians over the 5 seeds, last 1,000 queries after the scan:
>
>                   p99 (ms)   memcg file refaults   .vec resident (MiB)
>  base, MGLRU         66.18               144,387                 99.98
>  base, lru_gen=3D0      2.09                     0                117.19
>  FG, MGLRU            2.16                     0                117.19
>  FG, lru_gen=3D0        2.12                     0                117.19
>
> Right after the scan, base MGLRU had already dropped .vec from 117.2
> MiB to 54-71 MiB (median 66.3) in all 5 runs. FG kept the full 117.2
> MiB in all 5. All 5 seeds go the same way, and classic LRU is the same
> on both kernels.
>
> This is one synthetic setup and I tested the series as a whole, so I
> can't say which patch makes the difference.

Thanks! That's good news.

I think the reason is some of the hardcoded biases this series
removed: FG places purely by refs. Less hackish checks, more generic
performance :) I reproduced it locally on the base kernel too.

FG still doesn't track MADV_RANDOM accesses though, and still no
proactive workingset shift protection. Refault distance will cover the
rest including Maxim's case IIUC, as demonstrated before, it's better
to do that later as it fits much better with FG merged first.
