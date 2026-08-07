Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F773B2FD0
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 23:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786144359; cv=none; b=O3LA7zKcdWp25W53Qe0n76FYLZ3d/YETe8CE7q4wOGrngam0qxKba/nSqEs+bA8rhOAUs6PLYTMwfKUVcvp2uqh+E7JdPsMvsmZl7nFBAja/TB5vywWwDvT88JXg+m9v735F+RZWCIMw5JNjMRJccbC0XybXJHshnfKwD2BVQNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786144359; c=relaxed/simple;
	bh=JkCL5PcuHPI0mRW3XCGFDQ6yNZcUDpHgW7I1RgaehKI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LTiNiHyBkqHKk5gNBc8MCgtmSHrYtJwu06ExYbC2Ny0eT4sZtTnWmn3GB4ibrJMORcr6SsSC+iVl61Ez5WCXXI0aVFOw17VjdJmRpc3BQ6+yjKke849vI9eywSIeEJPpzcEhEcji7ioUTLkhySKjyyzJRt22MWzwMk31V6rY95s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sx1xihhf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sx1xihhf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1C71F01566
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 23:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786144358;
	bh=dowb5rrx8aW14inrtue8QbnzaOrLHhcAjLJTHw9fDKE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Sx1xihhf0wT2f5wuIdqdslNoo79JeZYANMuu3iHBr1z2F4U3R2eBFJme2r69fJtAK
	 i38MoVFaLOLJIR4CUiNdpMEjKPbyF6gpYFOsJ6AIRpuvDyaZ/qVRiJHAcxTfxpRpdi
	 yEn/iqhorSfrYD6lUFnzooKFm/o6NPXkb0HohaEJxML+wlSbep/11gL6Cbuteb0XY6
	 YxPUj3IfNBDbvStDd6yrYwx0VpnCB60hWz1//KL3gk4Kehl9FyuykZUb1+pL8pkVuE
	 s0LLKqRqiYfe/oihngFhKGP9DFOqHXq6VGrjqP1miEty0KDA3v1rMBYsXeIIMPuzGV
	 YzcZr35plXfLw==
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8f0e5e36912so1916d6.2
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 16:12:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RquCM76DTg3gATpWEKAvArz7rgsRUxq2QB8QT5pWi0iHTnuZD3h27w7TQdb0NThXr/H9C88Pfh1@vger.kernel.org
X-Gm-Message-State: AOJu0YzrRNq5H0lLEwMT11KPsZuDCSHshEYiuDwrDNwio37Fuheg9sO0
	NoGsnYSQqKT/2hjvH0VSVv+luw1NRXMFSdj2N77YPkFBDNtJrNqMCbeemR9+aa6angHxHkFUqxk
	tR7CHRzeKiZnqbx5l9Vf64AP3YQt80nY=
X-Received: by 2002:a05:6214:260a:b0:8de:9230:7c77 with SMTP id
 6a1803df08f44-908a2d25988mr105511476d6.25.1786144357815; Fri, 07 Aug 2026
 16:12:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com> <20260730122304.2496440-3-xueyuan.chen21@gmail.com>
In-Reply-To: <20260730122304.2496440-3-xueyuan.chen21@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 8 Aug 2026 07:12:26 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zo_uya7-iFS85W78+mpvjhmfxp7HfxTPKDD=Aiw2c1vQ@mail.gmail.com>
X-Gm-Features: AUfX_mxCOwjxKm1_zD7yUozU-Su7wX8R2bYYon98LGNe4AfrBRCrYZ1VBdnkqWo
Message-ID: <CAGsJ_4zo_uya7-iFS85W78+mpvjhmfxp7HfxTPKDD=Aiw2c1vQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5 2/4] mm: distinguish large folio swap allocation failures
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	hannes@cmpxchg.org, youngjun.park@lge.com, baolin.wang@linux.alibaba.com, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 8:23=E2=80=AFPM Xueyuan Chen <xueyuan.chen21@gmail.=
com> wrote:
>
> folio_alloc_swap() reports most allocation failures with a generic
> negative error code. Reclaim cannot tell whether splitting a large folio
> could make progress or whether there is no backing space at all.
>
> Keep the global free swap count and the remaining hierarchical memcg swap
> margin as separate inputs. The memcg charge path reports only its own
> margin; folio_alloc_swap() combines the two layers when classifying an
> allocation failure.
>
> Return -E2BIG for large folios when a smaller allocation might still fit,
> -ENOSPC when no global swap space is available, and -ENOMEM when the
> failure is not helped by splitting.
>
> For early large-folio rejections, check global and memcg swap availabilit=
y
> instead of returning -E2BIG unconditionally. On a memcg charge failure,
> swap slot allocation has already succeeded, so use the remaining memcg
> margin to decide whether a smaller charge might fit.
>
> This only refines folio_alloc_swap() return codes. The reclaim callers ar=
e
> updated separately.
>
[...]
> +
> +failed:
> +       if (get_nr_swap_pages() <=3D 0)
> +               return -ENOSPC;

I wonder if we can do this earlier when swap is full or disabled.
We could exit immediately and avoid trying many redundant paths.
Have you tried this?

> +       if (swap_margin <=3D 0)
> +               return -ENOMEM;
> +
> +       return order ? -E2BIG : -ENOMEM;

Best Regards
Barry
