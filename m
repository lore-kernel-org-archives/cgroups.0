Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E552D73BC
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 01:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788830386; cv=none; b=hGbU1rretuLilCzmHXdOopUBNK5MAyVxvZdncn0CSgRma2FxvH6Ip/IbNyqA+hDa2Tk3GXIkQ2ZTJdVmqx60KO+BnB90lt2VOqS+ju9agpS70nRGBWgzNmwp5uXVl7bMiOhWM1+B38isGjXfwM81tUosJcsxMk1Zp9NOCYR0yeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788830386; c=relaxed/simple;
	bh=PK/rwgSf0AY+1TSx4wx+jvG6IFsaQdqkhts9XFU40Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQS5L3tGKVP57biwiutoErFV0IuY0pLpVf3v1AAUfShr5C1FB9Gr3fuLLBPzj5an3GBmLdQcSEeP0B0c9DBKcrcZRcQqsJpgFD3lOm3Q81zyDMbAYZ4r1Vwd9JCsJ/AVC/UHBV/LogkQhDr3twXNXlLlJVUSU9gUQgJ6fA+rkeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B3SVJ9vI; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B3SVJ9vI"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-4b28d7c729fso2610561b6e.0
        for <cgroups@vger.kernel.org>; Mon, 07 Sep 2026 18:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788830376; x=1789435176; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C4iTZNJwexeZeeHQj3UOdA9eylxa0Qsx4P1q2zIlRJc=;
        b=B3SVJ9vIyJ/sVE6cMpLMoTP1/S14xbJeD80WguTchJqSs7luafbHUJyszbCZMXVvt8
         7WNfkW600Dc+FMOiPRpU4ubbYnXmkAWP7f4fgBJ0n40RZLInsXf59mi2GcpVvqGfhVQf
         Alc0aZnH1vbA1p35tWgcoL5Oxbqj8ZFgDJGgWwPHGyJ2PK92nTbcJRGqcHFUFrEazCnC
         R9FWxJLGdK3HCTpbfZ8y3Tw26K9WDbmmykFD7RFfQuSENZeqNAP2SrI5Wr6HDLtyq1HO
         i5cMztIRhQfNj/heKkRTuDwCsCy1051T5hXvXUjwlwmLius7yuboqS20Js7udaymjpC0
         TWug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788830376; x=1789435176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=C4iTZNJwexeZeeHQj3UOdA9eylxa0Qsx4P1q2zIlRJc=;
        b=N2yt72eJwnWZDJwqFWigTWaWp7nn+1KFkZT8l+KhpDsr4k2daOiaLZaljYFJJd/Kz0
         teTZOD83Xc6A+8ZimUnPoTMuCDaj1B24yVy/q5DZRwBgfB588HRaeOVDaPNL3Ut0kZuY
         eKPD2ncRgY7KG6SkiK25nLNVeBBLv40/HgThRXB1EvHq8wNi3KJ6DhFPBGP3giyvrQVC
         G9q/PsjYbcEcFE3s4bJ83TZvCndhUZt32VD7O71uN3dTEwracSI52zbbkJFpxLloW9Ia
         VkOw9v8sFFhzFCNgLgs7XGDB4J6uhLMCSoDu2wrExIR1w9ukFPV4H70N++LtagLUW6fK
         snBA==
X-Forwarded-Encrypted: i=1; AKwUvBwDBcpCTLcBgGOgYXZ2IXOQUdPV/d8ilPpIuphzaCoqwHiaoutTCicEUBH9ggE9/tsq806Bt8Jz@vger.kernel.org
X-Gm-Message-State: AFuF++ndZ9YHZb/dIi+WZ/KuX4u/HY5q+r29s7PewQUTSbmCPd7yVbs6
	BCuThG1Xg5KXvmCFd3w0T2OrkIrsJprJER/TaTN02X9TqmO6e54FAO/H
X-Gm-Gg: AYBFou3MBd0fNBanN81p55cvuv8JtWfN3EAQLAmHrZEcxTS9vPB6hvs8b7waH2Os6ql
	kMCekblJy2gvwYnnDYPOp863lpVG0jXOQG9cVaCmgvUy9kYs12AejxbHcErNIqL1FqViutEkFDF
	MWswtdKjYhbL7TpSQMifOcEj6dkKCH/gwhd+badjQUIbxxX3K411743dRmguiKaZGXGOxB44AMI
	aIAl2y4M5q/OezXcpXg6LqW8IFztfB1aBFnxi1Scm3wo4zGFFLCkmFnN1/kuYvutRSi5/T3q5qj
	VYNZV/RtXVpYkQ+cFHWK0ZOkavkF93WetL/74XUoS44rfQf3Ggvck87ie7yKI/cQ/fK7J0Kfpv0
	zDeWyCLP7i3UyfvkDdAgjs1r5jQas2h1EKKXpzAG67sea89e33d/XJv8Q6J0NlTHlbyIL3L2VGy
	UzwgP4V2z/Z8LiBm3cI0NK2IfNb7OjJwWIjg0IPMdZrdJ8uu4wcks9pkHssXjxzH05GljDLLTqY
	eHewb9cOx9ld2q/lA==
X-Received: by 2002:a05:6820:168f:b0:6b7:83c5:fdef with SMTP id 006d021491bc7-6b783c66750mr12147449eaf.48.1788830376431;
        Mon, 07 Sep 2026 18:19:36 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:8::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b6dea11aeasm14793941eaf.14.2026.09.07.18.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 18:19:35 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	dev@lankhorst.se,
	mripard@kernel.org,
	nat@pixelcluster.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	osalvador@suse.de,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 5/7] mm/page_counter: introduce an asynchronous drainer
Date: Mon,  7 Sep 2026 18:19:34 -0700
Message-ID: <20260908011934.1737458-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ap9HiQv7_9cyIe2e@linux.dev>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 7 Sep 2026 16:25:31 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

Hi Shakeel,

Thanks for your review on the series!

> On Mon, Aug 31, 2026 at 09:37:49AM -0700, Joshua Hahn wrote:
> > The existing percpu memcg stock drainer schedules a stock drain worker
> > per-cpu, one for every CPU containing the target memcg's stock.
> 
> But you are introducing remote draining. Why do you need async drainer at all?
> Just always drain synchronously.

I was trying to match parity with the existing code as much as possible.
But I see now that this series is a bit complicated because I'm trying
to do two things at once and mixing up the page_counter migration
and the scalable draining together.

In the next version I'll keep parity and only migrate to page_counter
and in a follow-up I'll address the drainers separately.

Thanks again!
Joshua
