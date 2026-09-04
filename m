Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CD84F0545
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 18:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788547034; cv=none; b=opxyZbWQmLY49D4m5xVsiZtLNc8O2J9fiCayvPtwCL7RfEuDIfTEbQDTdJEZe0J/lJBGUOSZWymoCcyvwKXdXJMTCXu3evK3G2UpR/01sK/8C3Iwi7EFwwgPW34PFxMYcKSWxHYekNJOtmwyyqsA/WL3oXE3yqQYAshXZT+V8wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788547034; c=relaxed/simple;
	bh=9OizNw+hgrpcrtMrjmo/Q42tnd6hiO2d6YxBTG31b2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=haD+9JiP/LG2B53SA9LMd0X5E4J6ojqgmP3FZ/smyK8v1gbBr0Z37xObJIE456rInO8EIyFoF6xPQ8w3DQ0g52p8fDXHHo6UGLGaq9echh09vvMvA6uL9Z+bKxO82zaQNDHoGlW+x9SNVjOGdT1j4wsmQuRYNOzbG34k5KAFCIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=coac330z; arc=none smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="coac330z"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-66fa996e65bso2598899d50.0
        for <cgroups@vger.kernel.org>; Fri, 04 Sep 2026 11:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788547030; x=1789151830; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EYrVETvRvxY5BVpkhPjtzdiUc0wbZQ7Wsx0WTj7855w=;
        b=coac330zcYXZ0SpezD2y4LK/vCwc8lfxb/8nJf6OjEW3c0G/fgOXKnbQd1P+ZvEh1p
         E9zT1qU1KleHqMC6+bqQMd0lCWYFPiFwVvKZ2z6O7aqVBSdK9MbKeJB1WpW2veWpdlZI
         nh+3hZ6ZHD1QBhUQzReDbZlHOPP3789PRYRj5No5paVIo+2hrGl8JxkG0nepMCeW2/ga
         HOq/z9P8VryBST5RxKC3xvu01zfsS+5oWYd8EnHXllFcuibDd4SLQxTtTNLD6tPaoJQ9
         i865KGcoiouOBl+EJCNKKTZZLA9cYWHVt1ATKcAT//AEqRe3ol20LZiShJ14FFRLEMTj
         6fXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788547030; x=1789151830;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EYrVETvRvxY5BVpkhPjtzdiUc0wbZQ7Wsx0WTj7855w=;
        b=W7K8kxDwuRL3Ne6WaSZXeYMAI6BdruSJJ+C61upPzRk96vus5DLP2Y50AIrH3Y0m8K
         3H/CAoVBqeGMeLb2ABpDkj0duZyFY1NYqRH9BdA/tNVSzxjlp7tpoYDe2yL7UG1rAa+P
         vFd/4EawlZ6qUVSYDZOlLVCIR0gP6sNOV8W471fAvbmoH5x+X3QJjPX6tHi2L0pyFXlR
         aF1DLJLV5fEB+K0Hx4c42u3M4JLJR0Pd1A9b6Fxpc/rBn5DanrC29W7qqvA+Pw649jke
         5xetPa8d0Ix6pa3keBdozNjinp4k/ldIZVgjnoAAmO1qsT5nfrBW3/XkQA+6+H3GPI+2
         7HPw==
X-Forwarded-Encrypted: i=1; AKwUvBxgAGXKzMYPTY9Lzv03/ylqGbdyoVQCqcE2wuZNullTsGzlOQFexSgHZzuRiUZOOIspMIg0EzWG@vger.kernel.org
X-Gm-Message-State: AFuF++m/7HUnm/MI4mwFEwzmwxySD1VlIBgI1ydVjwEe3yQ7E3NsTuRO
	rpgr8zvmdH3+ingDOdgcBT/L2hHtlVYrOPAXgojRQNLA9iF6SQV0WM2+ENv/sQD2nb0=
X-Gm-Gg: AYBFou0Vk/Gu/cC7U2LceL80nD3plj+AwfDJUcPhq9m21zmYn3kO7ls9SQLSjsEfRL2
	TifzlShb4y27TAiyCXrhbKUNVbdLL49UaLjr4Z6eDghprl6EwvnTRw2RzEfHoOMXGOfowxZYSyS
	qYLnftwVmDhO7SB2BX59waHkjUTJhHJwzPierF43kQdnxhDau8aV5Dy0JwAzydOhHBRB+i+05KD
	X4VsCl/HLehpmlhHXBDbA7UiJ2iH52DyP5HnWrpV+CyqfRIq7FQvI/5UVwC4Xr+nPnaqfvmrCDo
	783a377u6YTufTXKX/ISfhL7VHGBM9GUD1UFh36gw04odAnRRfNr2m2DL81+VskTIxam35ekF1l
	lJoPOTT2SkauXnh2i6q4bF5L+Ur7YMvuYQ/ByBX/E/yJBjDtCnrAyo1epkVmByi2rMWm7sILC/i
	pXm3xzlAP4KDWlctBW/ar37R6C/fcI+J2FSl4x/UnX4qxa71tIejI3g0P8HTDc
X-Received: by 2002:a05:690e:250d:10b0:66f:8d5a:e091 with SMTP id 956f58d0204a3-66fb59585bdmr525152d50.13.1788547029035;
        Fri, 04 Sep 2026 11:37:09 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8714a979199sm24242077b3.29.2026.09.04.11.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 11:37:08 -0700 (PDT)
Date: Fri, 4 Sep 2026 14:37:07 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Stevens <stevensd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] memcg: Don't call schedule_work when no spinning is
 allowed
Message-ID: <20260904183707.GF6641@cmpxchg.org>
References: <20260904173145.2028377-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904173145.2028377-1-stevensd@google.com>

On Fri, Sep 04, 2026 at 10:31:45AM -0700, David Stevens wrote:
> Memcg charging can be done from any context, but calling schedule_work()
> isn't safe from an NMI. If memory.high is breached from a context where
> spinning isn't allowed, use irq_work to schedule the reclaim work.
> 
> Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> Acked-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: David Stevens <stevensd@google.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
