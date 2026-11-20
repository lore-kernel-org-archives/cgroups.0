Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795134096;
	b=bcks93A1VjEmMI/9JlM9o/RSuyA4DGH1a7JfksKse11gN7NQGu4Hv0CXZnh8MZ65Kb05
	 iNQNO0ujqDx+o/wxYFFjH46ymAptlp4YwPFfeI+gmvmJj8R97VnMBuj8H1H5MZBdjByKD
	 7pqZESX0G4JUvXRW1iEotEHQglcTfPW6OTdsLf5hdeIw+XtVC+6lStVi/iYaXb+Zbq2h1
	 yjVL3hU0vV3/L+D8VqmJVsScghxUr5geGjKfygUB1jfqEIIjpooGyRtOmsqR+7Z63QKvx
	 99eNY0cHHaSjtdS602yiJhN0ugxFOd5EaTxwAnjeiKRm3PrPrYpnATFrpmhFjf07JjQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795134096;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=0CZfHhfHfESc4YrPufMYXO8QeXfOTlDtABpZbDYX5SI=;
	b=lU5lCZHKb5XrzgsMWrNkWZgV7bxJCkxC/KFDOsVbgvVwseqqCgf5KrNFhtZx5Lt4/crH
	 XDKpMYKIXax79/eMGq8BsgfggHywmW7uo7KiBguRfyEBQswUwokRj3hBKIw5KPdvUV8m6
	 3Rhbd38IjaAEldMhXLY3QZEJPmo6DXepKQS4zsihTLt/Y6oajR0SQg13vI5qJNBmqAlCA
	 /3cyj24ycS+7Q/fV+BNGGXO22PunKgxEKn4ohDbqApT++x26E8bzgGylhysVGmIk+pQZB
	 pv+LINvYMTofW/AZRE1kUjq4PHAdbPUH6G3rO2zJ3XbI7NJXDSaXRgXSy7xcY4+nPmA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pGSWXgGL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D271606A325
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 00:21:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D271606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pGSWXgGL
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so2570555e9.2
        for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 16:21:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795134094; cv=none;
        d=google.com; s=arc-20260327;
        b=iS9KBkix5jn/XxOr103jMaSyRkXV1/Re3IDBngWx0UGj2jwHYQGpSyavfXENmNfSwr
         rmMk1cb4vpQjV4IjLqmEr0H5TaHa8poQ5aXjBes4tsV7yPpUiyUO0A5d3Kki25OXwkHE
         D9Zu1d+pLsL8tUOpnSLnwrhu7viQ5XLr+VnexCbxPbmObc91+mk6vxlkVPlrMkbH6Wi3
         ZUVeywrGk/RJLDPtvHTDbQV42XzkJYCsfxQ6ckBzr3JehHGXuuW/OkWcyNh/M1vkvZA5
         ox6SRgskYabMxV76gAdFRo18X9cbP06xQwGcEac5V2lHIG07S88U9DRXG/sOobzSLjPm
         uGJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0CZfHhfHfESc4YrPufMYXO8QeXfOTlDtABpZbDYX5SI=;
        fh=FubA4SqCwfpms+/tgfbZc5ns6pWIs29ZKSgo5kHkL0U=;
        b=MzwHJzFizsNqhIeH0y+1MZ1RLMLINVsqC1C/2QzCW6nLVe7+L6r7ZMROmdDh79zpv1
         6E2ApZ68+ggwN3ARRW2tNEHXxaMf7EjgX91/uq9OC7K2CmSxPRtqFt+XrU3RQAL0nWtQ
         nyYKgxDlN+CklEtpK97o5eLTBOeyeRT28VsYn+G8mN338/gBqM3E3ENwnCnCSJ+nwtJf
         LD/UUBU6gngs6ygyY1XE77RuCR0A3slNm7iVIx5kRFYm7otn5GsGBXouOSL4qi712fKJ
         yx7eMneOTpdA5UuLDZSU+ZHMVsAdCMG3hX3/NsBL+WoQ7s1PnObWjQl6uXGV1lgU/BQC
         NNlA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795134094; x=1795738894; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0CZfHhfHfESc4YrPufMYXO8QeXfOTlDtABpZbDYX5SI=;
        b=pGSWXgGLJ4riANsSnV8Ep6Kh9hBrf+/2TJY4XMrynsJsY39fMZ/31RXH/W+fz6uIAZ
         XustpFrbAVsRo+v3vKXGsbAOEzhBkDcsHcPDgWQusgvAHBdMoi3LUEzM7vWqYH0HWNfy
         mGTEK5NEsrxtm8G1Xh4cAl9YUwFQ9ekINcmC4OpqX18C9mwZJBQial4uKk0s5HPTQCK3
         9i/7SvNaGW8cfs2Bxxrsewp8zwIVU66fnblYR+8E4f5YPYmFTib+QCYLqPFgiQxpic/c
         7PDmbTYVQuxiE+9th30A6WX1gUs3Q9Ta++dKXqwj94l3cRpm7r+NwgZkGvrq49DH3UHJ
         uR/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795134094; x=1795738894;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0CZfHhfHfESc4YrPufMYXO8QeXfOTlDtABpZbDYX5SI=;
        b=OkYiYR6F2DFn3USziBAPlQIFq8g2pe9gPpzGDGsPMq3SS1Xi7ECK2uJlk2Qfpcyz3J
         cpLP5qkkl7sualdLrHHenqSz94gdp4SSmldz6EKXtxwtnzjK9G+oiTWK0jLe5j4sOEwr
         8jDHbZhU6h5V3ljWcFUZKEAlESUddC9iHNw/ZQjoppz7piky4faM6HQxQy619RpyE2+J
         +pwZDGrYKrosaZzmKJMDC1gBsk0deiJD8nNMGyT8DqL1W90JmScJiWgxfD3eMHUoBWFh
         XU3Gf+Iqv3iy9PKawXAQxwt+z9UgjT0oYO/0SDwtEgpMqgfm/h46BuRdvEPbMt9PRXz3
         xh5Q==
X-Forwarded-Encrypted: i=1; AL+hErF0svs8/RmbSg3t/AE/Mt+jwOgDkGs8xSrjf8cxkKhQtlrpha0Q7wfxNzZCdnaHu0udbFrv3xIL@vger.kernel.org
X-Gm-Message-State: APuU4Z85Xi5Zc3ymI8FGiuHSFeLtW973VI8PHuWOdr6hOBeoQin5qAcC
	CMUEBI6hbuQHa7Ua/FWET7lr4tLc+BrlUdlG5R1nqSu1S1yrRW9/tZFQ3Cqz40boH5d+RZuaIPL
	ZRCO0s8a11TL1if/NFIWR8lNVts9ckxA=
X-Gm-Gg: AYBFou3gfZSqjQSsTMHEfrAPU1STStR31cCg9CBe43Yoi5JUent7Ap46uzj8WfhHvbJ
	vMJRwVt9eEFUrhFsFLwc7qYUBJ9ModwlV/XakbMyqWHBERy/vS2T1zN+foLBcTsZvn0fsGUgYn/
	vq43uYT+2vzb5p3aZTyYlLq+3hETUU6sKFpAxpYjMcUI3itsezVjgseWlkitDNAsZuifkD9Eomt
	ipDn4lJjnSqxj/DAxo51ab02ulYjSZEyCN9r/47mi9vPnT6SJVEnOzVkGyp1ar0YkFONzZSN6wl
	iCjTlh/cqXIqkMjo8ldrK/+ALMkRAwFofnhJb7H0ZH7vdPwbLIRKmuscYW401O/k1Vny1jnGvfn
	3KS64X8M+EHLxD9N6mEvJZ+FTq6O2CjnxXFejHe0LeWWy/orrXDxHhRJZl7h3ZyjZ7jgf0AIz63
	uFpD+JLfxOmPzOrfHFzWehDskUgg6mg9EKjtK8bQkf
X-Received: by 2002:a05:600c:4f84:b0:4bb:8701:a2df with SMTP id
 5b1f17b1804b1-4bb88809950mr27334705e9.17.1795134094416; Thu, 19 Nov 2026
 16:21:34 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
 <20261114002822.1043378-3-joannelkoong@gmail.com> <avvhFAxBcPk5Q6pW@chrisdown.name>
In-Reply-To: <avvhFAxBcPk5Q6pW@chrisdown.name>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 19 Nov 2026 16:21:22 -0800
X-Gm-Features: Aa3M54ocPog8ZiHHSRBMvtbJbL2fyYxbh9unTOuH5y8YoEH3_wTAT4fdm-kxXRI
Message-ID: <CAJnrk1b8cCOVe+4KL1LTUqw3vPE1EiFcELwurzgGPtfkvc8UoQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm: memcg: read root lruvec stats from the node counters
To: Chris Down <chris@chrisdown.name>
Cc: akpm@linux-foundation.org, david@kernel.org, yosry@kernel.org, 
	mkoutny@suse.com, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, ljs@kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 9:07=E2=80=AFPM Chris Down <chris@chrisdown.name> w=
rote:
>

Hi Chris,

Thanks for reviewing and testing this series!

> Hi Joanne,
>
> Joanne Koong writes:
> >The exceptions are the kernel memory stats (slab, kernel stack, page
> >tables, secondary page tables and vmalloc), hugetlb, and
> >WORKINGSET_NODERECLAIM, which counts reclaimed xarray nodes (slab
> >objects). Their node counters also count memory that isn't charged to a
> >memcg, which falls into two categories:
>
> This still describes the v2 denylist. With the allowlist, the root memcg
> also keeps reading rstat for NR_ANON_MAPPED, NR_FILE_MAPPED, NR_SHMEM et
> al, and some of those differ for reasons outside the two categories here,
> like swapcache being counted differently in the node counter, for
> example. Could the changelog say what is on the list instead? So that
> would be the stats that only change through mod_lruvec_state(), with
> everything else still reading rstat.

Will do!

>
> >+      case PGROTATE_ANON:
> >+      case PGROTATE_FILE:
> >+      case PGREFILL:
> >+              return true;
>
> NR_VMSCAN_WRITE isn't on the list, but prepare_scan_control() adds it to
> WORKINGSET_RESTORE_ANON, so once the root flush in reclaim goes away,
> root reclaim would mix a live node counter with a stale rstat value.
> Unless I'm mistaken it should go here as well.

I think your analysis is right. I'll add NR_VMSCAN_WRITE to the allow
list as well.

Sashiko pointed out that NR_SWAPCACHE and the other charged-folio
stats between WORKINGSET_RESTORE_FILE and
PGPROMOTE_SUCCESS in memcg_node_stat_items[] also should be added as
well. I need to look into this more.

I'm out on PTO for three weeks but when I come back, I'll update this
series and submit v4.

Thanks,
Joanne
