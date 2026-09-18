Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6886C3F8898
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 09:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789724474; cv=none; b=bcwMTAMJnU/0gEGvTyld8hKjfWHLROFIr7XalLuaKjvOeQAmdN70J805cEtKmJ9x+iuvJPNuQ6NXuUM/Kq3zZv6PfP3PIS8dsxI1K+OjiOiotK1NDSF0bfpGZd9wT1dzwlBIga6GezqkYf3OE6VhjrOCulqI2gM9VIViT+D0748=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789724474; c=relaxed/simple;
	bh=IR4Xs8Dn+IT7ihKZTCedV4W+0dWbX6d3AknpHpe5TcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iXHVDmFHfl0jrKQiN9QdkpqGN3s9Y3DfhllnJbpIQtclXpOnhnonmQmW//VaPJJcit+dFGMmdpLrSTFrH0io10Yp1pPTpBkReTy2c59+U3Lysgv41BCkgIospELDhUE+uRL6qlEmlWpU9nNW4jlXVgdxdN3hq0rJmhokIF2q+Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LAES7C7q; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LAES7C7q"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f9c60b9so35476066b.0
        for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 02:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789724470; x=1790329270; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Bvlc7PQn5Y10Z6hN+pRJdEeRFAR13rFud0pX61FSVmw=;
        b=LAES7C7qMl5J/amuAMRyjF51wxXmaG/zBTQf4XIhAqB25va7yzZKr6pazVM4V8LdxA
         E4xWkb1svpk0pEOQngjihkZl5GmiQnEmoXJRiQSRBvYXISLNoUcbDf7ttBpyHEQmDW+/
         QLUu2LxrV1upj9Uax59SaLVQdt5tJVyzgy0zkiEsxRDcX0QP9WB8lskjPCaQOzRU5OFs
         ATsnY95P3w1hXlPvIVGCe4myZzzQolOVU2dzayIsLriBcAiv6iNIKfprnzteaNhHqc2T
         9bKvELb5xTiDpqfWXTHKAD/UHRUSE2/L2Gzi7+MWg75Og1CEf1/6kb0EyaiuN8uZAJF7
         R85g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789724470; x=1790329270;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Bvlc7PQn5Y10Z6hN+pRJdEeRFAR13rFud0pX61FSVmw=;
        b=qBBKOA2S+3qruExh0mDhqvDXFkQK6RLg22MW09aDHnTmerGiWjxl/BvApu+8D/7ruL
         V2JfJ+x91M0VNO7ijSQOzQ4gpYcYGBjsA+JvqlgWzN/ZXI/RTTfOpSmRvZ2UtcTkmTiA
         NHd17TpLSq/NOr2hXUhp1ulKnGkem1NG4LUxKL91pL8VpVxu1YZfKCwPP3GeiUpqhoi1
         H0xkkhwdQIP9m7X68ZP7FpMO+tUvweCFpMUFl0OOmT7kP2Zp1qkoR8/9auZ6OSutgJX3
         3QNrQhGBX5fca4zil0s/qRscNUAJdTk/x+0dBsGNVYxbBv35CsMwXi/PEwBHuLwJ1St/
         4fEw==
X-Forwarded-Encrypted: i=1; AKwUvBzqslJbikPnjHM63DPN48qM/4+VXvqM/qGwGf9Wq3A/WzeW+YTXXmyDKm7wvRcWhZhsznw757UV@vger.kernel.org
X-Gm-Message-State: AFuF++lxTyLrcia8A0RygShi6ohGGeNMvVJAmfiHYxU/1q7YrTioFmtK
	BilAVznm0EQG7OSJ6DxN8ICN3oJx6Kd74a02XD2DvJkJqz9L7I1GkypzRFLKfME9jxw=
X-Gm-Gg: AYBFou3DdB9HTVB5T7DqsM9ATe7XHQ80F4F2wBfMvGaC0qIEHyWFsGWpEPp8EzBYPJj
	gD4Q37IyrOeLS0fj7HV+VKEvP6g7n9NFxYq8tZ/zsbE5X64jqZ/3XuwDewiSv233kshGM/+3WQL
	N8jAE92bwm9i0adpsTYsDNwx+RH6133XLnXdMN+5pHKughWdYKHgkb++Fw2cYjjxocRLf+VJcAn
	eaqB45fXauYuAV0QQJAqHcNhPYJPoRaw+D7HL3w8mylymSczTV+wFiPfqC8zHyxjZjGRl85S0WA
	xc7WxR9p5Zv0Uvf93DrplumJLX/+JZ3Xdo/+BVv3M8msSKBIuD9NporKEJ1X+5TMvvWUVYoN2cl
	WYsTmDtc1BWXv+seXx7padjayY2x5udlMpHMAAlY4SmL+JEtx9Ve/EfqqleD7X8pMnrrgRYY2j5
	PXfF2YWdUQzHKxp6/obHJRTePbEvI9NYPZ7Y22MHYPmiYUYLkP9HGi/cjg1kc=
X-Received: by 2002:a17:906:6a13:b0:c29:97e6:284e with SMTP id a640c23a62f3a-c2a165561damr161932166b.13.1789724470414;
        Fri, 18 Sep 2026 02:41:10 -0700 (PDT)
Received: from localhost ([2a02:aa7:4656:2314:c23c:9eda:81d:3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a1bbc683csm37937066b.58.2026.09.18.02.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 02:41:10 -0700 (PDT)
Date: Fri, 18 Sep 2026 11:41:09 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tao Cui <cui.tao@linux.dev>, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
Message-ID: <aq0HNe5s3zvOnM_I@tiehlicka>
References: <20260916125737.1095414-1-cui.tao@linux.dev>
 <aqxMk6yaiFHeeAAg@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqxMk6yaiFHeeAAg@linux.dev>

On Thu 17-09-26 13:26:40, Shakeel Butt wrote:
> On Wed, Sep 16, 2026 at 08:57:34PM +0800, Tao Cui wrote:
> > From: Tao Cui <cuitao@kylinos.cn>
> > 
> > The legacy cgroup v1 memory controller has already been moved out of
> > the shared implementation at the file level (mm/memcontrol-v1.c) and at
> > the Kconfig level (CONFIG_MEMCG_V1, default n since 6.11).  Its
> > per-cgroup state, however, still sits as individual members inside
> > struct mem_cgroup, guarded by #ifdefs.
> > 
> > This series isolates the deprecated implementation from the shared hot
> > structure: all v1-only members are grouped into a dedicated
> > struct mem_cgroup_v1, and every access goes through memcg->v1.X.
> > 
> > With this in place the v1 implementation is self-contained: its
> > interface in mm/memcontrol-v1.c, its state in struct mem_cgroup_v1, and
> > its eventual removal becomes a localized deletion of this struct
> > together with mm/memcontrol-v1.c, instead of unwinding
> > ifdef-scattered members across the shared header.
> 
> Sorry I don't see any benefit of this code churn. The code is already behind
> config. What exactly this code churn is giving us?

The only arguable upside is that this would make it ever so slightly
easier to track v1 specific stuff (once that s@v1@memcg1@ or similar).
I am not convinced this is sufficient to justify the churn either.
-- 
Michal Hocko
SUSE Labs
