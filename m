Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6353C81A9
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 10:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783937397; cv=none; b=nThqv5GE1NeYmVMX0kgl155CisajaMKOSVQuvLoO5Z56djIUmXhfsJoavbJKcIt/uqttb73RqHO1sgm24QNVMlf1J2dfh8owDG/S19VYkTO82KkPGX0IS9rHKEcQbzlEM1hDCH25crZHLtKzbnBtFqeQ/Yh1mkRt1/aZolRhlwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783937397; c=relaxed/simple;
	bh=gAekjFGKEHq9ATR/+uFuJYa0LCHO670PqMr8Feqyb08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CIrEzULbg9ruCib3BwsYhZ+GQKejde18Fd/y21iyPEVbfIpT3zqY3EU5lTrkjPRY211w/ftKdQtdMw0R6AAV1PK3cBkEUgDoXKwxXVU2fidqdgMRam9M0dfHCltV1MwZBPD/K4bHq9Jjs2oR3bQ66IEFLxWHCmUcLeX5sEKl5CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=G9usnbEc; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="G9usnbEc"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-475881b9a4bso2926235f8f.3
        for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 03:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783937394; x=1784542194; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RMaPztzkv7mkAfMpEcEj82JplFx/jQM80q6OSMWqA9w=;
        b=G9usnbEcxv3o9HfQLYYOUR/3sQnDQAz6Qkjmn80r+x/+4u93vIvNa0m3zk4U/Yhc0r
         V4VTi76XwTEjbw6qJIAUSbk0UfAvtYxCAdP0Z2q8/pdWEt+pmE8Tz6RUmXE4G9kazoRW
         BUbMRQSNA7EDcBpi6RGGe8ZGBh4KTIs6H9WkXWn4f016e+wjy/sIws1SgsBRWyA/5m0l
         /C3AKpNmRVSVp2fmgOR4QJBFJm6ylnLsc0x7f1SdyhGN3vny+hI3jgoMdqxAhNzCG1mp
         Q7TQ1ubMRLUSUm+r7qO3QrPMTSeQJS0mkbsWmPa7B2J1HHmU84F6PE2rq4HjZugbzXbF
         ah2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783937394; x=1784542194;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RMaPztzkv7mkAfMpEcEj82JplFx/jQM80q6OSMWqA9w=;
        b=kp99NIZpCktUI2nrgtzWorzaTyRd6WOG7vxgiZj1CMADha748ziGYOfiykIFFviOZ1
         t0/NpjkUIOMVOAZauSBkHXH9dbx8V6c+u/nvyChK3jCk5bNk+USXp7X7Rxt23qxLRqiH
         viRjLcrDicp1DBG/7+uTKagyIXMBU1frNS6H908AbLhBSBXHxSWft0Lo8mj69elkNlDm
         2ZhQI9I/LhOcd0oPniFK17xTW0ORnFfpbR/cYlW06lfPzMMMTufF3K/RE5iTVMf3cqJk
         1AHScMTP/cUzFE/0kk+4kj/EvzfPgzIByx7xXbiGDze11WMo+wCp4rO+/JP8FdTwysYu
         hyuw==
X-Forwarded-Encrypted: i=1; AHgh+RoVS1RPokQ0VS5sbI91I595NVFsqbF2pY85rB2xuVhtskjI7SxtzKRpfx7nNh485dFVZsy5YwxP@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+hA8reN/2QbFAOrqC+iizxKxwrLFPeHKeysCIPrw1B6OSQjae
	/oGGdqq6tmSwGXjRWYrZcgK0DW88wRaWTI1/0Ja0gpCN4Ys0ZcPuYJJvB4T4SXNUtcg=
X-Gm-Gg: AfdE7cnjYCFxE6jNkO7SAtCp9UhWbAKX3hVByzXVVXYZedOCGACF3zCdPywIRAKGPQr
	mbqdtG4Edt/1R3pgm1r14BKgu/iPCMo3ln2QFOn9z+w4hwK3Y3wLnF3o217uOn1R410PrxBUXdk
	Ciu7gOOGpbKMWBx3HGKoDMB7i4UermtKO8+2CFdhzzNeC7Ittf50XoHXVN1pVtQdG9wN8XlZBR9
	+rQtoSRuSMMRGQRgPbSi/14j/4C+jFx5tHlExIXor3LBKXJ/EfAs8ewEhLaiU3top2C+HdTXiCR
	e/b5qVcIH3iGwsNcuXRhfoZ9CyZ2+FPHMubUaE911+nyjtglyMcNCA1Pmrdbg8goB4HSG2QNbdx
	LuF/C9/nFRSwizaMTp0ViWqgTOiEJESzrvZ6YLwaW7Js7ZvXKW2n+qSuqtacr586wjRDJAwEeB7
	hSx1SuCNN0c3BZdnJfOd6fvC0=
X-Received: by 2002:a5d:64eb:0:b0:47d:edb2:a4ab with SMTP id ffacd0b85a97d-47f2dd2c919mr11096800f8f.43.1783937393990;
        Mon, 13 Jul 2026 03:09:53 -0700 (PDT)
Received: from localhost (109-81-90-85.rct.o2.cz. [109.81.90.85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa039b0cesm86605884f8f.22.2026.07.13.03.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 03:09:52 -0700 (PDT)
Date: Mon, 13 Jul 2026 12:09:52 +0200
From: Michal Hocko <mhocko@suse.com>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcontrol: drop unused cpu argument from
 flush_nmi_stats
Message-ID: <alS5cDDzoOJUWhlm@tiehlicka>
References: <20260713090010.2991906-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713090010.2991906-1-guopeng.zhang@linux.dev>

On Mon 13-07-26 17:00:10, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> flush_nmi_stats() does not use its cpu argument. Remove it from the
> function and its !CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC stub. The
> caller still uses cpu for the subsequent per-CPU rstat flush.
> 
> No functional change.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Looks like a left over from prior versions of the patch because there
was no use in the 940b01fc8dc1a

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!
-- 
Michal Hocko
SUSE Labs
