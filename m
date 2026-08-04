Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9113F9F28
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 02:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785809837; cv=none; b=XsfdMTlpndV7CA9Q9HTXDAi5jRISSlAVUzE5hk2LO38fhcq6coyeTWChRIgCuqcm5rWbiKJ1vMfKUp92I5fTiyCA4tfDDVzkXdyMj0B012V2wgH7EWTiGGHSOFeFO0gVP8BoTZSsZTjS3uqWBPv5fxly/vDstEj6Ds7JqSBZzHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785809837; c=relaxed/simple;
	bh=ugd4ls8P5Ob2mAtM9nqRZHiYdUNlnITlBsPv5xzpvGA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gE/+M/E4I/rNGUsUT2vyFmgcfWPMl9id7MbWmuC/C33Gti7oPShrlOZaZbNkO1McPu78Vqq4ZXXLanrEBfeDdzDphUxxA2cmLhP+y9n3MKvQkJ33Zy5yBy0HTd4fyotXqgUFqOXx1hNzjWmteSsBCOD0o9aln4UI540HXkmuUB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=zhJGm9dP; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="zhJGm9dP"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7eb63dbd229so357540a34.1
        for <cgroups@vger.kernel.org>; Mon, 03 Aug 2026 19:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1785809834; x=1786414634; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9x4qFGP3981GI72cVLYj63qdKZK9LaH4l5mhfg8vJwI=;
        b=zhJGm9dPx5WjuPfyMia4b+7ZIOFP8Ochr3tnOvbz2oG7s7d93bjJyxkO8yjSgUVxIF
         7IdyKatN3l4QEx4bvnn/+YS/6Bpr9V7DoIOTGvtZjPnXi0EedeODLelEmiJ8w0As0tKK
         obqFfr6SSBMqALIe+qqM44G9ZE66lAjV6eStgoeuVAUtctbta45qsL/FFCdYBbSSJy/8
         7cUdJs51NQaL0IJZPsmEWHCEKRynZ/42vCmmx7EXazeMCpB0Sq2b+3JdMb4Nz/tqd2k6
         m/x19SbRhPzoIGv3mRQMjj9WkJ1DE9L7ofZ/Rsi9mBCy/nueJAoVFpEaw/5/rtlOL4h0
         TAnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785809834; x=1786414634;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9x4qFGP3981GI72cVLYj63qdKZK9LaH4l5mhfg8vJwI=;
        b=bZibtlUsGO1nJZZWEaRtdVFzPH/VhYpLr+G1EFia+M2H5SzsC8rpPBDm2h3XAo0hg+
         lUkmJY9vj+JLRamd2+0Rgy05e8stKdFbMtlSr2FxFzZhTNGFYWivF0qhTszpZ7i1dI3y
         Z++xV7xvph6pyPpcyzH+6lQXBYbAKC9J8hBmyYvlWiN3ldQZtornbtYm16g5kO7Puvm0
         imqbZUW0SP/I+Qe88+ljeq4GnTbdHgmycn2ET6xbDT45MJLXpWTaCr6s529DxrncTY4o
         aDFmlM3L2EbHihdXdl/8vJSw7Pr43PnawIg0W4NUzgOWWJ70xbskwZhBckr96wSY/Uut
         6cxg==
X-Forwarded-Encrypted: i=1; AHgh+Ro4Fc8uCjfi3uZA1P5mJmmUrGvpIc6+ZR+mkQG44NG4sjNTZFy+WG++GENvUwxxQxhb5H4mqgpl@vger.kernel.org
X-Gm-Message-State: AOJu0YyCTce6SIJzanD7wzhMfE3uBecrgCmGvaH4tELQAONuQb+U8XJm
	eXfNFNcCHp38KZ3YL6XMjt52FgBGNE+Ex5RGgEnCxBJlhy2bWeIURY4yzmWgzmzJd4HLRLmlz7t
	1Wo6J9JYIFw==
X-Gm-Gg: AR+sD11DFWv1IKmKABPnSQ8Tu2DNmJPGzfC5tB0RvJqMlTXd06qR8QTVJB1K1G5TOBX
	d+Ix1xqxZYOP8qM447Qwh6E9S6YMtkDjoY5+ceQEZ5veRAvmxUOg/CcU6X7O+0s4vPHwNbLQOmm
	2hJe+Db+rhd6Jq1fl9yBCF3ZSew5sZN8ta1K5TTooTwBg73YcMdLfveyEe/g2TeAXCujzr2STwI
	rxFeDy/GejhQbKoHwLksQ/AeEVzrSugEcB0SFPuZErl2mztfKIWdbT1beAavAVcCXkdyRDNq/1R
	gHB86EU2Mmrxr0Cj6fjzlxjKQlmeC/3CxD3unYcm/zGcX1naoxF4Ft8iffxUAyN6V7bt10rqAdk
	q9WAcZq486232WkPY9wcPCb9xajITZ36y5r5hLLpXLzxStceLlle+lFuGBm0YTGabkUP3u5kow0
	N5J1m0wVib4n1PPmRGVfZpIFxQ49Bv6FRBHHS2RKSPF/ZdLiBkovxFXxIUn92YxAKvzuLqZYRed
	TWWUVzQqRsQDzLLqEHy1yIpgsa/MeKBfuQZF+pU6y1NU9m2n/xTJA==
X-Received: by 2002:a05:6830:a15b:10b0:7e6:d7b3:76f4 with SMTP id 46e09a7af769-7f1d1f48765mr1019984a34.0.1785809833793;
        Mon, 03 Aug 2026 19:17:13 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f18f07a55asm8914812a34.13.2026.08.03.19.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 19:17:13 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, josef@toxicpanda.com, yukuai3@huawei.com, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Tao Cui <cuitao@kylinos.cn>
In-Reply-To: <20260717054855.2018578-1-cui.tao@linux.dev>
References: <20260717054855.2018578-1-cui.tao@linux.dev>
Subject: Re: [PATCH] blk-throttle: remove dead field last_check_time from
 throtl_grp
Message-Id: <178580983269.518281.12242691821732111063.b4-ty@b4>
Date: Mon, 03 Aug 2026 20:17:12 -0600
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Fri, 17 Jul 2026 13:48:55 +0800, Tao Cui wrote:
> The last_check_time field in throtl_grp was used by the
> CONFIG_BLK_DEV_THROTTLING_LOW mechanism (in throtl_upgrade_check() and
> the downgrade logic) to timestamp the last upgrade/downgrade check.
> 
> Commit bf20ab538c81 ("blk-throttle: remove CONFIG_BLK_DEV_THROTTLING_LOW")
> removed all five of its uses in blk-throttle.c and the surrounding LOW
> fields (latency_target, last_finish_time, checked_last_finish_time,
> avg_idletime, idletime_threshold, bio_cnt, bad_bio_cnt,
> bio_cnt_reset_time), but missed the field definition itself.
> 
> [...]

Applied, thanks!

[1/1] blk-throttle: remove dead field last_check_time from throtl_grp
      (no commit info)

Best regards,
-- 
Jens Axboe



