Received: from mail-qv2-f7.google.com (mail-qv2-f7.google.com [74.125.230.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0934A37F33E
	for <cgroups@vger.kernel.org>; Wed,  9 Sep 2026 18:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788978525; cv=none; b=H/MJ62EBjnfE/msqZVinpZniK6p5X60/wmepemM2BpD1lsZFuabirdon88iCmoGIWkLHb8Vm8Xs05Wawi/1yHpMy64nyScwOAqhqTObR1Ozzg58MNJ7BqWDfquyayiz0k5ylWU5WrL+SwjadkzX0eJ1z864chynYWfaqSAHhWLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788978525; c=relaxed/simple;
	bh=NU00fY7Kqj7rRdxZPx//klgo1B0RnQLyxTcx0t8+WAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cMzlcYJcJ2wz8MAQ5cxgXpBxf8Hy9XWibLB0pXetkCQC2vPPX4Zx9ml5iuWFfhqQOHxgXCO2KTO7euXvndfpRarL05l/L9+kUDLXnftwzCmFCE2lZo0PC3wHd9dQYgoWdGuVBRbfhZdHLPgsiTMfCeWJv1F0C2ix5Hh1q/TbwrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=JPORzTKf; arc=none smtp.client-ip=74.125.230.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="JPORzTKf"
Received: by mail-qv2-f7.google.com with SMTP id 6a1803df08f44-90ccffc2654so36646656d6.1
        for <cgroups@vger.kernel.org>; Wed, 09 Sep 2026 11:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788978522; x=1789583322; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IC8+CYBpTjyEX77+0CoRP0GmnJOZZWZXdKNBjQTGBi8=;
        b=JPORzTKfN63DhIkurQSRkhzXbUEu9E1xZAVCUY5FtyLYNBrXEek8QsZKDiiNTuv+1o
         XYWcl1Z70z+b/yipnDmfLDlv3YC5GnGuBrYTo3FnXdRkGKDZEYCk4Zh7Y4FbypRQl8w4
         CH4hHUu2EeoRhUNliSEsDruIEGL8bFhkDGGEoNwgvGU123nnzYjU5AerXIqF44gmxITT
         j40V/ZBw9vW70NKS5POG4Ash5PZDpuifPCvorfrgL+gNgekOGo50UoJct2CJxFwNz1Ig
         Pg2pEI0JZ2/unVdO/FKW7HpopBm2HxdabAKrtQUR0ZYeVgA5eZkYAVn7txw5K+GInsWP
         s1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788978522; x=1789583322;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=IC8+CYBpTjyEX77+0CoRP0GmnJOZZWZXdKNBjQTGBi8=;
        b=VUnLYl4oTYGyPKvV6y/gwJlozozNinBVYrVA8Zi57T23eMMvgMdIqzhydBBNjlXfv5
         5n+PeDKlAYLRHVcpQ3RBI1vWTCt5tarwenI7I8di+BTpvnB1xDHPlr/naWXdFjaC1230
         4TlgFMIaiKgRFw+wPmZpmAQNfCDG05ja+aty/LGBraHI3Up18CbT72kGalnMPGUQXMPP
         R8zCw72/2EcsLLXlbjchAcscRf1EXgj28afdDEd48m+jiEKiX7xWhYJ0pm4sv0+dWXdb
         QIABQSyhLdU4sme7SHmqFaJNf//B/cf0oD5y/izHMIsfYpUNIW+rIOqHPOMtG6/EU5WJ
         Hx9A==
X-Forwarded-Encrypted: i=1; AKwUvBwl8uxBpFtg/hWf90Vq7Tp6Fvnz879EnoYOA8piLz3Vf83Iujl5Ltpts8fhwr+Az4Mohxp097+W@vger.kernel.org
X-Gm-Message-State: AFuF++mcvkT7/e18YE/YpfpszJ2N1i/NdTmSuCt3B6OAEdBUqguOew93
	DmJ2YqNYz07Cd0CkBA9a27rxUzUwpCFtWCi9HFMhLNC+tC/y2EdnbJqW8IYN3tBMMuMuAHZq23C
	6szfgFH2FxA==
X-Gm-Gg: AYBFou1129R+7CXH81+kfy9D8kGdbAZIc/PPUeYjMYJE1pG0TATasoXX3oCvvkQZIzh
	OOuJ2uoPCxxTr4N5n1OSPSQCS7nUzjAh6VuEHCmpEI8EpKbSj33yfRP7CR+boGpBN5Ec58hKL1t
	bUKor0qxdfuPR/3OfAviudhNzr60afMYVbixn/+IS8wgtq+V6oriDgUTBmINtwNk/BA2O36uLRc
	yloo3lyWy8kQDxhS77xEJbi48H+oicEwSsOYCLfQqc/AF9exnA3V8NeMWoR4a3Xe/WDVbPZYlyD
	flCoowQzxw64/1Rr26ExvRdj+pR9fAuNDEbc7GxaG+GjEq7BKOcaTjFZjpQSacZrXLiOQEQYcV6
	OqXrdCNJSUxhe76eJzmwuZuPNx8iIyo3JeL1HLJad3HP0kLZ+5kdJcOAQbnu+lS/g6Vyawepq/a
	LHhVroOMXciJZ6mn2lTASOfPrbkSLgfpWFIuuKYeK+2KK1/m58hiil62BTlsBj9iMcpVKj1A==
X-Received: by 2002:ad4:5c65:0:b0:910:74ec:8892 with SMTP id 6a1803df08f44-91074ec88f2mr36395556d6.6.1788978521419;
        Wed, 09 Sep 2026 11:28:41 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910406bf8c3sm150409236d6.48.2026.09.09.11.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 11:28:40 -0700 (PDT)
Date: Wed, 9 Sep 2026 14:28:39 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Usama Arif <usama.arif@linux.dev>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] mm: thp: restore SHRINKER_NONSLAB on the deferred
 split shrinker
Message-ID: <aqGlV7NjxrFPYtRH@cmpxchg.org>
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
 <20260907110111.2286932-4-qinyuntan@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260907110111.2286932-4-qinyuntan@linux.alibaba.com>

On Mon, Sep 07, 2026 at 07:01:10PM +0800, Qinyun Tan wrote:
> On a system booted with cgroup.memory=nokmem, the deferred split
> shrinker is quietly demoted to a non-memcg-aware one.  As a result,
> partially unmapped THPs are only split under global reclaim; memcg
> (limit-induced) reclaim never splits them, so a cgroup under memory
> pressure keeps its underused THPs intact.
> 
> This is a regression from commit fafaeceb89a5 ("mm: switch deferred
> split shrinker to list_lru"), which re-registered the shrinker without
> SHRINKER_NONSLAB.  The shrinker had carried this flag since commit
> 0a432dcbeb32 ("mm: shrinker: make shrinker not depend on memcg kmem")
> precisely so it would keep working with kmem accounting disabled.
> Without the flag, shrinker_memcg_alloc() fails with -ENOSYS under
> nokmem and the shrinker loses its memcg awareness.

Here is the reason why it was dropped:
https://lore.kernel.org/all/ah9PGv12mqai84ES@cmpxchg.org/

After your patch to make list_lru expand for NONSLAB shrinkers, it can
be restored.

> This was noticed by Michal during review of the patch "mm/list_lru:
> don't copy stale shrinker id from non-memcg-aware shrinkers" [1].
> 
> Restore the flag.
> 
> [1] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/
> 
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Suggested-by: Michal Koutný <mkoutny@suse.com>
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
