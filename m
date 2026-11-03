Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793716295;
	b=trMUKVJmSXW1k2BFTlZW9OfEBhCrguVTqPvl23MKfx1bXaG44rShgSnFs3c7QHVVnw1o
	 YjDrUn+X6UDmQYADyy2toxHTMlfJey5xJWx5v2Myq/UUcR8A4Od9Ucbrs1cllrLfAmWVP
	 zbdxa7V8xwBtXeJq7WR60QceuKNx86sTZ9pJDX2qor5PYUIO3DHjjbITXTREia6H/RXBI
	 rma7n8S9rX0a4nsmjBOOmVfYAW7HyFlcuCTiFc69Ea8opLxXET/+mArrDfQSQUcyrpPd4
	 /viRR87l5Yr4pBi04++vHjFstgQ6sme59+WANDuNtXaYFjD/L+UCoTz+kFB1h+xdvRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716295;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:In-Reply-To:
	 References:Subject:Message-Id:Date:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Mailer;
	bh=KXzabl41ZeEnGrVAYqexhOU2oRggUUYi90hmQPge7Yw=;
	b=BCjZqk1DeBhqvb+AqVX0AmfLuAsBDVAcdG8HDw1d2tSHJRsa8TMfNIXEN2NMwfwprzfR
	 Cin64MDerlAKiJ63KTGZcC1bdrGF0pDG9eKDVwV/wWK1yGYhi3DThfFIoqO5GSSOBpG5q
	 E4pS6bedIfBe0gtFfzfrg7iip/E2YO6DM8ppfFE3DTgZmiFbTk2cQEimzphXhwU3X9EoK
	 yxhEGizx3cOR72Lz5eLwrCQ8sfFl5MJv7+wuYarOSOPVnXhA4hr49gFO2Qr2JE8EgKDd3
	 6TI3YVrujAr8PxLX9aeF9hb2LFtg3U4FH2b5miMajXGGpO1/Wu+wdDDgDS/N/lLKgyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=pass smtp.mailfrom=kernel.dk;
	dkim=pass header.d=kernel-dk.20260707.gappssmtp.com header.i=@kernel-dk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=gCUl3iG4;
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9A360850AB
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 14:31:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B9A360850AB
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel-dk.20260707.gappssmtp.com header.i=@kernel-dk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=gCUl3iG4
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1ae18eb9ad0so4326728c88.1
        for <cgroups@vger.kernel.org>; Tue, 03 Nov 2026 06:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20260707.gappssmtp.com; s=20260707; t=1793716294; x=1794321094; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KXzabl41ZeEnGrVAYqexhOU2oRggUUYi90hmQPge7Yw=;
        b=gCUl3iG4R2jpywA1QQ9kJt+qOfE9h0zR8pM3mDaJcggKmtXx55bVra4P/CXDOGGj+/
         imZ08kKIS3RRKi4i1kr6kpejvmVS50Y3yR7/XTpaS5JuhBBEOCyp9/9i1kYWs6MdYrQl
         yLtTf3MHm9JQIo5zKXozqctrL9NL0pQ0pByG+gszIzL96BPuMiiHKfpG4l1yVo3qHknC
         ivAQ90QDSnWP+Xtrq1eQL0PFOdlXaogQ4drK57lZtwum7/hFDE05T7pd4xyEf/U46DKW
         LFl6oY2hd54Rfff9+G6Poc53Z5yB7GGzRMUmBl8axg/ufh8NqvuvLVva++p1tJA/A3o0
         obPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793716294; x=1794321094;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KXzabl41ZeEnGrVAYqexhOU2oRggUUYi90hmQPge7Yw=;
        b=HxKdTZFA5YRUce8Bk/31uGujV/S7v0yN2exJSTchhw231qATUXcWFCEsG7anqoIFr+
         dLGcJF26F6oFRZ57trzZj90OMKw8oVm4hmJqiY6diujTMPZ9HA0W+I6ljoXXqVVwkFdf
         koWkqiVnXdSCCIfktJkwcu7+GhHuOPTLST1+GFGqWTdFg8ldoMeXZzCOEaqAKsnXH4X7
         NBN/afvt+dWp1FZ9KJEhQnpAZ8Yo5mAEUqTEXuRnBIaZJEXEXyY7kSYycLLTeDPCdXTU
         gj1y3cm5ZHtKeennJpHNas+ww0kWn5nl0wMbnM5Opzvwu1TXi0N9mAnGDr2kyE2BL/zR
         SyUw==
X-Gm-Message-State: APuU4Z+q3vyTlAs+oyeLYWSUSKAP0l8cItVQAreay7g8FhIMAGQoV43j
	FNe5PKDI8UnVgXyfOlCovsvf0PiPHBChFoef1BC57lZ1ui9aG/wgcRt1sBXdDaRYzoU=
X-Gm-Gg: AYBFou20wnzqF0uj7Ny4MNQlx6Pvsnhd0/qjAIRpdllL2oYwFv+TVZsa4YLy8a99v4R
	pDViAwKLDhukrMpVccQ591Kfd2oC0zvWa9XsIOq802Ds6h3qf4un8YMZtfn8ZG3ck48kadZm1lq
	4kPDlxLFdBPnJzklreHnT5Ig1dYeOJBVyzUQa4fyRCfyDFJBnrJGdwTLSy+46lwlpun+OBqKN7E
	7A6c0PKIS04r3aW5MMjZ5VyMvyqczVh5RoWdtc7AeAOFNRaYEGAzrc2XZCaOEVP9qR5LNUVBDHw
	0bDLAIWzncGY8s/FH8PCA8oas3PYeNKHanCEFnfhs7FUD4wFPtbjTh1wWiQscg0ii/28rgACcnF
	7pihYBjF9T4nxogtIhdtv7Lo0v1zDh0UufsjEx6fomQrKBLaWvJNr6EjsH2UqlGC3W7UTd7hKGW
	0Q839MaSKzdF5xCRhDDfVZQtrLtiDcKEuLL/NC9+lInUTg5Gxzh8JB4hS7NIjA9o6hXS/fA3mQ/
	IBk8uL9RlGxAh9Yy2mRMUmqBs44PcIPyNXlbmLPQLI+6GKuG63FoTiNKmf/l1HaIaoDTuHprHK4
	ln4so3RimJbrQhpFb2nzq2+PDwyBQUtSUZqEQV73MM2dSa9SEiPgRY+giCxFl5FPrdwZS1hQn40
	l0wD+N5hT1p8B
X-Received: by 2002:a05:7022:eb44:10b0:186:5b49:90d8 with SMTP id a92af1059eb24-1ac5782fd31mr21082249c88.4.1793716294128;
        Tue, 03 Nov 2026 06:31:34 -0800 (PST)
Received: from [192.168.1.106] ([198.8.77.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b23b847348sm9534779c88.4.2026.11.03.06.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 06:31:33 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: tj@kernel.org, josef@toxicpanda.com, Zhe Liu <liuzhe1@kylinos.cn>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20261102061802.408173-1-liuzhe1@kylinos.cn>
References: <20261102061802.408173-1-liuzhe1@kylinos.cn>
Subject: Re: [PATCH v2] blk-iocost: account flush sequence latency only
 once
Message-Id: <179371629271.3691261.11171025306527479565.b4-ty@b4>
Date: Tue, 03 Nov 2026 07:31:32 -0700
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


On Mon, 02 Nov 2026 14:18:02 +0800, Zhe Liu wrote:
> A flush sequence with a DATA phase can complete its original request
> twice. Both completions invoke ioc_rqos_done(), causing the request to
> contribute two latency samples and adding the same queue wait time
> twice. This gives such requests disproportionate weight compared to
> ordinary writes, distorting the device-wide latency and queue wait
> feedback used to adjust iocost's virtual time rate.
> 
> [...]

Applied, thanks!

[1/1] blk-iocost: account flush sequence latency only once
      commit: e9804489e27dd6e33aec5511fe3780ff3009f57f

Best regards,
-- 
Jens Axboe



