Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FAA41B8C8
	for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 13:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785160741; cv=none; b=bPmQfcRkZEh9TVzWyxK/wHATp1IZrGdwMwMeMyAbUpDmShikDyiSAxMwD6uyZWUOVKRQgOtM6QrOT5nQBNuaLsc2LzhjIET5CUitLORct/dqdS5MQBNovlWBEJr74rluPTbLpCfSNzi3UlRGeEDbVf82Q8RvIl2fOfIE63JDbrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785160741; c=relaxed/simple;
	bh=muyPzWpTZnISbquf8T30N2+AdiH4JxtuSKf6VGHEv6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fJwDOuVs7Zcjau0v4qkLzVH/9KbTQ+kKstfxIzw6EbcSAumZLIGq6430EnSAAdRn2z4oYNwRhgyGf3L+TMDQpYJJO95xJaJWFZ+GwGUna0URG3HohdhkyKGv9OlHGQbqTKAteMJLcMjcZm8cTHJboaWOfb+EavaKZ/USv+4rPNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IuKzLZBN; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IuKzLZBN"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4954a9e8490so19268615e9.1
        for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 06:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785160736; x=1785765536; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jeVBGviPg2kCaObeNUQhF3Ba7R7LGyRIaSNUXdzPkhk=;
        b=IuKzLZBN/lL4S8Z2gP2QyMSt0x5b1UF9g6+PiBaSOxTTuTa3glShlM4OnVyLL79adM
         RpHVp+PbuuMkaA7z+i8tdDimHeU1GLIGiSDmmfoHUFWS26fcC8WmrtDAwJ5WraRbdPaS
         VaeviV9HXD6ZXb84OyILLnMIdS56Q6nX5bixPVpcofipDyb4DXcRhKByvAcyp+jXvG7c
         i3yybO71wIvthfj6Pb8jvhgbpp2NxqyqEshPEtkx2UldETLwHKiVoinmXDCInV67pS5O
         CSM030lXMrAgFVTocVHw8ZnxVUSkds8Uc0bSNVgdQEy/8NPn+cQWJ1hXcY8JVIffVTTF
         Iy8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785160736; x=1785765536;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jeVBGviPg2kCaObeNUQhF3Ba7R7LGyRIaSNUXdzPkhk=;
        b=smTVqwt5ZEQMfrJ6z7yp1fKZJ9L8qtoDLCG66eS2wkdNXm+gyA4opDM+jfTUTGEj6A
         usZwqLuiC868IApCjwuM6jfV1MZxOoiTKNsf4T8pRHXEJFRV10OHXYbi3Wijqn5vNP2n
         mTWNXRYvry53Z7YJykUKfJOgVqLHDOLmcylgzmvO6bYj1HNQ2/iUpEJkjXw+gu3bOtn1
         qwFMJEslsLeKdiW1I3yWiL05FZinjsoF17FJ41rQVXrgIXmzYh4hLKD5tJSJgcZHWEZj
         MLpNhBe8n4KLkwHUptezKk/2fjUDzUBwxnAokr3bXu7QyVfyHWA/xlpp8ab2hXzzkfPS
         NDKQ==
X-Forwarded-Encrypted: i=1; AHgh+RqmJas9vwHbT8GmHHOKM4YicstrtiDzsgWvQp9VFJeqGfJNVAiVBmbDSHqP0o7ciU9juRct7SZw@vger.kernel.org
X-Gm-Message-State: AOJu0YxYoJLEY9HMQkCPluSUxGXcchiQ09+edzKQ7nu9Hb3jQlOfpmAT
	pn8SclkFTvXL0s1wTaQb1dkiAd8PI78dCEO8xRlEvXGwl/Hmb5kymLut+/JAtwA83TC9W/2V/8N
	10gi4ZZM=
X-Gm-Gg: AR+sD12dBPWnYaI8eJhOEcHnhXUimPyen4UhJ38+yybuILsF2cRKk1YS7TBizBLQJTE
	/8Wruj5Y3L+EH1FxCCOoD4cspqxUjisDlL+qHZvLhQ2yq/ZU7nlCugq+pD2JALUHwAg7EkcUzcQ
	vgJzRm5biALGwS2D6F4kG5jLCVDb1LwcD69PjfOqcnjYzLWHVzSL+hGFXCyAd5ofkZhsSRSTFbo
	igb+rkSeFWZrO392Vby/td8DGLit30jJyAv8QKBtv3XATpaBxO4E/gYyfJNIaY13Kj3GhD1oAmz
	XnnAHN4p2/y7vDt+BPRHi3eqqFVMwwjnS0KlHBFeI/1eMe+KkerMic/XqkTLX10ZhMG65wJjEUv
	YaO6GL0zmdVC83DwhQgMNiMB8gzeBanbfkXyvmFZJj3WHJQj3OMXTHaqP9/W+5edtvExQ62j7V6
	jHS1GMO3BYOg==
X-Received: by 2002:a05:600c:5253:b0:495:7016:b875 with SMTP id 5b1f17b1804b1-496b5c7ca38mr104189715e9.13.1785160735634;
        Mon, 27 Jul 2026 06:58:55 -0700 (PDT)
Received: from localhost (109-81-83-7.rct.o2.cz. [109.81.83.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957f9ae5c3sm325139165e9.3.2026.07.27.06.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 06:58:55 -0700 (PDT)
Date: Mon, 27 Jul 2026 15:58:54 +0200
From: Michal Hocko <mhocko@suse.com>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is superseded
Message-ID: <amdkHvSMj95DUri5@tiehlicka>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
 <amcT75pLmA0hRUm1@tiehlicka>
 <615d091c-bd3b-4686-817e-5b29756542ff@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <615d091c-bd3b-4686-817e-5b29756542ff@linux.dev>

On Mon 27-07-26 20:59:23, Guopeng Zhang wrote:
> 
> 
> 在 2026/7/27 16:16, Michal Hocko 写道:
> > On Fri 24-07-26 10:18:05, Guopeng Zhang wrote:
> >> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> >>
> >> kernfs serializes file operations only per open file, so separate open
> >> files can update the same memory.high or memory.max file concurrently.
> >> Both handlers store the new limit before synchronous reclaim, but
> >> continue to use the writer's local target in the reclaim loop. If another
> >> writer raises or removes the limit, the first writer can continue
> >> reclaiming toward a stale target.
> >>
> >> For memory.max, this can leave the writer looping indefinitely once
> >> reclaim retries are exhausted. The OOM path sees sufficient margin under
> >> the current limit and returns true without killing, while the writer
> >> still compares usage against its stale target and records another OOM
> >> event.
> > 
> > The current behavior is deliberate as described in b6e6edcfa4056.
> > What is an actual problem you are trying to fix?
> 
> Thanks for raising this. I agree that the behavior introduced by
> b6e6edcfa405 is deliberate while the limit installed by the writer
> remains current. The problem occurs when that limit is overwritten by a
> later write through another open file.
>
> Writer A stores a low memory.max and enters synchronous reclaim. Writer
> B then restores memory.max to "max". A still compares usage against its
> local old target, while mem_cgroup_out_of_memory() checks the current
> memory.max. Since 1378b37d03e8, the current-margin check in
> mem_cgroup_out_of_memory() sees sufficient margin and returns true
> without selecting a victim. Once the reclaim retries are exhausted, A
> therefore loops indefinitely and increments the oom counter in
> memory.events on every iteration.
> 
> I reproduced this with a cgroup holding 128 MiB of anonymous memory and
> with swapping disabled for the cgroup. Writer A lowered memory.max to
> 32 MiB. After that value became visible, writer B restored memory.max
> to "max" through another open file.

Is this trying to replicate any real workload? One would expect that
writers to limit do some sort of coordination otherwise the exact
behavior is not really well defined.

> On the unpatched kernel, A remained blocked after B's write, and the oom
> counter in memory.events increased from 37333 to 13512861 during the
> reproducer's one-second sampling interval. With the patch, the same
> reproducer observed A return after B superseded A's limit.
> 
> The new check does not change the behavior introduced by b6e6edcfa405
> while the writer's target remains the active limit.  For the indefinite
> loop described above, 1378b37d03e8 appears to be the more precise
> Fixes: target for the memory.max hunk. Does that match your reading of
> the history?

Well, to be really honest I am not really convinced this needs fixing.
And if yes, your patch changes a well established behavior existing
userspace might already depend on. While your described case doesn't
look great it doesn't seem really harmful and the looping task is
killable.
-- 
Michal Hocko
SUSE Labs
