Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371B9481FC2
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 16:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281271; cv=none; b=Cdd1RJID4g8U66iNQquKT85J4kLvNIH9CoQw8UWk9BOBCVn2YPRQqdnXDZoFC6jEFI4P3tOx8vgdKRv8eSg4dZZCIsqb6jR9FVx6KjevjqSbKrdjb0qIJED36xTbRW8vBIfmZGn90t7pefqOLUMMJgbkpRMYtZXtBPJ1BlTL5bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281271; c=relaxed/simple;
	bh=3R8Bg53JyAhCy2qvymO/9qJ99ABaUImHkGF3d2fo+cQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MQ0dNkJ/Ig4RLCRPALjOrSlmqYaHs/uKH7wHkZ0WftUtE5CePrgGpnYITTjj/a5M8xYcafivQ9dTzWOpOZL8ljiFY2eU6I6YaR2tinKuGIGjeawE41CERkirYC80VRK+huRwZHXaZGkVo5T90x2CMO0KylDVyL1rwJk7eLFh3Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=LaMI0RE2; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="LaMI0RE2"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-81f3b227a4aso2865657b3.1
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 09:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788281267; x=1788886067; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZG1Y/lCpTOfNL04ELiR/+tH7Q8YET/r11fYlIJBd10U=;
        b=LaMI0RE2h3tDo0ppj7PzcMUt/pdKX78jQE3u0MHPUaomO/eFvixVpKNnhJysu4VgLY
         OCSgWTwnbbYBLeedBzxgt5fhOYlzG26pScf0JMaWs6/+oge9ZT27jZaI+ekdj3yBY3fD
         +sp+OOOQr5pfGyoUSCNtk06qLwQKkDpMABBhmFk1QiNz8WafA2dWl+DW/nxLFUbiBgg9
         LxXUrgCJILJf8k42CHynLWbJVPN/Vbn988Jvd78YwHCBN+vwIBOsHMFbd038KhLwf9HH
         00AjAaHjcPM/jtq3a2lr4ugVVYfT1F0ivmQnAsEn8AK2gMBe4BVL3EbPqpaUBRkStjLJ
         L6xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788281267; x=1788886067;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZG1Y/lCpTOfNL04ELiR/+tH7Q8YET/r11fYlIJBd10U=;
        b=J83v5XBZQUqZ+OPG7kYVJsik1rKJiwgcgx926KbKVgegXE06ay3RH06xbjGArJbK+b
         LWVnGpvYbAGlOvi2rF+DFCj/4Id+cm2oqdncvh2s5sI6+6ykbTu0fseYTBX5uxELVXIQ
         Ikabu9oMSHlr4P3z8NBo45FZp6ChWgu2bsYfqzGdaRM9fkQH9NmYc+frcn+Qq+RyMq2H
         t4AMDliEl67HIqSs2xsduAlWKEsOxtO1KmXHw/V/jZwD6/ei8H+fgKjd1cMfO3B1oK6o
         qgymyNmJUk5tsHpankU/9uIqfk1G/PEhxIyWx39fhOYMgGNLiXogFLaDYQSJ3q1VC9n0
         cr2Q==
X-Forwarded-Encrypted: i=1; AKwUvBxBuC1He0SpMVFMmXEjxBAaoaaAey95tYJv/4/cpkx9LCQFNoNFT+OL3qjKMcyW+THMUnhRPMPw@vger.kernel.org
X-Gm-Message-State: AFuF++lhBlgC9pYziz6MiiFKbWO1GL7F+oO8jlGdGnrZhz53K9+plesM
	gKEKdjO/3TNvNmR8V3Wf0343LjbXh3h3KnYymk6NPB8n626Wf206sgun8Y1FiMEdiP0=
X-Gm-Gg: AYBFou123tOH0L3AK5ty+NOm0nBKBDfyCv4QuQtHdljzm/65+e18a0QxK4qhzl1gmKe
	Cww7PYKla6/qr53Ptldc1s2Cb6nMHbQ0dLeevpo2VvUYrwbg6e+aZAvBruNjeOGkCP/MUc6M8IP
	SooArmucyGDtgyhlTvUfhMfCg4QaV21UZ/vmW0ps8PZjdvpeHYQ1dV17kYQdZ7otvAO9TZEJ2lV
	u3RJBtZBTZrcwXn5tm3EnWzxI7F5+mX1eghwo2XIsHFbDs2CcAUFZfWbnJK6MxagthGv242+v8c
	Rit+R8oFrBrU0BldG48He2FMQM5RS3im504S+ZwV5sV+G0C7k1tndve9eJjPNTGb4MgtV1ZqdRO
	6d8RTM8wdrkPlithY2rk5RJ6IiF3AcIYoLT2ZMOxDMEL1wy0feuIRi0kFDatIRGiz+lj2uCC0G/
	Ih6je8S+WusI0joSZxqtpFCqWGhQgvukW8wfiVH/F4MolrBStC4y3L3me1a+hM
X-Received: by 2002:a05:690c:f14:b0:81e:9826:942c with SMTP id 00721157ae682-85d625bd769mr138767767b3.0.1788281266714;
        Tue, 01 Sep 2026 09:47:46 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-85e65f146f8sm78197607b3.29.2026.09.01.09.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:47:45 -0700 (PDT)
Date: Tue, 1 Sep 2026 12:47:41 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Farhad Alemi <farhad.alemi@berkeley.edu>, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: avoid charging the root memcg from
 obj_cgroup_charge_pages()
Message-ID: <20260901164741.GJ3004@cmpxchg.org>
References: <20260829023251.474083-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829023251.474083-1-shakeel.butt@linux.dev>

On Fri, Aug 28, 2026 at 07:32:51PM -0700, Shakeel Butt wrote:
> obj_cgroup_charge_pages() resolves the objcg to its memcg and calls
> try_charge_memcg(), which does not short circuit the root memcg.  That
> memcg can be the root memcg: obj_cgroup_is_root() reflects the memcg the
> objcg was created for and is never updated, while memcg_reparent_objcgs()
> does redirect objcg->memcg to the parent on rmdir.  An objcg of a dying
> child of root therefore passes every obj_cgroup_is_root() filter but
> resolves to the root memcg.
> 
> Folios keep the objcg they were charged with, so this is easy to reach
> through zswap: allocate anon memory in a cgroup, move the task out,
> remove the cgroup, then write to the root cgroup's memory.reclaim.  The
> reclaimed folios are charged through the reparented objcg and end up in
> refill_stock() with the root memcg:
> 
>   WARNING: mm/memcontrol.c:2198 at refill_stock+0x644/0x940
>    refill_stock+0x644/0x940
>    try_charge_memcg+0x12d6/0x1570
>    __obj_cgroup_charge+0x35/0xf0
>    obj_cgroup_charge+0x1de/0x210
>    obj_cgroup_charge_zswap+0x83/0x270
>    zswap_store+0x1620/0x2000
>    swap_writeout+0x94c/0x14c0
>    shrink_folio_list+0x3388/0x52b0
>    [...]
>    try_to_free_mem_cgroup_pages+0x30d/0x830
>    user_proactive_reclaim+0x504/0x840
>    memory_reclaim+0x1f/0x30
> 
> Beyond the warning, the charge is asymmetric: obj_cgroup_uncharge_pages()
> skips refill_stock() for the root memcg, so the root's page counter grows
> and is never uncharged.  It is not user visible, since memory.current is
> not exposed on the root, but it is a leak.
> 
> Use try_charge(), which returns early for the root memcg, restoring the
> symmetry with obj_cgroup_uncharge_pages().
> 
> The above sequence was scripted into a standalone reproducer (zswap on,
> swap on a virtio disk, 512MB of anon memory faulted in inside a child of
> the root cgroup, the task then migrated to the root cgroup, the child
> removed, followed by "echo 600M swappiness=max > memory.reclaim" on the
> root) and run in a CONFIG_DEBUG_VM=y VM.  It reproduces the splat on the
> first zswap store of a reparented folio, with the same call chain as the
> report.  With this patch applied the splat is gone while the zswap store
> count over the run is unchanged, so the same path is still exercised.
> cgroup selftests test_zswap, test_kmem and test_memcontrol show no new
> failures.
> 
> Fixes: 20d6c1725228 ("memcg: avoid refill_stock for root memcg")
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Closes: https://lore.kernel.org/all/CA+0ovCgWzUMK+nNbbtH7eV65Ca=fDN4Ozu7iASgryjvv8Tk8zQ@mail.gmail.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
