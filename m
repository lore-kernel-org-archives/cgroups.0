Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E18B18B0A
	for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 04:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786941051; cv=none; b=kqyxisSzWefyj5ngr9aK86vF1gM5zRF1APAXc/TUVYJ2GGlx2zWH71nG0hwQXZA57EUHY1nUz+WhKMznIA+a6S6sNJedsSZofU1xjMpZySC1/GIqnlMtthbuLd9434wz1LvBOw9bFurBiq5phXxQe0zl+nYD2gMl8Sqbx6XQ0kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786941051; c=relaxed/simple;
	bh=dfWYSuiUAiueZVM08DAYOsI7XXNJhmiSC34xDHS08nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QR2GYTeiGewSCFno7MsBPEeBB1giDPn2vJyYuRFXAdVr4ghF1HHJs1S/D5gAY6TREtY6e+qoOdG4jjEcCyXQsG6SIKG5qwKuxr5qJyHp5JzWgZspRvF4Ool28hxu5z7WMfJAOZTdERsjwzBy0vleH+aUrnbokJ6th7mqYaXpuz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lOQAc8Ra; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lOQAc8Ra"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-4518ad44e83so1849730fac.0
        for <cgroups@vger.kernel.org>; Sun, 16 Aug 2026 21:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786941049; x=1787545849; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XzHa46yoeqtsHFObqgwtZinJ/lnkplRZ68OVnoGli10=;
        b=lOQAc8Ra8L2UrnGY+OawyjFF4LOZ3JqTKUt9dG+vNf4IFkSaL3lLNPXLXYWwWf0WUJ
         vb+V7YNsC+yX7wDicNW/DCS80vEzNodzR2qCuRLsQ2DVFUpRqkc6RWE8KiAgzk+k1wnM
         9gBxpbAMUp9nlmhKCWDIMitE6XG89+FErqBmizGOVCT9EFoFyKzwfbHaxDXB663RmCe3
         /ll09gL9WvppHYyTGrcgyGpWoSDM0Az17EI60S3v7A+5Onr7lZb2lqCt5YTNVJOOmErV
         SJisTmjckd4pxF0YAz63TKvhSDLmrKSeQ51pTjHPXTch8tzjRGtZssZPAUGIOj27w9sc
         NCzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786941049; x=1787545849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XzHa46yoeqtsHFObqgwtZinJ/lnkplRZ68OVnoGli10=;
        b=PWjujfsra17tywc8ivfxrF1hDxgFZXQlsxKihHcL1QmHRKjWg0jleD+4FfnjiOI5mn
         JgfJuO2ZPqkm70O7KbXrEEJXGZzJx88PGJZNaqp/9zh2yHiP21VN0sU70+PTtBVIaTY8
         NrVV2OJ6tGWvVri4SYF/p52+exRVUJw8EhIsqo7U+tCqnOklkz5am1JehzxIkTMrU+zd
         ljeJVtzirLw/dke9YY7DIRMJcSOGCWb6b3l0Mvz9tVZlyNvauZ2XmDlV2kvaROTLDKG+
         dL92IwxIeJAPYH0blW90ipkF+h/WB9UKBKMirqGwp4RZlekasDYcFQwxzz02G551pz2C
         5NnA==
X-Forwarded-Encrypted: i=1; AHgh+Ronrrp42brOPNDgSt0lSO9Pu9lYJpCkAvRDKli5qlAdnVjcdFuOCffbZodpXEsBA3p5l93LrVMk@vger.kernel.org
X-Gm-Message-State: AOJu0YyvSopxu9UZawwHH/hxqFT9z3h7UpHBVVI5maqNeza3j7+/QzIh
	vFTKnOP6hBtE0I50+hZjMKgLvt/s8br3/ksY5sxIZOoBhgBla+8g9Jd7
X-Gm-Gg: AR+sD1181E8SZzw9QMnRbbA0G3uW5TSjI5Ll0X0gQxYduKKSeJAJVaSLQTV99bbwUr1
	LM/U7LuzAntxSp78tPvp+jtIzHlkzn7XZPoravn+SIim39sKyFHVy1l8AjAWpf6ZlRyXX0QmcDh
	z57qlikKAJWpJUcIyITPFGQXV+Zs2Kf+7+IGx85ATqpL1Q2xDRLVxpSplGpFH1GsmAODhcMTQCf
	KnpDyinnSpFrR9irBYZHD9iMEhTzGF3KV0H9xa+qQVRHX5XTG/p6kgb9y3I/Km+5yvUXO6hgxLF
	lEdamJkDORwl4oBhnMNJzyvVNX8ZSJilsyxBF7kkdla4owZ/N0iFZzsVKIE3Snumsvz2/900J/y
	L01qWTGQTehGIav2y+rDrHX63dUkxQgqEIcR9sE02YjvqdhltBIDNA1VodkgB9UQK4EB1/KBr47
	iSvVUYatubpjsRqG/nIfHgdLzFVlDtvMz5wp7IZBTI3ir2r/d7ltizTukvlC3qbdBwM7nnEx3Fg
	muzS29eW3+IZy8o/rIAh9PBR50+/yjaew==
X-Received: by 2002:a05:6870:a085:b0:442:175:cea9 with SMTP id 586e51a60fabf-45e91df60e8mr22649897fac.7.1786941049279;
        Sun, 16 Aug 2026 21:30:49 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:7::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-45f22a7f3dbsm274098fac.1.2026.08.16.21.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 21:30:48 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	zhuhui@kylinos.cn,
	joshua.hahnjy@gmail.com,
	audra@redhat.com,
	bingfangguo@tencent.com
Subject: Re: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg offlining
Date: Sun, 16 Aug 2026 21:30:45 -0700
Message-ID: <20260817043047.1553572-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260817025917.66233-1-husong@kylinos.cn>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 17 Aug 2026 10:59:17 +0800 Song Hu <husong@kylinos.cn> wrote:

> refill_stock() takes a css reference for each cached memcg slot and
> mem_cgroup_css_offline() relies on drain_all_stock() to release those
> references before the cgroup can finish dying.
> 
> consume_stock() can drive a slot's nr_pages to zero while its cached[]
> pointer stays set.  is_memcg_drain_needed() skips such empty slots, so
> the offlining drain is a no-op for them: the pinned css reference is
> released only if the slot happens to be evicted by later unrelated
> charges on the same CPU, or by CPU hotplug.  The memcg then lingers
> in the dying state indefinitely.  On a CPU with container churn, a
> per-cpu stock can pin up to NR_MEMCG_STOCK (7) zombie memcgs.
> 
> The sibling obj_stock_flush_required() has no such gate: a cached
> objcgs slot is flushed regardless of its byte count.  Drop the
> nr_pages gate from is_memcg_drain_needed() accordingly.  Draining an
> empty slot is a single css_put() and a NULL store, and it happens at
> most once per slot per drain, so the extra work is negligible.

Hi Song,

I feel that this above statement is quite misleading.
Scheduling a drain on a memcg that doesn't have stock eventually
performs a drain operation on every memcg cached in that CPU.

drain_local_memcg_stock
  drain_stock_fully
  {
    for (i = 0; i < NR_MEMCG_STOCK; ++i)
      drain_stock(stock, i);
  {

Sure, for any empty stock during this iteration drain_stock is trivial,
but for nonempty stock that happen to co-exist on the CPU, it's forcing
a cache miss on the next charge.

The problem that you note does seem quite real though. I think a less
invasive solution could be something like

if (mem_cgroup_is_descendant(memcg, root_memct) &&
    (READ_ONCE(stock->nr_pages[i]) || css_is_dying(&memcg->css))

By the way, I think the argument that "obj_stock_flush_required has no
such gate so is_memcg_drain_needed doesn't need one too" is also not
really correct since a dying objcg doesn't flush anyways. 

I hope you have a great day,
Joshua

> This is easily reproduced with short-lived cgroups pinned to one CPU:
> 12 charge/exit/rmdir cycles leave nr_dying_subsys_memory at +2, stable
> across later slot displacement.
> 
> Fixes: d1a05b6973c7 ("memcg: do not try to drain per-cpu caches without pages")
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  mm/memcontrol.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 17da1f43b7d3..b931ec16bb82 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2291,8 +2291,12 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
>  		if (!memcg)
>  			continue;
>  
> -		if (READ_ONCE(stock->nr_pages[i]) &&
> -		    mem_cgroup_is_descendant(memcg, root_memcg)) {
> +		/*
> +		 * An empty slot still pins a css reference which
> +		 * mem_cgroup_css_offline() relies on drain_all_stock()
> +		 * to release.
> +		 */
> +		if (mem_cgroup_is_descendant(memcg, root_memcg)) {
>  			flush = true;
>  			break;
>  		}
> -- 
> 2.43.0
