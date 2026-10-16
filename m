Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC4D4DE72D
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 16:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792169077; cv=none; b=GijaeDXxQUh2sWYuT0GZfH9s9xT6hVpbIct3qtpqnLQC7HV9pizKF7pbv1FdO+K/4WJEZLI8bR/Kw0chM1qdvMNmYt/0d7XOUnd+8yRRsRYMi4y+XqRLWHxKJ1IxvRe3yOEgsr7fHenjjlhxeIDs7Ieffli/ScTqZUZYLDyvpUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792169077; c=relaxed/simple;
	bh=s9lKTZF8DBrh8wqpwctlnT2WvIuygkwQPynvZ5EjKu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PDb8AoQ5fd18afljOnM4VcIFc3r2LLIJkrTHYdlbFXnLrxHZaqOhhFx7VSeNkMaHnbP8CWGZVZR6/io+IZOAIlWmGXnq5GFYtibv7ZrCaQ32SmZHzweJvevuR4cuDoDVs/dmce9W+1a0I+zqgseq5yzQSbjWKScj4Gv+gesMcB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=XcrqgQco; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="XcrqgQco"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93f1e5d7450so12467885a.2
        for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 09:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792169074; x=1792773874; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wEVFUYbKAFDbpMze0BDiWYsy7fzEm9zY0vOk13vTjGQ=;
        b=XcrqgQco8JlgB1V166qMser8YEgzamOtUWbM3TsRGBEr0wskcwpQ6mUTPhjQj8fRZn
         8MfRmzVTz5saWvvsv1zkE84UbvTbHi1DyTZlH5fB4bNJbcqRTcEo6cFXXYM0OI6rbXeX
         F4yZPMMWI/lk/zwymDotYhkQFX4SIOYL5/P9lAbuhfnt6IG7exNO79mB4Qx4fQuC/qOA
         ViCmJxkcy/DSWIW60pbFHEY+E2WPUwhDChs/ntsNsAXfNCY0IaPmx6/eTMFvpKIDlZLB
         u75p+jEl7jN3zp5UnI6VAV37M9FkLgyKBm742KTViNQ0bv1U0f5ksNWnwOID2qUrRCjt
         aG9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792169074; x=1792773874;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wEVFUYbKAFDbpMze0BDiWYsy7fzEm9zY0vOk13vTjGQ=;
        b=robe6DIj1tIfRv2xC0WYLOfYtaTVtxxER1fySeJEzj3QcHpTSomi6kaSrT8Km72G9a
         hIpY7di7zQiYfYCZ3BnOXdJaVS2wNY6CuZeEul64RFmLD5aGSJKKnX3w/J2sJi9vQ+OW
         334sR9UCzdBRkvO6yQgEUWqT7gGFIG3Hkr6/8O94Woiu8dwuuYmlIUhjzwCpeqF//4CO
         n2PnV7T4XzjfOLqQYJUxsIr9Hy2+2Npn6SfEMqSm9xta0BAQN0vidb7ED/J7gXy5bRl0
         C3NUSotDXUBzbMKkgmviPyxl+yytCe4CRidsW2IUUR5UFV4/8SL5Y8XSzrJYh71SNKDj
         6s6g==
X-Forwarded-Encrypted: i=1; AKwUvBxelaPvVH7O9UqVFUTCIeIr80BACJVQhcwI6OAY8BvNRItMob16cZBlrwXfqvEjU17qsQbGx1mB@vger.kernel.org
X-Gm-Message-State: AFq9FYKydiQ56Hp6Ih0iZXbmP17BheQz6jzVNwu849w6IchvIm13OzQD
	LZjlEharW5KopefQxcgeIRya26cz0ASTIRIg9CX+QeULj8LCMTpo/AoMvEtX2Fk/jD8=
X-Gm-Gg: AYBFou0FOZkWwu1uHlyL4FTrLhlicSvILBkswi5gXGrPFs88HamOXF0FRhpYtDqxzJj
	wL5QIoJKcyDWXssq2Kz+mWnYSnNV9VOxY00sIPLwqHmkFaHMXxIrK584t+7rOuAujMayNkYC7Kc
	OIPGqqennuxhzu75JUZ/adJklduiAX8XvRVAyD05oywpAETviN35zWt5Cnx6A1C8vKjPCkRgzXG
	t/h9v0LjubUjGqvoOhFv8VS1ifCy5nr2VvEw4Dsp5Dyhxa1nI+6zRgtnMOTe9a87xd4ObzeURfE
	/uxxNr2Ww3ND6dJWWx/HREkMk5qmrPYAfU7RKfSemSRWGy42rELn3eTztBwmz75TEDMD+VsGLB8
	ftGQWQZKzBjvWbYcOgTtVZHbJDBIDi7VA23vSwyQfOzAlJl0W3HmRweaJt4CUZXppDjMRwPVVL1
	L/cHtcbEJr1T9PGMfxu8RbR2NV4vQ9Ys7wd0QPQB8095COEc2SdWhWLxqkBCWJd9AFltEB9T7dB
	onb6Hx16YIysJKx4wX5fwdKSZslRqZXCVkX5nLn4WhKGDwS7fPXEMkQ
X-Received: by 2002:a05:620a:269a:b0:93f:26e7:844 with SMTP id af79cd13be357-93f29d68b94mr65782485a.55.1792169074078;
        Fri, 16 Oct 2026 09:44:34 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bcb8b69f3sm27054236d6.3.2026.10.16.09.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 09:44:33 -0700 (PDT)
Date: Fri, 16 Oct 2026 12:44:31 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, longman@redhat.com, 
	ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, ziy@nvidia.com, david@kernel.org, mgorman@techsingularity.net
Subject: Re: [PATCH 0/2] mm: fix two allocator races with zonelist and cpuset
 updates
Message-ID: <atJUCRRcgRkTPigw@gourry-fedora-PF4VCD3F>
References: <20261014222456.2318284-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014222456.2318284-1-gourry@gourry.net>

On Wed, Oct 14, 2026 at 06:24:54PM -0400, Gregory Price (Meta) wrote:
> Two small fixes for lockless allocator checks that can act on an
> inconsistent view of state another CPU is updating.
> 
> Neither of these are stable-worthy.
>

I'm going to need to repackage this with some additional race fixes:
https://lore.kernel.org/linux-mm/20261015210539.3243563-1-gourry@gourry.net/
+ 2 others not posted yet.

There's some mild conflicts with the CONFIG bits that make the entire
series worth backporting for ease.

~Gregory
