Received: from mail-lr2-f27.google.com (mail-lr2-f27.google.com [74.125.230.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDA94BA9FA
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 17:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.91
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789493451; cv=pass; b=U1iYj+BtTXlbKjDcgIyw7lzKH6BSWe3a/eMOR6TTsOajrf8EuCLjwKknqVxD0sA/pTs610UV5io7fBDEyteWW+b5MI7JykUZrbi8dXCLs/hhWLdS4bClXX3GH3q1aZ5ZIRyly+qlunPlzEQ7xJHHNgtx0nwutCzZQnVmUW2Z1B8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789493451; c=relaxed/simple;
	bh=eAukwx8JnJI3cGyI5uMY8PGJs7GR2oj88tMoLLoGPII=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JTF/OcXyLoRFdoQgOVPgkNIJ62Mb0R6u5KZ6BmA2JaUzcVleWSO+Zxl4+n2Wnf+QVp7pzOFf1/hr2w/TG6tVMGu1Rv+JloF1auHLgpn/sPQDBIcH2K7JXqGgrOKYWyRxbWNWaWPG1ZsSK0ikX7kz/eKboqT+cxMVVWFXEJkjXeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pMKXXO6k; arc=pass smtp.client-ip=74.125.230.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pMKXXO6k"
Received: by mail-lr2-f27.google.com with SMTP id 38308e7fff4ca-3a5b6840edcso755141fa.1
        for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 10:30:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789493447; cv=none;
        d=google.com; s=arc-20260327;
        b=E+iiabJxTPaOEkn2oZ/4t2udLXGv4gmvGvnVeTBsM9h5U8jZVDzZw22sfUAtN4q+ns
         kVdy4gOeOlkmdfxU9fm5zs9hWZP6xXXXQChY1Pr9PQa8sYT45/NB0ch76B0KotbpI+QR
         NKmnHkVjlL4yg5AYw/HEQhn6FCiINv6UWg59sAFF2J+xE2JRBKrHqWu/DrjBtcxkfQVJ
         oYZNH/i44GpNtekfb+ffossLwG9Amhd22rI4DyAXsN1PPMA5MGg6zK7o0xY6Nxt7cjgY
         +K0fG4j3TssLl21ZB6ew3MFnxdgV4jyXLUIm44XE7mkWVXQ/UtNs4sTkV5xojayD9i82
         uLvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eAukwx8JnJI3cGyI5uMY8PGJs7GR2oj88tMoLLoGPII=;
        fh=2Y6t/zFz45U5bNEPsulj5F0dn3ASF9gwlYNAGWXRiX8=;
        b=pYNRCiPdqksZnYdxxX3Zf3rnTCDbfJyu/JOiPJmv+5CuLnoitMMlyLdsDen+oMJakb
         fNd4hpRikZCQOphiIqWwVisRk6f3SU7WRq18W0p0haDbBgyx25sl1EZ9BZItux6OFWRb
         VUcztByBAGASMx+eK4X67EFRDIhZgWlj8xymZe3r3rpYCbBtqn2C/kmW93ZS3/ATIhhF
         sFJN8SQXX//1z3DFXWflWUsmRuxCoFZDfjjdq4ThWWirOZgs6H1TPRSdVREHe4POz7hk
         1kokPKcU4OE5QonS2XTCF8RIlK5AD1+GBydw7h72VyS5LZp2vEUdSOe9ck/ZLcjeFd9G
         XvfQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789493447; x=1790098247; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eAukwx8JnJI3cGyI5uMY8PGJs7GR2oj88tMoLLoGPII=;
        b=pMKXXO6krim404h3lA2CBgbZIVtoJ3AXBFXpC/pDA7sW5dwR/U4xQM1yl7VXrT8Mvw
         7wKqDpX5Ixgy0et2Qlw7jPxKGHJi453rrY+1OBAjVNGjpDSB3/w7g+AVTRCYn0NtraWl
         kyxT8fIel5gvFbIzM+gLWuVlVrtviHjW693GxDF4XgZ0iDfPyBG9IpMVqG7Vyf+Rzlkk
         xaE3nzrTU/XjS8MPcc40T25H/dnPBl9rc4Yr+ig6uCFYgkuhDT4eEWtpqrsQEvsOXXoJ
         WDVwIRZAgLFA/oIFw5MRmv+KGvSXlH8g6KugWMBZ+llvUQtQjDOH5Y3lH2ZYMZJ150H6
         SKnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789493447; x=1790098247;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eAukwx8JnJI3cGyI5uMY8PGJs7GR2oj88tMoLLoGPII=;
        b=ozq1XHFjSyAfiKIvaCQVjhukpnOQybDzk1l81I2iDTTFN7DUFUsXgzyMe3HLoeaGvL
         JXz1Fak1YcM/JvbUxa+rL0vw4Towv6E9FfG2JdvvbGYh+YjdkTuMJi6dv541AZU/0Evs
         yapp9xJ8XW1o4mnH9cIbxqXSCZKfP1XmVg1c+MYyrV3V5apYNtVQahbM0lSwzswiRY/d
         vxAPafRzD5KurD1AUb/RbbICKaPZtcP0xZjxarFucS7JBNf7hxOEJocLLRNcrGkTbd1T
         UZLC8ieIPFsm2CjueHqCVKY371bGtxJEd98Q3Pp4LKxEUH1YOPusZxfHvfDHaILzDWl9
         TJNQ==
X-Forwarded-Encrypted: i=1; AKwUvBzaysrF8WaMH2CBYIUUYfQuQdNOysf239C2BM2ChbB9JFFdGsQV6nBYNiOJeY31wTy7CTn9vihB@vger.kernel.org
X-Gm-Message-State: AFuF++mo5bXJTViF1dOnP2XevvRN9XWo/sLQrKK9CHIiYB+eLkj6yiWs
	ogzYpo1qCYMtFmc7bcSz+Q+mqj+YeMk/Wsn/3lQa14RXo13S5f+qUGr09Tw1auIEadP0HvGQ5P/
	2y/FGikhTPum0M+sCJNtgLotB7JD0Xyw=
X-Gm-Gg: AYBFou2zVfZBzHKtZmPY+l5IRhOt0r5hBbE3jHgHpxYqrEYRY10X16121S0EU8IEUtX
	LtGuYtv+s88RElNFGZa+yrWxoH9tb5VxqTXKiJMkqdIxhistAz3HFsTcpY/kxzZyH/dwMdsRqA4
	jhFXJLyaSegBeyHLwB8aQwZVy2WzJ6jW4Cd/ywF4TmLmXYmJOiuLVKV67wo+k2BONLR0Q5Sp7A2
	CmvKtO+CtoHy/41g2ZYOyqGNxXt9nmjyVSmuEbcQKDo9+ZEqp7vKBGbVvkA2kpXU0WsJ1Vu9upv
	AruTzBzBX8D5tNUoh3yODNYp1lL7fHdQoGVUD0u4ldKjuSrCeCSgmhiJNIfR2s4iHvbbS3L6Beu
	I5z6pA3m4VGIj4cx/ZgbiPA==
X-Received: by 2002:a2e:be9a:0:b0:3a1:ab57:ea2c with SMTP id
 38308e7fff4ca-3a5c887ed99mr24859181fa.2.1789493447239; Tue, 15 Sep 2026
 10:30:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260914-test-zswap-wb-ignore-eagain-v1-1-6fb715c22cd8@kernel.org>
In-Reply-To: <20260914-test-zswap-wb-ignore-eagain-v1-1-6fb715c22cd8@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 15 Sep 2026 10:30:34 -0700
X-Gm-Features: AcwNN1XbTKjkghV6cjRHkn5yooQUMbPEmMgoyX4OeoEMM6gp36nDsHu1A29JVbc
Message-ID: <CAKEwX=N=e+x=S1qq=9fsNgd63axDjjSWgL7MF1pJFEQw71TOVw@mail.gmail.com>
Subject: Re: [PATCH] selftests/cgroup: ignore memory.reclaim -EAGAIN for zswap
 writeback test
To: "Harry Yoo (Meta)" <harry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Usama Arif <usamaarif642@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 1:36=E2=80=AFPM Harry Yoo (Meta) <harry@kernel.org>=
 wrote:
>
> The zswap_writeback_enabled test fails when a write to memory.reclaim
> returns -EAGAIN, which means less than the requested amount was
> reclaimed. attempt_writeback() propagates the -EAGAIN to the caller,
> and the test case is marked as failed even when zswap writeback did
> happen.
>
> This heavily depends on the performance of the backing swap device.
> Reclaim does not wait for writeback (on cgroup v2), does not count pages
> that are under writeback as reclaimed, and memory.reclaim gives up after
> MAX_RECLAIM_RETRIES passes without making progress. On a slow device
> where reclaim does not make any progress before writeback completes,
> a write to memory.reclaim fails.
>
> On a VM with zswap enabled, where IO delay was injected via dm-delay,
> the success rate of the zswap writeback test drops dramatically once
> the delay reaches 11 ms: 7% failures at 10 ms and 79% failures at 11 ms,
> n =3D 100.
>
> When zswap writeback is enabled, ignore -EAGAIN from memory.reclaim and
> determine pass/fail based on the zswpwb counter because that is what
> zswap_writeback_enabled actually wants to test.
>
> With this change, the test reliably passes even on a slow swap device
> (tested up to 1000 ms delay). This makes the test resilient against
> the performance of the swap device.
>
> Assisted-by: LLM
> Fixes: 158863e5d7cc ("selftests: cgroup: add tests to verify the zswap wr=
iteback path")
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

Acked-by: Nhat Pham <nphamcs@gmail.com>
