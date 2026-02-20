Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4379131A7E1
	for <cgroups@vger.kernel.org>; Fri, 20 Feb 2026 19:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771614173; cv=none; b=FQRQ8FpPp1KdjKFHxTF3Lj6/Sk5TkCeatrkjGwjuMFo0sE5QPERAT25VIaxYSLzkf9lCgsi13BxT7SMrM9aMawgJdqP5GivdA4rh+epTAhyQYmclgwhqUK6/7wB83sEJSYe+MklsM7g7N4nIDNsEM7f/UvJfGNlvHm1dahOHlQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771614173; c=relaxed/simple;
	bh=Cd+jqZjh3WAVSRNIVyZ6GsQswDgTs8XBJ+R9F/1aitQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZfA4pZcunj1OpJAIDXdxLN5MOAJ6+Uwed52qya3Ptm/z72gZlpNPfydqqildS1+mL7Dq/uX1lF72yFuW9iEqYOcOtJT2jqR4YtBfjoh8bTRvXZHgHQxILm2EFkAVlTT8rPDNfd5PfN+ZzuzEsA+fNdZyFqfNemBlpBAwhKzVuyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=AOUk5rAV; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="AOUk5rAV"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-5fc419c346fso700801137.2
        for <cgroups@vger.kernel.org>; Fri, 20 Feb 2026 11:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1771614170; x=1772218970; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=trvZR2sCF4V60jHjOkl0avZ915H6as3fJB6OlIOoH5U=;
        b=AOUk5rAV+hlsJaXE1F+bnciosMajG7pl6bg+mIRhdq+zzlDAndmIYksPbOOI2e43Bv
         bNOgkViOVd7LCRABYVG8G2IAyBx4DXkMI/2J59h6vsIQPZZ5m9u3eCmvhOu7oEhqZtdB
         78ldPSzPQJiHHUvH3pLSg6a28yp/WDtg1QZdD+oBuHVX7TKqjkCUeOnKSq3wtsjearE7
         /PnAsGCNH3tfYsOnmICFSL14JKTcfzSVWmoeiKYtWpJ3M8uMrizjPrRHK9oCOzZ51YUj
         NYg9jO3nJYkEmSNQwttNRq/8ULWeSEl+9AGwBulxJJNzWc6446yhNHoo/djvJYXaPpaG
         vQGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771614170; x=1772218970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=trvZR2sCF4V60jHjOkl0avZ915H6as3fJB6OlIOoH5U=;
        b=SwI3nCm3Dd8TA7r8cMoYZsOHqEutLXjnkX1d4uLgPkEarGMdAm37rOMdnxuEYE1MkI
         I2pUTm7lWeEuiCvtg6IV7oxaxKBLD6Ms9r3O+DoBKDqaSb/keNPctGDtwE/7u8quYmzu
         tSRna/q8+UBugarujud+UYF5GoVPxlfyPHODmiRH5sHTud+AfoiGvPCvdoOKHA4/WfTZ
         L1Bw86TM64WTBhuoLYE1dUyQLKIKaFqAwYcuLXuqBmbZaIW+7EN5gBmsxdtbQik5tNub
         5kDrgvYzVxy5QBlr5WuuFiFitQDntm2ewyE5WTvCUAMeHjecrsAUF5zNSIRmeL3rw9IM
         5j5Q==
X-Forwarded-Encrypted: i=1; AJvYcCX2MoM/4a7NRrkn1YtW5Q9zmH/d7iKrhHm5mXTfPO8YlVQF8jVkW74kHqL7NHmn02r7IqTHnfsb@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7QvCYcPlcgteV2J7zZPeYRicC1DGj/+TKJXW499R3Jx+xW7wP
	BKD13q0vXqJ3S/mbENg57VCrgfSrUnef/ezZvoJV91ewpkOWabESuks0cF6PM5BewRy/fAFfsJO
	Y9lHI
X-Gm-Gg: AZuq6aLP0J238xQzD0GpeVxDJx6Lu9hz2+5x0BkMmoHEeBv0peqFaXwq0rYV+8wWeCU
	otiMCqP+kzYzFOBAV56teKgZQUXFYxQ9wWWVxiAfkEV8jEU3ujbcGIQlnWfGOpWWfRrB4nvBLuQ
	/DrqSTS3gcIfsYD9ZJuXEuIZUnPQnqgooh1VooYKGAPKMChQRP6GVYDHiV74pX4Fh/k+8Hhai3a
	EmqG6yNc31SYiAR/sDOWfEs5I3cdLxBrtwZKbQqXSyWzvd3196j2OVQN4GFTuloKW2Mfm0gc9vJ
	OLQeYHHZW2Y5yLKJdwowuajWTTnDkNUxR4R9vJcqJ9iCrbgBq4iBP0ZhsPRXSG8QzgpmD40S6zK
	KMFFHOM7+rOlTbCYlgpZDzMigbGi2w2NW40J5+VgQCEE016vP9gNm4wvDCKqwlzs08t6CarcjNY
	2l8iAAm8ouC6YsdXDEBmAlsg==
X-Received: by 2002:a05:6102:a4f:b0:5ee:a7e9:f157 with SMTP id ada2fe7eead31-5feb31253ddmr438759137.40.1771614169735;
        Fri, 20 Feb 2026 11:02:49 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d6df498sm488911cf.30.2026.02.20.11.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 11:02:49 -0800 (PST)
Date: Fri, 20 Feb 2026 14:02:48 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, mst@redhat.com, mhocko@suse.com, vbabka@suse.cz,
	apopple@nvidia.com, akpm@linux-foundation.org,
	axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
	david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
	jasowang@redhat.com, joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com,
	rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	surenb@google.com, virtualization@lists.linux.dev,
	weixugc@google.com, xuanzhuo@linux.alibaba.com,
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
	kernel-team@meta.com
Subject: Re: [PATCH v5] mm: move pgscan, pgsteal, pgrefill to node stats
Message-ID: <aZiv2ASYc46m7K_c@cmpxchg.org>
References: <20260219235846.161910-1-jp.kobryn@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219235846.161910-1-jp.kobryn@linux.dev>

On Thu, Feb 19, 2026 at 03:58:46PM -0800, JP Kobryn (Meta) wrote:
> There are situations where reclaim kicks in on a system with free memory.
> One possible cause is a NUMA imbalance scenario where one or more nodes are
> under pressure. It would help if we could easily identify such nodes.
> 
> Move the pgscan, pgsteal, and pgrefill counters from vm_event_item to
> node_stat_item to provide per-node reclaim visibility. With these counters
> as node stats, the values are now displayed in the per-node section of
> /proc/zoneinfo, which allows for quick identification of the affected
> nodes.
> 
> /proc/vmstat continues to report the same counters, aggregated across all
> nodes. But the ordering of these items within the readout changes as they
> move from the vm events section to the node stats section.
> 
> Memcg accounting of these counters is preserved. The relocated counters
> remain visible in memory.stat alongside the existing aggregate pgscan and
> pgsteal counters.
> 
> However, this change affects how the global counters are accumulated.
> Previously, the global event count update was gated on !cgroup_reclaim(),
> excluding memcg-based reclaim from /proc/vmstat. Now that
> mod_lruvec_state() is being used to update the counters, the global
> counters will include all reclaim. This is consistent with how pgdemote
> counters are already tracked.
> 
> Finally, the virtio_balloon driver is updated to use
> global_node_page_state() to fetch the counters, as they are no longer
> accessible through the vm_events array.
> 
> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
