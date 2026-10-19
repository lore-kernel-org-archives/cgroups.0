Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792434419;
	b=jax0qIKBmJ+GFP+jMkje3MiQ8S2jIbnoSZR5nZlkxAtAacIvZgTL45qaK4MzW/PsL+ld
	 9BUgVwnffeUQ/xokxSWQG1UzThkBBJsFWdi+VL2idVqUFtan1kmvXQzNdDZbvuEZQt3in
	 3nM/E3070rBKLpt9vgtIlYqvPPQRSjahrs/1+k41/+Vecnc9zS3kysZnT9pWXp2Xias1r
	 Lfu4HMUik5jsRC7ehqhR7zmN10VaKq0pD7/OX5S4jQjQe8SpwDsPjnLgYqo5/0CflBoRE
	 gyiE1LCCrKEnPDYhA4Q8Jnp95DCpVmwHmJBkRJxelwS2w1tGTI2bpgTnlFHU+Wi+WWA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792434419;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=t2oeQnIv4huhcfpcdL6g/3ERvtsaXDF+ZLHo7Puiboc=;
	b=mBqsvNzP5kKk1W6dxe+m5WY9sCmcRpthNynreW1W1R1j2UoRu7eKdg+NOZ4KK62A1siz
	 1QEpf88OGlsRTnyUrKsMepIA5Nshpf/63Wt+3mY+tyevklycpGoBGRis/EprI4+JQG1ds
	 SlbUbKw3e6C7EljYR3entXjYvIfbmeRyR6AvjWNw/j6HD1YrzIN2PyeHKxjqfXtI0NYNX
	 wSBUIIkq6txBGdy7rjRTP25nFsNFEPuG0qNBenruOtGASI9V+EcELr/sCAuDCmnVp9FQt
	 sgoywaDl40wntqekc9EiOYZrrF2727bPVyVFIzlxZ7TSZ3kuogIak3IFMEt++Au05eg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linaro.org;
	spf=pass smtp.mailfrom=linaro.org;
	dkim=pass header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b="id9dgP/a";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B2F60A383B
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 18:26:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4B2F60A383B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=id9dgP/a
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c3fd91337baso321234066b.3
        for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 11:26:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792434417; cv=none;
        d=google.com; s=arc-20260327;
        b=cvBLqZU1WIDA03bB+Z6Ao8MX92xDCpCr1/UGzvTT0hogs1/u22bnLDJO0LYjAlgtTP
         7dKPATDWOHbkVnzZ65e9DM5ck56DJ7qP/9vuRFHGc4bKt8qvEUD+bsNbXu1gRlIsmyHX
         E6breQMhRDnNJtbhOU1Gpt0Jr7GSM81XHzgceRcuS6j5Jgn9HGAumr0xAjvK6qGQlY1z
         bToibI3LFgYy8JMXudjvolpDOZyNxzYFadHilCZxrORHJeIBTdrX1PojGQ0VRncyp1r0
         9MKJ0UTiZdtotnelpQysx5T6VUWGSISjuUIHIn0l26uGCRRpYAR4J09xKpCArJTR6LpL
         Fiew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t2oeQnIv4huhcfpcdL6g/3ERvtsaXDF+ZLHo7Puiboc=;
        fh=71m+i57MzDdPjT8rekT1yroI/IdD1LrSYd1u5+HemOY=;
        b=Mjsxp5lyQ2XJYRU/tEL6Lhqb/uIrUHUERGxjw83vSZIAcal7mn1ZUR66cU3wHyqYqh
         ntJA+1+rkdRenNnUPehNMaGFZntXHxixe764VjJ3ukbFKX1EljMdc5dnqU5wJXekx3Ye
         ZZUT/LEdH/ZHBd3GskJFgvzBJizB5PkyXJxwNFrtCksTd9gHNbxkIxsjxtRsUtRubOgM
         q04i2WTBPJKP+N2OaTdsTci1FQgyxGC4+Z+lmAt7qcrfEtukEffgn720fxafH+hZTvUc
         h5inZzsmyqDwfv1epiO3d1QRfHg/kIKbK3OBcG+h2/K4oMoCEO2m++kmyCdcWRD89999
         Us6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1792434417; x=1793039217; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t2oeQnIv4huhcfpcdL6g/3ERvtsaXDF+ZLHo7Puiboc=;
        b=id9dgP/aGON5jHxySeoY8/7bhA7Bw0yAeW0ixcKyXHGGTbR8Q1ZcEAPn9rhloJ7eRq
         WzvidabKvzF+/Emp7EdUvl2T5ftFcEb8Y/yAIGxfM2lcU8+QbtB4szJZa0kD5HpFibEb
         WmA//RxmKYrsugjs+S11KDxcnHl0ZUiEPmnC6ZjAzm+cjcAt7//0K97wJNLa51NH4Tzy
         tczMhyKoKlDlTzIGCBMX6q6k2+MUow4nx5K8iGW3yH4REYJwWSWGocNO/qe25zEy8bOL
         LPAGbaDxJZIMzKsPTpPUCK1u5he48Z50DIEKdzeh/xX0J7wceyllz3Q1Pw/2lfEs49Ph
         EZVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792434417; x=1793039217;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t2oeQnIv4huhcfpcdL6g/3ERvtsaXDF+ZLHo7Puiboc=;
        b=gN1p6zDghvBsZEPZs3w5FxQOFkm0MBrIUrKtBBk34OPsbcKYNTdvP6p9NS6nLDQTAH
         cVFSAVSl8+b3BYID1aY0mOk6f943+x25oThnUtgWoRgWjH5nDjK95+nXPdf0tibp1jo4
         6vl1FAygy7iY0PjYkKOWc/5tbhauQCGtDWfl39Fjtvpgz+wsoHikwJJjudapCJFzTciw
         UbjhCXoQcnQLCZUBUSItnVl8Ik3ozG8TjHTW1nRaEzEwtKLNQtstpGu9t06xzJdP6faL
         HZwu0VA+ZheaRR3WS5ht80oAvPTP8Lok/6s+vd/WmE1EjBGetZKMXAmoZtGAHMuwWmUi
         EFvw==
X-Forwarded-Encrypted: i=1; AKwUvBwRNcwHh4S0yieoVvZ9OEsQNfCwV3iB1GnJ+XN4lGcEKHBi5FNcMFKitt7I7yBwopiqoyWwsWLC@vger.kernel.org
X-Gm-Message-State: AFq9FYLGU7lefoK4bCttyNBuesjUACiBWAsB3tstzeLAX9IPZIEY3Un7
	JxtdV6mFuDNuVYMDzC50QQpaGylEPOvyk3z9hCjnj407vo74P83ErmldyiRUg/3N4xx3Cf2I72a
	Hkg4HxKlhxxDBZy4oMEzKUnqFp+asuPOooQtAY1eiVQ==
X-Gm-Gg: AYBFou2oV7gbRQGmGwliV5TA5PhCwu53qTlkXF1WxoEHrZGs9vVewmpc6NjDOw+SD50
	kcEpbCheF5++9VtJZ7lOj/nUPYDNRnEG82Y7F4Zz7W0TdJTE7jneVQ9OJgI+s1QyCovkpu4fQSl
	KQPTc2CjoK4sw2Vpbb83z/44QovRXorAWwL+d+pi3gPli+K1LblaWhZkwpDTUijbDpigT/DDjB0
	0Qu1SMLpukC/ApFwrMFrMTBU7fZhelgyeomJie8jDeBByw85HPlI2nKLw5/rjubSYX1YhQACPZU
	SjndjS7XJ3vqVfYdpftPGzloUNQaFTQJ8X11zDzeKop0h7Mnjbi08sU6P6kf0XYp9+hdsqooEUb
	9if3xAcv+Apg=
X-Received: by 2002:a17:907:9445:b0:c2e:3a72:ffbd with SMTP id
 a640c23a62f3a-c419f906e41mr596826466b.41.1792434416971; Mon, 19 Oct 2026
 11:26:56 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260605105513.354837583@infradead.org> <20260605124052.227463677@infradead.org>
 <58dc8e8a-7260-43ce-aebb-8d9c29a6afc9@okonski.org> <b1002150c3e4f877d04790cd8e85d2149d17722f.camel@gmx.de>
 <atZM6uF0CqCNh__I@vingu-cube> <f1d0fc39-6939-4fb3-a422-273cd5c347c4@okonski.org>
 <CAKfTPtB_gMM7axqM167_Tb=WiChskGPXFDgQ4YjVz4Bj+ZiJ0g@mail.gmail.com> <01e25832-955c-4f39-a902-6cc253a2791c@okonski.org>
In-Reply-To: <01e25832-955c-4f39-a902-6cc253a2791c@okonski.org>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 19 Oct 2026 20:26:45 +0200
X-Gm-Features: AclHuK90r4FeeoWvPhrCCn1htGhyOf35EnRL7HTpsvX3KQMMhx770D46QVqgV_c
Message-ID: <CAKfTPtCVknqCO45p7oR3s=1fNEmDW-jv7-wtQh7vwkuJ=UmVcQ@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] sched/eevdf: Move to a single runqueue
To: =?UTF-8?Q?Jakub_Oko=C5=84ski?= <jakub@okonski.org>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org, 
	longman@redhat.com, chenridong@huaweicloud.com, juri.lelli@redhat.com, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jstultz@google.com, kprateek.nayak@amd.com, qyousef@layalina.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Oct 2026 at 20:24, Jakub Oko=C5=84ski <jakub@okonski.org> wrote:
>
> On 10/19/26 20:04, Vincent Guittot wrote:
> > On Mon, 19 Oct 2026 at 19:36, Jakub Oko=C5=84ski <jakub@okonski.org> wr=
ote:
> >>
> >> top of 7.3.0, it still regresses from 7.2.9 if you test with a nice 19
> >> spinner in the same cgroup. I think it's incomplete.
> >
> > This patch only aims to fix the sched_idle task group case. I will
> > have a closer look at the nice 19 case. Have you checked the different
> > cgroup_mode with nice 19 ?
> >
> > Vincent
>
> Same result in my nice 19 test for all of up/smp/concur/max/tasks.

Okay
Thanks for the tests results
