Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4050D37FF6A
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 20:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788296395; cv=none; b=VpiNCJcBM90031j9q5gEbSskmte/KFaZbxIGM1ihYUN0BavGMDvyEM6KIE90kTc1Wq57/rWbIToTLwOmofufwUT/YcumecrIgnGCFqi+utwlO+PLL0IUOT6wlyl6do04GBJm/3OzkoN+wj7N87chK/ytuKb2af5XsJM15P8OxfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788296395; c=relaxed/simple;
	bh=7Bwol/isO3PKYL7GwxQ+DnKxspzRoJb43zIQMxZuCDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LlB3YZVcLdX86wiDWHay0xSV8d1Ca34gP18w4jVEhKKoss1mEXEZlnXtpmauHym6i/AbJFMLQYYeNNWc30uK65xFMpgUq35lwa0xh093N1BhN7Q3Fv1itMHfAGbCxf1/6AmShoLllOwrrwvdOsvWXiEx3luHTE6g1C4qmXbi2is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=YJfB2dm+; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="YJfB2dm+"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-85aa9c1308dso4831727b3.3
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 13:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788296391; x=1788901191; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=scAaW2u08X/6xoYYfzAu3cY9q95BQA8pLakjGEvGhLQ=;
        b=YJfB2dm+oM8zkvx9mZ/MCddLaSAoLBN9yf8SQYeCD5dVyIi8jWR5rQbpndEo0A5f4g
         N6FHZIL0MdU5dunJVOO8yTEV/34kI0F0BcI/Ij2BoOE/bBndwc4wgOetpoDhOXt/FInO
         ZQLISVUf4WSItvhdBUm697OS6mZVbVlw9BxEfse1pm/pmEhmAsZHMvGTTNbAWVZi5aaa
         SgDlTcKZXIatCkekAcJMZh0AUDL+iz8ab+SmcMILC+xTNl8g/nodf4Zw9f0/AbMU26q8
         5N3rbmsVxw37+0ZClT7huVzl3d6WRopmNQMjVi/9pqjjKVhil0ikA3YHjO+aNNcIkvlv
         Yy6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788296391; x=1788901191;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=scAaW2u08X/6xoYYfzAu3cY9q95BQA8pLakjGEvGhLQ=;
        b=kYs6PXGi84o2QyrfAftR0W3qusSyldqa/pDVoyUmJWLQmCZMeHRPwTE+tQQWJvVoRH
         vmtYDGboKpvhekA9KSkGGrc1QiTJ/hwjBxlKFre4onWHAZrYMGS15GqzXcmJbq+w7Kyv
         SiuoBWe53Hi03JX8PWYEXv+6BP+gee/CaeBjxSXo01ZBfSndJ01+/rzKUB05GcjysAp9
         /f0ZR8wYCMogKETzn1DGBbCB6JKbFM9TW83y/JKt9xFHn4LyGSka/M2t6EXCqp/jNfPy
         3zuMEDEcLEretL1OSvVwwa3QpKw8l9WC6371Q2zeBFw/gGb+CJuBYQ5C+QqxXgyUjZV8
         zG6Q==
X-Forwarded-Encrypted: i=1; AKwUvBxDAiwgymcwWOqtFUj0CMEDVLHYS5D/PtgmiE7JSAUmEXSv2jEjmT0NBVFBhaGk1Bq3+f85i8to@vger.kernel.org
X-Gm-Message-State: AFuF++mh12/DXSAdcoHdtJTmqliWxfVRvvzMgPNizsUZF7cUgNvOs41x
	Qjq+/Vbj3B4dt0gyND1KKUioykFm0BqFiZ4k3obASGw+rcZQEJMRTEXKunoxUHzEWCA=
X-Gm-Gg: AYBFou04YOJ501Hj7GWNpa7OHEQs+rcKAaKNvtI85xF+jhjwKufHEIGwxuiX/OzBvCU
	+V7To9nx/C6rRdv1CXGKAvaKFbYTcTIcYcunybmrVl8LocL1VcWkrjQxkZV56KDaaeznZP1/oR4
	gJfoPz9yKH1lNrIMnWBfi5wjISMzins9Ny5a5rVyM/wJhZUM3tOrSHeIS1YAUhVpFRiDDEI77m1
	a1S0DesXRiNO7v0bAKsiXUkYmpUYVBiktnYv5Ivq2mX+xSncrLGHUzHbufasHjSdOgUzQwiFgXZ
	5G4zGqRSr6OtVlGskT6z1nB3WNxQ2nxNVgD6voFy3FTPkV5WaBxL73HYzyRshknkg5ma/a8e+/f
	W3m0viSLERjSvzfqM96i37ZCOAvUb/zMTfojDWFE6s59wgoLyalfYm63S7t1b37UViQhgKQ+LKV
	j6PEqd0CuiSgkcVPHRVitpJ3b2T5aXB9uRw5aOgw2tDyOR13cz+SmghqfxYvnb
X-Received: by 2002:a05:690e:1347:b0:66f:8a2b:3db1 with SMTP id 956f58d0204a3-66f8a2b40ebmr2730463d50.46.1788296390661;
        Tue, 01 Sep 2026 13:59:50 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66f986afd80sm444525d50.20.2026.09.01.13.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 13:59:49 -0700 (PDT)
Date: Tue, 1 Sep 2026 16:59:46 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.com>
Cc: David Stevens <stevensd@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is
 allowed
Message-ID: <20260901205946.GL3004@cmpxchg.org>
References: <20260831234339.280376-1-stevensd@google.com>
 <apYXCL_GJs9Ovu0v@linux.dev>
 <CAOiLmNEV8b3TW_Q7+h5mYrZ1Nw73XcPFPUsapeYObLYajq_PJw@mail.gmail.com>
 <20260901142552.GG3004@cmpxchg.org>
 <apbyZgB_Zu-DK8pN@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apbyZgB_Zu-DK8pN@tiehlicka>

On Tue, Sep 01, 2026 at 05:42:30PM +0200, Michal Hocko wrote:
> On Tue 01-09-26 10:25:52, Johannes Weiner wrote:
> > On Mon, Aug 31, 2026 at 06:04:57PM -0700, David Stevens wrote:
> [...]
> > > There would be no guarantee that memcg reclaim would ever be
> > > triggered, which also would also stop MEMCG_HIGH events from being
> > > generated. Overall that seems a more serious than just dropping
> > > userspace notifications like is done for MEMCG_MAX.
> > 
> > I'm leaning that way too. It's an indefinite error, and it's a freely
> > programmable surface.
> 
> I am really curious about the indefinite error side of things. It has
> been my understanding that these NMI safe charges are a) rare and b)
> there is userspace running so eventually any discrepancies would
> resolve so the excess is temporary.

So I think the question is what limits the error in both space and
time. When you say it's rare and userspace fixes it, it basically
means the answer is: luck of the common case.

But that doesn't help the worst case that can be triggered.

Like I said, if we need to have code to handle that !allow_spinning
case anyway, I'd rather just have a few lines of working code than a
(lengthy) comment explaining the luck of the common case.
