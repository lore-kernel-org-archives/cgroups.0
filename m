Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908324;
	b=0ByL8+AgzWny1pgXSbbyW+RCtsQLuwi2GbHwY5Cu+9uLXr9sAp4xr6y2Ck/cC9AkzelE
	 dE6bInPBTW3HXBQ3s12GAN3kXFJElRjN1Lb3YgwOELPDuWZiulFBLNGCReKGf+5R8Vilm
	 hYx6m0hQscz8xetFXjZOgiieX4a/k/7jPjHo8dEUErDdJZX/5Zlr9KIPt2KVBiH4uGv7e
	 pHSzhd5TVJY+UaxV+dZJsvFMvMx/whSixcwlPfac5H36NNeD9EqoTLXOzbqRYop5sU71/
	 XuQKysD26lvriSX/zg5paU0guxjdGoZLuaoF9NrpQ7CjeCfL7YVlEli5bsp1ZqOP4Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908324;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=E9t5hHnAag1EnA1IvHhWRwDHScTDeDJAqRJADEROHAM=;
	b=qE2uo2m3O/TBaC2qaz0FFxlbNIrt2AU912aqnE7UDjfrHAVuehkMIerPJ/kyL7lb/WN1
	 h+SDoPMSewLMSmd2yXRgR2FwFpnbaaiFePJQIgdESPQurSjGHdI5ovP76wTc/T7xrpTXz
	 mZsamKyagCoZUxfdV+YvshSefTXPQ3X+xGZ87g2XjaU5R0zZAkHRrY/wBF5gVyYbxUoAJ
	 vXUmEF1R0Jqe1Za4w6iYQYmFilLqbmQWqWgTR/X6HjvHSDVRGiN//iSIpPDM+v1YJx1FU
	 KzRYVs1D7NYvNX7E4wuJ/571m3T1ZSj6GahPDTLiWAbr+YOdSm0JAU9hs7Ye35jOn4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PvJMfIQH;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B203606A6C3
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 19:52:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B203606A6C3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PvJMfIQH
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4af520023fdso6188645e9.1
        for <cgroups@vger.kernel.org>; Thu, 05 Nov 2026 11:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793908322; x=1794513122; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E9t5hHnAag1EnA1IvHhWRwDHScTDeDJAqRJADEROHAM=;
        b=PvJMfIQHklp/6lrIJDb4DxHqeo8UgGdpsAu9dqQBOFpKyjqnOfM/bLgV3jxURH5B6C
         peftRdY9+W+wmrPZ3XDgPPzndrl8XFrtQKEW2KmejcJyjMbVQytxJ4wYg+NEdbJ+kAMb
         YgbG8/TLr5IdJxT9UkKKgf0QtKgOPlH9VIMBTFgRway+YkJj8wMlFpeYvfN9mFDljH81
         vt3JkDpxF4pVmCMAJhLHG6iLtEDLCGbY1lXGeo7kO/Y4waQ5E6rMiaH6J0bxlSA1sBx7
         SFfRyAQSlHD9i6J8DHV2lrf6bpl0GeOeyt6r6SCkSKRHbjY58i3VmbMTDSjXjjNcp9Ik
         h2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793908322; x=1794513122;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E9t5hHnAag1EnA1IvHhWRwDHScTDeDJAqRJADEROHAM=;
        b=tbkSopZg58R1WpayWJaSm/DF6iH0ihKkGTjIa6TW3/4ptqK6nfWmRDBwluSker9gxm
         br3xDHiU2C1Ee3vta5Z1jX1Oj14LqTq7W4qCymdkLtMsJkL/9kPqro7bMtJKzToKWeMX
         qMcbK5HcTBh3xQF+mi90a2mC5RhnGm2iPWKLecvw866fQ7jYyX2MyoxRc9suLsegov4z
         OW7Sj4r++iGZxua1T81jlRcg4/W3TbE+O0zEOsHPNA9SKB3NioJXbVca5zoeGq9Ll4JZ
         /3TsUKaNiyVhOrftntnI3auhpx+PjLYcE+XTx73a209r4kvbkx4NV8m2zcD788u/GYHq
         mt0Q==
X-Forwarded-Encrypted: i=1; AKwUvBzrINWtmXyNXJ2wQ62SKkBIbl8pDU4l9totkNY0wv+j4usl9VijBFzT1UagjZl/+m3tBohbBggH@vger.kernel.org
X-Gm-Message-State: APuU4Z/TKSWyxM3JSSGaw9B8zvqJ4j9/oPNDagFV5u1lKNADDEPxCGxC
	IraPRScbcqB8TjN19uzw/rDufRyO0qvLg9zS+ikjDJVfkEPzdi1YCyIW
X-Gm-Gg: AYBFou1RChvsJChiTQb/9Guen7+vn1MZBVcOlPs7m8/rVMUWOo1qio+jQlpA/odoEOs
	8x/mi+wUuln+cueah8sJEOtigfhZtfUQPOddrNMJ2NCkBoHsBQehnTvCadv2L3C3spYVrkl7euQ
	d+qAw4h0r91DooUdwTN6Rxv9B20osBfrr4Zn2SrTnC7CoPzVWHBeVM/pALx0bAc3lrfvGVKnLTt
	iTF6mWVIENZk7Mk+A0iL5ZvHL93w+uQFCmdBGwGcb/Y0nGRQVOtdnss7OaS3gTXkhUFKyh/5IGw
	EXyrEf9C1HsfyxoICNwciOigzGwgxeP2MzNsoeDRViJoDy3Eql37/LBFkDk+0bm+KZeNw2+FM1p
	OUV7f9xA6JebI/WOC7rH0KRCbcPaunGTqh2ahlWqEId9WvBIV6SGEvIIr9RpiXFoLHs4SH4NmEh
	7ee8X7lunQinmojaIOzygt4rvGN/1WCbyQulTwuP9cMx4vlEBvHguVzEHue5sNwX+hDqDCd7sMU
	w5/zJlW1HXGaiNN/Ea6PmDG5mj7bGGa/aQwk3vGTFeIQmd6uVLfpOxB2DsU3zhgHdUSXBzeewm3
	Orv/+Wjcm+KOcCH7JhElG3cNPZ13pRtp/q4NVwPnrV+jKPUHrA==
X-Received: by 2002:a05:600c:6d8f:b0:4b6:2242:d0be with SMTP id 5b1f17b1804b1-4b6d82b2c85mr3060825e9.0.1793908321669;
        Thu, 05 Nov 2026 11:52:01 -0800 (PST)
Received: from scheduler.schedules ([85.100.66.184])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b6e1b5d676sm2497515e9.7.2026.11.05.11.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:52:01 -0800 (PST)
Date: Thu, 5 Nov 2026 22:51:57 +0300
From: Kayra Cizmeci <kayracizmeci@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: juri.lelli@redhat.com, peterz@infradead.org, mingo@redhat.com, 
	vincent.guittot@linaro.org, linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com, 
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, luca.abeni@santannapisa.it, mathieu.poirier@linaro.org, 
	longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, shuah@kernel.org, bigeasy@linutronix.de, clrkwllms@kernel.org, 
	parri.andrea@gmail.com, m.szyprowski@samsung.com, weihengqiuu@gmail.com, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3 01/24] sched: Fix cpuset_mutex double unlock in
 __sched_setscheduler()
Message-ID: <auzdzi_ZIqmYFV-Z@scheduler.schedules>
References: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
 <20261105193359.1450487-2-mathieu.desnoyers@efficios.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261105193359.1450487-2-mathieu.desnoyers@efficios.com>

On Thu, Nov 05, 2026 at 02:33:36PM -0500, Mathieu Desnoyers wrote:
> From: Andrea Parri <parri.andrea@gmail.com>

> Fixes: 111cd11bbc54 ("sched/cpuset: Bring back cpuset_mutex")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20261016062629.2102883-1-sh_def%40163.com
> Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Waiman Long <longman@redhat.com>
> Reviewed-by: Kayra Cizmeci <kayracizmeci@gmail.com>
> Reviewed-by: Juri Lelli <juri.lelli@redhat.com>

You gotta add your own SoB, no?


Cheers,

Kayra
