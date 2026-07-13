Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FC73E8C65
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 10:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783940222; cv=none; b=lFbShlpbzmxRBTTzkalYY1VVibi5qRK8n+IMbPHoVYEbwhzkI+Ej08sVkigjODF2B+Ad18jxIxrSas0/d+a+JnRmK0Rwl3mo76xMu5MxCr/1jyDfLhadOJJ52yNjezvbWHRuvQ6gP8Ioqrx1ULtzSTG+C/sUR5lx7ht7T78A2zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783940222; c=relaxed/simple;
	bh=y7zI6WWCN62EttLtA8m/eJMwaY6HfV7JtvtgKW2u+RI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sIt11GAy63w3H+r8LUVmr4/Ir7xmlB+/LaiYrrjj72XBEvZ7GaKgBloSI7DhtkNGE2h0/ZLskxmW+G/9Q6n/pY9uj44KQu16h34tJ1ZacrnUlx7iFUq2rLQF0GEUlht/1TPKaBqwUX9YTgVcyzHDPDrCOQFXnhU1uNXoeOWmVII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=L0inpc3C; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="L0inpc3C"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so22219545e9.1
        for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 03:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783940218; x=1784545018; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4Dhj2OBMuhusOZcXZldE/EzCpMTqXXR0jxmWBxe1EX0=;
        b=L0inpc3CP/d/ACLmiClmdyk04MGYYQzowGg+hyTlIjfzZG8+i+eLstDVM7G1V9wZPa
         DbCq9RThE/phL8g5fGwGB24sQf5O8f5acacYQMpC2DzXynsSDuo0vWVAJE6fD7RYFsWD
         D0FEGE/9zdPp00aI06fzR79iwvCPi3Ee3ZNfU5S5JjnvAXpK3qZREo4uZEY4CZYmViRA
         5EMP2HytNoFlwCAb64uVnhoPnjqeiBMTxiH9wGFtedGhHSjOTfHOT2n7OJSthoAbpDrR
         lT1GteYzVXXG0frwaB8w0MCkk2jxSnMdbhZ0gQsgYw4zh66Y4nKY9+J4tflf8a8hdQzX
         IQEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783940218; x=1784545018;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4Dhj2OBMuhusOZcXZldE/EzCpMTqXXR0jxmWBxe1EX0=;
        b=ZvBFLolwaoCucNOhBBRmTmpXLx9n8/2LORyiDT5gAJI2OgEfjK9b+dYUG5ZjZFM70z
         jw8QyKikIUdKkXePz2CM2l5DBns6Ipi+JiKKAMiwDummDpx72BFff9zAcnGGf8Y3vQE8
         PPhMRwjlvLzkdh6AfWyl+ILnHikybQvyM+HbvArdQT5UXJuKCLVYmms9ggY4LZaeDPxU
         nVigend1ehw7ek9gNtIVweaEVtB0jgzrjSl8h6xeHTcN1gday/DNQh+Ch617HSfRtiIL
         Yohh+TAFhLiSwalZdJcdUGWMTAdrQECQMZz9W2F4m2bEh1PRMtcwAJwS6MatVQPoHLQC
         FZxA==
X-Forwarded-Encrypted: i=1; AHgh+RpPblmVtpm1zpcQ5ASqyseYbi2pJ9eXzh9jQScaH0tgOdZ3tTfg3ybbIH9tvQqw9qkOjLGxaoSW@vger.kernel.org
X-Gm-Message-State: AOJu0YxzWbeYh9IOYo8bPyPpVyFXIC7eMILejMvBvaugV4r5sN1YNAmP
	j+mbX2xcHX19KewPoQS/U+zQLBvsiansaJx1qzkrXHpu5stQcJXjYI13RLkdfNyVLZs=
X-Gm-Gg: AfdE7ckJ79kR7+O+exUR+a++U+acNYW38F9kEBitGo8jbF7pku3MeQ3wr54jTl9eTPC
	xhLwo/jVZAysUxb3L01c8v8jRnpjj2M5RoB5fDS90vRv7RtuOZ+nHihXQB6hJnwrihlRytBd2YL
	+6GsGrm1gJTT24KF+0znRbsAo6s3gCTYBDfCmCK7GCmTy4rhOyLU6fGH9gX9Hd8cu2iVRpY7aj1
	P65LTTUwz+PMFsKYXkWbEHiWvt65VBdDSgpu/Gy1TTs6lcfSh3ETDLo37KTR//Btdqet+mGHtI+
	0IsHfiEhuDiNdWZDec1qFaLBmG357zcxG28OXihfHOB6R2Tmmkg6Ijqhzcp69M/TX8BIscHhOfG
	6AQdAGKBC8WT5NPCLlmwTwnM3Gjs9B60Tkgp4YRBs0uZTLFnFckCmRmyhhRQEY+CvZw/nzaP6rq
	oOj4XPFTOzVg==
X-Received: by 2002:a05:600c:a016:b0:493:f442:3de9 with SMTP id 5b1f17b1804b1-493f883174amr85181725e9.27.1783940217582;
        Mon, 13 Jul 2026 03:56:57 -0700 (PDT)
Received: from localhost ([2a02:8071:6401:180:d892:bf43:a0b4:83b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb73ae14sm352682965e9.11.2026.07.13.03.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 03:56:56 -0700 (PDT)
Date: Mon, 13 Jul 2026 06:56:55 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tejun Heo <tj@kernel.org>
Cc: Matt Fleming <matt@readmodwrite.com>, David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Edward Adam Davis <eadavis@qq.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	"ziwei . dai" <ziwei.dai@unisoc.com>,
	"ke . wang" <ke.wang@unisoc.com>,
	Matt Fleming <mfleming@cloudflare.com>, sched-ext@lists.linux.dev,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, kernel-team@cloudflare.com,
	Sashiko AI <sashiko-bot@kernel.org>
Subject: Re: [PATCH 2/2] sched/psi: Shut down rtpoll_timer in
 psi_cgroup_free()
Message-ID: <20260713105655.GC276793@cmpxchg.org>
References: <20260712174619.3553231-1-tj@kernel.org>
 <20260712174619.3553231-3-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712174619.3553231-3-tj@kernel.org>

On Sun, Jul 12, 2026 at 07:46:19AM -1000, Tejun Heo wrote:
> psi_schedule_rtpoll_work() is called locklessly from the scheduler hotpath
> and can race psi_trigger_destroy() taking down the last rtpoll trigger under
> rtpoll_trigger_lock:
> 
>   psi_schedule_rtpoll_work()        psi_trigger_destroy()
> 
>   rcu_read_lock();
>   task = rcu_dereference(rtpoll_task);
>                                     rcu_assign_pointer(rtpoll_task, NULL);
>                                     timer_delete(&rtpoll_timer);
>   mod_timer(&rtpoll_timer, ...);
>   rcu_read_unlock();
>                                     synchronize_rcu();
>                                     kthread_stop(task_to_destroy);
> 
> The group can then be freed with the re-armed timer still pending, and
> poll_timer_fn() runs on freed memory.
> 
> 461daba06bdc ("psi: eliminate kthread_worker from psi trigger scheduling
> mechanism") deleted the timer synchronously after the synchronize_rcu(),
> which prevented this but raced trigger creation instead: the deletion could
> cancel the timer that a new trigger set armed during the grace period and,
> as creation also reinitialized the timer at the time, corrupt it.
> 8f91efd870ea ("psi: Fix race between psi_trigger_create/destroy") moved the
> initialization into group_init() and the deletion into the locked section,
> trading the creation races for the window above.
> 
> Neither placement in the destruction path works. A pending timer firing
> while the group is alive is harmless though. poll_timer_fn() just wakes the
> rtpoll waitqueue and doesn't re-arm itself. Bind the timer to the group's
> lifetime instead and shut it down in psi_cgroup_free(). Nothing can arm it
> by then. timer_shutdown_sync() because the timer is never armed again.
> 
> Fixes: 8f91efd870ea ("psi: Fix race between psi_trigger_create/destroy")
> Cc: stable@vger.kernel.org # v5.10+
> Reported-by: Sashiko AI <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/all/20260711000434.36C4A1F000E9@smtp.kernel.org/
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Both these patches look good to me, but Suren can you please also take
a look?
