Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794479773;
	b=fRKWqsiaPzEA0LVVln/nrM1gD/eIwimnHyfi0YmQmtSZsrSPlsA4y5HIk28wXluu5PDC
	 Hp6Sw19WDdp6RZjbprLWQ2lcz5YlaodpuYGQjnyD7u2Y986qCKM5FZnTdLAIGyAlKvtDj
	 KBeqcfTY+Y9vn8YJ2MWG1f7wGpb3syOaA8WwYtA99BIAyo8uBR0HsqT36xfdRBm9WL6fs
	 1v8MyRi9y9HAF2BCkLGM9/5SHgp15AwLdUn0+1iBeWClXbIUX8WSX1RZrGHOJuqblmsW4
	 MqejPbA1e5HOeXuTmldIrQxZtsDzrDWaVFgp7ZJEkkaM+Ldp1pwqDiuqblRLWZXejwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794479773;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Ogwz7ul59oD/hj3UG/Yij9D+/c4RWMPymBINXQ6+9Bk=;
	b=SMnBLlCtcWALD+eYcxbOVZhVY+CsuMz+ZXoAzKCvAeWm8Y4lpj9eBrvhBqgq1u7FjeD+
	 /9I36V1zUjRT3oQay+lWX6kH5aM5aJl1uVSjVK9GnZUjGzLd9BJfGwgS3fvjx9K1Aafxp
	 D0CNSV2DTFfgrenwbIcmxN6zYzpyyPiRmBLFP08yl1xBzcNfugfECBNzdSftMK4AHAiZT
	 iqm4bNlFpl4+NYK9njExfFcZ4cOx1gVjYz2zSKZWI9vZpZ6tWzYAa0ucwGUBrPHalp/Hp
	 j4AdX9zacwfmSPMBCu88bjfFp8rglPUvWX+ASRFiJAYhiWpWcPNJST36LWFCgb6Fw7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=U6OaBErl;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=lPkq+kCJ;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8540A606A886
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 10:36:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8540A606A886
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=U6OaBErl;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=lPkq+kCJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794479771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ogwz7ul59oD/hj3UG/Yij9D+/c4RWMPymBINXQ6+9Bk=;
	b=U6OaBErlYMSHobbPrJAoJTPY3fslh246DBRqobmFAs8roRgp/0Fx6LTp0i9vQ+u0hwCsFa
	gPJzRGAI+QvuLXpM4wBPJILFXz9dI41hN1RCwuzCNf6fkRdxvlkoDzuTDI0jYVR377TB6j
	WYdrqMuFfCWqHWmOSmTqeZHgqz07OEM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-ABY4Qf_aMU6rf2jYgjejHA-1; Thu, 12 Nov 2026 05:36:10 -0500
X-MC-Unique: ABY4Qf_aMU6rf2jYgjejHA-1
X-Mimecast-MFC-AGG-ID: ABY4Qf_aMU6rf2jYgjejHA_1794479769
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48df02b91f9so378682f8f.1
        for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 02:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794479769; x=1795084569; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ogwz7ul59oD/hj3UG/Yij9D+/c4RWMPymBINXQ6+9Bk=;
        b=lPkq+kCJM2Ukg4Zws6fskES5U7k09H78lXinl0DlX74ddFDmHzPoI2tle74/yBu5QT
         KmdGpfCaUUduZ611q1IBDRvn0whTReefWjNQ+JejQMGX5ys0WOCZEtaImQLznHxcc88n
         c9keFcTrhU6XgoCsOZaXXSXu1STQ7smK8H3Tb3SDJMjH86TB8W4EKLpqEpAlECxslsGb
         nPCDrkBZjKceLlOg3gSjJe/VsievNDtwa8UhUKjklSuRpcTFhvoVCmvka8/7GmPNqQ9B
         HFGO2yw2BTSnRmACKW9KQLE6ibOMdmhZqf0zZETh2o9YABo16mPyySOsTXPDOTW5G5zb
         vLnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794479769; x=1795084569;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ogwz7ul59oD/hj3UG/Yij9D+/c4RWMPymBINXQ6+9Bk=;
        b=W/z0LwS8w4UqzPjxGYfa2IVZrZHlYXWMGe7KJiU7p7YdbAuMgcd656L1dWtSw6w/r0
         +xdwNq4OLoKEIyYcdBYx6eE+IcdwdzPjr/MWOBTPlchRA2IlHz711bzV8uD0+lSLSSiv
         WpkLxZNnZ+TTioKAupMqVtta5/Pyfztl6UKTE5kibi/angmC2OrC//1yVlLXfqz6i0xT
         0q3Kfyq236aFyBf3UBLoj7aZkQv4YZ7KZLO7jvajzW17aB2wQm6++H0rQ800wUFGO6X3
         JwWe9weDvzNWyMX7+sEfNXapDSnfBhXa7I4pcz82ymz327fZSN981OIYSr+KT0y8wzrX
         j57Q==
X-Forwarded-Encrypted: i=1; AL+hErFUDPdMDnOvVrhnAq83AVAt6PNI2FIxdIE/kRA5NLYsADWNZL1RgK7nlh2RGM3ZorHqarhLn3e3@vger.kernel.org
X-Gm-Message-State: APuU4Z+cnc0XKQ9h0Sp23dJQEmJ8cHI7993Gl7pENmn9OHIICPm067TX
	q3qt0oEdomLDyxBwOpqebNQ0C2oyHHYMvToMQ3HVOLTMgsId+ZHoF/LnZH/lF2MACQ3F6bnSjjW
	IJijgnpvd3t+XYgiNIuJpkoYb20HamZEikAwmGiMeuZ+rrLHHlKB+LW79hK8=
X-Gm-Gg: AYBFou2zy9tfMqQjGSGnUT/eR1FDbrMri6M1C6TjmgLPAKFq9UkCb1L3ASHx+c6zObM
	zfe+X7apqsdRG/lmjvJEv1kiJHGmdHgNQO4QYFysl62HvbuUQihX4rpqFEN02XZO5XvknVwLNv7
	QDeXDW1MnyuzRDRgBrSTPXLuLZQffcFZok7dzCTfIFn/I2+Eh8Ni2z0QRcAkRGjaAhSmI9kxIL4
	cruiyUNB2Ba9UfQopPMhFAd5c3DHthvNEPttZvA14AGwToInZz0DiPm4Stwc+72EKtfRTl46fpv
	u0hq8pIRtyGHQrLRxrqonJH83akBdPY7m4r95O6sjwYGiCN0LgmvVeIr9kD+UyKz3IEoN646zzK
	jXRe7MZFy72jGJLquxypUmpqvYkZr5X33WW0di+s79Hc2pLmrq7Jen2rJ6vSzfLG/HVYX2mkqci
	FFIVU=
X-Received: by 2002:a05:600c:8b57:b0:4ba:4395:560f with SMTP id 5b1f17b1804b1-4bb4e283efamr44875045e9.8.1794479768795;
        Thu, 12 Nov 2026 02:36:08 -0800 (PST)
X-Received: by 2002:a05:600c:8b57:b0:4ba:4395:560f with SMTP id 5b1f17b1804b1-4bb4e283efamr44874665e9.8.1794479768472;
        Thu, 12 Nov 2026 02:36:08 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e27a8b0sm60917155e9.15.2026.11.12.02.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 02:36:06 -0800 (PST)
Date: Thu, 12 Nov 2026 11:36:04 +0100
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
	linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v5 26/29] sched/debug: Show the deadline bandwidth of
 each runqueue
Message-ID: <avWWlEGGqVPYkuZw@jlelli-thinkpadt14gen4.remote.csb>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-27-mathieu.desnoyers@efficios.com>
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
In-Reply-To: <20261108185406.1549770-27-mathieu.desnoyers@efficios.com>

Hello,

On 08/11/26 13:54, Mathieu Desnoyers wrote:
> For each CPU, sched_debug prints the deadline bandwidth of its root
> domain. It does not print the two sums of its runqueue. this_bw is the
> bandwidth of the deadline tasks assigned to the CPU. running_bw is the
> part of it that belongs to active tasks.
> 
> GRUB reclaiming depends on both sums. grub_reclaim() takes this_bw -
> running_bw as the inactive bandwidth of the CPU. The more inactive
> bandwidth, the slower a reclaiming task uses up its runtime.
> 
> The kernel warns when a sum wraps around, and when running_bw exceeds
> this_bw. Bandwidth left behind in this_bw triggers no warning.
> 
> Print both sums. The deadline_bw_test selftest added later in this
> series reads this_bw in its params_waking and random_mix cases. It
> checks that this_bw is back to its first value once their tasks are
> gone.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
>  kernel/sched/debug.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index e0d6cd3bd607..3dbe1d7d2d77 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -1174,6 +1174,8 @@ void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq)
>  	SEQ_printf(m, "  .%-30s: %lu\n", #x, (unsigned long)(dl_rq->x))
>  
>  	PU(dl_nr_running);
> +	PU(running_bw);
> +	PU(this_bw);

OK, but we will still not printing additional useful information like
extra_bw, etc. Not sure if you are aware of tools/sched/dl_bw_dump.py
drgn script; maybe that is already useful for the needed additional
debugging information?

Thanks,
Juri

