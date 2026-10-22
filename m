Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792636582;
	b=I8ZpKsUUq0ZFU+kZINQ3Fpciz7FQDA6EZCCNJOOMo+R8QoFScQFHWhKPJwPfE4YN9dvm
	 IbhzL3j3+6oQFO6MZyz0Pn0ocofgmKvNx4x70M9fy3MMF7gK9a0iP89/hoak1HSfHTFGb
	 /b0rBqZ9LXKz3UHYhe9fk/5blBY/y/yCHuN+v+tXjzk2GXD3pWOs+AUZeLJLP+Oz6/DQI
	 2pgDYoNxrKtZx/6f5ZOf7g3Owv5CZ245r4ZlpJCejuFxuCHiLHFK4odUiMkbG2zHbgOBi
	 XOYJt5GOdEOyHe5ef5XbI0Kf5m0NBUZ6PbYVEN9kYyO04eGfhSEWGeZ+HznClplWflw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792636582;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=OnfyzMLO0P5DWvV355CXnkmHdcF8VekAj3yYMzW5EvM=;
	b=ejoa/v0Sf3NRDNyL68oeaoNknUNKTylvm+GF1Yx8zDYS2YMbHUFMGMSXNliFMeFmtKs2
	 s3FIG/mEDzl0jHw583zV31OlquMWi3W5qlG9N2SH/afV8hkhCoPlYgTxc0rT42PWagfBr
	 bsszcK00Litf/uxYcuLIJrdId0+xAXe05B/+rMoSMan5OKxh8Gcm6uD//h6ACPIJhuuND
	 +XscKvnnC4EWitLsVyQrL7mjZIg8uX6nZB81rmWk9p3XTQtHlmcFdepzYFWtVbfu33Lci
	 YnZhSxqsr+0FQuzdO+UXpZr0PlrC9AWAo/abXYjIrlGpvFDbmcLL1unYmxT+Ig/Pfdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	arc=none smtp.remote-ip=209.85.160.182
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0B4606A31D
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 02:36:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F0B4606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-535f9de49fcso9047381cf.0
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 19:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792636580; x=1793241380; darn=vger.kernel.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OnfyzMLO0P5DWvV355CXnkmHdcF8VekAj3yYMzW5EvM=;
        b=DXfRIZohrO6JOR9N2TQfXwi6cS3IFf0u3AYrwtcV6cAz/rVDD7gYA/cEnUd7wXfC6H
         sfSTAy7j3LwrJCHxVAhzWFOpiEsgVwT/fRT6BmOjP8g4NxugF58Kv64hPA8hnbMyMMLg
         Bn4uk+VUNjJYH35He0ZZnX1j8fnuR9z1X+77UXRo20wYlj3BIhM4ayOT/xvxHjPPdiU+
         FfSYeOstSqlXfhKWllHX+JM7bKGrsEHmlMhl8dWpG2+mPCDE3Y3naPT+E0bU+/a3txYD
         pdUabMTzTxVpr1fgM8p26nP5aBPgBmL9e1ItEt0i/hYPGLmhUgvgszhgzDYl95JPGZok
         h0jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792636580; x=1793241380;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OnfyzMLO0P5DWvV355CXnkmHdcF8VekAj3yYMzW5EvM=;
        b=0N50q8xJ6CA/bcDv5fWzatBom7dttdKKqptI3X4TXETVgMFgREgYkh4vaCXc3mL6Im
         Gsvor8J7paknJdaO4TquZ39dDcf6Ix+EwBFv8YZ3kiCqsQhksDXkOb2Rmjo31LngDPv4
         oQjdkEQDdGXm1buV9g3LlZssl10MsJhMA+yZh6UfZiA9QAw6u+1ZRg9WSStbLYfDDi/+
         nBJ7taAhg/jF+EnH8SXlvWQZGV5Wucw3/TBTvoRtgAaur7JVP7yvI5Q17w0kZKDpzspV
         Fqe5ldQ34vUpG/lqR6WF2EG4B8h5iMelsO/brpeIJcADZjU3mv99NHDnOuuDbQvVupo6
         sNVw==
X-Forwarded-Encrypted: i=1; AKwUvBxUL0chDS5FnQTuHZ3yJ/dG0PrZYAZst7ojYhbeqc9mrcXGQbHu6MDtwKjYkO+krj20SP2HRbHk@vger.kernel.org
X-Gm-Message-State: AFq9FYKtZCCZA2iGtbKfR3Ct2qQ/OOJyLAfP4T+GPhCjDZFCBdOmuqtv
	VdLrA7Wxi3unx4zo+XWbkM4SmVN4z1TzSzs53aNANOdnXkfB44vgLGM9Ciy38JUS5Po=
X-Gm-Gg: AYBFou39TVO6taQbRBoEMthnxLup0HxP5fdRb/01MmVrhRJB5Y5sifNX7QkHaaQ38yG
	MHsFjK6+UXDSvSYRV1Nimh/xQBQJ/MXx5ABbjOBGOKkh3TrB9KRwc6BwnMeHpEnbhDTCknztjHZ
	fBxHc4JGxmsOU1z2LDZ38MY45cSAl3LRaOUpjALvDB16O5r358RRfTSfjHF6Joau7jAYofGevaM
	oMNe+MUqTVQ2Xd6Xf8r8smCM3gK4bO2HKLX2ta7ckJwBZl1shv16uRoPsYOX/JjRhpnZCP4tR4p
	om/j0eEUiHfuNRbMy5JGSyTlyM4bXLF6Ww9LOffxm5Gb4GtrUXt/nv4bpwmyEjAvtzi4VnMP6EH
	J3fvyIj59sUXu+/3hEE62WJhx4F4LKiKCM5Z+SCrZxa0Jcb7laq0QFZ4LUQEX4rRbVp9WNSey26
	z1v6ML+3qQk16MJNTl4eZ3zqIIIamRMgL44GpFCG/IRjrFxSPDjoJRPb4JsD1Q1RJ817acSF758
	l1WARqjkAyGgkuNwtpGlMOWw+ZvR/eK8qTzMQxs0Yi3whw7eZPHEAJ92iIQDo359X2hD/lyILSa
	UbLt3AFmQRyIe2WaqSbFV2000+w=
X-Received: by 2002:a05:622a:4cd:b0:533:2bf3:3301 with SMTP id d75a77b69052e-5369b86ae59mr66504611cf.36.1792636580301;
        Wed, 21 Oct 2026 19:36:20 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536ab73b09dsm16032801cf.17.2026.10.21.19.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 19:36:19 -0700 (PDT)
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
Subject: Re: [PATCH v6 00/12] Virtual Swap Space (Swap Table Edition)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
 shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, 
 muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, 
 baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, 
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
 surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
 yuanchu@google.com, weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
 haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
 baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
 skhan@linuxfoundation.org, rdunlap@infradead.org, kunwu.chan@linux.dev, 
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, cgroups@vger.kernel.org
In-Reply-To: <20261021060323.553433-1-nphamcs@gmail.com>
References: <20261021060323.553433-1-nphamcs@gmail.com>
Date: Wed, 21 Oct 2026 22:36:17 -0400
Message-Id: <179263657717.2549665.11401372071846447074.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-20 23:03 -0700, Nhat Pham wrote:
> B. Semi-synthetic Workloads (memhog, usemem, kernel build)
> ==========================================================
> 
> All values are mean +/- standard deviation across rounds.
> 
> Test system: x86_64, 52 cores, 64 GB swapfile for all 3 benchmarks.
> Swap backend: zswap (zstd) with the traditional active/inactive LRU. We
> focus on zswap here because it is the motivating use case for vswap.
>

I get that the motivation is zswap, but it would be nice to have
disk-swap performance numbers here as well right in the cover.

If only because...

> For each benchmark, we test 3 kernels:
> * Baseline: mm-unstable, no vswap patches.
> * VSS off: vswap series applied, vswap=off, to verify that there is no
>   regression to existing swap paths when we disable vswap.
> * VSS on: vswap series applied, vswap=on.
> 

If the numbers you presented carry through, I'm left wondering why this
is a boot option and not a build option.  I rather dislike the boot
option compromise in general - but other reasoning aside, if there's no
performance impact, then I don't see why it shouldn't be the default.

~Gregory

-- 
Gregory Price (Meta) <gourry@gourry.net>
