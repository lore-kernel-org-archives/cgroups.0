Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505FA2D7DC6
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 02:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785809920; cv=none; b=ccT/+YWYVbrMnDpT7u6dcj49qMgQ4DVCBo8xY0Xy+JYWBMOqlTGHYmBydcqNFc4W49WxnmGpbi3/B5EUKYDf8whmDRD5aY6cISKC9FR0NrJPVvgbE0JXrhAlI4NEF9R16ulsjk4/MGImDj/YSaoxEDXc+1q6EYjHTA1g1SLWt4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785809920; c=relaxed/simple;
	bh=pmJMriNBQCqUGHeZqy6wsbcjTG2fGf0Zyc7A1+GzgEU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=cK7OwRa1RPE9D2boJQ3RGrU8VXZcZYVXXg9d+OgyhLogfGXTwOnN4fJ9tYLWzpaarndtwY/cogzVPfcdezcp/3/OcrRpKFdUmAcfTtPh19+5t3vmtnKY/lwMIVLXlMzZKIYHOsQEslNXA55GE4o+V5SOW0gXb4/PGSpmPxw8Lb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=l0Ak+XAd; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="l0Ak+XAd"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7e6b5737bb2so3680557a34.1
        for <cgroups@vger.kernel.org>; Mon, 03 Aug 2026 19:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1785809918; x=1786414718; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3Y7g3mGGhWdn70/LKwOlCWoCG1+0V5HkHLeaxW/1f5A=;
        b=l0Ak+XAdg3po0nbcIjyPplfPeU7ORQI2z5QcvgJMHCVqRO+0zLHRXnQ6wWwKq48ujd
         Z6MC2Oq5c1bSo2/BDS1lua0M/eQ/zxoAEIkBjBOs5+rvHk/hFxEg+efvLE4t2dwB6QcO
         zH4yfDzxLR+ApKCmIg7MkECbIYcZTCywlFa+GbnXEsIy5oV+ppALAxa+E3OxCXzcjGNI
         6EPzPQ9llM4fTBNnSW/H7lu/hSYuYd33qr8BisBQTiojFiHFpeoxpmNBu7MoYb3jbn9U
         xe1xwoQgtvpfH08daNR6zDuEOapKnvkwXvT6D8wogKlfqznG/DTSlOMpau30Ql/B14iS
         SJ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785809918; x=1786414718;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3Y7g3mGGhWdn70/LKwOlCWoCG1+0V5HkHLeaxW/1f5A=;
        b=nJ6rYej3yRdgYliG1XEbvjhQLomeWwL0xZs93xh8FtyKFdypznMG3/2gYocU3X4ftL
         qEW9D1xQRNjKPgzy6GJl9+YAc3J4s2yoQ/Pkgd5paojhaBrVWBAc+sbjonRIw8Ej0llv
         hvGZOQ1Gv8XfHvhZuOMK1wNG4CqBMBhUp2QdK1llNbpI22rBX9NyyJN+86ZbSkASNgKj
         rGQAUl4BCCM0i/X+IIlZgT5GNsxPtxa/B/msueMpzrJE8mDUEN01HPLfge5T/rH58qnZ
         CtDsE0jY6cUs3uLEethKk4gAsk73E6p1/To4p8viNYIRtOCNosjChD26XN1uhjuLnP4B
         VpGA==
X-Forwarded-Encrypted: i=1; AHgh+RoliqhIPfLPdA5ZjA4MxOGVifdNa3AOJbvgkLM2EsfGU/cRGHhbUsSDVdb+kllNBpt+yZQMvvj0@vger.kernel.org
X-Gm-Message-State: AOJu0YwZ2XsnfvKEU22wjcrCfMTagQ9Lah3W6292aZR4bI+92eesCv++
	RVkCWQG78UdPlZgwstqwaOXDeldVqid1jD7iIOoUMtoJ80KVtrGLXzI/XwUXNw2sWVc=
X-Gm-Gg: AR+sD11W1gouye/1K7TpeY/S8B1CTr9n1IqJ4sOLyL82XTeLwZa5ae2MAgr9fOXrtEU
	UNdEnTht6sH1t966ObE1TnmMmMIARPRWJsgPRRPi83oBGXjpvzdTi3Qmt7vH2GK9keG1AeAZ2yR
	apw1Z6g3P5RNjgr8Xro+5yVfR7BklRBCwD/v7diI7n2qOJXOyXhBTvT799/txV2aL4o0JjA6P/x
	RswDlDO1Lm0maRMuQwKzKAyrNUnciYssJh0D/MKlGbnOQpUEN7wkDd/c1WvCrYEvuYHK3v2XaOS
	QNx+3MR/al22xd8HqB+yJsFja4JdCqo/JD6hwAD7NqvHf7/aRO1cbARta65PpVVSQCKKfmw1wr9
	JP7z+mThvnysGWFhKdGuMpOOD/vOqntwBUn1r5/5EiYFEep/DVX9rm7P5T1Vunu8pfLcD5nROVF
	N+Z0+J2Yl8+v6HQoLfei5uJ/DFhrFndBc0DYJHajG+OkOD4iEFCz0wGAizHbGxkmDYPZgRl6I3D
	67t4XVgkRGifybViPtYXS5jNofG2KYf44BAL9z97A==
X-Received: by 2002:a05:6830:3691:b0:7eb:3af8:8c09 with SMTP id 46e09a7af769-7f196cb6591mr21082116a34.3.1785809918236;
        Mon, 03 Aug 2026 19:18:38 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f18ed96df3sm8941838a34.9.2026.08.03.19.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 19:18:37 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: yukuai@fygo.io, Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, josef@toxicpanda.com, cgroups@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Tao Cui <cuitao@kylinos.cn>
In-Reply-To: <20260803134104.138411-1-cui.tao@linux.dev>
References: <20260803134104.138411-1-cui.tao@linux.dev>
Subject: Re: [PATCH] block/bfq-cgroup: use data_race() for online test
Message-Id: <178580991680.519961.8800080646193720210.b4-ty@b4>
Date: Mon, 03 Aug 2026 20:18:36 -0600
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Mon, 03 Aug 2026 21:41:04 +0800, Tao Cui wrote:
> bfqg_prfill_stat_recursive() and bfq_bio_bfqg() read blkg->online
> locklessly, same as blkg_rwstat_recursive_sum().  Annotate with
> data_race() to silence KCSAN.

Applied, thanks!

[1/1] block/bfq-cgroup: use data_race() for online test
      commit: cbe81d612038fa3fb986a1e31fe7b8f808079cf1

Best regards,
-- 
Jens Axboe



