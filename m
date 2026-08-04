Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0241D37DEA3
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 13:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785849807; cv=none; b=GnppqiyXqhmzWwHaGeyhZ2RIJ/buXEM+DF/J5CbxeE6RGo4n1lU0W+Cu7xhPC1brMy9WSHhVNccS2rrYST2/gY8JRoHWdXMND9vsi8Zxme0rlqHiaWsJ+9DpM4ZnXPP5Fz9ZdD0xv5uOz64VfVVAnsCSQhLJWEgNp3UsJyMgT2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785849807; c=relaxed/simple;
	bh=nJGLwOnjaiBGr3EByw1hYgPml8fYT3IQsjeefH14hdc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=R8NLBUS1uYBGZP60yvkFc6lHhUvPPsRSFNYEfMFMrPMkvfSKz4VdVrO8aruQNc86c4dv9xToUKdZpk6RcBBnb7BTKMPQDTIJ1lbnnBvAAuSs8T09wh1Dwmwejd/uZLsjeFIbnA2N3YTCLFOICbeZrPxjkZ6nwmFGLX2LsIA1ubU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=PD8eEW0D; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="PD8eEW0D"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7eb34c17b96so3077470a34.2
        for <cgroups@vger.kernel.org>; Tue, 04 Aug 2026 06:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1785849804; x=1786454604; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RpVxsVekQ2M9CokiwJgSvP8TW55dMVQmJDPHcSttZIE=;
        b=PD8eEW0DbugPbt6RfZ11dAUcnJBahnu1PPs5Pd0d/YOVlGlH6x96F/rfwVfh34q6Du
         4x5K0VlJ8dvvwneyjHspysXAihMbD3ZJFW0SfyaC5AHCFUs9WkA5In63z0B0q05ZU5rG
         ftFdUIuRqyTJ28Hid/z2rVmYDr/tLglvmT5C9leaJU/oSt4BTEMCgyP8QXhlDC+xJ9vz
         MHAOrvBO7hkANitKHwg3+Cl15PG0jk4mfI1QkMJ7z7WUSRbHfTXxn6pQfDfErRe13UL8
         kesEDkM1PX8gqv3R7xnZEPNdDYs0h1Te8ZnMzIZOxPmTHf99jEBdjwGOaEAvMvoXHkzh
         zV8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785849804; x=1786454604;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RpVxsVekQ2M9CokiwJgSvP8TW55dMVQmJDPHcSttZIE=;
        b=OwrjufinjNfNTAoP7YGbf7A98kWd64b8+68j9y2Md2lKcUF07bxx2XpyH7j5K020xQ
         5AVwCaNihMUT+b6EmbPtH/GEg3YbrN2z16LTv0YLajK//Iacb82ZuDu+rKxNidyywC7e
         Yc5Di4JKIbMWDfevljBRXDVl66vTbUm2ETTFrGa+v+idXFYJGFM5FH0M0VLDyNKuRVAv
         G5OFDsY+hDjlu78qoIQTP+EEMcOX5F0nLUkSolGfrpEkRa/JKjould5pKRMRjfK++ub7
         8Atb2Fa4N042tcX26LQOK+GBe6n7M2Srb6dMbRGsMgohUHack5uA8W0oGo/8wOTKN9iu
         UEcg==
X-Forwarded-Encrypted: i=1; AHgh+RqajsR3F0BdpVIhsdx4a6Jy1Ukm9cMqiWWb8yQ7nusPdJucvgEy00BMUTCBs+1E7sSn3aW/gjP5@vger.kernel.org
X-Gm-Message-State: AOJu0YxjzzQ4DVGS9DGTJ7w0EDNN3+fmTV0HOLmJrFW6Xwzva0T5ufAE
	/kc5SpKudSy0HFX/xidNUuEgToC4TYS28GfEDeQFM1cxFwGUTiV8bfLgwaMnXPrTAgs=
X-Gm-Gg: AR+sD12SKralvqnDxr3uJ7ja+h5s4K20fFliiQDr8wMsXY9RnRAZL3V1AWvfg/V78hr
	a/m6cb1okbJiqfmaEeA6Xe3lrMLtiESEebTbM4S4Zcg6Cna7TxXrwMKJso1CfpT0ZdjI9MOhd5d
	CFq798UQx8Qlwi5AOMYZHGkYpLShNJLyEgJ7Q8ImZz9gceu/FMH4kV/8DolLu24iFxMVP1zHzdS
	yzXTHgUuipcwogXweiTityC3wFOzJ5pSOY4jlpVhn2daxU0e7OBzE8qG6cLh0SyQ38Stt3z46UG
	CF8BqGKs1CXwDpf0ceHfokA/mgtzDM04g1iHRYtBe5fkK7YYl4teS/PAeAFhB8R/q6dT7aQpiVB
	L+SxAUqgluS/aYZK9VYX8/t/JvZM01NXMACegZApQo4nrU7ur1Y5uXTH1LWDWqHsBIIqJ0xUS/F
	lxtMeY0mS1cZUxUUKGo9+Ob2+ajfv0cwo9FXP5/UhB8WbEHMfN9eg6KsF0rnrRkzZM11UCAhrwr
	JiA9A+hK/rUtsCFKX6FdqMupv2TSk/XJZsd/7sYTg==
X-Received: by 2002:a05:6830:81fb:b0:7e6:f482:df36 with SMTP id 46e09a7af769-7f196f48cbamr26550307a34.15.1785849804022;
        Tue, 04 Aug 2026 06:23:24 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f1df568d7csm752384a34.18.2026.08.04.06.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 06:23:19 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: tj@kernel.org, Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicpanda.com, cgroups@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Tao Cui <cuitao@kylinos.cn>
In-Reply-To: <20260804054120.161933-1-cui.tao@linux.dev>
References: <20260804054120.161933-1-cui.tao@linux.dev>
Subject: Re: [PATCH v3] block/blk-iocost: annotate ioc_pd_stat reads with
 data_race()
Message-Id: <178584979848.950360.4692094909873127154.b4-ty@b4>
Date: Tue, 04 Aug 2026 07:23:18 -0600
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.15.2


On Tue, 04 Aug 2026 13:41:20 +0800, Tao Cui wrote:
> ioc_pd_stat() reads ioc->enabled, ioc->vtime_base_rate, and
> iocg->last_stat without holding ioc->lock, which trips KCSAN since
> ioc_adjust_base_vrate() and iocg_flush_stat_upward() write those
> fields under ioc->lock.
> 
> Commit 35198e323001 fixed the same issue in ioc_qos_prfill() and
> ioc_cost_model_prfill() by adding spin_lock_irq(&ioc->lock).  However,
> those functions read configuration parameters (qos/model) that need
> synchronized reads.  In contrast, ioc_pd_stat() only reads stat
> values (vrate, usage) where stale reads are harmless, so data_race()
> is more appropriate — it silences the KCSAN warning without adding
> lock contention during high-frequency stat reads.
> 
> [...]

Applied, thanks!

[1/1] block/blk-iocost: annotate ioc_pd_stat reads with data_race()
      commit: 4d73bf0ca4fbe7f252154ce98d6693c6c198164c

Best regards,
-- 
Jens Axboe



