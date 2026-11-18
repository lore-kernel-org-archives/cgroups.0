Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018059;
	b=pjLTmqE5huSYB29iXhxWNIzNufYiPQ2YlNN7EnsBw5Q8hqA8BrtosNvqRJTIYt6UV7j0
	 XBqbr4afBezJMvPpYsCo+gUdNJmV6ag3S0fmlQhcar9lhCcPYHX5zT9WA2FudlYW12YyO
	 YoYMleCVLqqkWyCLjVgrY6pZN0YYPIhsB9ukLNYOGjTzXLq9cafLC1G2fr57M9tWX4soF
	 zo2VDgZS0+ioQrc7jJm9UgybTYTunjOBRxwjsh9C4xL3PSJhCummP8mWCnHttV9UnAYrd
	 ys0Awj0Z0vxvt/q17sB8xWwFI6DLIHf8JdnJ5z9IPCZ3chDiIsWuqYqrUJvYRRRCiSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018059;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:In-Reply-To:
	 References:Subject:Message-Id:Date:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Mailer;
	bh=CV7oamrSYXfpp3NnleoEpP5E6f5lbD9kU3nbbqKEnc8=;
	b=g+/dwkdUbn+vgw6kPZz85DjXPYuJZYqQec4o0kIpZlK++RJLMNQZ3lNX5c0w9d5iXVdt
	 ZUc2RwcZkezvIfMW+F0jvnQzRdzMerHu+AxpcvuUsV8s+3Jloo46avov+mjuBUXE/G1ma
	 VXdbQQ2ky0lLagk4yC+RssPVoTbpWrcAARs7OpjnRT4Vi6fNMi4+YsipqaA3dR//Lv2qH
	 4ZEaD07bospkHiGK/AleAamy9hdnK+6MSMOqgthUD374d4DxE3uqeqgYKwzpLAD27IdL4
	 TupYxn1OaDoGz+jLMEOfc39OHbbQcvZptfV9Nhi/5I68tpn9YTnqNDcbxlc2FyjZcdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=pass smtp.mailfrom=kernel.dk;
	dkim=pass header.d=kernel-dk.20260707.gappssmtp.com header.i=@kernel-dk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=a5rhgeb3;
	arc=none smtp.remote-ip=209.85.160.50
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBD1606A331
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 16:07:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCBD1606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20260707.gappssmtp.com header.i=@kernel-dk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=a5rhgeb3
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-4a76f0cce5fso596709fac.2
        for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 08:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20260707.gappssmtp.com; s=20260707; t=1795018057; x=1795622857; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CV7oamrSYXfpp3NnleoEpP5E6f5lbD9kU3nbbqKEnc8=;
        b=a5rhgeb35b8T5xllNNAeAnECO5OGWZ6FRR7g3JBTBjO3p29UNlMA5n5uAkVzlQrWDb
         9X9tktBgkFW+N1AWN82LjGdQogSQ4C20Uq3ZqEfNc6b6QQnInosH7yAuraUEAckqLXRN
         H8QXC6YWgM0rKmm4+aQArZeRlYHi5A9ujcVq17/4jz1Po88aC8PZnbgZwqfdfkRwCDwC
         qIHH+l6buu7Fbly+5y4La0q2XL0yaSHrAlzPVTYXoW28SKbupT9CWG8AVuN6tBNNGPlM
         8hw0B9CbHIRCEOd4dlJM8dAk2Ph1GA2THTGe5CsJF+6hPmUpcm7u9I0yji42m2YfX3bz
         V/bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795018057; x=1795622857;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CV7oamrSYXfpp3NnleoEpP5E6f5lbD9kU3nbbqKEnc8=;
        b=q3q1Shg3rSwhSHiY7wHGEp37Vb4fuh4jNCxa5jQhOHgc9dulE92SnY738KDWiVT065
         lBNdknTUb8iA4n/4xHg5MQ4ncc+jDeHMtQFOZTf6kAj+oWtE92cZYnfjhikec0i3soaq
         nyb7CUyNEkjGV0oOMZ0bIi2ojgNHzehpySBbfPrffnGZV0Y5NeRahjWU0hqlfoWqlSX0
         8Z/pDxK1S/QWJ+zQuL9MWmRXHRotaSssnOex3dSy1OgaJWXi2fUW4RY1HS6zKclf9Jn9
         qhvlOS01tLwPt6BPEbo6AMOxhEazYCnzyJ4+1JVvVR23PSPRDmVdk4Ly3g0/3xKA3fO0
         /9OA==
X-Gm-Message-State: APuU4Z+6XLgCj0MQPC3+leEQ2HG26OYfgZXhm8uE+AzsBuzRqWd2A2DR
	YymWAMMY2k5LNorLHucU/3cZmP/ukHLEZJf0V6RugghCox9PIAsWmatevheU3r/BHWORB9h1Vjr
	prRzMT0M=
X-Gm-Gg: AYBFou06xneo6Cav7Ql8XCesLy27PyDPBWedEqik/APyZ6xP4F3um2W4ZeUKQ1R5bkj
	1X1vb8/bxzWn6u9obaWUzYKSzGvZMqkJ9mTpjtOiFSlOpbHJZPekHjDPiG7Hf046Zt4zQ1lO0zh
	UOMe0Bwd9VNlQqmRpDoLqAYdckZu3H9z1BqtmaXiry8bBwjc8zS/pFsmR/QnvrF/bTkt84dt0xB
	aQ50IZf28aZJAm+cCTxlb27BAAEpawHT/t2POB6hjoBK0pbw2pPtpklLqHY7ceh58AOKLUF7AML
	X2fG2JalVwfrBNK8/P7HxraNix1p32y2sanU7xx3PH6rDG9XxnPybcHvqQ5dpP5KD84AuibKZFY
	6ee8iqX0z0dHY2hagcoBme0tMRWZi9Jmpx4COBUPaK9hk2Uvzd1F2SM0AUdsQ8QWuhFDkIbLl/w
	cipSbW9WfMSAerFS0A8BQ2xtoVuf99ElBZDe48SehpnZbI5mfnbPN0R/ZH7QB2r0CW5MD6w/GB8
	aoX9QQOAymQ9uKIuHz7PvNDliccPhEdrlDnpD34WQV16gecFFx1SpuPGVld+tp5J0sVWpzaHHMb
	1LQlcGvKaDbWSVz0jWFDGL4xpAuai+NtzCUoF5OUa3kHLfe6GnIP5u7ei4uMMe9m0d178g+JuIU
	lUiAf8X39jDgZJiDt14U4Jfa7Wwc2AvvrDp9S27sXLynnHiTA8w4=
X-Received: by 2002:a05:6870:d285:b0:4ad:5a7a:f7e9 with SMTP id 586e51a60fabf-4b7613c52femr2613744fac.34.1795018057354;
        Wed, 18 Nov 2026 08:07:37 -0800 (PST)
Received: from [192.168.11.112] ([96.43.243.130])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4b743721fe9sm2624231fac.6.2026.11.18.08.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 08:07:36 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 Nathan Chancellor <nathan@kernel.org>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, stable@vger.kernel.org
In-Reply-To: <20261115-blk-throttle-wunsequenced-v2-1-1d297c891b82@kernel.org>
References: <20261115-blk-throttle-wunsequenced-v2-1-1d297c891b82@kernel.org>
Subject: Re: [PATCH v2] blk-throttle: Avoid unsequenced accesses to jiffies
 in throtl_schedule_pending_timer()
Message-Id: <179501805630.17649.245726738544852847.b4-ty@b4>
Date: Wed, 18 Nov 2026 09:07:36 -0700
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


On Sun, 15 Nov 2026 20:37:57 -0700, Nathan Chancellor wrote:
> After a recent improvement in clang to warn on unsequenced accesses to
> volatile variables [1], two instances appear in
> throtl_schedule_pending_timer(), which can break the build with
> CONFIG_WERROR=y / W=e:
> 
>   block/blk-throttle.c:469:25: error: unsequenced accesses to volatile qualified 'jiffies' [-Werror,-Wunsequenced]
>     469 |                    expires - jiffies, jiffies);
>         |                              ~~~~~~~  ^
>   block/blk-throttle.c:469:25: error: unsequenced accesses to volatile qualified 'jiffies' [-Werror,-Wunsequenced]
>     469 |                    expires - jiffies, jiffies);
>         |                              ~~~~~~~  ^
> 
> [...]

Applied, thanks!

[1/1] blk-throttle: Avoid unsequenced accesses to jiffies in throtl_schedule_pending_timer()
      commit: ae1171f38098098e88c13c38e462d27babb50038

Best regards,
-- 
Jens Axboe



