Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.218.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1795520571;
	b=VD1VCQqbYhG5WY1uE2W5ff4voVRHrfLb18wglI6zlX2JqkXqCMt2epWOACk3uRgdLNSz
	 egwL89L6lk4dq0+tSiuu4wDLw7oja2JvXzuIzD7ESawZJn9JWqXiK8rED1A0prU2G1MsL
	 Z0lO3T8YkiLlV+LRPgKnDqNmvbz258rJsRdSqJm5y9kXi/AQPCaVm2cTMutpLI3opKWyi
	 QGOw0N97WywUbrhx9bS73ASNs+tliAUyZSq4xRceMO5ZXEU7r2BiQHEMOZmVAxUqZxA8o
	 htwYYh33NY94CLYW/zpUKtYHFOCVIxnUpIMKQ1iF3z0VTzTFiJjzBy2Ze2Iy86/QslA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795520571;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=/z5ch5pLpPdbk1BmHD/hwwHu03qByQafwYZQeBV/lWk=;
	b=kcmwREpUqKfAVqFtOcDeRVd6pT3+QBLSF/5qEdwQhCtuVIhQMXFV59ThJj41n41+v0th
	 jyWyfkZ/qqhADjAVfqEwVV+gB7hZaGGv70w4WkJB5N5O+ZCzBqF06hIcnLbYqwzDzAPA1
	 7HtFZoRc2OLYwO1Yzj9fMBAjAHkVyly8J2g9xw19ESn5gqIr88xPOw1HuZmKmZ+DUUS7Q
	 YlR7pRKCTMJQaCoPkjB78F5izG1zPVb/376CGgBhlXVOp8QMB44fI/E8E1YfwcQQntOB6
	 yi0tID5oU8MpH9KO6IsMhrBM6FF8vJBmtU5zqvviYsvKe6ZnERqbqcSMNJxp4zGPksQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xq2R+zD1;
	arc=fail smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AF1606A322
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 11:42:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83AF1606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xq2R+zD1
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c4cac7a7d3cso634364066b.3
        for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 03:42:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795520570; cv=none;
        d=google.com; s=arc-20260327;
        b=Mk2xGw9aJWNti4a3CZOOv0tpqamGlAwZFQ9lvOUJFxEKD/AN8FPYtpZEd5HCqcQ0YC
         qFIngBlpwdZ5iCRsnC1ZE69ifsTrN6ixJvxv325xDAz/az3BYC1ZzVV1ySmcibPhOV1P
         INwUNYqSHp4MMW4e0/WY7tjZHY1UI1gUIdzwOchABCc9+7mSHFo244M27wopfcCnbwLb
         UhuMvqv2E85esThff3PYIBHZszCPAklGuau/BYd6GDO4/b1EGeH3VxgTdwxDKrSV20yQ
         +zG/iBcsJrAc4zrRH/377hTT7vHlctgkTtjb0bD8B2mTyqIv+QYS6dfM1d9BAsp016uw
         kImw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/z5ch5pLpPdbk1BmHD/hwwHu03qByQafwYZQeBV/lWk=;
        fh=sR3QKMnIlMADbLkJE5zpUEl34zPIVfOsBw3aJas0jes=;
        b=d07123UmcscMFV6L72DWv/2Dua/nGUlUaHIu5sjp43l4CMTrTEBimlmdGrwCVciPAP
         7KDFIfZ/70Sf3YJlKu+UF0QwGt3wdHnvqFLhrKk3xzxaDmdhM1bGhDP3sg6dVBGAviZy
         JCrUQkExyV3r+aIIszBu6dbuna/3OY2L1RBngfbmIPAH0b6pKhakxhbiG2grPYlvF7+F
         QVm7KDQk4qc6H4oyTp/V3Y5MNisdaALKnCyMsY/l7CweeCST6A18ThEZAb4ansuCZgr1
         DEadq087/dVpCh7g+4xjoTbPwSfok+F/pQQLu0+QYDZYCSKCP3eVhuSiJ+GJZkL9szIt
         9C5w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795520570; x=1796125370; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/z5ch5pLpPdbk1BmHD/hwwHu03qByQafwYZQeBV/lWk=;
        b=xq2R+zD1p5RXUgEpNuhoK8xg7y7NVsHGKr0JxP3zhBiQsU4buKR1kPpzJ/h+RQqvIc
         K55ISJpK52O/lqUCD5pfVaavDjp36RTFXuUvgSOG1ZLmbK/9pg9kLToRaik2nhslMcSw
         f8N0rFjHECKAxVeGwTTUI4YuQcWm+aY7w0dKOqzF8x1QwWuKu5HsvTINBxEXBxWwc95U
         UT6yrwDt4LNX1XlVFwwn0ahcfAe+N8X0MLHch7P4VkP+5Omm+nrwg3OwKrRdP9DBDa80
         fnCWgJRXNa0BguDlQChN0Qc1ponkNx6AtmdYdcRuTKZCxjhv3NFRe8n00Nvq4C4MwGs6
         e/yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795520570; x=1796125370;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/z5ch5pLpPdbk1BmHD/hwwHu03qByQafwYZQeBV/lWk=;
        b=1W3n0QfIwi2aFTemzIc+bT8l0oi9iS9lWZaXqaOnwTBkxsdrRzuT09PDz0Q48rkJpU
         DgcqyPNgvKMwKvBxHgl9FJDv9zGF0Y0vWmRCSEtNg/i4OOVMy3G0VQm48tHZxtzXfzw9
         BQZixjyHyEUjJ/GcFBELl9hQdtdPv2R58s+XghesmoYu7SavyaGIuqNG14vLCaV7UEan
         Xj1L2iGPv9vZFy+0dOn3S+Pc9D1zMxjdqeE9P+MZl4aw7gaZERwaf8nM/Xi8rrXPTKVc
         Dfy9Qsr8S7QDtnDx/+zDNspTUCOeYflSD+S+tTQbMGMS4dokgDsw/GTVMLW/wOVPbuFo
         vjyQ==
X-Forwarded-Encrypted: i=1; AL+hErH0Da3pUsKhGeX1/yZLw8vht+49cPi9020dF7UZGWM3jcTjRt3SD1ifyVoJFI0wIWiG/rttP2o7@vger.kernel.org
X-Gm-Message-State: APuU4Z/7GVqD2mKpVVtOsQhzXGM6jRYx5xW6wHDUfbG+ofFrczEYgP41
	4j/lysVADbH9RsDehYFvQXy0jJu5Sr50O6Gm8OkIrzPuj1QC+J1xIz6GOnSJii7UvMEWLyrLc9r
	lL0RwuZtHcLJl7C02HChm8ihd74d2mWY=
X-Gm-Gg: AZFdTZcvaMVSAbf+oAzpxoOoV0Qi0jf7F2Kl+Mx3OVbA21szsIfNeDFy5jrbZOj8MOP
	s4R3cP97c6HB20jFlUcK5bf07sT0JKDowt5QzXxbGpASrXupFdmOt+D7gy3ffzTAVm+B9UFuOo4
	5fZz/OSh2rhLDwoV+pct41nQmt3yTNUmaTZDTEH9a7KPBR4gv+gQ0Bfjxa0xxxy49/D57JL//7o
	l/ZD+bK2t8fYr5PksGu9zM91EBwMeGcyF2/cxeKFfybcxAF9HcayLbwaedcKRBHki2UlezbCMW1
	wSdHhJIxtLDtMkR9+u20xwNQDuztmj9xhHEFnOmcZqowl3RqUn/ACgI2418GmrBWJpXNYLkIhbA
	5T0UrK38j7t/VuPhVYan2owOQ15XVbrgOvUu5
X-Received: by 2002:a17:906:1255:b0:c2e:378c:8ceb with SMTP id
 a640c23a62f3a-c513ab2f292mr893283466b.36.1795520569665; Tue, 24 Nov 2026
 03:42:49 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120095559.429515-1-xavier.qyxia@gmail.com> <awBN9VvV6yM6Cjut@casper.infradead.org>
In-Reply-To: <awBN9VvV6yM6Cjut@casper.infradead.org>
From: Xavier Xia <xavier.qyxia@gmail.com>
Date: Tue, 24 Nov 2026 19:42:38 +0800
X-Gm-Features: Aa3M54qQ26PffOi-ROWCmcVbedXfEWG_6O8l67P-4AZYWdcQV7atuYSopUWOUaU
Message-ID: <CAEmg6AVjtaiq9Q8rC_V5TcgAxQ386CsDtiXO7A6UzC+FzNdGTw@mail.gmail.com>
Subject: Re: [PATCH] mm: batch per-task lruvec stat updates on the writeback path
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, shakeel.butt@linux.dev, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	jack@suse.cz, david@kernel.org, brauner@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Willy,

Thanks for the feedback. That's a fair concern.

The original fio benchmark uses 4K buffered writes with fsync at
the end of each job, rather than after every write. The improvement
is reproducible in that setup, but it is a synthetic workload.

I also tested extracting a tar archive and copying a tree of small
files on ext4 backed by a ramdisk. Initial runs showed 4.3% and 3.5%
reductions in wall time, respectively. However, these improvements
were not consistent across independent boots, so I don't have
convincing evidence of a real-world benefit that justifies the
added complexity.

Further testing also uncovered correctness issues in the patch.
Deferred NR_WRITEBACK increments can temporarily be missing from
the counters while completion decrements are applied immediately,
potentially affecting dirty throttling. I also reproduced 8-12 KiB
of stale file_dirty accounting after fsync in a non-root memcg with
periodic writeback disabled.

I explored a writeback-local alternative without modifying
task_struct. Although it passed the correctness tests I ran, it
did not demonstrate a reproducible end-to-end performance
improvement.

Given these findings, I don't think the current patch is suitable
for merging. Please consider it withdrawn.

Thanks,
Xavier



On Fri, Nov 20, 2026 at 9:41=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Fri, Nov 20, 2026 at 05:55:58PM +0800, Xavier Xia wrote:
> > The writeback path updates two lruvec stats per folio through the memcg
> > rstat machinery: NR_FILE_DIRTY when a folio is dirtied and again when
> > writeback clears it, and NR_WRITEBACK when writeback starts on it.
> > Consecutive folios almost always share a lruvec, so the same counters
> > are updated over and over.  On a 4k buffered write + fsync workload
> > __mod_memcg_lruvec_state() is about 8% of the profile.
>
> Is this a realistic benchmark?  Does it represent some real life workload=
,
> or did you just choose it because it shows the best benefit of this patch=
?
> This is a fairly significant chunk of extra code, and it'd be nice to
> know that it benefits a real-world use-case before applying it.
>
> If the real world usecase is more "there's some pretty high overhead
> when flushing accumulated megabytes of dirtied page cache", then there
> are simpler solutions that don't involve messing with task_struct.
