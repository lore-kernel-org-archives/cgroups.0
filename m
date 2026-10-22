Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792670743;
	b=H3+piLxjeJmw+tZjq7AB/Vngg6tQvRV20HCJUr61ILsNe7e390DIYWfNs+GQ6ynP/pYK
	 Kdin/SGHaqBdlUQlWzVAJuGjy15GyBUsGsMMF5NQK3fbSZSyINUs2KN+TmP+YGVrn0kX6
	 aL96gMLMwdE59Hg9t3lvcSOvf8Erid6r0jHG/jX99KtrC4t7Ng0AFlJLVRVH73LfCfPRa
	 WEOAvJ/f+W5PgJyVjwcFhTG2CMWHxidSEP827D3SxVBLjy6zvmVjwi7n60C5Jc32keo3L
	 bA7tbbDyjwXcbNyiwuaj7UKElYFJNpHGCJbwEeDRfXAewBMzk5JDkeSXRlEZXxAmBag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792670743;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=1lD9amVrEN5VBKxfAQDsDxJlbpUbXAXUW9BovN0dNeo=;
	b=AmShomnKNY27RI5dsCa06uPMle2b7ESQG8K0jKZ22lGeFpo1td6RfWB7IKQmFwnfmpQU
	 xNqKTsdiCrbQIhmdv3t4PKd1ohAQ7l7gDyHrd/OM3I+vwjVegVm7ubd2ZzZsBvq0SQIox
	 eUfhQsbxo4ovrGS3twv5TbBCqNPVFCQuYtbfCl2zlxCCpUpW42J/7mg7Au1IVQKiQIipw
	 Et2nmJzxKRHAFIrP4/tBMgRSvBFAFgpF+ZTta2toODaJRRvUhGOz5MET6pbF8FQZSyFlH
	 DpGT2S54FdAUq25xOBIPT2dZAeKUR4b22uar9MDIAmoac4be2VEp2xuHWwWwOwLlbZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=okonski.org;
	spf=none smtp.mailfrom=okonski.org;
	dkim=pass header.d=okonski-org.20251104.gappssmtp.com header.i=@okonski-org.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=TFe0b1FY;
	arc=none smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517BA606A31D
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 12:05:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 517BA606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=okonski.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=okonski.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=okonski-org.20251104.gappssmtp.com header.i=@okonski-org.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=TFe0b1FY
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b1b13e09ffso2477042a12.3
        for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 05:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=okonski-org.20251104.gappssmtp.com; s=20251104; t=1792670741; x=1793275541; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1lD9amVrEN5VBKxfAQDsDxJlbpUbXAXUW9BovN0dNeo=;
        b=TFe0b1FY9C3TGA8Dl67TnvQoj1F18qXwJAPvi9MzJ/df3ytvAibyfiIdATWXBsI9fl
         MCwA6ZLW8v36el5BmhkkSPbo5GEunLpdo3db1TvPsHsSSb14YOQ5+h+zVSIcovu8rwOd
         wjg1YGSJXECAgDsJZ0o0omuQO7Xt0VXnt6LCdMTOGS5DyS0bnMY+IT4GNpvFbcJeQg51
         8EhC9Timl6zYN6M5dJgzc8EFw7TgjubHR2kG/sdVIJnokuwQMB6kRMdtm9DSj0UMugP1
         1HGeMnaRsZyerpM1+sb6S0r1BQyQHZpmIqnX5Nwoi3iSOol2z5TfFxQTHE828/Loquhp
         mRWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792670741; x=1793275541;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1lD9amVrEN5VBKxfAQDsDxJlbpUbXAXUW9BovN0dNeo=;
        b=AVEkz4XR0oY7Vju/1N4dwlrH22id8h4NKSPHhHmt0EbtdukZ+G8/KXJ5P0ZwHPQpY+
         OejbIGr//eIEeKaUtmp1VcdtRFRMMoxofYxS8odfuYXf6txWN82Z+Rx2RoWYIGWOW+iN
         R19lwOrkF/lAX4oOnwxcDzyQ5g0vU5Hfg/BoZcW2x/Z4uU7HqnR/P36qi0DcmzWRjR1v
         62fQwDqde4eQHcovSxv+zEw8Frx8KFXMsbxn9mFhTwHSh8AYJSAZq+kBVDqVQ69k/eVt
         WNC5M+9gyGNWBOVQJ3OFaTeGfHQwF/Qsue0Xuce+EW8YIcAXtRtcpK/KeHZvFeKPK8kN
         9YZg==
X-Forwarded-Encrypted: i=1; AKwUvBwjR551neBVpu+nOc4ygCcE/s3V24aiZYQZzBIo5O8hdDRdH7sbIfU58tIfrWaj129GSkzYiu7k@vger.kernel.org
X-Gm-Message-State: AFq9FYLQuBotKnLjBmjJCM8KuJR61xOILnxAnDvv+KFzjyloN9fpct6Y
	8vnoP1ml944yLnC9aU1OwyAM9zMr3sS+qme4q+TlOg10sQoxy+APuBFsF/uNDe5bYk0=
X-Gm-Gg: AYBFou2ty6027qjKsWinTdwKKW/k0z4mTNh8N/aX0EghvvVkyRx1Fec2t7mS8/mGG5D
	iFNCzdhkIvlytJTB25vfCBWT/SI9FG40dGAkmkaOduIN2U+j8NRGefDNKTQzE2jeAUuwd9qKVkO
	KZ4RJ9AKUKQI5oNYZ9q5O4B+BYRsoSLFV/vrzdkvdVglL7KCJD7e1z8GNvHg2Dcq/9P6IZnByVK
	34pXWkfL0qGiO/og7kRZzz+NW/w0S0Be6IitnBhvXQMLFD1QW4BVMX6rmSHBsCCPf7a9igWK7nV
	jorbE7AvqWH80Uy+BOEDYd31LSl7nxOlFzYCFXI/0u6K/hHEbgUWhTSqIyfijT2+XhnO+gAMUWT
	1AaBr6/DfWwBPRx4E7MNtg/2+Vn5OmbD+kdx43XRd4w5iL0rqu+GXNX1ANfx6xpmj5N9I61B+4D
	K8zp64iGs7nYe9nX7P6GFcFmwGDkioLmDvhbBiT8uQ3mlVLc1qqyuBcHmsaT9DXr5wVs+Bxnx5Z
	0f8oYoKOQFnjxYgf9wcPKiPaj1z4bLXBjhA2gR0/Uc10ZL7uwKybnUpxWxXUmSSNaqskRRQe3tz
	LCYoQCqx52LYiITVHKnGw53XjD5NkqlkI5+Ch1tYvdvGL6w/AV6hA+WasMf3S0Sahs/sV8ic1XF
	VQeZbn4MqZQUfvOIGFlMdp2nu
X-Received: by 2002:a05:6402:4284:b0:6b4:29f7:f951 with SMTP id 4fb4d7f45d1cf-6b429f7fb5bmr881676a12.39.1792670740302;
        Thu, 22 Oct 2026 05:05:40 -0700 (PDT)
Received: from ?IPV6:2a02:21a0:10:748:1::2? ([2a02:21a0:10:748:1::2])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b403110a23sm1638992a12.17.2026.10.22.05.05.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 05:05:39 -0700 (PDT)
Message-ID: <a82eb30e-685a-4ee3-af49-36b1102587de@okonski.org>
Date: Thu, 22 Oct 2026 14:05:38 +0200
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
 mingo@kernel.org, longman@redhat.com, juri.lelli@redhat.com,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 jstultz@google.com, kprateek.nayak@amd.com, qyousef@layalina.io
References: <20260605105513.354837583@infradead.org>
 <20260605124052.227463677@infradead.org>
 <58dc8e8a-7260-43ce-aebb-8d9c29a6afc9@okonski.org>
 <b1002150c3e4f877d04790cd8e85d2149d17722f.camel@gmx.de>
 <atZM6uF0CqCNh__I@vingu-cube>
 <f1d0fc39-6939-4fb3-a422-273cd5c347c4@okonski.org>
 <CAKfTPtB_gMM7axqM167_Tb=WiChskGPXFDgQ4YjVz4Bj+ZiJ0g@mail.gmail.com>
 <01e25832-955c-4f39-a902-6cc253a2791c@okonski.org>
 <CAKfTPtCVknqCO45p7oR3s=1fNEmDW-jv7-wtQh7vwkuJ=UmVcQ@mail.gmail.com>
 <CAKfTPtBVJZ7DUeDci=JkCs1kstoYXsBru46VchZV7DE5=RB2+w@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Jakub_Oko=C5=84ski?= <jakub@okonski.org>
In-Reply-To: <CAKfTPtBVJZ7DUeDci=JkCs1kstoYXsBru46VchZV7DE5=RB2+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/21/26 13:55, Vincent Guittot wrote:
> Which is the correct way to ask scheduler to make a task to run 1st

I totally get that and will try to make the changes in my workloads,
starting with https://invent.kde.org/plasma/kwin/-/merge_requests/10192

That said, I hope both the cpu.idle and nice 19 issues get resolved and
I'll be watching those conversations. It's too disruptive otherwise!

Regards,
Jakub
