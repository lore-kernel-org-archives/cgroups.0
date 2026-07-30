Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F4644AB66
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 16:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427438; cv=none; b=QhlijlBDwg4eTPKLmeFAQM8CPTkCstGvxSKGtzP1wRYgdO3Pqzut7ZjFySWzE6Zs+QOFuoU/rq+3YYDF4rRzvApXx5qD7a6HVwKNXDR5u3tfZKezLnv84pCcQWmK6gaQxaEH+TuwpyH3/cf/jxyLpHjQU7zPA5MFAWiuSWr4K7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427438; c=relaxed/simple;
	bh=7d5lntCj59d+3Rr13P4WG6eQCZD6DtMQ3Qhvxm9dqdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hrIQHaUDkTt+ZJPOw0ul2woB0zn3WnpdnOvN3oBUF019sKRBH4KscmcMr8EG+K83Qr/bvcN/RCiCdR6MvIIVsCmzAGsn+d2FRqfThvOQQtAC1tx4uQk4OroaRT6oi9+ZQFpLnOrv0htCIzgyK9Ve7cjQGy8quws5uhgT5ACpuPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=QiSPcDAH; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="QiSPcDAH"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92f03daaa97so152510385a.2
        for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 09:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785427435; x=1786032235; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PcFIQq4zwEGh6eHDSNhDw7+n/lhtQGiDqeuI6khw0pY=;
        b=QiSPcDAHwVxH0bugoLZDbspJNQvZzY0Rd/Yn6FCC9hLWBpVnkc6B5jGHgl31Um9Oe/
         zKNHMTf4OjZQ/pYRd3jXqxWQe/ERzQshCUQSUsOLj3beHaEGsU1y+AAd5n/D4iP6X0u2
         yZxaTDzp8VD7p1S7XuvevM8eoewykcGupfMtfOF9D9YdICTO3kn9x3I+UrV0Y7KfXtuN
         9V7j5UUUnrs2mDww8Wlej4LyTEh/A/YLEPmTmDjCsNr1dEFp32Ljw/YuTexNTd3E5TUV
         34GGetoaPraVocigh31T1YbHbiQztfaNXPb3TlvXTcsL+qTIj3M6wuKFCzLDqaMnLxsN
         X25A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785427435; x=1786032235;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PcFIQq4zwEGh6eHDSNhDw7+n/lhtQGiDqeuI6khw0pY=;
        b=qdvdzKZx+XC2I9KTI7OQy1WYxc+aNFwj8d4qLw7+y4F1MoYFI1mF0mUE6JcqK1phR1
         nIxr/7alDEd2K7mGHSGLv2Lucq7DLHr8s+kA0ciH+zd+quuawYzfZTCA++G0Tra9E/6s
         R19MjQjbANvFovruEBJrJ4kyb4qxzBuyaSp3dW84u1q1LDGW4/OCckIofPHya8ITTCqs
         HEgXmtANLjQT+BPrEz3qUb8hpiXJdpcX+MTiX6uSrnUu4RKofehOGEh/W2E36dZKU4Se
         8u/o56HJvg9BbzI8zIt65XFsCJiDXhQABWcL8FDdNuk/SQWYqJPdWLf1ZwyON8gO+8sI
         OqMA==
X-Forwarded-Encrypted: i=1; AHgh+Rr5m8yrJhOOktMVMAeH6ms5XIrMDOYeehFza3zBaBx+vDG6WeLVvi8dMe9X3fobv0paMWnBRdC+@vger.kernel.org
X-Gm-Message-State: AOJu0YxZbTBpzAbY4hWIf2Rkc6IGamlsA+DJY/LwX92KO0GfHALTPITV
	dL3xSr+GepSXNo5Wg7pTK+lDG4zpxf4P38LYYEjWR7cOhcR1bFKaWnPy1bp5NFw8/Go=
X-Gm-Gg: AR+sD11ylLqYWRb/HDxL+7mfG2ZGEWbPpseZR08H8O2e3fLHJvemPqzBKcTxGQt+yNe
	Od/NtsKj6lmrllrx/nL30bH4eQ9DC3ixKEyb1w1qzNzFDOzKptM3AMBak5/mfG5ZK61lbGLR59H
	jCsgNpAMGD2CcgcKptRN9Gb++qkjTrZw8H2jdmarauOtXbjmQ/v3JGEFYIZnV2cwj5u3ihe9NWj
	w0fG/3v0Cz0VKTFOmqBVtMEUsXEHGPhVNqZUFeXbDOfiRIi9W4We9pP4Gyf7YbuQi7gFOFDVIjz
	XM/1TjUZcIsBkg2ABbCtHD87R8kaCvH9hSHfyq+Id4J7ewuTfQEAHcG1fnsICbhyDNSSEyXEGrL
	Wn8JKoYGy7kZjmmSMPjA/E8j9ucFHUICu6rMOhgEGtDoNpMH5ezmk3mxfcFxK4enFPtBkkmMrDH
	3Yq6NOoN905IvCKbmSAY4uOP3TZvwcMWIaj81vMgW9J/Pk68MX9aTFT/H6eQY=
X-Received: by 2002:a05:620a:4105:b0:930:84d0:fd3b with SMTP id af79cd13be357-93485f9aca9mr384901185a.7.1785427434538;
        Thu, 30 Jul 2026 09:03:54 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3221bc7sm438877585a.7.2026.07.30.09.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:03:53 -0700 (PDT)
Date: Thu, 30 Jul 2026 12:03:47 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ridong <ridong.chen@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Finkel <davidf@vimeo.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH] mm, memcg: fix memory.peak reset clobbering other fds'
 watermark
Message-ID: <amt140aXu5tYZxln@cmpxchg.org>
References: <20260730115314.1069089-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730115314.1069089-1-ridong.chen@linux.dev>

On Thu, Jul 30, 2026 at 07:53:14PM +0800, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Writing to memory.peak resets the peak for that fd only. Each fd is a
> watcher and reads back max(its own value, the shared local_watermark).
> 
> peak_write() resets by lowering local_watermark to the current usage.
> To keep the other watchers' peaks it then walks the watcher list, but it
> stores the current usage into them instead of the old watermark. So once
> usage has dropped from a peak, a reset on one fd wrongly drags every
> other fd's peak down too, even fds that never reset.
> 
> Reproduced on 7.2.0-rc5-next under QEMU, two fds A and B on one cgroup:
> B sees the peak (410624 KB), usage drops, then A resets -- and B's peak
> collapses to 1060 KB although B never reset. With this patch B keeps
> reading 410624 KB.
> 
> Fix: save the old watermark before lowering it and use that to floor the
> other watchers, so a reset only affects the fd that issued it.
> 
> Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/memcontrol.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 60145aadfc5e..881e7c459c64 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4692,7 +4692,7 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
>  			  loff_t off, struct page_counter *pc,
>  			  struct list_head *watchers)
>  {
> -	unsigned long usage;
> +	unsigned long usage, old_watermark;
>  	struct cgroup_of_peak *peer_ctx;
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
>  	struct cgroup_of_peak *ofp = of_peak(of);
> @@ -4700,11 +4700,12 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
>  	spin_lock(&memcg->peaks_lock);
>  
>  	usage = page_counter_read(pc);
> +	old_watermark = READ_ONCE(pc->local_watermark);
>  	WRITE_ONCE(pc->local_watermark, usage);
>  
>  	list_for_each_entry(peer_ctx, watchers, list)
> -		if (usage > peer_ctx->value)
> -			WRITE_ONCE(peer_ctx->value, usage);
> +		if (peer_ctx != ofp && old_watermark > peer_ctx->value)
> +			WRITE_ONCE(peer_ctx->value, old_watermark);

Ah, because B was previously reporting the higher local_watermark, and
its peer_ctx->value was actually low. Fixing it to current usage is
wrong in that case. It must remember local_watermark.

What about if usage is bigger than old_watermark? Then we don't update
the peer_ctx just yet. local_watermark is updated and propagated into
the peers on the next reset. I guess it's correct, but it's kind of
tricky to follow.

Would it be easier to understand if we mirrored the max() from
peak_show() here?

	usage = page_counter_read(pc);
	local_watermark = READ_ONCE(pc->local_watermark);
	WRITE_ONCE(pc->local_watermark, usage);

	peer_watermark = max(usage, local_watermark);
	list_for_each_entry(...)
		if (peer_ctx != ofp && peer_watermark > peer_ctx->value)
			WRITE_ONCE(peer_ctx->value, peer_watermark);

This code hurts my head. No strong feelings either way ;)
