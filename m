Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6B343A7F4
	for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 08:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785312150; cv=none; b=m4WtRVK8yLO0o+WaO/vWng/flBh7jO8p7ucNUudtZGK1bXLx5XLcUAlEkh2EyKpVRemmNEg+4doMogCH/1wVe5KXTIAIlP21Mg9EKnhmOmlrOny9mdHG67HSm5bCNwEAf1+iC5M71W3pa9TDUihjQAQhGJRYPOPAmqs/JBmMlK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785312150; c=relaxed/simple;
	bh=uyRaigyWSLAjcFMA+4nW37Qzta9DLAn1JIfpSEoopaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YVVJPHTMEV1uonVoVEqBe2GUBoTopeNttCFSarcjfwxURY7Rw4an4Dlwq5ENx84/Isz+yG2n38bds1XdL4pZ7GjcuNEfinfnCcUOkY1vkC89nHMHL6OqTz2g6KcxHK6sEdwZmEMVwnc+x/ARIkHgrz/dTzgftLYYVmRHBDwf2rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OMRGShBv; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OMRGShBv"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4798bea72f9so435184f8f.1
        for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 01:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785312144; x=1785916944; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xqNI7GzmVD+ON60PavI4uX979smGqBUstiCgQqn1YZU=;
        b=OMRGShBvAMH4JQ8MjFRWT91Lwb5WLIokzuKVEevH4s6rXqI5rDGVUt8rCFoXCCWBV2
         m1hzb9p/o/4+qZeiqe0Sgrejr612DR74ip5SnvLW4s05/jI5cJwnD7Y/XHQk3uicteZa
         VP9M1ZcDiaIvYiL6jxzKyN0Hh7TWzJAaTk7ZThxQppkWJibigc30m2Hmca4IXrDp7Wo7
         3HUqGlQ01Siqf6dkmIL9SYSqW3ivWTb+SgqOvAL1CrDeNk0pGU1+aS0wzLb0ExoJmikV
         p93Z5hdSPm5788285nnu61NPetqLDYnJjDXsHQPVyAJ63hxbdTW/UEFh8pCikStDjFIp
         w3hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785312144; x=1785916944;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xqNI7GzmVD+ON60PavI4uX979smGqBUstiCgQqn1YZU=;
        b=aoOBatz2RlSmAx6qSY0tvPSTHxCGDHb15xkjENUfP+M8uwRNP7JSbVKbWP/GVzFo1D
         EKHSwbxy0/XmzJG3u3QZkXaLftHwkoIdR6ZeMoD2EGpjjj+A09y/UcgmJCqNL1X+8McR
         jQUKwWasJ5Luoon9MpL0qy2k28exTTj//PMHh/ijM8WzESw7jwRotJaBCfnwmeP5aKU8
         3yXpQ502B+gkOwVNw1TXimKoWCDf1a5V1xTLYbzOiQQGn97bFNyAhkOPSz+xI22vFzhM
         6RrlRp6vHVJ2kBhExwqsDGPcEUNbZSd7dynEVRPrdgkOYMQt9Qh9WqniJEX16jsm5reR
         xorw==
X-Forwarded-Encrypted: i=1; AHgh+RqHhF+nEC1hObkYRw9BgrIdh8se3neFlkOkfS3aY2qdFJZ0aWwrcBPs0ZA3DoV5fka3vcTbfCi6@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2rE74dXVTI9eWDzpza0lJ9OywGVsMVODfVaIV+daj8mskNTAw
	JYNMLlE9e28yoglP7sGoorJc57fHwrRY7cHXprCPnhRJQDB8n2vC/AGU41fWyGhUkRY=
X-Gm-Gg: AR+sD12xMmCegEUDQ0cJCDtxSGFQvL/riCM+oAfCLBqUmUO+kvjTeSpV+wxNeuZWuO3
	LhvPxgASPWCJopTnLMuyMPhwhizmRWBwKcW7Hzcp0dKqn2Yc9ZVn+lENnZlsJdmZw0YoKwNKS+N
	aXopia2cjG7A0ApalC8NM9A3ErXXMRc7A80nsqtFWkDO8lNFrcVNSKWcHyCO5dDHrzDa8vStdLc
	XjjO6MfGPXNmowlF2JXh3eTMrOyc0mVKPZU7pUxLHCrSW75oi12RAfDIPUIKEi4Hv2QvwrM96Pg
	jWrBOTARvg8jHGMmlg7+Ac1T2y9PR7PAqGIotuJCq+VpK76bpmV6USCMiRz2O1TA8Bn1Odmp9ww
	zS0TNhup/oowAGV9T5Vgmf99YMzkuN0/xC5P8O3HGxq70Duwc3ij4xFR7E3FhNXOHjciolYNF46
	/FmS1th+p9VEeqqQCXeYYrd26Jqt3x9ahwRCwZciqI4L2EqZc+0sFsyygCmErhocQZEfwlZLCtJ
	B2IldxM
X-Received: by 2002:a05:6000:2011:b0:47f:97f6:d39a with SMTP id ffacd0b85a97d-47fb1ed839emr6971287f8f.17.1785312144463;
        Wed, 29 Jul 2026 01:02:24 -0700 (PDT)
Received: from localhost (109-81-83-7.rct.o2.cz. [109.81.83.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6b18a9fsm5229420f8f.32.2026.07.29.01.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 01:02:23 -0700 (PDT)
Date: Wed, 29 Jul 2026 10:02:22 +0200
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
Message-ID: <ammzjkUIADCxO2mP@tiehlicka>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
 <amcT75pLmA0hRUm1@tiehlicka>
 <615d091c-bd3b-4686-817e-5b29756542ff@linux.dev>
 <amdkHvSMj95DUri5@tiehlicka>
 <f706d139-53a7-436d-adc5-c691577ce53b@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f706d139-53a7-436d-adc5-c691577ce53b@linux.dev>

On Wed 29-07-26 14:15:25, Guopeng Zhang wrote:
> 
> 
> 在 2026/7/27 21:58, Michal Hocko 写道:
> > On Mon 27-07-26 20:59:23, Guopeng Zhang wrote:
> >>
> >>
> >> 在 2026/7/27 16:16, Michal Hocko 写道:
> >>> On Fri 24-07-26 10:18:05, Guopeng Zhang wrote:
[...]
> > Is this trying to replicate any real workload? One would expect that
> > writers to limit do some sort of coordination otherwise the exact
> > behavior is not really well defined.
> > 
> 
> No, this was not motivated by a reported production workload. We found
> it through automated randomized testing for our cgroup observability
> work and reduced it to the reproducer above.

This is an important detail to be mentioned in the changelog. Describing
motivation for a change is really important, especially if it has direct
impact in user interface behavior.
-- 
Michal Hocko
SUSE Labs
