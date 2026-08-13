Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBB643F4A7
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 08:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609660; cv=none; b=X1HRrzIUfTr1k0zoF+3KoUhnMinpdAW0yp7GwIUEaZmRZCQKtvhngu58F3aMEtusC0vRoekK7gEd3MhLt4shjfSlnlFvXIkV/lyeA0N9ppv/pfH0JBtZO9bcatf61M3BFsvN/38eS5vEWQwM5TjTwrbN/8y1J7Z+1ZCpD0wKNg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609660; c=relaxed/simple;
	bh=I2Z3Lt0zyIesAusnAYiav2A+GTcePjF7nWszKETHBnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lfybSjJEmclqZ5e9hA0L3Juh+iRgHLIT3gEWv06CQRSK9SfBNDyvd2q6gcBdctExfDKo0WpV2Hn0xlabp5bla7PVe0OhXs87z1iDqJZIPG7DXgxgGnOyPxd32XAzUtfCXvgSzN9lES4yXKheAVrIVWxzakNu1Jp7K9gRvWfHaQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Rdqhe+if; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Rdqhe+if"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4813ea321cdso426613f8f.1
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 01:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786609657; x=1787214457; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9K1rmCOf2/ZVat80yjoIGMbcH4J2enbzgcI1jz4HLNM=;
        b=Rdqhe+if5EXhw6G2OfjwVdaEe97J/ckIBwf4AOfiw2BFY8fewKRLMWBmEOc2xU3Fdh
         9UX/TX++r4W4aR3sA7tHsZP43dkMV5mqOuyukBwnwAryJU5RGbRVjCknz+a/rpBxrfCa
         6txDvJYaTLLzIWhBQolr3tZqor0uOQ31u8LuKqS844wETu3Gp8mUcyM82MvsR/1tKjcb
         mFABA7JiL8DaIaBMpEhsJbFAqnnH1lCzYbiNGyfTwVboJC0STPzZgWAFXBAdr8UF5hNc
         z+vR+/cRnXHAqzYormMCzO68Gfvm2tK8OIuilaZ008THhqRTJmUAEUv/MM2jrsjVq+hp
         LZ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609657; x=1787214457;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9K1rmCOf2/ZVat80yjoIGMbcH4J2enbzgcI1jz4HLNM=;
        b=OwtOPK4GzGkqg4YrbPmnxbeHIpZbBo1RxmVhiC8/MUBSH7lersTnZKToJDuU7dYf2L
         B3dmQDgOTPXzKBunoKLJ/K4+Asf+7BbCoZbKzukxwChUE3bfI3TbCTEg+ARjTqnmtJIa
         Or+IbtYiQjtWeQ3BHxH3Cqwsip4lkCT0vGlch9XUpu/EaBzhjufwdXVKfuz/WdvMbzM+
         JmqRL2YFRjElDT//dJcG4PTTJlF/DU4X4N2C561acl+SWMG6xviTCri1RCJQffW66uWF
         gX3v2PPH1jznltbewRy6NU7SWDC1+8eMy3DvDuPfJOJGStc6DZedbkqzdqdLtypMdVy5
         SUBA==
X-Forwarded-Encrypted: i=1; AHgh+Rqfrion0k8e2CD0IRadnE1nBTS9aciHWS8QzVzwTifOgyl8tjQ/Kwr7b3QoenOyKvBHoIzga3ry@vger.kernel.org
X-Gm-Message-State: AOJu0YzO03GWpd0AZeLt/RpicGkQAT3l2VNKSNB3sECih3s++YIp4R9L
	BlLyTZoc5pq7kIeckpEBPGViVIMF34NanXWXJ9cbdALhyYO+HbFM24HfDaGwou24IhU=
X-Gm-Gg: AR+sD12z/UL8NmbJqAikHLNV0+XPUWTUpmLRxsVm3TMvd99MvUz5XRevWAbEqInk/j2
	i3XQrqSgLZoUVwOp7RbQhvWeHl2DbSKrgEvmtRod+uHIv/Ia6ZXSU/fldgE4acY1nIcgEr7cCFM
	HMHgiU9fAvRffwUMAqND1FndYOHUVE/0fMHQBHuoJskxeRj1NG5M6+j93zkSaVnvzaHj0qFqy4Z
	x/DUXX22JOXiWRDRYkxszuC0cvB45WPdNsz1Ke5RQ14H/hyPggDCBFLSOnb8rBT7+H34iGBGB6/
	CGhD+dSILg1rWmYLI+hePtjkvKvWxCfzBfWMWIyCAOTWbqPN1cAAEb8VbBuF1c5GSclqwiBjynw
	4uhm4i0w9fW0ykcuPhqP6hGoOWx8Pm8kEcGKJiVDJ8wACNK88MwNUTNJtyedieD32jmxsW+nKrf
	3qUQT++bHVNZFa6DWW4BxaZqxhfVu4C+NKfrTLA1wbwiZ/zoeHXbZZQjrqaPDiJULfLJKd9J/y1
	5De
X-Received: by 2002:a05:6000:61e:b0:47f:8603:a879 with SMTP id ffacd0b85a97d-4815a5e20a2mr4317178f8f.11.1786609657483;
        Thu, 13 Aug 2026 01:27:37 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a5c2769sm4395482f8f.36.2026.08.13.01.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:27:36 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:27:35 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] memcg: remove the per-node soft limit tree fields
Message-ID: <an1_96llTS_zbmxp@tiehlicka>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-8-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-8-shakeel.butt@linux.dev>

On Tue 11-08-26 13:32:01, Shakeel Butt wrote:
> tree_node, usage_in_excess and on_tree only existed for the soft limit
> rbtree. They also doubled as the buffer between the read-mostly head of
> struct mem_cgroup_per_node and its update-often tail, so replace them
> with the explicit padding that CONFIG_MEMCG_V1=n already used.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  include/linux/memcontrol.h | 13 -------------
>  1 file changed, 13 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 7b02f1b3bb88..ce24e04967d8 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -95,20 +95,7 @@ struct mem_cgroup_per_node {
>  	struct lruvec_stats			*lruvec_stats;
>  	struct shrinker_info __rcu	*shrinker_info;
>  
> -#ifdef CONFIG_MEMCG_V1
> -	/*
> -	 * Memcg-v1 only stuff in middle as buffer between read mostly fields
> -	 * and update often fields to avoid false sharing. If v1 stuff is
> -	 * not present, an explicit padding is needed.
> -	 */
> -
> -	struct rb_node		tree_node;	/* RB tree node */
> -	unsigned long		usage_in_excess;/* Set to the value by which */
> -						/* the soft limit is exceeded*/
> -	bool			on_tree;
> -#else
>  	CACHELINE_PADDING(_pad1_);
> -#endif
>  
>  	/* Fields which get updated often at the end. */
>  	struct lruvec		lruvec;
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs
