Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7C33EC2E6
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 02:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785809833; cv=none; b=tHGHCu9qYhcET3qTixQqTjLPxxB4i/zhSN+PEmHP3Oyjhi35vfiM4GEr3H1GCHoz5sEFBnnOQhTN3bwQyZ0C05U89kzxIcwsAuHTc53ZH6tCGc3QrgEJt46GZTHJJUDfTuxxTHER5jYgcSc5GAIlD6MdqzMJwP+/RDOqQthv540=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785809833; c=relaxed/simple;
	bh=NAnpiWgfws9FS74DHuan7DMixthowGvqdCUnz10HlFk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hVU7oIIisOdjgQe0U5bzouYvFVVRCYE6/1h+YUACWpti+9wXzmHYpdlEJ0C5PsMuJ5RlE+LUGM4Dd99RNmk+N8ZSRkZ5naY4WjhJX5w5FbP7WHR4SWXZ3vdjdWxPouH7GE0ZzybKq99KyrsU8JffYBIsUndSgdAWByNfGdGOW9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=h4u2CF3+; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="h4u2CF3+"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7ee125ec926so2733494a34.2
        for <cgroups@vger.kernel.org>; Mon, 03 Aug 2026 19:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1785809831; x=1786414631; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oo3PGqHrxJ5gYaBHeUEq5xU64gA83nu6jSpdwaT7fRE=;
        b=h4u2CF3+SrtENgypgv97Kg4XudQ5ob2lvbgilQ8W4pAf1cHEOLF4nsy6OLwA0aSoQi
         vVGZLmkP5OcHefcSCS4HFHC+Sm3qz9dc8ctOpxQ+n3G4UpstJCCSROFhrLHmIcK1kcHX
         G+Vcc5apqCb0lMENtWTWROh7OSdmN7KnFH9d6w522e2g78h1hOmo2guYnruYLVnW893m
         RGOYcUgnMhyJImEKkjmD2WDGEh4wNQSBn/BoNRez176VqI1JAA5RtWLRVdQfl8v3deqr
         MzAcVwH4gKyymU+p8MjbKMQyDjwyPg+B22fzwN1IrITJNgLze6uhLA0jXoyfzua0IM4A
         gINw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785809831; x=1786414631;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oo3PGqHrxJ5gYaBHeUEq5xU64gA83nu6jSpdwaT7fRE=;
        b=pUgKZhlhsNIfZm0WLwQ73Czamy9DfDkTcbZ0clQCjRAW2A0/iMR81zyP3YTCFeS8v6
         GG4tIXlmTzyh3SEZgPT/94jDXr+GRSOBqfN3cWX3dT4rpVWN/mkUDGRUL1Zl/XDLp1ka
         20AARs1gSl1DzhCk/D4Dhm0cD2+NY22sg+6EzX3YoNk40P07DdmDwJfTQM53lqawMVBL
         PFCWCBWaQ4GclyMGxrK8x/4PKtq4VAnPE/8M3wediZiyThT/DRAr1+ZtZ/rfqUOyD0aL
         VWEP2717YPzdwnUNFtVozPxhAL1hHT46xLXLlIDjzdeD6Kw09o7kCxfqZJiD3+eu051A
         y6Jw==
X-Gm-Message-State: AOJu0YxJyfgZfEPOlGtPmUPo/bMqcUvTUMVovkwxLGNVeAZeGjikZFpp
	LjxlKYZ5x5qv3MYY+NCE4NU9IHTSlgflJUXBwSIhoNFpXtRiegdCwtEH0SV5VxaAQvOokkzzuYU
	AAFbDABkXcQ==
X-Gm-Gg: AR+sD11fR9+T8JddbAvfU7VHjbFEMU2dl+15UflFVriN1A4pnfs3EnYNw43ycHGXNfF
	SCL4mmWwm7eLFv2EBxB//i2Bg2cupfWCHFHTNsscg6MSGDbY0xzUHjtjpv2ApkDTZ4PIna+yl6M
	qrKSavmF37c5sEziHhL35Zv28jSKPTVv1lZN8dEhYtB6iwpOzinniIbjaRZDQwt8/mppSkWjVFM
	zHO3dO1eSY8XSkw07oDTwwxMZPT3qbx3w/qx95X4RtXYf9s40CzqbDkLYmu4nhYiWbFJcwKhvaq
	g7fpPHmZNBz8mx3voZ+HLyjTDTPagqY7f2dq8+I33wnSi7FnczawA1Tdh0jug9Ccqhjk0Oc2u8O
	VUCdReFmUERboAMR4GuGDu8ebXuemSzujmqEVOa4R30LZJNYLRd0TvW3YBVRg0NIzbyeA0fe5KT
	FQR1lWEv2mS1NdgqvVPNqPKELixSdXMuhFu9mfLPxIq9P+2oCOao+s6vBPCj2u1DPjQ/p/wvJ9t
	EF/yjJPdOmHDb1rNkaXHQ+tLulopoiWc+WJfVeUpQ==
X-Received: by 2002:a05:6830:3789:b0:7e6:ef2e:28a5 with SMTP id 46e09a7af769-7f196fe6ff3mr19369677a34.15.1785809830654;
        Mon, 03 Aug 2026 19:17:10 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f18f07a55asm8914812a34.13.2026.08.03.19.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 19:17:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: tj@kernel.org, Yu Kuai <yukuai@kernel.org>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, zhengqixing@huawei.com, hch@lst.de, 
 yizhou.tang@shopee.com, yukuai@fygo.io, nilay@linux.ibm.com
In-Reply-To: <20260802112525.3933753-1-yukuai@kernel.org>
References: <20260802112525.3933753-1-yukuai@kernel.org>
Subject: Re: [PATCH v4 0/4] blk-cgroup: fix blkg list and policy data races
Message-Id: <178580982922.518281.16495429438409271117.b4-ty@b4>
Date: Mon, 03 Aug 2026 20:17:09 -0600
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Sun, 02 Aug 2026 19:25:16 +0800, Yu Kuai wrote:
> This set fix some problems that are reported long time ago with minimal changes,
> the blkcg_mutex refactor I'm working on can fix these problems as well, but it's
> complicated and may not land in this merge window. So I think this set should land
> in this merge window first.
> 
> Patch 1 protects blkg_destroy_all()'s q->blkg_list walk with
> blkcg_mutex.
> 
> [...]

Applied, thanks!

[1/4] blk-cgroup: protect q->blkg_list iteration in blkg_destroy_all() with blkcg_mutex
      (no commit info)
[2/4] blk-cgroup: fix race between policy activation and blkg destruction
      (no commit info)
[3/4] blk-cgroup: skip dying blkg in blkcg_activate_policy()
      (no commit info)
[4/4] blk-cgroup: factor policy pd teardown loop into helper
      (no commit info)

Best regards,
-- 
Jens Axboe



