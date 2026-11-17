Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794920437;
	b=bHpflFIIrJkC85c6FTiWOnrWvEWbiQ5xQbIbhvJkbf1jnDuG2YGGWyZqjSomoe29hwhU
	 LKRcPSt/UWmjbLpr3tCNg+tXoPbScZtie0sioraDvym5ypft64Aj0fkeHr1NRjfVXLBj9
	 zbqRzdtV2SUrFJ2g8I8vregqQwyFqqm5kJF5huz6iZ90NPd1s2fKeHqJO09WucDypOO3x
	 YUHHBJS6W4mM/yZSajaj4jzh56lk4ihi/mwPNDVnE/hxoBiv62GwuZgAVgCNl5eVPbHrL
	 +NLpJsG/cNgLkPi6tcFTWNvgL7GlCIRKk9F1u9+knEbPj/YOa6v7D4L/loZ213SduqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794920437;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1pou6eazVIXgzMzSicK2lENYxL4K+6GggzXTgkNl+FE=;
	b=DJBRlPllV7AriaC3pln9ofehA71q0gmXwOmiQ9fwLgrcsjFkHdv8hRO0CUVPfR9g8SEn
	 wpmPEYtHBOxKkitpK8x8G5mOEDPArja5Dny9lgKw/uBRxaZBWUtzjB8ImOnQk8uONCIYz
	 O1CvinB7csbUfzhA7e5IwaWDCTshuhaGnBUe74HTLlXIql+h7l4RIPXoHaWtu4J4nDNSV
	 aFaccIDvjNkyyNifcuWCMb/uh9PTnGAD9XUMZmXFkGqaP+7lrJMvGQTgXyjZxg1m31HEA
	 g/tby9pntZRpJNbL0sdPunAvtcyyYcw0MKroXqFZeXMhqDJvzZVLWWnw2Za4awoXpzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=E7PpaS6F;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4727C606A337
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 13:00:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4727C606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=E7PpaS6F
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a210470b49so38333545e9.2
        for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 05:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794920435; x=1795525235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1pou6eazVIXgzMzSicK2lENYxL4K+6GggzXTgkNl+FE=;
        b=E7PpaS6FhetZjyMeTxICsrWjeqCx1d4FC0wXkU/i59upZv1WqNgukn4us5FQBQvPiM
         nuHNDjLjE8/O3fAYnqO3abBUSVD9zXGHaj08wJ/hEVyfaW94c/Gwy79fMxbBOlHlWmXr
         ofu7DUHp/rdDfZGy3yzsKjoondVyQvqXK4J1ho149XdGcPAVEXFWtgatvCT+t0CnYkUp
         CmxKMch0nZppHkRuLt6PWAS4aOned3F3V14N+p+kDwd6sCQZxu1gDN1rjrLdw5Bk0gN8
         Nk0yxweQ8A3aR0ls0KHfqzRqv/8Q1yKkI26Xe9Rcr/EdIkZGMQfITF7mHU0Rm7EXDjWq
         J9Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794920435; x=1795525235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1pou6eazVIXgzMzSicK2lENYxL4K+6GggzXTgkNl+FE=;
        b=e2KWl1/BoDDsN/tvbfcKHc1MlsfdDE66RPXIJrYnOcAeicnqYdhrkfAJIlvTIsmC7L
         q0J4i5Cn0XmLjfZYHu2gmMyYl6cAvnmeYPjFGDdYgM7otOgLmAsS5ohtIavAS0vzbqyp
         AMv19QzH5QMDFWsLnto7d9yWjsOhfv+LjDmy0Rt/wfsGyVnXF5AgMCJW6pMFx+bGE56C
         qwcDwTo6cH+prdhfgsjaHOFR0UezklLkWXXHYY7WLaDNukYjUJj+zLngDSdaS+cLuiZX
         pPhZfDvkF8kOvYShSsCg6omSRURKzduahrfyPrb3kXCJppE5WWaxs1H5qJCMkV7DNRu4
         WFsw==
X-Forwarded-Encrypted: i=1; AL+hErEWW1cVS2CoEwVdph9FQFYGiwMB30dHBsUQJJcqOEZ4Q92KUmgWD4ywH1bidARkzEzd7A/q/iVB@vger.kernel.org
X-Gm-Message-State: APuU4Z/wdfChdfCgrht6n4LTwx9ztFQ/7w/kFf2km3n6PbTWVnEWRwAF
	oOTuRotuHg9qdUuCrwGg55aKUxQvPhw00u8+CUEBNIvKc9s/YsZEzhIL
X-Gm-Gg: AYBFou0x8tJJeN4fJhM0MTjW8WOnR71hGKQ5jv4kexp4Ea4Yp2ODADYcaJoN1Oiwz+E
	xx3FxlfMKj+X5VcvmWzO8K+JzFBNreuw5EZy3+FUkqPUgQpcLYauQI5SsDycgVLCz6J7HIqPhz1
	lYK+UVsTHExhwbLDY8MA67Rxq4uJdCh2Y7rAQJqZUynx6LIdQPvMdkalKCwQODKdk+2UcfPDNT3
	4BGRFdI/pIbL1eu3oIKMM1peOJCRNObX0KjVAjBgUS8ptVPSkaeRJ+hDB07f0ZNBB4oe2vdPIwN
	cfUPNDjSD00KCtejNHqAKGoVAr8w5D94R5aHenX0OwKnGq9fRdxsWRNKiCPrF40ntLOqozRbpdS
	6cPv7A4wcnXlNXrGXSzvOVbwCiSgZ0Z+rsdsB2TqocqLPrUIg/9KW+BzZGPn+6qesB+Z8dpSTbQ
	2eo5cuOdjDS+rlF3Air7mYY33J0ZubuyrpesN9opj+jo3xYFw8kyGF5/OqiP4q86RPuBnxlvfFy
	rdxRmO8NrH3JaXjga8AiAl8rCB0X2fbEXXFzvaKB6vuLyEklox42Gj5p5XowFHDoTTdA4Txtrm9
	4N+WW4PQp6MORd8LzScqw6rANQ==
X-Received: by 2002:a05:600c:3e06:b0:4bb:6947:3e1d with SMTP id 5b1f17b1804b1-4bb6947426bmr171284605e9.20.1794920435270;
        Tue, 17 Nov 2026 05:00:35 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7ad9430asm35683315e9.15.2026.11.17.05.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 05:00:34 -0800 (PST)
From: Yuri Andriaccio <yurand2000@gmail.com>
To: juri.lelli@redhat.com
Cc: bsegall@google.com,
	cgroups@vger.kernel.org,
	dietmar.eggemann@arm.com,
	hannes@cmpxchg.org,
	kprateek.nayak@amd.com,
	linux-kernel@vger.kernel.org,
	luca.abeni@santannapisa.it,
	mgorman@suse.de,
	mingo@redhat.com,
	mkoutny@suse.com,
	peterz@infradead.org,
	rostedt@goodmis.org,
	tj@kernel.org,
	vincent.guittot@linaro.org,
	vschneid@redhat.com,
	yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Date: Tue, 17 Nov 2026 14:00:33 +0100
Message-ID: <20261117130033.19195-1-yurand2000@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <avsSdeZFb7CXnMro@jlelli-thinkpadt14gen4.remote.csb>
References: <avsSdeZFb7CXnMro@jlelli-thinkpadt14gen4.remote.csb>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Juri,

Thanks for your reply. Sure, Sashiko raised a lot of stuff to look at, so it
makes more sense to look at the patch once (hopefully) these issues have been
fixed.

We would like to also address the interface issues which Tejun pointed out, so
if everyone agrees with out latest interface proposal, we will fix Sashiko's
issues and implement the final interface as intended for the next RFC v8.

As a side note, some of the raised issues are strictly related on how the
`cpuset` + `cpu` integration is implemented, so we'd like to have feedback on
the interface before fixing them.

Thanks and have a nice day,
Yuri
