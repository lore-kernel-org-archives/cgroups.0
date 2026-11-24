Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795510961;
	b=pEEJVzwwMCqulAqGZklgPtHHPFWHcd8VRV0SiZ7BRFZ6a0j3ji5vFPdZh8Y5Ap6eE8eP
	 NQkHl2HXLIASnqPnN/0mpjYguAf8jfv/6MZ/WfqEFB1YvaWeBpODh6gts83RFmXgOpyQE
	 8kXEzoK/ZuS9og2l1zBTo5/nu5kuBe50b8xbkSJZMbjQwl6I8gR1tbG6Ps4DkzaItTvzb
	 akr5fCwGh3iFPLUcPHUdnK4HI8AgVSUB10qnuDMpBLLW17H2ImuOzLX21kMZPfB61TmCT
	 n8R4kbJoABdbAdK9O5DP0Cgq+0QO1NdFcFGZm3BERZCEqqU7EmNPLmy8yqGJ6Rlvqbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795510961;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=f3rJv8YrmzEdADJbDlr8p5ker/HZcgTcdaAmPaPw5V4=;
	b=R2PYIaeFxxtej0ttVTm62GJ1Y7Fy6v0plcJvf5a6O0AcHu1bUAM2EQFE5M5WJHgf8YN4
	 iJWvGnYcec4GQcCwvtkbpLqAq1ZKPQ+g/EiP3ZG1c8t5w/9aJDXbQ2GVipVHFmwWTdXDH
	 W5QCaYLf23LQQnyeNwyuawqKZmCoSy5ZGLw5PoJqJBgCfXKTu76S5L9Ml1eVJF/O12lDd
	 cqZFLlNhRrYTBddmVnAkHK8UfbhmL39pMLUqIRAzQ6bVCH+XzpCBK7A96jKqlNINIORtO
	 MV/sL2hDD+lFsmnVx2ATHPx2sAd4jpDblIDvm5nQ5GdL/MVrQVWivhjiVuIwyD5lQXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=WFJuKjiP;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AAC606A322
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 09:02:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82AAC606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=WFJuKjiP
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4ad6219f7d8so3559289f8f.0
        for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 01:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795510959; x=1796115759; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f3rJv8YrmzEdADJbDlr8p5ker/HZcgTcdaAmPaPw5V4=;
        b=WFJuKjiPPTJLRL6xA9N6lY6hH1meTzrIl/OigvIKepYtiB01JB+aMQ81VP7vJDfJ8G
         cL3MBSh7Vju7iS82p+0+qV6NL6y6olYF73IuiRJIT04sl+R/GGwnXY4axFWvQiU/CfCg
         kioc8wGgGcVnCPSh2e3C/vtN8O/qPTHutptLQcyh8Xl6utlIm8SH4xykGIEzZA3AcbqH
         xsuzBfFjC5vD6L/GvB+zWV4lTPkTHY/6GrxMWag4wdZ2zJwVrTTw/w+pDrgf+0EA2cb1
         IzA7+yGoukChqRrUpl+Iwp7J4oveB4q+PimwdAv9KzO1y+/q86u3q4e0DH0d0cVntiso
         om5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795510959; x=1796115759;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f3rJv8YrmzEdADJbDlr8p5ker/HZcgTcdaAmPaPw5V4=;
        b=k0/42szS+h/PTgBrVthpQ/x3kB5j7ZVny1hwSyuIanMf7Kbc3PGVG6jGmsGzjIpEfp
         s2K5RDLExLtTCQmHKCPPnPWTBpw6svERhBeM/rWo9syiGKmRq3KfLzlt1vExKxLkLTLe
         quUZrrihRrP+rE+zyFZDRTGa0VOSl5wcd8uQTbeSPLmrkDQcY+Z/TBECNwpUti2mwQOW
         RSSC5+YNiOmx5TOBnsgl5qFlg84q9DkPkBw6+1txlDW7Rw/nTL5bodJM2fbIIBs3J4qZ
         GBY43uvEQ1iSTTz6VKTT6iQpONVH4gsNpW7s46ijL7+CCcg3nWZhiqBtZSgLZ9WCh+3W
         PAsg==
X-Forwarded-Encrypted: i=1; AL+hErHMxcRF0T+NE8fZdMfT8BvumMbDskU69xEtCMjG0yVSWQ7DA6mnzgZV23DgLYg6AKrODrJ+BzLV@vger.kernel.org
X-Gm-Message-State: APuU4Z9vxQda+l3FfbrwpPy23Bo/gNOB2yzeadQSHuV2jw0bCol/lzSm
	RA4Ebg8eWsOqpRwRZGAop8P/5heT0IdyPyNl3/YPOyP42+x7tNt0yqQrCqek1RXsAsA=
X-Gm-Gg: AZFdTZct3+7xJe8Em26/cthqP0wFHpu9aB1nneY5zgKMGK1GIx2eeL3EZTIGy/uOOfA
	QlD4VGzFG4S4+Bk7V6aV68+yUZRdYlKdbTArjHqWlRh6GLa4xJ4quF5LnHsSTd+G011cb4mXGGx
	Y0FAqrS3/d2kUWybpUWL+3IQKrkKXwfDxut3BjI0Qnu2r8oQW9/BmttAkyPmN1poOpv4NcJInk4
	S9mAD1B4I/on+n+vGF31n8kQDFfHG1U39zVoThlfhe5UiXL/V3+ayLv5aLXN4LI6chOXY2LXoOD
	P3+SIdFL/cgydPFV2Wn6xf3/HV2s8RocLVLIE0b82m6rMqG1t/7ksIUfohXD/h8VGQdqtfo/uD+
	/Vx8LK8cZ7PCbPZ1tEaqHqx3OxD1rM9d46AC09a7mfPqkT5xal42OOO0an/vi+ExybscgvZXt/M
	C9B4dboCFaYHw14CvZO5CClQj2rq3wHIaK9nra0VH5Q11BfF7aTedxaMyNgFvUfaNGxM5XYwVrl
	dKC5tWTfwx90NyQtQZZdVEjEEs8zPxrpzH4aYefZLLzE6XgmXHVG6BmmvBfiwelwJLcZBF6p1o8
	klAF/I1xukFMV7LwzBWKbdIJBdVMC685sjDfDJPl3CQ=
X-Received: by 2002:a05:6000:26ca:b0:4a6:4687:2ce9 with SMTP id ffacd0b85a97d-4abad5ac73dmr26444918f8f.4.1795510958871;
        Tue, 24 Nov 2026 01:02:38 -0800 (PST)
Received: from localhost (109-81-82-199.rct.o2.cz. [109.81.82.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b110ba3sm21973988f8f.35.2026.11.24.01.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 01:02:38 -0800 (PST)
Date: Tue, 24 Nov 2026 10:02:37 +0100
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] memcg: free the private ID of a memcg that never comes
 online
Message-ID: <awVSrbJn00wmh1nn@tiehlicka>
References: <20261124000439.967403-1-shakeel.butt@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124000439.967403-1-shakeel.butt@linux.dev>

On Mon 23-11-26 16:04:39, Shakeel Butt wrote:
> mem_cgroup_alloc() reserves the private ID of a memcg when its css is
> allocated. The ID is erased when the last reference to it is put, and
> that reference is first taken in mem_cgroup_css_online(). The failure
> paths of mem_cgroup_alloc() and mem_cgroup_css_online() erase the ID
> themselves.
> 
> But css_create() can also fail after css_alloc() and before
> online_css(): in percpu_ref_init(), cgroup_idr_alloc() or
> css_rstat_init(). The memcg is then freed through mem_cgroup_css_free()
> without ever coming online, and nothing erases its ID. The reserved
> entry stays in mem_cgroup_private_ids for good, and each such failure
> takes one of the 65,535 IDs away. With failslab failing radix tree node
> allocations during mkdir, 1,500 mkdirs leaked 6 IDs this way.

Considering these error paths they should be pretty impossible in
practice (and without fault injection), right?

> Erase the ID in mem_cgroup_css_free() if the memcg never came online,
> which is when (memcg->css.flags & CSS_RELEASED) will be false: it is
> only set when an fully onlined memcg is released.
> 
> Fixes: 73f576c04b94 ("mm: memcontrol: fix cgroup creation failure after many small jobs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  include/linux/cgroup.h | 5 +++++
>  mm/memcontrol.c        | 7 +++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 2afb4cb2bb4f..123c713dcc91 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -449,6 +449,11 @@ static inline bool css_is_online(struct cgroup_subsys_state *css)
>  	return css->flags & CSS_ONLINE;
>  }
>  
> +static inline bool css_is_released(struct cgroup_subsys_state *css)
> +{
> +	return css->flags & CSS_RELEASED;
> +}
> +
>  static inline bool css_is_self(struct cgroup_subsys_state *css)
>  {
>  	if (css == &css->cgroup->self) {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 091401cecf39..e7dfc96fd1b9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4545,6 +4545,13 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>  	irq_work_sync(&memcg->high_irq_work);
>  	cancel_work_sync(&memcg->high_work);
>  	free_shrinker_info(memcg);
> +
> +	/*
> +	 * The css_create() error path bypasses normal CSS release, leaving
> +	 * CSS_RELEASED clear. Drop any private ID that is still reserved.
> +	 */
> +	if (!css_is_released(css))
> +		mem_cgroup_private_id_remove(memcg);
>  	mem_cgroup_free(memcg);
>  }
>  
> -- 
> 2.53.1-Meta
> 

-- 
Michal Hocko
SUSE Labs
