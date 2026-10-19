Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792434301;
	b=eRohkYXNSy1uwBjIMYarku4GUCdM209j/oqdlxAM82lmGl1b6xaxSnAdf/cBCjTYpkeP
	 gbVG8TYUnssiz3jRQfzLzW6vlIAlReS6aL4BiGd82qzsVGlwjLLd41DRocF+rWMHuw2Op
	 8uHPsClr1VSaE0JOoeGEklEGpPg9kHz1P3t+JFDcV/3vHBucstdb9LsvQLcQ25rGOhRK8
	 7QbkVAvRcyguGr/tAsJjS6I3uAKPnkjexSvYLsN3AcwKnjCEjnnRckFNiu3bld+60QQqc
	 7bamHHohrjypSNGXghA57DHTEJHBS39Epo1C+4awsjQQDGaLT9WHuR9QdXjrag0TU6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792434301;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=jtPccQqJ2uVD863ndD5Pql7lUKykf7N9xt+2EMl4boQ=;
	b=PiWsfpqVgQwSikFfapZAaWGtZtGlTSY26Gk0nCl8wu8nLvPJ6SO9H2glahlfvesYmrS2
	 t5wTHm5yhnIHJOFZtGlUb8GsMsWOhYYlAXOEueKpCU3yp6fJRZ5Q+QDUwpYFSDT44tisC
	 0jEqGxA2BkrKwzRyeBGuSJe0Rh+STw0ByUueZmD2RjvTyRJ+2IH6RpYh87n5JznVe7OQ1
	 3vmQ2RI8AkeaJnPu4+sDEHFIjTaGEsHDab65VDQXe9QdChPUlLf6Dw0F3wL/sVEi4wtid
	 qblvCCbs5pMOEOg1DM/7VS4BxgeO5eDZiuAJBQxmZeCPIWpUJ2NAQ1VAnFs36jYIg/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=okonski.org;
	spf=none smtp.mailfrom=okonski.org;
	dkim=pass header.d=okonski-org.20251104.gappssmtp.com header.i=@okonski-org.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=X4UC2tzT;
	arc=none smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282EC606A31E
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 18:25:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 282EC606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=okonski.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=okonski.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=okonski-org.20251104.gappssmtp.com header.i=@okonski-org.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=X4UC2tzT
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c45551fa84eso108077166b.3
        for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 11:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=okonski-org.20251104.gappssmtp.com; s=20251104; t=1792434299; x=1793039099; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jtPccQqJ2uVD863ndD5Pql7lUKykf7N9xt+2EMl4boQ=;
        b=X4UC2tzTUDZMrZcRbRquqMSyNAEOAKxUZtciQ+klss0scatPZpmv25j24B9UxdZEd/
         xE62JUeiUGNFiVcWffAloXMa0JMZr+o8SsYSLbmCAVGPl8DFTqvqeUbompo6CKj2nMEd
         oVgiaPNxN27Sjag2nS8ZbA8JGhC+/GdREmTUpnpubIMCtnx7EiDY0aeTRjl0mc1Gyc0d
         GfpPgSxGEPBQatqNabT0jsPj7Myzvg1n7aECT4hFEmF1PHdrj1jxPY0i/HsngGe1exd3
         8NemxlzCAzGve5Olrt3xFbOQtq9/jyuRFJUcKqGvCRtwq6juCC1lfQ5/Ea78iNT+4cSj
         48/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792434299; x=1793039099;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jtPccQqJ2uVD863ndD5Pql7lUKykf7N9xt+2EMl4boQ=;
        b=LBtqMQztR9sNbpNbVbgvvSlBf0VMtiV7Hn6rxw1z7jHDgm52EUN+DXvm4OdQ+kQvBN
         sMCnNOOu81XbQjwVnDlUWDYbLSbMg1U+1UrJjPJME+nccDtst5pno0yZ7TZ+MRPaFniD
         lExA/s6QhovlnI9huXckD8yuOpPaILQaNuecJM9ykSG3IVieDfRfmOdlffFKyDkWeb8A
         TbtXVUrMkZumjNN8SaNXJyCDhCPjKcXN4judMfACnOF9K2svlRmStRLV5weZjBi+RM2Z
         lLE4hRTuCmC2aevzJSWJTl66WAJHe2jup0mO81W3uXtRVCaepF2PUiQmgjaWjmU9Jp8/
         hk7w==
X-Forwarded-Encrypted: i=1; AKwUvByJzp9v9BrWPf3fB4hYu3U86mvsr/gl42Nqf4/+F52Ib/s7W4Ju3Yo4h7IOowsufUWCL0jVIwwf@vger.kernel.org
X-Gm-Message-State: AFq9FYIfoejODfm5adMzvykXwBtkE3L2vUcmOv4QlWcddMExy6rXioCA
	yR3FJpnP64DLfcbB0Z4Wd1BKtdzVXm5ymh80Qh92mx77tCcT8smipRzkL15sgMYWqnM=
X-Gm-Gg: AYBFou1BD06LPdn+I0EOKd8ueA5Yj8JA0wgA43xdMEoufoVVQFb6mJpgSFTPdVQga0a
	ImDFk3+nuKuzVQN2x+X9gfoisoiPzBCbF1KCfEO/tijXrnXNkqTg312aJRwAbenc7olrX6xt25a
	3ZAd/AaSOMTN1Etu0dwxPJsmFevNoM9FBTSeLiDBKkvKnEd3I1rqMhyM+4dSVGafw2FybArtenG
	sE7FNHkMc+nZrD25R+Xi8CT96CqMPytH5OdO6+cQg+JhjpmeAGBnDjoMp/AI+mMY75lAs1+ByZj
	G/t3fsl00Je+RExXTbQPpRsnoUKm6WZFwPCmMi9AdtgHARXQpz8vpryGOm6KDQqBVR//zCQe+ZK
	9VCbHCztujoj8B59uui/9lU0Wn4HbLoHARgTuAAsJUgLzqWQatBq1S0jXrhIVUt7wpWGXxJbEtQ
	bqTel1J1NMn54WrDd68LKNDd7N1L9K5uMllSBq3inCmHR1Ys6iPnzG81jblxwWnmPvwfwdYyy1k
	Q6+zmSGLYfMCimwodj8Km9A6RxiYaw5voUfY1cOMHvTipX9mGzS2O63+6R2NL5PkQtzlmSoTg8+
	h2JIQJfLaAI+Yv23QLTONxUZQReNYWmEllsDsvAS0Dc=
X-Received: by 2002:a17:907:b046:20b0:c42:102f:15d7 with SMTP id a640c23a62f3a-c42102f36d2mr336567366b.10.1792434299287;
        Mon, 19 Oct 2026 11:24:59 -0700 (PDT)
Received: from ?IPV6:2a02:21a0:10:748:1::2? ([2a02:21a0:10:748:1::2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c40919bc147sm388919966b.50.2026.10.19.11.24.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 11:24:58 -0700 (PDT)
Message-ID: <01e25832-955c-4f39-a902-6cc253a2791c@okonski.org>
Date: Mon, 19 Oct 2026 20:24:57 +0200
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] sched/eevdf: Move to a single runqueue
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
 mingo@kernel.org, longman@redhat.com, chenridong@huaweicloud.com,
 juri.lelli@redhat.com, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, jstultz@google.com, kprateek.nayak@amd.com,
 qyousef@layalina.io
References: <20260605105513.354837583@infradead.org>
 <20260605124052.227463677@infradead.org>
 <58dc8e8a-7260-43ce-aebb-8d9c29a6afc9@okonski.org>
 <b1002150c3e4f877d04790cd8e85d2149d17722f.camel@gmx.de>
 <atZM6uF0CqCNh__I@vingu-cube>
 <f1d0fc39-6939-4fb3-a422-273cd5c347c4@okonski.org>
 <CAKfTPtB_gMM7axqM167_Tb=WiChskGPXFDgQ4YjVz4Bj+ZiJ0g@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Jakub_Oko=C5=84ski?= <jakub@okonski.org>
In-Reply-To: <CAKfTPtB_gMM7axqM167_Tb=WiChskGPXFDgQ4YjVz4Bj+ZiJ0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 10/19/26 20:04, Vincent Guittot wrote:
> On Mon, 19 Oct 2026 at 19:36, Jakub Okoński <jakub@okonski.org> wrote:
>>
>> top of 7.3.0, it still regresses from 7.2.9 if you test with a nice 19
>> spinner in the same cgroup. I think it's incomplete.
> 
> This patch only aims to fix the sched_idle task group case. I will
> have a closer look at the nice 19 case. Have you checked the different
> cgroup_mode with nice 19 ?
> 
> Vincent

Same result in my nice 19 test for all of up/smp/concur/max/tasks.
