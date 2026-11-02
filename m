Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793614368;
	b=0QB/MSlOUolXXxP+8bD9dStNqnv/YtKt9BONoEazoOGRspl78yOt2GHtzorEso+Kxlsi
	 aqENHlkbqUTkXypgsgErpeW5FTmJ/BZ2maW2ga9BfXdu3LpQ7SbKaNGuFCT5kF664EAda
	 hF61C4BP/VpvKlScSxWX/swB6aCOFDNp3mnIYAe/pN2rxB6GF5EFfT7enCg8YkrHOJxhC
	 Emd59xzCRB4C1Y7WmIEuukiNZQp0fmSc/NSxYs0b6gKVBn7u2ZiKWKfoaR26w8hL4IO3U
	 qOKEYXF6j7mDqopu5ZHR8ty3txIUcH7Jc4gept/ULwQSFgKxjRKyXI8Zmm+XA7tEbvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793614368;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=zhAJG7RoUXOoz7M+qXiobMg1MbFShww69uh/kTjgH68=;
	b=3HoiKJsaeeO43hf0yAyn7n1blaz2HAhzMreXRncys9sxMPr26KufSlk0f0w+CU+W/56m
	 HTZLYkDUSRP0DWdJC1Gf/YVy7SpRcXYKRzYeIuYF6Akv0iQxoK9HSdSlfLr7lPbYNpMV9
	 iN220lVdgmrBZ3Dn3DJ7RgDyHfkgDZtbxKYG9KoQWJvjGjydibuGDd0sGpUItiA2HSRIw
	 R+lFItNeWz5uSnV1Y0ztYDsBgp8ZgM/TooEDIuQSueXKHddFCOgzqW2p1NfVa6zmtDjiL
	 FML2XieD02qkRa9YlpqXoSislF43JykigBf2Qd6hsxjWK4MDp38Nok8mNgmpGR8n4ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=VmuCN7+4;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A837606A327
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 10:12:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A837606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=VmuCN7+4
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a5036bbac7so16362695e9.3
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 02:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793614366; x=1794219166; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zhAJG7RoUXOoz7M+qXiobMg1MbFShww69uh/kTjgH68=;
        b=VmuCN7+4AZROpo0l32qa7fIa38GzCV9C5RE7VWKIVqzBzIm8UL5G2FotGfej9c1OcM
         d+100dYvuuHHZ0DjCCpo9jjJ2fVhZzrXeM4uIDsoYltVvF9/YOv3EYWquqtbS5eJqSwf
         4dv4PJB4Xr1nR6H4EBRh9oQzkDrntLwyEKVPhMGGLx8ydJK9mxEIeRSbishj8frkFwWP
         k5J5B3xN93hnv5gX1ouoySBr3tjvb5zuCkTRlySP9nv6oRR79H5I+cyM5FoRwlU2yY4w
         rt65w5HFcdZi3Sp7dCrV+bT6avv1cp1nXwNTOgr71kCtFEzB4pSYcFq7AO47cM9DxB+i
         SqzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793614366; x=1794219166;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zhAJG7RoUXOoz7M+qXiobMg1MbFShww69uh/kTjgH68=;
        b=ZeKXazkWf6H6nXix9KrBHbl9DorwYykrOqR5h5RTxX3/8KDUpTPt7UdU0lStyfPxE9
         XhHHZqNCpZJS2LZWHyBGN3/UHtzHKN6tyw9DLAY3tTUuWd5pPrsBJXdajYLz8i2XeR+t
         E2/NXkA+kSPFRg+ibMOwKtAScavcFX0l0p4BpFo3gyfkR8YfC97Jh15p8dZkrFP7te5n
         BZ7r0SZHLfWWjPxJLGdPvr3JCOTw+RAfOu4r/eK4hz9eB+/0MxybepucDZlU0IriMGsn
         kWJp/nDjDike3g9SjEc9qfK3CTL7FxLJGZGZw4g2tiw2F+tAziJ7sjQyOaGGc/jdmKJY
         gB1g==
X-Forwarded-Encrypted: i=1; AKwUvBzUJNQ9a8OKykyzcYMinSJDknCuF2iEgArtAXSFUNjAHXMIJVRHnAEbzjDwnIPXRiA5o6wNvH6G@vger.kernel.org
X-Gm-Message-State: AFq9FYJS7rMrOZ5yHEr1qpCTjyLDcMSEb24AX1Orc6ty0L4KkO6IhTGT
	09zbvXIeFtI8UGsSCDjUacqgCsAb+I/Z2zyEK81fteIejqsNuIVVquaDuVFsTSEtKLI=
X-Gm-Gg: AYBFou2tk4XmorvIHoi5xbcpohX9/gdu0KgsaLMOjQgSXu7nCjO7wRJX0+YW5Cuo67e
	LSxaZLOiu3/Ln/gnvfCTplNMSRpg1BQRu2z8Zg87X7xf6hszSAxzVVVugVetHcr5os1eiZZo13I
	PXNnbsxH3+AL4a1bevmyJjWZm4YGvm/nstMzIYw1xo4l6fnLv4y0cfVqepC2YnTTQotBYKYXZgT
	BRkfBcau6Zu8eucM+KZ3nd9AOgU6tAe362TEFEMzPDgjH2wvJY/J7HouoOPC/TXbsoT98mHt+4p
	C0yT7DAx1wBFLED1CCjdiqwq6MGPee6W+wcnF/Jwk8gvS1QHnuSu36f6GtptUYeggFrobAgAWlV
	niN0t00dbPj/hK0EjNebmDYUkJyh6OpbrTAWMB88HiAyzlnS9YtlGXh7+A8hKPUxGGwi4E4lzvr
	wAt1bYu0rahZV2L+8hsaGELGbNEO+kQYdRDAeYqRiB17OemNCfpLDcShXlYdev8YQHFDwuHBXpZ
	kELneZofrX/fK8NdTMyc2DMybswVoTEZ15V6YhKUOlKvFESsA0l1+qfC1Ole/j7bdLVZ5Wrj5u4
	gAQ1gYMtpqCq15yRFW5q8sRI9fkxP9j3KxmGN1I=
X-Received: by 2002:a05:600c:19d1:b0:4a2:677:ad8e with SMTP id 5b1f17b1804b1-4ac1970b9f7mr217205325e9.34.1793614365911;
        Mon, 02 Nov 2026 02:12:45 -0800 (PST)
Received: from localhost (109-81-32-81.rct.o2.cz. [109.81.32.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b9a3b1sm20935867f8f.44.2026.11.02.02.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 02:12:45 -0800 (PST)
Date: Mon, 2 Nov 2026 11:12:42 +0100
From: Michal Hocko <mhocko@suse.com>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	penguin-kernel@i-love.sakura.ne.jp, tj@kernel.org, mkoutny@suse.com,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, zhanxusheng@xiaomi.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: don't miss processes whose leader has
 exited in OOM scans
Message-ID: <auhiGqKJeukk7t3P@tiehlicka>
References: <20261026120248.2188024-1-zhanxusheng1024@gmail.com>
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
In-Reply-To: <20261026120248.2188024-1-zhanxusheng1024@gmail.com>

On Mon 26-10-26 20:02:48, Zhan Xusheng wrote:
> From: Zhan Xusheng <zhanxusheng@xiaomi.com>
> 
> mem_cgroup_scan_tasks() walks with CSS_TASK_ITER_PROCS, so it sees only
> thread group leaders, plus a dying leader that still has live threads.
> Moving a process whose leader has exited, by writing its PID to
> cgroup.procs, moves the live threads but leaves the leader behind, as
> cgroup_migrate_add_task() skips exiting tasks.

Is this a desirable/intended behavior? Shouldn't we move the dead leader
along with the rest?

> The destination's OOM killer then cannot see the process.  If it is
> alone there, every attempt ends with "Out of memory and no killable
> processes..." and the charge is retried indefinitely, and
> memory.oom.group kills nothing; otherwise another process is killed in
> its place.  The source's OOM killer still finds the leader, reaches the
> moved threads' mm through find_lock_task_mm(), and kills a process that
> has left the memcg.

While you patch works around this seems like something to address in the
cgroup core. Should CSS_TASK_ITER_PROCS iteration see all processes
regardless leader being alive after or prior the migration? AFAIU the
thread group belongs to the new cgroup in both cases.

> 
> @@ -1452,9 +1482,10 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
>  		struct css_task_iter it;
>  		struct task_struct *task;
>  
> -		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
> +		css_task_iter_start(&iter->css, 0, &it);

Shouldn't this be CSS_TASK_ITER_THREADED instead of 0?

>  		while (!ret && (task = css_task_iter_next(&it))) {
> -			ret = fn(task, arg);
> +			if (!mem_cgroup_scan_skip(task))
> +				ret = fn(task, arg);
>  			/* Avoid potential softlockup warning */
>  			cond_resched();
>  		}
> 
> base-commit: 6b4b543fa18757297ac756a6fe6e64f506b7844a
> -- 
> 2.43.0

-- 
Michal Hocko
SUSE Labs
