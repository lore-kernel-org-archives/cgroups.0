Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795007737;
	b=h9TdChZOBsytRhA3GHhi4fg4FCMxIXug8/d8KiEvzNtLPFIC+rvkX+L7UbbPnoCCyjts
	 6qoXK0tf0fIJS/qYCFvzY4mSG8PbsAB44C9dCYnYkU8kKIjek3ldllyKtjFnYUF5WZw7G
	 gyO30h06J3kvkvgWzNkClioa2dPOtqv+NjexFJEF+CSOGq9IkVj1CKnWIS36M3LV4bsWK
	 pGxTTyIB2vgXsCRgH12yT9OT5NPMD3F+EF/TZ/XgcWN3fsRFU2lW0jgASzn/iyr42qq1J
	 9KU6YoNoXRDijOVk+JcD0bytQbh+9o/eQE6faO15isaDwlqhuQD/DO9ZsLZDsFSU/PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795007737;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=GDBgSBwB9SZv912xAYmFSFm0+XZuKPzPjOZZNdWEPXQ=;
	b=lTxCnWxaD9WRTrftD7sf7WNpLxImOm4mAkkOvgAj3W7yAf6f6Zye1aF7L5XMbJX/GIb9
	 cc2ldCSxvMwSLQZBAHJb5C3nmUbgXvky4rrvOXZEK+6LqCh4+rX17Ee4Uy3sebdWbb1/Y
	 wiNCLTIKZA+VKxWEYmHWqu/KUFNzbxu96v2s4Ic77iaOTH/d3KjGwhI/A4wDJ8TN5M7f2
	 BTX3Wz8ODQ5vPYHZ2aXipeDCigJSdyxbQ2yq0LSyQdzksbHQl7LVnD/GZb1dLPBVUwDCT
	 TU2Ts8lzEqpwjDZjvp9sQWhJ3s4IunDYBC/ME6/rX4LLhhYGARlj52bEqWu3AQZlGdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dw2tFieo;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=aZ71aw2n;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD76606A320
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 13:15:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DD76606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dw2tFieo;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=aZ71aw2n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795007735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GDBgSBwB9SZv912xAYmFSFm0+XZuKPzPjOZZNdWEPXQ=;
	b=dw2tFieoV2fUktIlo0TDK4I8UddhaWCMjQ0RpJmBwGRrUxLeTyC9lJV2MMZi1yZ2WLP5dN
	pYIHMhX/LR1ysEbldW1KdHlw3RLwaNPw0TzqV/TIiPnEsZUkO+pvdhAz3n0nYk9jaOC8r7
	gfhq3iKct+gLMo+hhnQF3t0piot4PT8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-O3CEGGvjP-eUcJjsoNiV0Q-1; Wed, 18 Nov 2026 08:15:34 -0500
X-MC-Unique: O3CEGGvjP-eUcJjsoNiV0Q-1
X-Mimecast-MFC-AGG-ID: O3CEGGvjP-eUcJjsoNiV0Q_1795007733
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4a799d93bc3so276618f8f.1
        for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 05:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795007733; x=1795612533; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GDBgSBwB9SZv912xAYmFSFm0+XZuKPzPjOZZNdWEPXQ=;
        b=aZ71aw2n8oHteORzK1U/UStkmYdaD98yxYzrW+hkEZQEEtPaFjB1Y6q4hV4xCJpCwx
         cnsqw71jhW44xU/UIWFXJtPXRLw4bJe7KtTVNGUFrYhkQnPGngKWt/+mC5OstdzU++IZ
         3esEFjloz3o/Os0RkoqXLx1TvuAQaBu/u2lN74HCh7hgrmNG/xNaJqA9FbFy0HgdA7nK
         z7CBcJCq1Ij9WGdnNevbF+o45xuwfsprrcxTiqlKYd1kwpeDIUB1wezCjoL3DRNyTmcS
         zbFa1C2XKYOstvughcn84NKIzTZKoeQ3bIV7C7lTMtIuXJRm1gWKJiRRKp8JxjYdbzRS
         PNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795007733; x=1795612533;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GDBgSBwB9SZv912xAYmFSFm0+XZuKPzPjOZZNdWEPXQ=;
        b=SerFya8vM6hau24uv8JOvQrpdYwT+0YKJYSK/obphBImeURv92NNv1Fn7Ma86N1cLd
         V50H+jzemIjgHLsFbuWb62umagcOKYgOmynWLqMw+zPfsKsvnNQayKQV/McLNFEXTyxU
         PmDQupYgT1iTGHulScdedtdmHwl7dSVHlmt0DnoBLaz2Miw1/D+DE7YiaP1qYoNNOfaZ
         lWYoW/2Wa3p7Fy/LLzmCUZE2Y/0+JYxCgG0F6v3UtlhBahKkMYuOI8EZShQgQ6jmpVRb
         fMNCqYAToU9U5Z0rJ25E6rdbgMryfy6dI9MgMNu6/g1/szROuDrLda28BZyQs9Wb3dyP
         b4bQ==
X-Forwarded-Encrypted: i=1; AL+hErG2/OXbEXiSkVaPlcY7lSS3/ZKN6ldXm58ErRv/x1vXXczrDNtj/ufffHcnsRb0UTnyI/PJKPhw@vger.kernel.org
X-Gm-Message-State: APuU4Z9gOvwD+99sG2TTk8HqaBj4B6Xf+eh87piRY8gr3RLYKoaEWOZD
	AmbDjFVPlfvaCIstkEFl3gWcQ9iNGB9hOfPlA1YWpbUGbKXswUOZxv/om/p8LnbYaqNu45G18kz
	rvSDvwyqKv0KTOGK4U+qRkom0oJWNZQXGwRKx+74cFYcwXJwoJSUC3nULDkc=
X-Gm-Gg: AZFdTZfeUpH/bP43jSAPJc7bN0O28kbY913I7hnbHYI6J4VVkrhv2nTmJfX5lgrf8aJ
	SeFL84uj2VARRzBNLIbQg6umSphi/4lz1ZhmmiAwBmU/2ENQNVe3xmjqSVR653v3eKjVbQWYNM9
	SWuP2iNNe0YaabCucDp178qT/K6DFD8953Ffls9qI7VtAc+3tK2scGAUN9q6FrtFfqnBuVy0IQN
	3TJk/50kgpUWDdbHU9SHsWpKAlAk3fO7r+ZP1l2roFdt8/mo8VobI6a76qQ4NlevImhyrZfpddB
	4qxYELV4U4TEY9wsTooc/BtPw5SnsMGS/YArPZM0uVktjjsFif2F6BhjrXcMvZmaRP3Szp9JV8z
	JQ9M0Yh28yY8rred6XSrG22FX4gVhXFtc6CBKK8KYgt7DmjmbWK+/XdpBm/Tc3OmhZiqNHrVu0n
	F4cgY=
X-Received: by 2002:a05:6000:1889:b0:4a8:714:7ad4 with SMTP id ffacd0b85a97d-4a807147c78mr1864899f8f.32.1795007733069;
        Wed, 18 Nov 2026 05:15:33 -0800 (PST)
X-Received: by 2002:a05:6000:1889:b0:4a8:714:7ad4 with SMTP id ffacd0b85a97d-4a807147c78mr1864799f8f.32.1795007732558;
        Wed, 18 Nov 2026 05:15:32 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a64b60940csm4651876f8f.0.2026.11.18.05.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 05:15:31 -0800 (PST)
Date: Wed, 18 Nov 2026 14:15:28 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
	linux-kernel@vger.kernel.org, tglx@kernel.org, will@kernel.org,
	boqun@kernel.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	kprateek.nayak@amd.com, luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org, longman@redhat.com,
	ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, shuah@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, parri.andrea@gmail.com,
	m.szyprowski@samsung.com, kayracizmeci@gmail.com,
	weihengqiuu@gmail.com, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH v7 08/40] sched/deadline: Do not replenish a boost from
 cleared parameters
Message-ID: <av2k8JlLvUcBBOhn@jlelli-thinkpadt14gen4.remote.csb>
References: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
 <cefacab5f1c0e7617f17e050af4ef5f6db01700a.1794922146.git.mathieu.desnoyers@efficios.com>
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
In-Reply-To: <cefacab5f1c0e7617f17e050af4ef5f6db01700a.1794922146.git.mathieu.desnoyers@efficios.com>

Hello,

On 17/11/26 09:10, Mathieu Desnoyers wrote:
> When a SCHED_DEADLINE waiter boosts the owner of an rt_mutex, the owner
> runs on the waiter's parameters, through dl.pi_se. Commit 2d3d891d3344
> ("sched/deadline: Add SCHED_DEADLINE inheritance logic") calls this a
> temporary solution. The owner is never throttled. When its runtime runs
> out, replenish_dl_entity() refills it at once from the waiter's
> dl_runtime.
> 
> The waiter can leave SCHED_DEADLINE before the chain walk deboosts the
> owner. Its parameters can be cleared in between, at its 0-lag time.
> replenish_dl_entity() then loops forever on a dl_runtime of 0. It
> holds the rq lock with interrupts off, so the owner's CPU locks up.
> 
> O is a SCHED_OTHER task that holds the rt_mutex L. W is a SCHED_DEADLINE
> task. T is any other task:
> 
>   CPU 0 (O)                         CPU 1 (W)                     CPU 2 (T)
> 
>   locks L
>                                     blocks on L
>                                       rt_mutex_setprio(O, W)
>                                         O->dl.pi_se = &W->dl
>                                     sleeps
>                                       task_non_contending()
>                                         arms W's inactive timer
>                                                                   sched_setscheduler(W)
>                                                                     W leaves SCHED_DEADLINE
>                                                                     task_rq_unlock(W)
>                                     <W's inactive timer>
>                                     inactive_task_timer()
>                                       __dl_clear_params()
>                                         W->dl.dl_runtime = 0
>   <tick>
>   update_curr_dl_se()
>     enqueue_task_dl()
>       replenish_dl_entity()
>         runtime += W->dl.dl_runtime
>         loops forever
>                                                                     rt_mutex_adjust_pi(W)
>                                                                       rt_mutex_setprio(O, W)
>                                                                         spins on O's rq lock
> 
> Fix this by reading the inherited runtime, deadline and period once, and
> by not refilling from cleared ones. They are cleared under the waiter's
> rq lock, not the owner's. So test all three. The owner stays runnable.
> It gets no runtime. A negative runtime is reset to 0: the owner's own
> reservation does not pay for the boost. An owner with no parameters of
> its own gets a deadline of now. A deadline of 0 would mark its dl_rq as
> empty. The wakeup of a boosted task already gives that deadline when its
> donor is cleared. The owner runs until the chain walk deboosts it, or
> until it releases the lock. That also covers sysrq-n:
> normalize_rt_tasks() changes the waiter without a chain walk. The
> warning stays for an entity that is not boosted.

The above paragraph is a bit hard to decipher. :)

Maybe something like the below?

---
Fix this by not refilling from cleared parameters. The donor's
parameters are cleared under the donor's rq lock, not the owner's, so
replenish_dl_entity() can see them change under it. Read dl_runtime,
dl_deadline and dl_period once, and bail out if any of them is 0.

On bailing out, the owner gets no new runtime, but stays runnable and
unthrottled. It runs until the chain walk deboosts it, or until it
releases the lock. Keeping it runnable also covers sysrq-n:
normalize_rt_tasks() changes the waiter without a chain walk, so a
throttled owner might never get to release the lock.

The bandwidth the owner consumed while boosted belongs to the donor, so
a negative runtime is reset to 0 rather than charged to the owner's own
reservation. An owner with no parameters of its own gets a deadline of
now. Its deadline must not stay 0: the dl_rq uses an earliest deadline
of 0 to mean that no deadline entity is queued (see inc_dl_deadline()).

Until the deboost (which should happen "soon enough"), such an owner
sorts first on its CPU's dl_rq and runs ahead of the other deadline
tasks there.

The warning is kept for an entity that is not boosted.
---

> The reset bounds the overrun. But a runtime of 0 still counts as
> exceeded. So until the deboost, update_curr_dl_se() still requeues the
> owner at each update. An owner with SCHED_FLAG_DL_OVERRUN still gets
> SIGXCPU.
> 
> With a 300ms debug delay before rt_mutex_adjust_pi(), v7.4-rc2 locks
> up in 8-CPU VMs. A kernel with this patch does not.
> 
> The Sashiko AI review of the third posting found the lockup. Juri Lelli
> suggested this fix in place of a larger one.

Also for other changelogs, I am not sure this kind of info adds much, as
I fear it will be hard to track down in history anyway.

> Fixes: a5e7be3b28a2 ("sched/deadline: Clear dl_entity params when setscheduling to different class")
> Suggested-by: Juri Lelli <juri.lelli@redhat.com>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/all/avL8oOtjKqVNR7-l@jlelli-thinkpadt14gen4.remote.csb/
> ---

For the implementation,

Reviewed-by: Juri Lelli <juri.lelli@redhat.com>

Thanks,
Juri

