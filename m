Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC093264D5
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 14:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788444593; cv=none; b=ODH4qehYOl+aQ5peLeGILjpuNHrQUaKdCBXezvc41sjGg+mRbniTyaqLGOfvlow2wAQodSijvLucr1oRzIhE1qnx2P6tzlTmlCSl7CzjKn2glB5UEgz/xTs5wlhU7CO9qRfivSozvBccRxFin8wiqLKsT1UOee5AvmpSu8YjZ7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788444593; c=relaxed/simple;
	bh=+gAcGmt/xxZpDNYTrG7z+20D6m7/JO5BWqC8Lc+Pa+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pigFWpnfVKi+hsglOej9e3w7AqCFE2UyciQfs6oevsJh+lAwlR7yw4NwamAGGn97+hz5FmL+a/CSgdrtpn3dwNaHZqDzKODOWsNZjfZ8fz6U2MYk0EZi7ePuaw6PHk5sG2FhY6s/Z4yEXNPfKw6Xx+vcoyl/XDg5RagR0vtevxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=mAZkanw/; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="mAZkanw/"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-861145fc841so26709447b3.3
        for <cgroups@vger.kernel.org>; Thu, 03 Sep 2026 07:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788444581; x=1789049381; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MdYFxMzLhAsz9CXEVO1o2mt6I0dz9BL/Meo6d0Bb364=;
        b=mAZkanw/TyIItdAvPxAOx63vpebYVyo8tFKf0jiWPCXmC64pMI6BL+mkilUh0I0kqk
         xv0p62emWfQ8+8xv079y/F9OUZOCTS3WSVCUcFRF7ZmX4DHKFsiXGYxHz5PuqsygG2j1
         QOfyEaMsKoZalkSlMmKDgtzTFPImJZdxVcl+L3Y1y9zoJSQd8lWQ027BMWB0VQHlnnno
         r+f9LtJcRqtWMalX/sDv7SMOo7l/Yvjb7mPG8eLUF/CqUs1TKboaaV1X+V3Cb4X22mxz
         jdZ9QAPZ8/CO0djf2MD6ghIlPluWl9+F/SyW2y5QYvtPCY+X5bSBJuNWCms3uqAl2Szy
         C+dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788444581; x=1789049381;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MdYFxMzLhAsz9CXEVO1o2mt6I0dz9BL/Meo6d0Bb364=;
        b=HxyxV1DspbaAhsiKtOC9v4zyBj7I49W4HTjNSkp8Up/4zexuZLze/Qqp7U5ph16qee
         Sf83pS6/35rNpMxw4HtlzIWDD6l85iNSiH+S3+ORsaecTgs4AChmVjlWJlIObaVMozXQ
         fDyMCTRlyKBRWGBB/2Kl2zjwRaMpvgu5UaHrj/Xz43Kxv4R20ZP3m+S1I1sa0cxdB0Xj
         gc03FL9tsJuHKh6JSjpcwgaZRpsIIkFl4yRFkK+IWRHwcXwzzN/KjH48MUYMLHOUxx5f
         e2h7cy1Dc76gMD7Q2Hxy8yn2XilATK0d4CixlZdSjY5vqS935SLp+fVN/SjMkvnBMrRZ
         SFrQ==
X-Forwarded-Encrypted: i=1; AKwUvBxWGQFLcPieAG9xw2YhGokp/h+dv5fxnaGherRaeCuFZeQv5MJZgwmkqAdSZVtK0A3f/TtBa2E7@vger.kernel.org
X-Gm-Message-State: AFuF++kFyWGMIMI+4w+nKp8+VwZOD4y6Lc01rwZ7dFhgJUbLPPW7IS9u
	njxyHaGXsFAJJO18jHe4rKzvrzj9mC0cPgtjUYXMq2rA6jMlR/RRdkf1J4YN+CeM3JE=
X-Gm-Gg: AYBFou2S3v8MNUfmhPepqz5NOKqlMw2YxFx/YZCq6ax18W00BS0GpcFjcUA4XYO5yKR
	bfEATe1BPTv708j0bCRh4LANAcHYYjK17XrJ676AniaEuWFdBjA6XTGjj3OJ5FywygHDULkmjOG
	OtpyzBUqZ+7tcF8X074WCPOR0ojrgTUKp3xD6GYck+++9pNI46F6MEDOW4GAJCcOuh7YsO5/P1o
	vVZ5HRPu8+NHBnk8ufpNQQtBUmYowPQsPCQigHnqgT25biR1AM5CT9ADm5VMxxiUaoTKvmEa9/x
	JrOtX+drecz30Hyo9oYl2G7oVEymlN6nKVdlO+t+DKyps0iLTup363VXM+kx2qPAKkQJhZ9Kfdh
	UCKT+OYnrRGO3u//XnulJFY138h3avfGIXrz4LlM3P4Gr1jme6UgMfS5cMIyvLVcwXTLZAH6r2x
	/M8e+urE2GLNfSDQKu5GxPr4nx8YOiYcZbS/x5pSCRLSMG4QKp0hQySNz0DcA6
X-Received: by 2002:a05:690c:c512:b0:81f:2403:9e70 with SMTP id 00721157ae682-86c51d40664mr58591657b3.19.1788444580869;
        Thu, 03 Sep 2026 07:09:40 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-86c178435b5sm40369647b3.29.2026.09.03.07.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 07:09:39 -0700 (PDT)
Date: Thu, 3 Sep 2026 10:09:38 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Down <chris@chrisdown.name>,
	Tejun Heo <tj@kernel.org>, Yu Zhao <yuzhao@google.com>,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
Message-ID: <20260903140938.GS3004@cmpxchg.org>
References: <20260903031952.1120321-1-ridong.chen@linux.dev>
 <20260903031952.1120321-3-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903031952.1120321-3-ridong.chen@linux.dev>

On Thu, Sep 03, 2026 at 11:19:52AM +0800, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> For MGLRU, memory.min/low is not honored during global proactive reclaim
> (writing to the root memory.reclaim) and global direct reclaim, because
> these paths shrink memcgs using stale or effective protection (emin/elow).
> It can be reproduced as follows:
> 
>   # echo 7 > /sys/kernel/mm/lru_gen/enabled
>   # cd /sys/fs/cgroup
>   # mkdir -p a/b
>   # echo 100M > a/memory.min
>   # echo +memory > a/cgroup.subtree_control
>   # echo 100M > a/b/memory.min
>   # echo $$ > a/b/cgroup.procs
>   # dd if=/dev/zero of=/tmp/testfile bs=1M count=200
>   # cat a/b/memory.current
>   222650368
>   # echo 500M > memory.reclaim
>   -bash: echo: write error: Resource temporarily unavailable
>   # cat a/b/memory.current
>   6070272
> 
> memory.min is 100M, yet reclaim drops a/b down to 6M, breaking the
> protection. The traditional LRU path is not affected because
> shrink_node() calls mem_cgroup_calculate_protection() for each memcg it
> visits during a top-down tree walk.
> 
> Commit 30d77b7eef01 ("mm/mglru: fix ineffective protection calculation")
> moved the protection computation into lru_gen_age_node(), which only
> runs for kswapd. Non-kswapd global reclaim reaches shrink_one() through
> lru_gen_shrink_node() -> shrink_many() without any protection
> computation, so emin/elow are whatever a previous kswapd run left behind
> - or zero if kswapd never ran on this node. Relying on a prior kswapd
> pass is not correct either: a memcg's emin/elow are derived from its
> ancestors' memory.min/low settings and from children_min_usage, both of
> which change over time, so emin/elow go stale even after kswapd has run
> and must be recomputed at the point of reclaim.
> 
> Introduce mem_cgroup_calculate_protection_path() which computes emin/elow
> along the root-to-target path only, by iterating through the cgroup
> ancestors array top-down. This avoids the full tree traversal that would
> be needed with mem_cgroup_calculate_protection(), limiting the cost to
> O(depth) per memcg - typically 3-5 levels.
> 
> Call it from shrink_one() for the non-kswapd path so that each memcg
> about to be shrunk has correct protection values.
> 
> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

With Barry's two points of feedback (changelog and comment),

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
