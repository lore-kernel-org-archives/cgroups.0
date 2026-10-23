Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792768338;
	b=5fZ6ubYPF3osYY0ECYCJTp748P+Qboa01lD3ajtcTUjRHdjfhdk9sGMRmOkstYVZ06wa
	 HMpQYi7qakxLrpgKbyQwJq9wJPowDNkZVVWrm5yRg6uoz4MZ8+8L/dokbXcQX4pE8Jb8F
	 LpqqRJekBuYOarQv+WrCk2qFS0ULF+HtF6rcoDplJ0Lin9YZ7OAPBe05LLyi0GtOzelkQ
	 a1x+QCuPKTYTwHlS6QswgyBUHunNS4zpQIRvo4Ah/n0qRju71i2cT/d6xFA5IroL6OfW6
	 aAQjUISryaU4YDtGs7xkmNE3nWdEoXYM9AVekguNyxMjaQrOwfMwhRoO6ZMaRg3Q4yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792768338;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Content-Type:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To;
	bh=/nChdOq/b/gyYFhyjIipIGWStlUHbMLmpH6JMhnlOpM=;
	b=3+px5RM0dvMzCo996i/+Pd4xHKKOwmXHj52o0mduUzcBQSIED1AiYMYRcu5fzM3q9Pfw
	 KM2xqniOdfA69lKvf5CWYuxKx9N8ixU10DCybuRM5x4Ovzu/tXsdmQAQxvBi4wgyfUKvk
	 d1j4IvVPtjrBHU7aVBL/2MIUK9jlBANyQtbA8FXgY+VIf/CbAKJOUbkq0rLJ5fNJPgr9J
	 NrjkktsvEQJOggbu4N6h6IAIgHlekANsz+rEEAIke2MzLGZiY7gT0Snv/05IF1ACt4WTX
	 LCPCvF8Df5cJQcyJVPHW5PFfUDGmWbv7+WcszDEcSAFUnuSIwfFvO3P/5PHf6OtJBFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=colorfullife.com;
	spf=pass smtp.mailfrom=colorfullife.com;
	dkim=pass header.d=colorfullife-com.20251104.gappssmtp.com header.i=@colorfullife-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=XFQA8qEt;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE105606A31F
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 15:12:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE105606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=colorfullife.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=colorfullife.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=colorfullife-com.20251104.gappssmtp.com header.i=@colorfullife-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=XFQA8qEt
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48b060ec084so668076f8f.0
        for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 08:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20251104.gappssmtp.com; s=20251104; t=1792768336; x=1793373136; darn=vger.kernel.org;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/nChdOq/b/gyYFhyjIipIGWStlUHbMLmpH6JMhnlOpM=;
        b=XFQA8qEt8ByaOAUvLyzpvHxIa/ul77IfVhjb2qRrhv6hPJfnctOAaGmlbxG2CB0PCa
         fUfkOOTjioqvqox19/Nmul6Q9oh+UoeJ1SsS+FeG7p4HrlUINaHpNFbQ8uTdLJg4Hxmr
         +YRJNwDcT1cysDyftwq3afmdfTgF3Xi9cu9EGFob1/kLFHg9FkwiSPVqm6R6XfUacYDm
         37lLFxo3296LMftonjo60A6SFn6/XD5Hsy2gkf7L7YrqkTnZwNoRksCyAcAEo/Tq0ba2
         ezDx7sXqT5r5STLAtGXSU30mQPSV+Tt2YBkDr8ZUsW8dZzqxsgzrDyV4LnNK69cvB3fb
         ivtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792768336; x=1793373136;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/nChdOq/b/gyYFhyjIipIGWStlUHbMLmpH6JMhnlOpM=;
        b=pSPBYdx9EHMM0NiQDxY6SJwrObL03Cx/7F9sA1xE3sG1PLbBbeknmHODLYtT8a576i
         0f+mVswxcf3aV5nRqRxh2eNKztgdpghbG1YC0nmYO7iMhXwf/jOj0LrlCiJkkifQ7AIL
         u/SABT1vG3Z649rLCpKqTzAdDRvzbHU/Zbmgb900METNpDo6nUxD812sUs7xOJ2qr6sn
         AcUKZ4/Axspj6w1eRHARYcsgnpz5l5KQ/lBtw7MxM6BLIJywc8I3pFILfwBY3NagIpGU
         fRQfXYnhu++2yNZ5iYfPGIxj5sIojuBA1uU154A2J1DY18Xa4m531gnkDRUyDMGs7vYh
         9mMQ==
X-Forwarded-Encrypted: i=1; AKwUvByeov5wS1qsgo7KEQOFOOGgK3xCNyQ0kGTg1+4MsIIonjb+sAYfetIc0lT7pwhPqBENdKHg8w5O@vger.kernel.org
X-Gm-Message-State: AFq9FYLHe24d1ShKOX6PRZYeDmZgX7LS/hs172Ito1wPOr/n0pqiHGSn
	AIe5l/W7CZ4qLRAnCjSl9hk/lcoYUJaWM93//2W1yHla2h7xc7qmFy9ZsP1vNSE9MQ==
X-Gm-Gg: AYBFou2w1fCqGbsRFAEP2yg9eS7CRq5nGqMkuPkDG/BsoNm6h8bQs1mp9RK5CPAY5Jw
	sIBI/uSggYvnIEfJG8EfpUMyWJC05dUKyPH0Vzo5YqHEvj6gMs0FOOVrr/RW158DnRV1DbSZ7kV
	LjgOpvY+kMg3lwqdgkQwKZ5+y02d7yWNllN9Wfg9y9X/R642o4eO/fYOVHsaGuauZD7BBTlAbbV
	sTCUfyceYMEl9LAJOZqa7Rm+DaMbMSdyw7Q6dnLrUtoHpG+U9IOjxDzyNSPYGPefBiBUO7hrBcC
	4x4y+ciSJ+HdxVki7bh04dFRoGIZI5hK8MamEAj/9tJi2V7pqBLPNnB9DY+AuNbkq9SiOJNP2NU
	u8rfgwM3eT+vHhyt0vUzoJhLeH4au2oNXDinBYczz7hMlO0LL4NySPOv3hO/dQJvRNk8YMuWWfY
	MyoqfeEOM4/5GWr5dp2gwihsmkXjTy1DAg4C+AjZkudaLR+Mli9MMFOaUfZLyQYEHJXl8YlEYTK
	OOG/Upryk5G1HbkRMH6FuB1hQ0JSui34/mjNsb5a+MMfdZ5S+KcnviByrMY3+lSIK0fmYL6bieC
	xpujCvYDghgiJ464ANGk2DMsS2+DM6k5u/U5EzE1gksIRV6Iugr1z7P/2ifN5UyEHCnICItWce+
	lEeiZCmjC6ySk/SQ=
X-Received: by 2002:adf:f308:0:b0:48d:b650:69aa with SMTP id ffacd0b85a97d-48e387ea74emr3047183f8f.50.1792768335827;
        Fri, 23 Oct 2026 08:12:15 -0700 (PDT)
Received: from ?IPV6:2003:d9:9707:8b00:3fa:3a3e:198d:ab69? (p200300d997078b0003fa3a3e198dab69.dip0.t-ipconnect.de. [2003:d9:9707:8b00:3fa:3a3e:198d:ab69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3d40e830sm347543f8f.35.2026.10.23.08.12.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 08:12:14 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------lWpYfqxAIT1R3O0UqvedLtQH"
Message-ID: <24afe3f2-8cf3-4182-a5ba-951e3b574f12@colorfullife.com>
Date: Fri, 23 Oct 2026 17:12:11 +0200
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
Subject: Re: [PATCH v2 2/3] ipc/sem: reject negative SEMOPM values
To: Yingjie Wang <x-professor@outlook.com>,
 Andrew Morton <akpm@linux-foundation.org>, Alexey Gladkov
 <legion@kernel.org>, "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Vasily Averin <vasily.averin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Michal Hocko <mhocko@suse.com>, Alejandro Colomar <alx@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
 "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
 "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <cover.1792724953.git.x-professor@outlook.com>
 <4fc7f5cb6bea186c5266415fcadb7e26c7738a85.1792724953.git.x-professor@outlook.com>
Content-Language: en-US
From: Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <4fc7f5cb6bea186c5266415fcadb7e26c7738a85.1792724953.git.x-professor@outlook.com>

This is a multi-part message in MIME format.
--------------lWpYfqxAIT1R3O0UqvedLtQH
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Yingjie,

On 10/23/26 5:19 AM, Yingjie Wang wrote:
>   
> diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
> index d038d944257f6..2a542f838a530 100644
> --- a/ipc/ipc_sysctl.c
> +++ b/ipc/ipc_sysctl.c
[...]
> +
> +	if (sem_ctls[2] < 0) {
> +		ret = -ERANGE;
> +		goto out_unlock;
> +	}
> +
> +	ret = sem_check_semmni(sem_ctls[3]);
> +	if (ret)
> +		goto out_unlock;
> +

The mixture of an inline sem_check_semmni() function and inline logic 
for semopm looks strange.

I would remove sem_check_semmni().


Reviewed-By: Manfred Spraul <manfred@colorfullife.com>


--------------lWpYfqxAIT1R3O0UqvedLtQH
Content-Type: text/plain; charset=UTF-8; name="all-inline.txt"
Content-Disposition: attachment; filename="all-inline.txt"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2lwYy9pcGNfc3lzY3RsLmMgYi9pcGMvaXBjX3N5c2N0bC5jCmluZGV4
IDJhNTQyZjgzOGE1My4uNmJmYzY4ZjA0MzUzIDEwMDY0NAotLS0gYS9pcGMvaXBjX3N5c2N0
bC5jCisrKyBiL2lwYy9pcGNfc3lzY3RsLmMKQEAgLTcyLDE1ICs3MiwxNyBAQCBzdGF0aWMg
aW50IHByb2NfaXBjX3NlbV9kb2ludHZlYyhjb25zdCBzdHJ1Y3QgY3RsX3RhYmxlICp0YWJs
ZSwgaW50IHdyaXRlLAogCWlmIChyZXQpCiAJCWdvdG8gb3V0X3VubG9jazsKIAotCWlmIChz
ZW1fY3Rsc1syXSA8IDApIHsKLQkJcmV0ID0gLUVSQU5HRTsKKwlyZXQgPSAtRVJBTkdFOwor
CS8vIENoZWNrIHNlbW9wbSByYW5nZSBbMCwgSU5UX01BWF0KKwlpZiAoc2VtX2N0bHNbMl0g
PCAwKQogCQlnb3RvIG91dF91bmxvY2s7Ci0JfQogCi0JcmV0ID0gc2VtX2NoZWNrX3NlbW1u
aShzZW1fY3Rsc1szXSk7Ci0JaWYgKHJldCkKKwkvLyBDaGVjayBzZW1tbmkgcmFuZ2UgWzAs
IGlwY19tbmldCisJaWYgKHNlbV9jdGxzWzNdIDwgMCB8fCBzZW1fY3Rsc1szXSA+IGlwY19t
bmkpCiAJCWdvdG8gb3V0X3VubG9jazsKIAorCS8vIFRoZSB2YWx1ZXMgYXJlIHZhbGlkLiBB
cHBseSB0aGUgY2hhbmdlcy4KKwlyZXQ9MDsKIAlmb3IgKGkgPSAwOyBpIDwgQVJSQVlfU0la
RShzZW1fY3Rscyk7IGkrKykKIAkJV1JJVEVfT05DRShucy0+c2VtX2N0bHNbaV0sIHNlbV9j
dGxzW2ldKTsKIApkaWZmIC0tZ2l0IGEvaXBjL3V0aWwuaCBiL2lwYy91dGlsLmgKaW5kZXgg
YjE0OGI1ZTE1ZmM2Li41MWI0ZWZhM2Q2ZGIgMTAwNjQ0Ci0tLSBhL2lwYy91dGlsLmgKKysr
IGIvaXBjL3V0aWwuaApAQCAtMjQ1LDE0ICsyNDUsNiBAQCBpbnQgaXBjZ2V0KHN0cnVjdCBp
cGNfbmFtZXNwYWNlICpucywgc3RydWN0IGlwY19pZHMgKmlkcywKIHZvaWQgZnJlZV9pcGNz
KHN0cnVjdCBpcGNfbmFtZXNwYWNlICpucywgc3RydWN0IGlwY19pZHMgKmlkcywKIAkJdm9p
ZCAoKmZyZWUpKHN0cnVjdCBpcGNfbmFtZXNwYWNlICosIHN0cnVjdCBrZXJuX2lwY19wZXJt
ICopKTsKIAotc3RhdGljIGlubGluZSBpbnQgc2VtX2NoZWNrX3NlbW1uaShpbnQgc2VtbW5p
KQotewotCS8qCi0JICogQ2hlY2sgc2VtbW5pIHJhbmdlIFswLCBpcGNfbW5pXQotCSAqLwot
CXJldHVybiBzZW1tbmkgPCAwIHx8IHNlbW1uaSA+IGlwY19tbmkgPyAtRVJBTkdFIDogMDsK
LX0KLQogI2lmZGVmIENPTkZJR19DT01QQVQKICNpbmNsdWRlIDxsaW51eC9jb21wYXQuaD4K
IHN0cnVjdCBjb21wYXRfaXBjX3Blcm0gewo=

--------------lWpYfqxAIT1R3O0UqvedLtQH--
