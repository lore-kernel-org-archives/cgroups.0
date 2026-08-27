Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471194457CB
	for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 14:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787842763; cv=none; b=ECiAAF3eE4GL24nzBwuZg2syeVkaBJu+jbbmf2UQxDlDwfeQIlof/2e3dCuATUqDltY2+ovqIJVKND9x6K4rf1y7JcMnppX9NGaZCogghrdw9ZnJiR+ANwcZvOFxMfZUSCLo4uyoiuTPIiJgpoNFdrVQOOVWb5rAy9QTb/Rv7KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787842763; c=relaxed/simple;
	bh=RR+IUy6BeU23gJRdnSXxRw8SirU1x2z1Zv0XN+mlf+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cZ0KIkYRXGQoe7HGcVZmfi/0HdPniTIuFv9OTPXOErAMV/Ww+GrEmKEJ5WcLmJVCnDLX3zLjqeSiMl89CD7v0sFIUNSBc54aR3YtmrGKMCcir/GMSlLpEifCebVklPS3zrVn9i/4Ya+SsDkoJrVLqflPDW3pmWG4+5/OyL1XBfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=lFoZFqjD; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="lFoZFqjD"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-836cb2fa1bcso37660547b3.1
        for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 07:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1787842759; x=1788447559; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d4lPcSEVrhw95aM0IABtxJRmbb0KihXHWFn9jTHO+gA=;
        b=lFoZFqjDq9phDt72Un3JCDMdeZIOtIYGQ3jWW4EYhWYAo5CbPp0QcKiOnE+AJbaaYq
         AYjewtTUfh+eGHC5p6ImFm9/Suxn0PAei/84jTYezOcu6QW30E9jfACTJl3odUB/rzki
         mXWCYw1x4fZuy+MmpstiAfGk3sl6X36ssgJwW9lsGhJpoSk7uYIXCAHFGb1ng5Cc6NTt
         Zts2ACxDcGj2hFRNU3hH5dnRzXIo5r+odb8Gmqkw55/zT0jn53Io4y5DmActQiBp2s0b
         lQ6r9IjvBlj1GWtJt1uv0b+KMPvK7WieOrL7WAbrIMcYwe2XgIao6ZCexzg2yfuP6uBD
         svRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787842759; x=1788447559;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d4lPcSEVrhw95aM0IABtxJRmbb0KihXHWFn9jTHO+gA=;
        b=KJt0lCdy3RLXxtV+JvfTzp8McNoIXXH0F9ObubZ+JLK1GVyu8HMlkyuT5rDpvL2EJy
         lMBXC787i3cfEyIc2DEmKnYvqEBcDYU0RJp1/TWf99TbThMMbppfIfPM/XIXnvI97M40
         vn6QHwkODwIER47y7RIZEUY1AYAIhWn0TVs1AUUsqKoV7VE/7UH0MyZSlYQ7j5IOBBb8
         OIww5foVduTeB+PkaHrGkfVveZeQ+AxCHF6JDoDXKRB3NrXVb+CG2iw1Zz1tBb0GESXE
         Hq2lBivk9u1KgJyWyOWzGxbYtPWVfELN3ch4iVJt5ZYr4JatFfiX++TESfbbpBIiRjxR
         QQog==
X-Forwarded-Encrypted: i=1; AHgh+RqQtajt/Gi6eaXayrq3OedMTTkydJKRsKWtxyo9m1O+izK7jJy0dvAAkFJ5YKcDbKVq9ktVKmqJ@vger.kernel.org
X-Gm-Message-State: AFuF++nx0Rd0i1bZeB+6c7X2cKnQkm0zG/JzttYdspjrjptrBezynIfU
	4kK9MyGAgqKrya5hi5RwIMhCIad9Pc7fECmvonvc0zZM18UXrwOD6LFHV9GOxv8iz/E=
X-Gm-Gg: AR+sD13atemjMrW5oa+f8l/7cg+z3nOG8Wt6e6l1TR31CnvjVJZQeOa/zxKD12P8nzg
	8HbCK69jd+IxR26Bb6aQS8mvFdjneugm63EAtZksZ1YPAQkTii2c7mGsq0Ab8aFyICwTGfp5quP
	YLGiBiw9MH2tpshHsVA0NrFPjpilI4nAhGYgqtlBsI5b6YrpsHwwDwiCN8mvzxJIoTDLGlNgnGv
	VJYVPJrlmXpgnCW4xJ9ZGsZSpFQVYuKaC8W2ISHEZaTQaw1+0gZ5I6/1TnQ6pxQQq3YDjIHFszg
	pJUHt5KymCyq9XOiXMgkIinqCkXXcSqX6VRJ0ymaGB8cx7kRispv4RVa0NdTivHRyO4CNkxgpVK
	wuhDjn+kQ0jm5cyFaXbG5tph4RJWd+le0UoTXahow6rPvAMaenlK0h5tSwx0JF0T+e/PAhpCqKP
	jESJChFYoYiqEP1+fWyc2v97B1+fkIm0wVy0asq87za4E8x/0LJe7+hK8ecgGH
X-Received: by 2002:a05:690c:e288:10b0:858:def3:3422 with SMTP id 00721157ae682-858def3356cmr38360687b3.27.1787842759108;
        Thu, 27 Aug 2026 07:59:19 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-85b5bc34efasm11365667b3.7.2026.08.27.07.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 07:59:18 -0700 (PDT)
Date: Thu, 27 Aug 2026 10:59:17 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, stable@vger.kernel.org,
	syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry@kernel.org>, Chris Li <chrisl@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memcontrol: fix data-race on reading jiffies_64
Message-ID: <20260827145917.GB3004@cmpxchg.org>
References: <20260827025457.116191-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827025457.116191-1-jiayuan.chen@linux.dev>

On Thu, Aug 27, 2026 at 10:54:56AM +0800, Jiayuan Chen wrote:
> KCSAN reported a data-race between tick_do_update_jiffies64() updating
> jiffies_64 and mem_cgroup_flush_stats_ratelimited() reading it directly.
> 
> Unlike jiffies, jiffies_64 is not volatile, so raw reads are plain
> accesses and can even be torn on 32-bit. Use get_jiffies_64() instead,
> and fix the same pattern in mem_cgroup_flush_foreign().
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 508bed884767 ("mm: memcg: change flush_next_time to flush_last_time")
> Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
> Reported-by: syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Minor nit:

> @@ -785,7 +785,7 @@ void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>  void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
>  {
>  	/* Only flush if the periodic flusher is one full cycle late */
> -	if (time_after64(jiffies_64, READ_ONCE(flush_last_time) + 2*FLUSH_TIME))
> +	if (time_after64(get_jiffies_64(), READ_ONCE(flush_last_time) + 2 * FLUSH_TIME))
>  		mem_cgroup_flush_stats(memcg);

time_is_after_jiffies64()
