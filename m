Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016028;
	b=w0jIefvBy8Mt9tUzyMpuY7UU8xtjBS0iRPGfw363+/2T9ufCEf4SSQtd9PRQMlEHA+Q2
	 ROtDQKzLEPW5ru0/sk9A+Uba8cgcQbilV0TyCzrhgDKgcsEN+yxpT2TN+8ngWtVKe8TTE
	 PAvRSuqRFDW+Xf3bm8T5qO7aVBgv0FfIamr2TgrI+ILJBbS/Pqw4X0IaA9tlgCJhR4Iqw
	 doSSJqp71HCEVW9TNCgW7vEdZpozO+SXhlcDRy9CHhWFCvbmLebgtdR8FHBMP5EbCHU+X
	 ELLVrmacY87zwvoUHnTqabdWIoqOsm5rmWBWa7g/52lnm4VG4x9bdiD149IM1MkQxqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016028;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=x85cpobaf638Fe9w3ZW1Zro4FQs+4uIPwl9i5atMIvg=;
	b=fz9VUxLq3i6j7YIWFBQo95PFqMK4Iv45CxGIG3ySoAKQWLAsD8Gy8+ESiv9Q5lqitxMo
	 4HeuyjrYvKeotN+Zhxwbaktyh8fAmyMyC6K3jgzaWhLbzUQy2zbeUogI8Fg1pd9Dd6Cbr
	 i/AGniUDfRwRFjSP/I79AdWBrRcg1clMrqPkklPeQce+11XhJXAdFELmHoSZCUNwOsFcs
	 QnkLJQsCtto4MV/PKER1Z1ol5FrptuO+h/c/Daok98b3vfHAv1yKWFbOlU9dAecs+h3ha
	 Q5sVfiVx+rbmq2pnV/w+nHkRNCwMk7GUXe/v9WRNpdqCFcFHVP2hIdYet6Qtmllh+9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SMHVdGhq;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=hjapHfa9;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A302606A32A
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 15:33:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A302606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SMHVdGhq;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=hjapHfa9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795016026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x85cpobaf638Fe9w3ZW1Zro4FQs+4uIPwl9i5atMIvg=;
	b=SMHVdGhqsrOTmOb/h7yyl7JinrKAkC/2HQEylbpLDrEdToSemJkq0rZnXh/1bc3keuw82u
	Tm4M+YIsPV5AYYtZqxRkIqD6Vt1WP8b0VAfz38mPiC9liNh0AeenirvzdaxvuK9XwOunVR
	JGUCx1kCMnj9XixnhrH1Mh5pUo5GOAY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-M_jK2d6MMwaSEUy8kkx94Q-1; Wed, 18 Nov 2026 10:33:45 -0500
X-MC-Unique: M_jK2d6MMwaSEUy8kkx94Q-1
X-Mimecast-MFC-AGG-ID: M_jK2d6MMwaSEUy8kkx94Q_1795016024
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49febef74e3so14438895e9.0
        for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 07:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795016024; x=1795620824; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x85cpobaf638Fe9w3ZW1Zro4FQs+4uIPwl9i5atMIvg=;
        b=hjapHfa9Gh3Zmy9e0Dd9POv2CixHjjA6fXGunjIJ1xJ1iLutSfN3J26cEelLg5++1s
         aybMZHXUIPLNRvWSWyhJiy/LqnvrE8LIUVyHrM6gJKVkEAuHl6KHOhdUW//uGfE7oO+b
         N8th80yZMR1lm3M0MtWxQ+/wjcTW/6SGrGFkJ8Euu1CzQf4xmmIUYhczo40kdeufkohy
         1iv+6emM7lalwYFFhqy9d9C1VXmgGIEel5Ie3rXEUGDEkhTFUHnhc8ozAp3cRDc3ojYU
         jzsuQ0poAUXPz0V3Jkgsr31wy0pnbjcKgCmJluwtndAp5fcJlFgxAgdcdvlv9dsjIqR7
         Bi3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795016024; x=1795620824;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x85cpobaf638Fe9w3ZW1Zro4FQs+4uIPwl9i5atMIvg=;
        b=aSBpIyvIW8FcuenervWLEoCYP23LBDLO+lXggVstrOLeT+2tFmNP4MnGBEPUDJuI8r
         NXFAYzGh4DMS9xEPUx/2uQbqMHy0nvgYpjmPagCvw07t6H3+rtF5ECatiW2ttlHDlw74
         8sC1tVhzySkletufXrsDYr+CKWxt6MNRZRDHw4SbBTOUI/t7j5g+5T4LybhZDNsV6jHt
         jU0Jfn0n66ZYOKocYUjNSuOwNHDtpaglWLZO/j7OSgIFEHPtZ96SNtxi7FFbLIdQMrg8
         Kt3Hj92s9g+J/gfHeIuD3Z9MytTOpZ8U9WvDbkYmXoIc7VjpVW8QDMOE1SPN/uP3Uqc1
         cZKA==
X-Forwarded-Encrypted: i=1; AL+hErG7BKBSrNmheSHOPBx7aB2811LM4s74Ny1HXLE5DPGgAlJ/OjU9NcqQoIeW/+h27iC/cTrStyb7@vger.kernel.org
X-Gm-Message-State: APuU4Z/RZ+qBva99X2Q9sbhbVlcTYueO0tLag3LvCl21KoirA2hRC6+O
	8nw+ouC6V2bZk75xRCzHXt++GTK8i2mU8ByTDcbaL2/uoVI11eabqCXHkSdPeeOz53oyxhpCjFR
	OgSXveFbf+1/8nJickoD22CbCqKZLJo6ycxFVcWtaLQILWP68llhDELmq75I=
X-Gm-Gg: AYBFou1ynz08xoJLg5OuT7lzWGgbMVw7U3zwzQ+nwckrsYgTnEj/iqUbL6SMePb4Ji6
	fTiHPk5Gis+ld2SQkWcLhLcTBaYsGwwggus5IeEU8RnLp8KsBR3Nb0Q4kbWnRv++RiyQBoBq/K9
	re8MqEbFIDyZd2rEk2J0/MHJ9iVvadD1Khx79bjz/zz2mSy0kRDi08/PBISmwX2ePyPukzEZ//6
	kH6t6uA0ld4MBtjko/mnUDRFbGjFpQdPUPqAhzkEd42Mlj+XMLXH94PcA2J1UWtWy36CMc/tfSP
	VF9qKzZFqK9UDdgEGgINik1jBChtKK+oJ4xHww13tWIcJu+bcSEGMFy2YJy1Ci/SKd035m/4NgJ
	4QyP2BmkZrpJhE8Nqir4N2y+wmsU1w7ATC5meDFh5jye067tHAdDNiriuG/aUXcnVfvLONmnwaP
	54RkU=
X-Received: by 2002:a05:600c:37c3:b0:49e:6581:7baf with SMTP id 5b1f17b1804b1-4bb7d6cd4ffmr53089975e9.2.1795016024078;
        Wed, 18 Nov 2026 07:33:44 -0800 (PST)
X-Received: by 2002:a05:600c:37c3:b0:49e:6581:7baf with SMTP id 5b1f17b1804b1-4bb7d6cd4ffmr53089605e9.2.1795016023651;
        Wed, 18 Nov 2026 07:33:43 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7e50e992sm37379485e9.0.2026.11.18.07.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 07:33:43 -0800 (PST)
Date: Wed, 18 Nov 2026 16:33:40 +0100
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
Subject: Re: [PATCH v7 13/40] sched/deadline: Release the bandwidth of a task
 that leaves the class asleep
Message-ID: <av3FVDh4PX-5gWSW@jlelli-thinkpadt14gen4.remote.csb>
References: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
 <a809425266acca7cfadd2e8187a7b5a815ba32cb.1794922146.git.mathieu.desnoyers@efficios.com>
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
In-Reply-To: <a809425266acca7cfadd2e8187a7b5a815ba32cb.1794922146.git.mathieu.desnoyers@efficios.com>

Hello,

On 17/11/26 09:10, Mathieu Desnoyers wrote:
> A task that leaves SCHED_DEADLINE while it is not queued can keep its
> bandwidth in total_bw until the next rebuild of the root domains.
> Repeated, this fills total_bw up to the admission limit. Then
> sched_setattr(SCHED_DEADLINE) and CPU offlining fail with EBUSY.
> 
> A task that leaves the class keeps its bandwidth until its 0-lag time.
> Releasing it earlier would allow temporary overloads. For a queued task,
> switched_from_dl() calls task_non_contending(). It releases the
> bandwidth if the 0-lag time is past. Otherwise it arms the inactive
> timer, which releases it then. For a task that is not queued,
> switched_from_dl() relies on the timer armed when the task blocked.
> 
> But the timer is not always pending when the task leaves the class:
> - The task blocked after its 0-lag time. The timer was not armed.
> - The timer fired while the task was still in the class. It only
>   removed running_bw.
> - The task was woken up on another CPU and is not enqueued there yet.
>   The wakeup cancelled the timer.
> - The task came back to the class asleep. switched_to_dl() cancelled
>   the timer.
> 
> Then nothing releases total_bw.
> 
> Fix this in switched_from_dl(). For a task that is not queued and has
> no timer pending, call task_non_contending(), as for a queued task. It
> arms the timer if the 0-lag time is ahead. Otherwise it releases the
> bandwidth now and clears the parameters, as inactive_task_timer() does.
> 
> Clearing the parameters keeps later paths from releasing the bandwidth
> again:
> - A timer handler that already started finds a dl_bw of 0.
> - The deboost of a later priority inheritance boost finds no
>   parameters.
> 
> An owner that the task boosts as a waiter can find the parameters
> cleared too. "sched/deadline: Do not replenish a boost from cleared
> parameters" handles this, so a backport needs it first. Without it, the
> owner's CPU can lock up as soon as the waiter leaves the class.
> 
> Juri Lelli's first fix, since dropped from tip, released the bandwidth
> here without clearing dl_bw. The bandwidth of a boosted task was then
> released twice.
> 
> Juri Lelli suggested the call to task_non_contending() in review.
> 
> The Sashiko AI review of the third posting found the two cases with the
> 0-lag time ahead. deadline_bw_test, added later in this series, tests
> this in pi_former_owner_asleep and deboost_released_resets_period.
> 
> Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
> Reported-by: Tejun Heo <tj@kernel.org>
> Closes: https://lore.kernel.org/all/2b5fb3f22bca6aa383be8f4781923392@kernel.org/
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/all/20261103-b4-sched-dl-bw-fixes-v1-2-dd761fe005b4@redhat.com/
> ---

Reviewed-by: Juri Lelli <juri.lelli@redhat.com>

Thanks,
Juri

