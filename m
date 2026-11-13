Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794607365;
	b=I9jMCZqDEjip0ldBGM3/Nio3m4xol8sSbAt5VXL/a4fQ+WqV5GATHOzsIskswg6CAa7N
	 go/qEhLLqOHoTwp9hj/Gs1+5ZTd3DVTsVVV+7KzVWoRb3kRhicwgZiE2S/doVHSJQzO/F
	 cnMK1CWcSXMPX5aH6FxPu3A8umTsy+s7s3tOllwfy86edbKgEYDwS5QiuoitjwUmXUrXJ
	 zWpI4UJIL7IEXRJLxOOCVuzs56LeKbJfUlabxyI78YD15x0wSxznjfJLRWNcqiVkvBydU
	 jLzVQE1ktmUo5yxDped4bx9ktNcpR/GAmHjAXpCqPEixO2zwwpa6F0mrp+vwlX0VZ7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794607365;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Mailer;
	bh=hLTZgrPRMvXWTx2mlzS40LX99kos2rQ4Fybij+QpVFY=;
	b=qQEN03spT3RHxoM4zdsSq20x0NX72fdRTANQTlDmNa44JXZTqsOhsRy83SZaADilIC1c
	 wRfVYE1zV+wcTHS59ojqb6nVnBXmNMzbgn+iEhpRz5KQB+kb4tOIHOhrRdmT8r6PtwAqs
	 fD0BAb24NJiMN/tagEHbjkO1Osgie/7Gfqm1zEX7mdDaHvzymEfGHh8r+3SSSN3PcBt6K
	 Een05IJrhUep1E3g03W3ZFbQyrWM3YFqtTV0GIFnurx5bS5+QGTB5aYdsV8/4mp6pg2qO
	 M8scocjwI9+g/Di4xnJwN1TCWyqALhvy7M4/nUb+sOBxh+B67qoT4QH/lDO++wX7pSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=pass smtp.mailfrom=kernel.dk;
	dkim=pass header.d=kernel-dk.20260707.gappssmtp.com header.i=@kernel-dk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=MxhT712Z;
	arc=none smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBE5606A32E
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 22:02:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDBE5606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel-dk.20260707.gappssmtp.com header.i=@kernel-dk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=MxhT712Z
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-37000e7234bso2282106eec.1
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 14:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20260707.gappssmtp.com; s=20260707; t=1794607363; x=1795212163; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hLTZgrPRMvXWTx2mlzS40LX99kos2rQ4Fybij+QpVFY=;
        b=MxhT712ZOs+9JNd48QhgsCPVX4B2Me3T9nNcqh3+3RQIFoeMHmW6Wl+WlG2eszHG7G
         W4bGVTq7kOwx0uGrHE749/Tzt6Y9ubwt7FDE57ZwQZaq+3mRm8NYBnSD32+sxDnpYi1J
         dgcSCrMRfotrVHqI5i3Kbi+QCZDRMIolbVs9aA+B1iC+BwuNhGViHLF3pMd8wHVK40kr
         JLrUUdyWvqq0c1RzBf2T6Dv00FUD++njrC800eHkQB4c5nh437/q9qqnhrvfqYN5tBqG
         O8kvLa0TcHNt6kJys2AnCLSbPPfn/+e8mL6WHWyTzfXZXIDcVL1HTOm9QCxHfoUZRXn9
         yLEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794607363; x=1795212163;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hLTZgrPRMvXWTx2mlzS40LX99kos2rQ4Fybij+QpVFY=;
        b=UabeG7gxk2/Kv9U3GfVrCpgdX32MAUB3FnAGnW5TKKzTDSvqOMom35b25bQCNsNTKf
         99TesUXnYAwnGqmmmnb0PpR0RLdscOc93B6MVzoO4C9OGZlt7uWN8Unrq4UIisCztcVD
         rhpf65uot2tWK2H+e9TAKzPEdA0X0IDmsNjgGTv5azqQK0FGhq7KVXf5t9Cuh1mZPRli
         RITGbHfILIURBh+AgRiqVUrZRC5UyU+36OlsBb57O4l4xBFdPoCmzU5Olwq1ffPx/IO3
         0Wi3iOa/bw5DA7rXozXIRqLnekoWLa8imBAjMx1sArSMbnKoO5olNcZ//1C39BVFU7LA
         JUuQ==
X-Forwarded-Encrypted: i=1; AL+hErH7c/TDW5iM1hiaF2Yyiqla8D5JuTRTeC1AZNI32MBjEl8tR/IUUqziHlFlj75TWqmqAtH1qDfl@vger.kernel.org
X-Gm-Message-State: APuU4Z9BzUZeqjHHTCG+QV3F5y2R3P2jaoZZm6OyoXv4rI7ivdIJEquY
	0aWtHf+ijOnN6j1b/kQvcLoc/Utt7HC06ot6Kj2k8qSRkLs+2kM5QUSWwEx7CtOsj6d/QZ8VobX
	PtYKhmoI=
X-Gm-Gg: AYBFou3D4mXhj8Ym5ovQLYfEP+Js9HIlJUH3EtcdOHMl3UmvdHOmp1RIS1Et0lX80fG
	8+xK/8gS47lHn8w3iH4RuOyY/ym8ebxTvAwEXzrrBURePk7+kKkesUfpKj5+Iop4yaWAqTEWK8x
	xDcCrqOMBFzChM0IOvky0lagSeNIjt7vCmxcIAqmBhAgAe94zZdFzTXlJ7xjmdALMSINMklyWHJ
	sA+AzRz6DXNemebrsl/t69IJsATZUHRDhwf/iJibSQBK2dzbs4tj8ogjAPyh/oEA5SR37kVxxB/
	Jb0PshBemyhzhCm2J0rZ4lPNYAdIPQEkOChGMRtM9EmngLC+TNb32zjI0wE5aq8rYTnV6thXYNZ
	aD3jvzW0hab5sexu84oKjTRuFBIkXUUafc57AT3mbd9aJc+k8n8jCl+VUGPpeYwydHE/4wHqG8D
	dCd8+UG4H+oTIbsJs/o6C0GBFDKwMSOxrUdgWuWDbS/aUq4O2sbiuYxQyINF3WNUuKbQOw3XpPY
	uSZI2uVJALYI4ggs5tqkaaSTlXl20eWYkWO4hxpLcEIReUXl0inJmio4MPslLWsiWE+0u78Ae50
	bHmNoO13UvCaDVMNqfOMCZaN03L5E90tlMvj2UVY5UgLNQa7bdhkDdTUayDVpMJKFcU0UqrKTJE
	J9pXJMhpNaQV7EFNkUxsWCoCb6CQs6FPslg==
X-Received: by 2002:a05:7301:db11:b0:369:fe4c:b48f with SMTP id 5a478bee46e88-3796047be6bmr3147605eec.0.1794607362850;
        Fri, 13 Nov 2026 14:02:42 -0800 (PST)
Received: from [192.168.1.142] ([198.8.77.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379563e6b6dsm16981662eec.21.2026.11.13.14.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 14:02:42 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Tejun Heo <tj@kernel.org>, Alex Kazinsky <a.kazinsky@ideco.ru>
Cc: Josef Bacik <josef@toxicpanda.com>, cgroups@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 lvc-project@linuxtesting.org, stable@vger.kernel.org
In-Reply-To: <20261113110842.4189035-1-a.kazinsky@ideco.ru>
References: <20261113110842.4189035-1-a.kazinsky@ideco.ru>
Subject: Re: [PATCH] blk-iocost: Fix overflow in donation weight
 calculation
Message-Id: <179460736165.18529.16250644917025390352.b4-ty@b4>
Date: Fri, 13 Nov 2026 15:02:41 -0700
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Fri, 13 Nov 2026 15:08:40 +0400, Alex Kazinsky wrote:
> hweight_after_donation() receives usage as u32, clamped to the range
> [1, WEIGHT_ONE]. Since WEIGHT_ONE is 1 << 16, multiplying it by usage
> equal to WEIGHT_ONE wraps the 32-bit unsigned result to zero before
> it is passed to div64_s64().
> 
> This makes new_hwi zero, which is then clamped to 1, incorrectly
> reducing the cgroup's in-use weight to the minimum.
> 
> [...]

Applied, thanks!

[1/1] blk-iocost: Fix overflow in donation weight calculation
      commit: a56d5a485be4a9d52f0d7b3ed0dc3521367cb986

Best regards,
-- 
Jens Axboe



