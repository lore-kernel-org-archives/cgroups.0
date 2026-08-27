Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE71B2CCB9
	for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 14:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787840940; cv=none; b=kAKx6pWU5jSdZ3FYgDIw3GiSXtWaPTGL1O8zVMUeGgU/Lm+wmzw6BBvBOHetSUnHwBSZCSrUU1rcHNS6tCTlC1bgkbafdXfuC/KEL0cok45nGJ6/5nQzr2ko97CrYblEBmNU1LOzAxU2tiTJJBeaG+mx3lGXyTNz5C92SMPkjF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787840940; c=relaxed/simple;
	bh=nKAx+rvAzxQ2/kf2GcBVYLAy8Xi8kdNaL+EwFmlkcWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZgxPLR6WSLFq3n3g5XwDPoYffFiJ36N2Fd6mTYXnsLD6ELcXtRj49n/yPU+eEapsSK/LF2FUvStGjfybwgMMShhfw7/wnHG5GNlo+rv4h2/iSAGTT2X2pHIO9HE46MVn/u6Fcp3CUKXT/Zd6ULe0Klkbg1p/3HjLQVcsvxoDcXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gTYm8g/9; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gTYm8g/9"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49978908b35so16806885e9.0
        for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 07:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787840937; x=1788445737; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PI7Nz8d3HH69nhtcQsyOVYUPwrNGYdNUTrVZkR05tbE=;
        b=gTYm8g/9KbfqyhipbgSGeThEFgXOcXxabdTWb5EEzOyxnxM2hflSJOx4ResaUX8kz1
         4cr6raNb4sWtBDJ0XXGta9HHjOI80JJEc2evQQDeYTTzhHhduH8/Qjxth86M7KifOLeq
         xhKk6iHQBqb4ld2cH4KAMc9zDDwQL9sqXD2/zLlucOqp03reBjW5F19Y5bE94lO9soJe
         PlhaXia87Mm34L9DGhRSftRPmAivW36q371pLAhAJJ72ApY85FzVUSXup6rCGXJvB6Gw
         qvCRk852/11G5ToUy0fDscvA527YEdvHPQuozbr85VBlr0RoIa7qhPPuTxa4tKBAJveW
         AI9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787840937; x=1788445737;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=PI7Nz8d3HH69nhtcQsyOVYUPwrNGYdNUTrVZkR05tbE=;
        b=WuWab/d8KTEa+XF0iYn+quvAz5gdkv9dHplR4fDiTzhaGt4jxv/ebTnh89vJL7qq46
         Djs2wufuJHJsk7dbMlWLMsX5Q1Fb07UFEsIfhtqG8UsHxIt/rxqoWkg2iebevtc2cCC0
         R/wDDyW7SilpjFOPSYa9p9cXPwxd38/WoSkI9g3bezJZaVr5fWfMRyhYZcKIoM8ss7Mi
         IvWBdJKhnoV/Xk/szq31UkJk9JKmP+7Xhkqzp14itHdaW9mTpqC644Ajy6mT+pLj7Ml7
         XxjVCkc9V/QopDRoR7fAlVy9ifNS06Pmnpj/QJEMxdWBJ/AUre40gkXysYD/hX/wxbG/
         FG5A==
X-Forwarded-Encrypted: i=1; AHgh+RrTxW0sSIX+uL0VEfV611tEtxnlAmI2SDVkLhLi1InbIoBoeFqoldARnhcnUKTHyNxRZ92GOzPc@vger.kernel.org
X-Gm-Message-State: AFuF++ng081lrO4aghvBhVisct7NGK53/x2ePxeWebAVhD5fR60hskDp
	H4l/XFU8mXMjYwRHSRVHP339anXHJu+x9n3IWaaMw7sbKU+JHFFX8kDyrx9iBhYhX+w=
X-Gm-Gg: AR+sD117AcaeKVKT//jIbJxD1hgDgperFDlMvlFF1enmv9ezXH5Itn87agrIYEj2f+2
	lH2X9i+6AYhq9DS+78uBgTQxMNR7tXUMlsNLtafrdpxUhEqaEygP/KIfb/KjX1aCvGXprfexx/e
	HLxqub63ca19zd3E3rsH7ubdvAk0m8fynxkv1CwcW/3WEWxXaJ8L42IggcgvSvfi4daOMSQppR/
	cLFgtF1qUPzPaFvOaeDvEET1vVWdeb6JD0cv8h3vk0aJQsYGRZXys7KHFdFFzZhHuEsG1mhKn/R
	miGYkHO39jjnBqDjp1bT/CEu6SFiIyOtMJa1CxcBVKUzIL1IHTFUYA1pw2c3bTCwWj10JoeuBMP
	K/S9TyLRzp7qHUvy2dsOdXXyL7wH9gouNq7FxuLSmAQPw+A2Pv7yh6KWsU3HyeMtQ8FmOPNNHK7
	DmF46rQa40zej0Znfnwrj8g8EG22iPJ8AK3eOB29KOeIiUeAtpQCM=
X-Received: by 2002:a05:600c:698c:b0:493:cefc:d113 with SMTP id 5b1f17b1804b1-499dc6f5dcdmr215984745e9.5.1787840936850;
        Thu, 27 Aug 2026 07:28:56 -0700 (PDT)
Received: from blackbook2 ([84.19.86.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b494228bfsm54431465e9.2.2026.08.27.07.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 07:28:23 -0700 (PDT)
Date: Thu, 27 Aug 2026 16:28:02 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] selftests/cgroup: test_zswap: fix implicit
 unsigned promotion bug in test_no_kmem_bypass
Message-ID: <apBJbOhQakQH4WyP@blackbook2>
References: <20260827034807.2822234-1-wfelipe@google.com>
 <20260827034807.2822234-3-wfelipe@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260827034807.2822234-3-wfelipe@google.com>

On Thu, Aug 27, 2026 at 03:47:42AM +0000, Wilson Felipe Pereira <wfelipe@google.com> wrote:
> In test_no_kmem_bypass(), delta (stored_pages * page_size - zswapped) is
> checked against stored_pages * page_size / 4 to verify that the pages
> pushed to zswap belong to the test memory cgroup.
> 
> Due to slight stat update timing differences, delta can evaluate to a small
> negative number (e.g. -5MB out of 1GB). Because delta is declared as a
> signed int and stored_pages is an unsigned size_t, C's usual arithmetic
> conversions implicitly promote a negative delta to a large unsigned 64-bit
> integer, causing `delta < stored_pages * page_size / 4` to falsely evaluate
> to 0 and fail the test.
> 
> Fix this by declaring zswapped and delta as signed longs and comparing
> against a signed threshold, ensuring negative deltas correctly evaluate
> to true.
> 
> Fixes: a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem bypass test")
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
> ---
>  tools/testing/selftests/cgroup/test_zswap.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Thanks!

Acked-by: Michal Koutný <mkoutny@suse.com>
