Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795056340;
	b=R3GCTfUUgxFFK79sPzshhMbnC1PW3P6I2MgprFexbOE/W1HjAvV5IgtVpVF46sj/nwko
	 SAk07HyFShnwC0JQdwm5psyb2p/HVSd1S32OdO04YD84txgl+rGxaBI/4hh65EXK8bRIa
	 Ow40vXGd8cHvM8i9hf4Sw22QU7cZtQVr3xFd7H/oSsdVJ5QccrLj0zC2Y/mBAr8zjQ1s2
	 5QCL2aWh0RD9TX+xMcVncYHpORqEDBYP2B5JUE39JdOPcpmzLOL1IcKx6xejKryOs9F1B
	 /Ppk6OGlV/J/NagjZw9Bl0yMN8QWG9W8q8qQAbQRWaUmBzyGsegD2YspQQtPen17HxA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056340;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:MIME-Version:Received:Received:From:In-Reply-To:References:
	 Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=nHE4K0vpamVM1it9uzuLpZzTtHZ4wN8e10RDqi3C1Ys=;
	b=LbLfX2+zzWPSNNrVovhQCnRV2hH16AARe0A+ub0MYbIrJJGskdmKhAl+NK8SgMMdqdDW
	 08NU/3M0+bMKK/gNo19VaZBZqZdwbiV1pjHV9/O0iwJJICKoSkDs6KpxNSWquxxx9pseu
	 HllAvuYxzrjfXjWsTlvQQDlhQluj2Yj2MtNOysIR2eLBn8WU+VGZ+HvyaseNsR0gLNEcf
	 BFEZaevFTzrQPupRZrq48XpB9uJDWE8oE5tIFt8lTz6xLJraNd+gnffqTeA6IB/WdK2vL
	 BkIpazBtig1vgqcgmH8kwTlK0y+q6Nq4BqDusXwp3839ZaRlVkbuc9aXfKU1e8AKWVA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lpIdHj8c;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.45
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB160606A331
	for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 02:45:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB160606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lpIdHj8c
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-921159376efso18382576d6.2
        for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 18:45:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795056339; cv=none;
        d=google.com; s=arc-20260327;
        b=B6A/Ot94121S8bAs0VqGjG4ZDHuS7V9EtV3RX+QM7FsMjmbA2+kBSInAWKrQuibOCt
         r646lzVuFMdCqvarFCcUD9xms5nl0oUw1Rn0zy2Odsbh3Ru8LT7ppEvdTz618G3es+Ls
         GhCnJbpM5KMIYVyNkbjWCzm83TN9+Rzm+SYjFpoFPFN1L1Sq3hYdL7YrpoJyDN2H8gyG
         4hBpDVyfymJ/iscfIcxj0UNzMFYWQ1c6+GfN7SNaLfNbjUAqg9rA+2F6YrS3Ev6gM/YT
         MotLBnWUvtDoXsg2kN0Fk+uuc4xYUfBzLOXoV9cEQ1yOeY1u51j/ppCUN5357x8bIpwt
         Ohqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=nHE4K0vpamVM1it9uzuLpZzTtHZ4wN8e10RDqi3C1Ys=;
        fh=ixiJdPFXvWtGOtrAZCNNavm74D6gkJ1ioZC4JufCWlU=;
        b=skwGev2dBPChRWSzcg0JH8gTFJLsQlWrNX8ndSXM3xRk3+NWyfEYZlKI/6EgDwLXhH
         KJ/NcBBBXEpdiSvbQ8A4nHQKhp+JXPcoGuyyp9w1EuaWTMU1XOu7ZBsCy/eARsxG5mHT
         Uu1NkAcNO8j4udmpgDAcKaXeVh3493XJlfvhTyHzQb1CU8TXWPZoq/I3k2d0OtX9CVd0
         Xanq4y8BdHSGebuNoWaz2N4TPvJigM+9zFuV0vRhw/QOe9cdHx7qQb3Kho6m/2cZeajR
         /q04RdFKw+6JV0CTucD9p7nJrljbKVQA4WaV+9rhTXyVOeTSjqmwY14OjKMf6ipd53Eb
         2r0w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795056339; x=1795661139; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nHE4K0vpamVM1it9uzuLpZzTtHZ4wN8e10RDqi3C1Ys=;
        b=lpIdHj8cethl8NZ04UEbRz+LsiWFLHUwPBYl72U+VxoSD8U4CYn0fPfmuEd9AkKC/k
         1NYK0u//7vksQCDLPGAeqS50HlO4npB38ANnEGJIWroZI8qUSOoUtCNHSA8PTWPQ7nN3
         uecm3J5PG4//VoSP9XZ2aff+uy+HdLV3heFUfHst57h2mO5E/gNDiOisfFv9g/liPIUf
         znuejl6YqNLdGFeC1/6/HKaAAs/qgKPdkg1/Eiyq/tzsNvMuZqDlDNqh9a6UE/KCct0z
         oLVgqeSNP7Y/yGgDk+rKt+VF0gLkneUdnS8JQ1vnb/we4OLqgPIBBKRmJ7YSN29NoqTc
         Is2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795056339; x=1795661139;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nHE4K0vpamVM1it9uzuLpZzTtHZ4wN8e10RDqi3C1Ys=;
        b=SD1oToeY7UrfmFvizi66Q013ri0rNc2o6adBT4yqLD90zu4A9s1m8mNbIycxRpbCW2
         89mwkPu5sVaj1vLRPFZKHNAhaTPYcuRVhLkz1m/QXATgTuYnNtKeExCJ0NKFhRdpZGTA
         kqfw0sigHajIe6tYX30stY+c4OfXdgihvFwfNxclHgEjxIV9WKjIIAHhxUXKnUK56/oM
         mZPmbd5GpQ4NtlCENDX23c3ZABmoec7BwkwXh9BNGB6frUDBDoyrio6LQmHq32QnKPat
         sKJc61UzGWJNTtRQM87hp4OAXBTWanOpzxLuVo58nFMQWH2/Tol5BtHneGu+hprdAO0n
         vlYA==
X-Forwarded-Encrypted: i=1; AL+hErHCvMBOuUb5HA97fgyz3A7+4O/RSAByQ3rehTbtygaROXOZKvv5id5d4qGNKBraZNLtzLnZxpZz@vger.kernel.org
X-Gm-Message-State: APuU4Z+hWo1qGonaVFb05o9SvGqSRWiQuY79qNrmj7OtB0gnKqTSKH3r
	H10J5h6bWXlxjUYAToBbYFR2KPHYJcDXetKXSjkx3vt0y+VH+FyOFjXsg5Molf94OZZy69IF2QF
	SKPfRy8ThIVt75K1pDfT7OkmKSuB4Sxo=
X-Gm-Gg: AZFdTZdWK/hu/h9XTH0XLkgDuNgZNDj7ALSj13gvWmm0HKS9/0EpjiSzUShio3FIqrP
	qptYIOlu45kbgr5D8zewnuFHW4Rik0BjPA8JZDZ6n9R7o+GDDxOyvM8s+OA5tgUxbijrEFoT60j
	5ukL46n9ILJHvYV+oTgzlItETw8AZJy9koc4kE3X8kpkmnzEC3N+fKuROQfaKfKbV26ECGoBTyd
	/Vt5DaehoSMqMd6jGNMlaPX5ugTeua9iyOuu+cRSQKczMwtOQ/OrIUtmaqd3qnNsLya//qyO7Zh
	OV/GSq6gcro1QIGKRMhsl+7AW54VXEx9VIAO2Q/b4kcM9PKXBlIDD0agPcBMigGUltm2FHbgD83
	A0KzILIezwAjbFPMEbCzmJD5G0Xhyg65fJfUW
X-Received: by 2002:a05:6214:4509:b0:91e:93bd:17d4 with SMTP id
 6a1803df08f44-92114f234d9mr68688036d6.31.1795056338595; Wed, 18 Nov 2026
 18:45:38 -0800 (PST)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 18 Nov 2026 18:45:38 -0800
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 18 Nov 2026 18:44:56 -0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Wed, 18 Nov 2026 18:43:28 -0800
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Wed, 18 Nov 2026 18:42:52 -0800
From: lianux.mm@gmail.com
In-Reply-To: <20261119-mglru-fg-v5-1-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-1-9eee2fe97a2d@tencent.com>
Date: Wed, 18 Nov 2026 18:45:38 -0800
X-Gm-Features: Aa3M54oczcrQgnIKIdlWRyAqAv-8pL4r_8Eu0gOG26vA4iWYOD9SKwZ3124B0Ic
Message-ID: <CAD1ZK4Zo_qQf5aJkVLtoc-LXM9XbyZd2Vy6rFvK_fih-6FE_EA@mail.gmail.com>
Subject: Re: [PATCH v5 01/17] mm/mglru: rename the generation offset in lru_gen_folio_seq()
To: kasong@tencent.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	muchun.song@linux.dev, qi.zheng@linux.dev, ying.huang@linux.alibaba.com, 
	chrisl@kernel.org, baoquan.he@linux.dev, nico.pache@linux.dev, 
	usama.arif@linux.dev, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, vbabka@kernel.org, surenb@google.com, nphamcs@gmail.com, 
	youngjun.park@lge.com, ziy@nvidia.com, gourry@gourry.net, willy@infradead.org, 
	baolin.wang@linux.alibaba.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, hughd@google.com, sj@kernel.org, rientjes@google.com, 
	yuzhao@google.com, vernon2gm@gmail.com, wangzicheng@honor.com, 
	chenridong@xiaomi.com, tz2294@columbia.edu, ryncsn@gmail.com, 
	liuxiang.277@bytedance.com, ehab.ababneh@intel.com, 
	zhaozhengzhuo@uniontech.com, joannelkoong@gmail.com, kunwu.chan@gmail.com, 
	hui.zhu@linux.dev, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Lian Wang <lianux.mm@gmail.com>
