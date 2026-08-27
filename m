Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299BC47CA61
	for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 17:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787850907; cv=none; b=TTm7K7ibQ7Oc2+8hMcTuUFXI8bwAvxH/Tao1sNDaFQUeeJ9HLr4RxMb88t5V2Tf7no81dRVHGm09zf+fLjYRL7Frtut0SPheubZ1Yz2ruQwljXvzsGOp+gGtSt5lUbQOSd+u5UD7aKdJV0/kBUwkGYrPrHKXSTyza/O06XWQja4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787850907; c=relaxed/simple;
	bh=b+DbO/XBRVMRrkEPpL+a8uMHxOKqXYztv7EREra78xc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d4oPR0Jyf/+PqpXMKYGElhcmzeNRoxJsPEfq0A9jdTQ0ytW7WG1wY/VPSv99+NevxLIYfzqFA9YZ+yaRP2+kqw3F4Ba/KidRdtynvzdut1zNI7u8w6yn6vd4wmUxXQRkgRSGZpwoD3iFWLSTlttaDceaJQFLehHHOj2b6AWpGcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=hGEE+8bz; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="hGEE+8bz"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-836cb2fa1bcso950547b3.1
        for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 10:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1787850904; x=1788455704; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uQnMu3iWvpGPN+g3IV0k0ZH3wDq8ERD9nTW8XM39tKI=;
        b=hGEE+8bzf/Y+yzK9IPDD9jQPIyk0rtF3ze2FRvddTqNFXwrO1szjujUG7oul9sbmJj
         MPkPCS7ksHtop/Exs8DmSM6cYabeH3IJrCwd1dXHSvTUXpI/JL5Ijo8aRobeFJvn432U
         WedPz+ScNjjc4OYjdBzQJ7Lf5Ej3LvPEfTYqI1iOyPIZfi+SJThW45/S9EPsjTSaBU58
         /cGedcx2u8tP544KzHN0EK72Kt5ABAzQPuGDDhGsId+lnzHU0EK+StseoE8k0aialhK2
         j1+eBP3bHhn9jRByIx2Z2pmCHPtXKqD7227QzgHLd1hm4mE0zHzDZ5DNFDmHkBa3m3lT
         /XZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787850904; x=1788455704;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uQnMu3iWvpGPN+g3IV0k0ZH3wDq8ERD9nTW8XM39tKI=;
        b=fW8UUvDez7zUVS3kfNNIcnsIyvnV02Sr2KtLATWdlrPUnyBWlsvyHubRn1nf/Hb/at
         0d5v/c3yGgwqcfw77dDf9Pumt6Ro/WRj9EgXMjEaO3rEMEE4Oa5wmI2DuPpE8yEaouPl
         EgoXGKiCDBICOfta4m+RbXkBBJUXlj1Z4uj2oW89MtHwXHArGMFLvjsLzqmQ2hrXNSaq
         OBp8fRydVjxwKLMTB7u2E3N9ahUwhZKgZf0CnePazyDyMoNJ/XgtBF2kmk+RGybfTom1
         myM9Vb1X8X6txEsoTeHX9TOIJ+K/sBzptwP3GYbM+PzDkIsBpD02DdRr3htEjRuGuS+x
         6ASg==
X-Forwarded-Encrypted: i=1; AHgh+RpeQ5gi40MJ334lGdmlxCpVgpifxAikUssmwAAGLFUjzkNB4y3/PQjmHumu+CyWKjeyv9DsnWex@vger.kernel.org
X-Gm-Message-State: AFuF++myoIwh5dVyI0iID/IS5wWBnCyZUizvAqMxkgupAwoqakD8l5PP
	rmWhYygRGMydNsBvqvAyR5xSBwLTwSlNpNlxn+x4ufnSbl1qeSf+GKZXDovE83qzYoc=
X-Gm-Gg: AR+sD12fFPuCbtAhFZfYdRZ6sHC6+bWs54Pcg2Iwpb7m9nBo2RjT86JY6Jw3h464wlA
	pVeckxPOROKdYsxkGZ18AX+DeHdlaLvV0rwuOZxZw3E6K7m1jCdueQex85mACZjbqirlMLYhbzT
	0VqmyAmO1+5g8ZA6dk8AVvmUyG7QiiKZBb95vOjqDCPJl+SOncODeESoxYvN/ztlnYzLap+kG9Q
	S4HrpbQMwq2jWcIl3HR9u5kdO0DhYZEmzXLlgtA6SG6cavLCfJB48yQXZyh8sQXVQwJf2LWRRUF
	oDqGCLoX8vdwgXsVABbgNQUwtuAlplRcopxGObVynhzyrBuDoF2T1nkCe8PkA6+1GsLRLCmV/qt
	iCc3Je9W1iDh3ikrohAccgAS0qGCNSBwH8Ho5d2Zphgncm9J4BiKqNLjj3sBKRnIM3tdGhbBHJJ
	Gcwq7GnUW1ODMpgwv+QA0mp2QZwK4Gee9XS3N/bVD/jMcxsfQbg7m0OMfJCO6+DA==
X-Received: by 2002:a05:690c:c017:b0:845:a433:c337 with SMTP id 00721157ae682-85d632603a2mr3858517b3.0.1787850903708;
        Thu, 27 Aug 2026 10:15:03 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-85b5c7f08d6sm13933737b3.11.2026.08.27.10.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 10:15:03 -0700 (PDT)
Date: Thu, 27 Aug 2026 13:14:59 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rik van Riel <riel@surriel.com>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/memcg: fix UAF in drain_all_stock() async work during
 offline
Message-ID: <20260827171459.GE3004@cmpxchg.org>
References: <20260827124211.3b94b103@fangorn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827124211.3b94b103@fangorn>

On Thu, Aug 27, 2026 at 12:42:11PM -0400, Rik van Riel wrote:
> drain_all_stock() queues drain work on remote CPUs via
> schedule_drain_work() -> queue_work_on(memcg_wq) and returns
> immediately without waiting. The worker, drain_local_memcg_stock()
> / drain_local_obj_stock(), dereferences per-CPU stock caches with
> READ_ONCE(stock->cached[i]) and does css_put() / obj_cgroup_put().
> 
> mem_cgroup_css_offline() calls drain_all_stock(memcg) to
> optimize reclamation latency, but never flushes memcg_wq. If
> that races with cgroup removal, free can happen while workers
> are still pending, causing UAF. The drain work could also have
> been queued by somebody else before offline started (e.g. high
> throttling), not just by the offline path itself.
> 
> Timeline illustrating the race:
> 
>   CPU0 (rmdir + offline)                CPU1 (charge cache holder)
>   -------------------------             ----------------------------
>   cgroup_rmdir()
>     cgroup_destroy_locked()
>       kill_css_sync()
>       ...
> 
>                                       refill_stock(victim)
>                                         css_get(victim)
>                                         WRITE_ONCE(cached[i]=victim)

I'm really confused. CPU1 acquires a ref for the cached[i] pointer ^

>   percpu_ref kill confirmed, css_killed_ref_fn() called
> 
>   css_killed_work_fn() [offline_wq]
>     mem_cgroup_css_offline(victim)
>       drain_all_stock(victim)
>         is_memcg_drain_needed()
>           READ_ONCE(cached) -> victim
>         queue_work_on(CPU1, memcg_wq, work)
>         // no flush!
>       mem_cgroup_private_id_put()
>     css_put() -> refcnt may hit 0

So how can it hit 0 here?

>   [RCU GP]
>   css_free_rwork_fn()
>     mem_cgroup_free(victim)
>     // victim struct freed

This won't run until we hit zero...

> 
>                                         // worker delayed by scheduler/
>                                         // WQ concurrency
>                                         drain_local_memcg_stock()
>                                           old = READ_ONCE(cached[i])
>                                           // UAF: old == freed victim
>                                           memcg_uncharge(old)
>                                           css_put(&old->css)

...which is here.
