Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792583772;
	b=sZl14F0kvlspAtbJyGm1xlatm1ErR331gAa/uYKICZw9VpuyFVPA53ALp90lMIAB8iaA
	 g0DsTUsD2N3VDXW4d/oE7Z7QKGLdeK0t5yRCwwkfIbvB48ar7anog+Sh6Yo8pT2S6Ibq9
	 UqAotfNI3lEM2Z5NR4VgLqvm+9y5dvbUhgD9p4FAcA8h+ZWCoFeRGIb+RtX4CDW/x3R4h
	 x6ZMAh18SfxaBiLrHLpuwHmHl7HQmh158tTM8+a1iZM5x+GhMQcztAOj72oHhodEc+yJY
	 tENkCOdMBenLXiiqtefoaqOdoU27rnrY3TLNQ4kIWjPyNgawUXnoAlt1tnYixaMENgQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792583772;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=8yuyhb5Fki6NqScFBeL2iUHYNCmVlC1WuYS0bvIGiyM=;
	b=PLwRsJplDJ2j3O+iCS8f2Pqk2ehHhnabZfaYDZfTt67DYDwk8BTx1txuO+5WpDxvEqmn
	 WA/CR9Dnh/kZw+ovIFm2ELgMwCMNF6grgI9v5TcEIQMatz/kBzpmJT1rfNw1lxGXFk7bU
	 /4r+giiTkWe2pBksUHmtwoblM0bIlckCMQow+/3rhuSAyyUTMK51QcoJn0xwlqn4GoKm1
	 WAxAAAgVLzaWeKTVSoZOOrIQb8nVJl4YLEGhjAwEXM4H0HZeU/fqXldpros5QtDCrABdH
	 /jlVO8hqq/leqqmLFv3+L96+D/xjNELRkwXe6r4myCfVvifmNMEBhdK77T2l5u7WFrg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linaro.org;
	spf=pass smtp.mailfrom=linaro.org;
	dkim=pass header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=J0CfDTaq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC48606A321
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 11:56:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DBC48606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=J0CfDTaq
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4682977f9aso45280966b.1
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 04:56:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792583770; cv=none;
        d=google.com; s=arc-20260327;
        b=KjypWgXsSjI1w07CcekkGzm4PNKUgpDFCMAYK3utrOcAoCyVCtIMZL6FhVEbx5Ac89
         zyx4I7BsLf+ITKJ+P5rq9JIG8VIdhY5LUWJfOSypcRqvssniIrn16oQTvwEmr9OA9Qmn
         SduxK5wsX4Z8bKZy7IrpWOon0F19ki1Tj58qM3HmO33ifIufwnaarlraYGMQ0otSK2eG
         5vPO/ZslYgP15EASaRahy+OraCnQHMAhMJlqNRYjsRy+1mCcmEZlDlaEJqmrP/Vp0yku
         BVWR6ZmsLEtZVYa1Oh3f0f+hwvLrJTdPvDU8HKzo0Fmod+dwkPYp73NA+w43DE4ZiYUP
         hdtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8yuyhb5Fki6NqScFBeL2iUHYNCmVlC1WuYS0bvIGiyM=;
        fh=qmj3iqbi2ZSTwZ4qVRB8WPcVU9aT1r8GE3yyXUW/TZQ=;
        b=BWySn2cu8QhEZYIFLAhAag3cvJgZDpfrkudEagAMYMwO9uIJm8LKwaJ/l1DeUevv3R
         UqT+GeppO+/BI1h4tDV/t2lBsuHd7/cDHSYj7pxRdSNjEjwJozf+5lroyVpJtqf6xDot
         E2ebDDLX5Bryl7VDkiWCF//fdDhlmUm9WTQ5hslorJiFbGRtVDrTJ5M/0zvLCu3ROOoT
         Dxs8QnlSg5AV9dsBzKezAGE1PNH0rk/nDq3+l9ya+xLBtT9oEaiNV+h1hfE0Mf+S4yt4
         IaWxKNyR4A4DmE/Suw9X0F+OxgZC41/6lSnp2O59NLWLqNdjYiWlUR0PZhnSK190aZMU
         vW5Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1792583770; x=1793188570; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8yuyhb5Fki6NqScFBeL2iUHYNCmVlC1WuYS0bvIGiyM=;
        b=J0CfDTaqQKJEdO+Rnh/euFbjllu/H4o67ceEoe2O0l66CDLDq0OLskkHvySFmpHZIu
         FfrSBfhbawenVxLFxAjDAeMdNVCSfTy2p9VppS/M2f40yF5BI8nC4YoS/KkpkDrSYzBs
         QktE6EYUNGGFSW6Z1lmcQUBt63mF/QnEw6QT6sFDLXLGtP+nmCV1I/Ee2z18PJ73drzX
         gv8X+WPLRo2eSZZN22+9zTT0lFpGQyQTqw1AY6U4Hr348LFUSuzXdeANKEgBC8l2RzRQ
         yk+VOLar1Bm/vGqDU6I5uFUTazBavJMOgFM0NHxhmijEQ9tgoBY1Wdkmrp7HZyj2JxT7
         gB6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792583770; x=1793188570;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8yuyhb5Fki6NqScFBeL2iUHYNCmVlC1WuYS0bvIGiyM=;
        b=hcnm3AlrsfK+L3WqF+arG+gPEWS+75Wgtqez4UFmOTPLCbR3uLd0LVIvrLWZ4Tozxa
         SCm/E2cCdovMMCc6OKM86gXUj20YbeDEqTGoG3+50+ojIu5KadjriTDz6/Fty1nNml7D
         3sVWFE9v3mqP4tMkzd0bqPOgXGFTKxnQmzPUTZ4DAO+R7wa5ZoADic/7/2jGFLcChDT6
         sTcj3uE09A4N/LE9AVIB4u5Xs6q9YtNZdAaVAGWJ5aTxqBBAWoYhIceJ8mN/GEfn3Y5q
         1CPc8sitUP8HSWSeUhQRa3Off93aky4ZbxydBkiTSTlBUb/3otCxdMusyQw8BIlmuW6m
         hlVw==
X-Forwarded-Encrypted: i=1; AKwUvBwGXfK8yZxU9pIS8v6z0PSsdBW3JuatG2jm8XXveJG47UJCqyn97OiBipT+fNYsXzwPsNsVqm8w@vger.kernel.org
X-Gm-Message-State: AFq9FYJtPVpYgdVlkKNDvIWAUntvWma7H07kligd8K1t8zNJMWdh5G4a
	t+Axt3CtVvXRVhHVZQL4i3or8hUDsiDYPmc8vf+u0Tg0nXdQ6BQn5A6kTf6WBoj3mdtp24Ez573
	4MH8uRqwpLM6mSTvT4yZpXlN5TB+89RvqucQCUTUqnA==
X-Gm-Gg: AYBFou2y5ueP7+GvsPnIRFw5MnIcjmajiUXrVTssq64TmEnFaL3lAuafVRx8JXtJwM/
	mRGIFDM8/sz/gfeUPvpjjBtlQpJIhtDBwCHYaCp4khDn4Xgq9ZUabHe9pfyBRQ95Tr2okb1+4gp
	f8rkfsR2S//E9cTfQooPZWLtD3IOC9FlMScwQr7kUL2BSxI7FZzih66HYZFyYKRtCjgNUSlNR86
	VBAuOmiygvl96oKTH/sLnjrAUDFm061b5+QsDrnuFrCHWm24Gyab4HKUQA4BkYYFs1OaTkQ4os+
	tidOfd+Lvzf0yYiC8/tDbC/tL8CpUfc+Te3HnWVAX0jwG7NAKrUfL0bBHFmTTJk7MMCUzAOe8VY
	T+aVVOXSg4YEpi8ZZ1f4L/fjpEiqk8ul0U+JZxgnA7AEAz83nH35+wMeM/mFNivNADZN3Cts=
X-Received: by 2002:a17:907:720e:b0:c2d:d9f4:2c85 with SMTP id
 a640c23a62f3a-c46796ec330mr164329866b.41.1792583770062; Wed, 21 Oct 2026
 04:56:10 -0700 (PDT)
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
 <CAKfTPtB_gMM7axqM167_Tb=WiChskGPXFDgQ4YjVz4Bj+ZiJ0g@mail.gmail.com>
 <01e25832-955c-4f39-a902-6cc253a2791c@okonski.org> <CAKfTPtCVknqCO45p7oR3s=1fNEmDW-jv7-wtQh7vwkuJ=UmVcQ@mail.gmail.com>
In-Reply-To: <CAKfTPtCVknqCO45p7oR3s=1fNEmDW-jv7-wtQh7vwkuJ=UmVcQ@mail.gmail.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 21 Oct 2026 13:55:57 +0200
X-Gm-Features: AclHuK_HyzJ7BjGGfXkJYzTYS0YfndPN8-x7GbK4aP5LZbn8GhJVDE6PE-Cm94w
Message-ID: <CAKfTPtBVJZ7DUeDci=JkCs1kstoYXsBru46VchZV7DE5=RB2+w@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] sched/eevdf: Move to a single runqueue
To: =?UTF-8?Q?Jakub_Oko=C5=84ski?= <jakub@okonski.org>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org, 
	longman@redhat.com, juri.lelli@redhat.com, dietmar.eggemann@arm.com, 
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jstultz@google.com, kprateek.nayak@amd.com, 
	qyousef@layalina.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Oct 2026 at 20:26, Vincent Guittot
<vincent.guittot@linaro.org> wrote:
>
> On Mon, 19 Oct 2026 at 20:24, Jakub Oko=C5=84ski <jakub@okonski.org> wrot=
e:
> >
> > On 10/19/26 20:04, Vincent Guittot wrote:
> > > On Mon, 19 Oct 2026 at 19:36, Jakub Oko=C5=84ski <jakub@okonski.org> =
wrote:
> > >>
> > >> top of 7.3.0, it still regresses from 7.2.9 if you test with a nice =
19
> > >> spinner in the same cgroup. I think it's incomplete.
> > >
> > > This patch only aims to fix the sched_idle task group case. I will
> > > have a closer look at the nice 19 case. Have you checked the differen=
t
> > > cgroup_mode with nice 19 ?
> > >
> > > Vincent
> >
> > Same result in my nice 19 test for all of up/smp/concur/max/tasks.
>
> Okay
> Thanks for the tests results

I ran more tests on 7.2.9 and 7.3. I confirm that there is a
difference between 7.2.9 and 7.3. With flat hierarchy, we change the
weight used to compute vruntime, deadline and vlag. The positive vlag
elapses differently with the flat hierarchy and slice protection
becomes more active. I  used rt-app for the short task that wakes up
periodically in my test

    - v7.2.9
Metric               | Value (us)
-----------------------------------
Total Samples        | 16983
Total outlier        | 17
Average              | 54
Median (P50)         | 53
90th Percentile      | 53
99th Percentile      | 54
99.9th Percentile    | 1582
Maximum              | 2248
-----------------------------------

    - v7.3
Metric               | Value (us)
-----------------------------------
Total Samples        | 16368
Total outlier        | 632
Average              | 145
Median (P50)         | 53
90th Percentile      | 53
99th Percentile      | 2039
99.9th Percentile    | 2132
Maximum              | 3367
-----------------------------------

That being said, there is a trend to make the lag to elapse quicker
and an app can't expect to maintain its lag forever while sleeping.
Instead, the app should set its slice to notify the scheduler that it
would like to run 1st as long as fairness is not broken. If I set a
slice of 1ms for the short task I have :

    - v7.2.9
Metric               | Value (us)
-----------------------------------
Total Samples        | 17000
Total outlier        | 16
Average              | 52
Median (P50)         | 53
90th Percentile      | 53
99th Percentile      | 55
99.9th Percentile    | 55
Maximum              | 56
-----------------------------------

    - v7.3
Metric               | Value (us)
-----------------------------------
Total Samples        | 17000
Total outlier        | 11
Average              | 52
Median (P50)         | 53
90th Percentile      | 53
99th Percentile      | 54
99.9th Percentile    | 55
Maximum              | 57
-----------------------------------

Which is the correct way to ask scheduler to make a task to run 1st
