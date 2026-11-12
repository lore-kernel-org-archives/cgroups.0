Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794503518;
	b=HD4y06Nfxd56zqdJ2n57qVlOmOjWWSUJ4bfJQjPUs2f4i9vaCOKqNXuY5x51Q4h555Zn
	 MVN6JmtNxte5jwHpTP5KGmqV9l4D6Mm5pGozAWIkCCFpsfxHyWS/R7iguUj5o+IMmq0pb
	 WL5EK9zmr16RF4QkQXoorVIhjphGCv45AUi/SxuMXazLT0PYWgKjb5PqL/WdMgmcu0gB2
	 4gtT0XXjaTYbi9Dc2DUkJWDx7Dp0oOP4y29RWu18Kac1mopmGsFVCCnupgddOu12A7ZkX
	 DTiTo/E/bs4qyMk6GkAZ53PsL/5w5dpe/bMcjfnhfVO3c8AyDq5rmubuimQUkzGqFvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794503518;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=3KCRPd7UwqaiMFRIx4N7MG3QRVArn5qzACfVK+4/t80=;
	b=5kMTzn4dYfJsaA2hT8aMM52FaEUopgCZSBbcsqLFaAuRwoX46+YTkG7jXklcoQJ2biuW
	 AzxiZZmyj8/HciHdF9KGvRLYS8ZHyygL6EiAFr8AZR9YdpYIfN6zbEbGi94jH9DYxvmyN
	 CAp7c8l/WudoXBZoMlzf57nJZKvfEVfVf4sDuepCEqZf4AjXx9j0i6RJkgX2MQnM319DC
	 basFyNKhiStrXuNyz/q4E3AqAiGxEIb8TDogjZn7A7wzA1XsFIZJjoT0ILpTNh2HakMno
	 bn33P5SsDVrrzwVLKt8FyWinjmTBdsibYIfe8+lB7KfcsyZXoM423CiDCcsKO9fEo9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmpxchg.org;
	spf=pass smtp.mailfrom=cmpxchg.org;
	dkim=pass header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b="OsX/Wv9U";
	arc=none smtp.remote-ip=209.85.128.181
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5975D606A321
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 17:11:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5975D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=OsX/Wv9U
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8b0d63f60bcso1201637b3.3
        for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 09:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1794503516; x=1795108316; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3KCRPd7UwqaiMFRIx4N7MG3QRVArn5qzACfVK+4/t80=;
        b=OsX/Wv9UMQobNjPA06ctArQA+nB3PW1FkFuXJ7cxLoUpu2z7Eg5Uzld57YMYDBVMX0
         XCTCX4jcd9s9D+kpVL94A6UlfWJJ8C8xvA6j+5jyNiOEZqBrNjWhmUcAaCS5syRA3xUn
         gFpqdGFUqd4oQTk81ZURRnCiP3TPzrMDK3qMohmm53cW8I5Cb6m9lANezSO8GlUVTejt
         muzY0bTwLmvmJf6bNbc0VO1g8uJHLa2yfYH6MNPKpLguFucSHMb5e11CHiF4CD7AQ1oB
         M/V2aJRdpraqtlzQeT7TI4gPJgsFH0cV6fsivjWFg/d+q9o+bH8IeqpeU54VEPvWKTTB
         HmWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794503516; x=1795108316;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3KCRPd7UwqaiMFRIx4N7MG3QRVArn5qzACfVK+4/t80=;
        b=nfN1Y+zeg2F77d1n6iwHb7Lkvppl+BhJpUs+jJk0gNllxNA8K8cMtkJaaFiN8BX9Pb
         RdJvV/QfAFLq76AYZEg17FjsgM5zmbJaY9+XLQDfu2zLmKwQgL3ql6YvaHsos/ft6Zqq
         KY1HzhrDlfQ9vpriNb/fgIZnc909bLfXIGAblMBSyCzRY3XLZ+/ONiN8OLWRGHrXgq4k
         PofQsxaFqRFXkdKWb1Q3enm5zjMyBXmmfEo67YS0g0WzrheI+qr9KrWfRYuf4COBtqOB
         0m4+AYfwDCZa0s3OKHyeCik0MyjrQiVLkTLhGqy6NZYQvUDQJbox3y153EAfnv5PibRv
         yt1g==
X-Forwarded-Encrypted: i=1; AL+hErHtkm5v3FZx1UDuU5ho4dzZl8y3+/o1q8T7/hzupMiKeuj38s/WFGzlNcPZwxm7JFayI0oq8qTZ@vger.kernel.org
X-Gm-Message-State: APuU4Z8gRpQD7lDUUnlMQhEVS5hEnhv4UPV1ECUUQa4EnRGQ1g+sfRP4
	a5kf64Apewy2DcLFfEgK7hlrq3tSDDoYME7RvEfWnfP+dU+Tr6K+UiLfLKOxHN8rlSQ=
X-Gm-Gg: AYBFou2q7rcuX+iIvZ0UASHI0t0oQkCE+NGpGLPqMqc9ZrNE9bXu5/mXc1HJO2E72ZI
	EycZ7bKlf+hbSLEkyy+tb5yLN4UtbEVqsfNKG/FJuPe0MYOBqVzaEjbR5r/m1Jf3pEDYL+1dcsJ
	MXL0RyoteP4wnytc4iOhVBuYA3Kacy0Szbpt8KJZGdB7+wXG4Iyrx3BMmR45JuasWF7EDHiZigo
	AwawE5L2xuBUl+uFRLBIPQWpHb4nr/pNdTFYClPBbjXn5YMplP/udUpuN5MzLAFPkQGi6n+XupV
	fks64M88Mr+gqxoNEbKqMbhZSb0JFWy1+6l5LLcnTMqrlFGzsyWQLUX4LjksyyXONO+2Pd3klfi
	Q98R9V7rdbp4Y9pdLFh0d5F6qfMLAKBntRbIzuTd6L0MZMab5PCkbWzXnwX2Ycfmkv2bH8OzZDh
	vNlw59ovu2cfotaNToHcYRS3AGfYfe5V2dVqShhKoZV+LK2VYMpJSj9bWMIWNPpzxUxjKQMbaOc
	+x+zIPni5e+DWlamBK7K5BlP+lGNw+nr8ZeIN07imtWD/Zss5gMRFcerT8ylDY8oRYcALbnpbXN
	4kHyksV8KDXxDrddAyov2sxFSHGs
X-Received: by 2002:a05:690c:e1d2:20b0:882:b4b2:c49 with SMTP id 00721157ae682-8b4aa23f086mr1270387b3.18.1794503516202;
        Thu, 12 Nov 2026 09:11:56 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa9fae24sm252827b3.41.2026.11.12.09.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 09:11:50 -0800 (PST)
Date: Thu, 12 Nov 2026 12:11:47 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm: memcontrol: Don't lose track of exiting OOM
 victims
Message-ID: <avXzU0coRUkBdPWC@cmpxchg.org>
References: <avA1wXhTMs9eY2NF@chrisdown.name>
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
In-Reply-To: <avA1wXhTMs9eY2NF@chrisdown.name>

On Sun, Nov 08, 2026 at 12:41:37AM -0800, Chris Down wrote:
> When oom_evaluate_task() comes across a victim we've already killed, it
> backs off until the victim's mm has MMF_OOM_SKIP. This gives the victim
> a chance to free some memory before we kill anything else. However,
> since commit a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup"),
> css_task_iter skips exiting tasks once signal->live reaches zero. That
> happens before exit_mm(), so a single-threaded victim can disappear
> from the memcg scan while it still has all its memory.
> 
> This can kill another process when the first kill would have been
> enough to recover, and we've seen it happen in production. If the
> second victim is in a cgroup with memory.oom.group enabled, the extra
> kill can take down the whole workload.
> 
> In tests I used a 64 MiB memcg with swap disabled. I started a process
> that faults in 44 MiB of anonymous memory, submits a 4 KiB direct AIO
> read to null_blk, and goes to sleep. I set null_blk to take 10 seconds
> to complete the read so the victim would have to wait for it in
> exit_aio(). Two seconds after starting the first process, I started a
> second one that tries to fault in 40 MiB.
> 
> The 40 MiB allocation hits memory.max partway through and triggers an
> OOM kill. The OOM killer picks the first process, which has more
> resident memory. With the read still pending, the victim blocks in
> exit_aio() before it can tear down its address space.
> 
> memory.events showed oom_kill 2 in three runs. In one of them the first
> process hadn't submitted the read yet when it was killed. The slow read
> just makes the window easier to hit.
> 
> The cgroup iterator hides these tasks so that cgroup.procs doesn't
> show processes that waitpid() may already have reaped. That's fine for
> cgroup.procs, but the OOM scan needs to see a victim even after its last
> thread has started exiting. We already have CSS_TASK_ITER_WITH_DEAD
> for sched_ext, so use it for mem_cgroup_scan_tasks() as well.
> 
> With this applied, OOM selection backs off while the first victim still
> has memory to free. The 40 MiB allocation completes and memory.events
> shows oom_kill 1 in three test runs.
> 
> Fixes: a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
