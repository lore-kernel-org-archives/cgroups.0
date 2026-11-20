Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795179924;
	b=v/Q39Zbbp9NglYJHMKQ0pt8SamK0bsbGdSmXcM62Te7f/cftIOujCjy/pZa7apTvEnyU
	 1GqNKwXSNGpZe37N2iv/1JB+GJA3ztvSPFertG0cDOeng7jZoxYNemAxK3l6awejxW1pf
	 n9ZTQrZgkQYAK8t4lq+pCjQGHTkHhB1o2i74VRm+ZkVYkzWso57JPfDRoPLbCEeaApZW0
	 49qYIcppWdmOTHlwuHthcP9jE47sG2MVyZI6LibKdvLPVO6R5ea42AgWgyFwGWDOM04MT
	 8OcT7FKjmzzqZaGusJt1dTZvqbiH0/gMz0ckRtICQ7wUBCBZABxP70Uz5cNvC5RpNKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795179924;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=P1l8hjvVS49GyIA6u6rGG13XCHYYHrZ9VUNaIusOyIk=;
	b=ATZYh5o///xt+7THNO6fdOppp2T/8bKEeSQasSaSO3fzpJ3tsvow/MFwkDJMLsLccgfK
	 a6NgLDEGnqOQt02RoqT6LOJq0lVl61r8iFehRD9RsGHXYG4X+00/uuoEMOR65zlrvnoUy
	 67OM1oTfvxNFEJGrzY5cw9+FlAEHeAgUF7WN9NVqVHfmQyG3CqbEDyPY6fKJS6SUSqvTD
	 As8NjoiIaiw+Jg1wDTVURsQyid1lIACIQsTksgVrFf2G2UtGSI1+Wgvf8MsqLZCQESaOz
	 t51Pzh74BjigmwrfOW0+CfFZlXhbA0mkkD67UJSbUJt0aQX8aATJiJwV7Bwuk24zAtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OhjTY5YT;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b="a7E5Q/at";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD0A606A326
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 13:05:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FD0A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OhjTY5YT;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=a7E5Q/at
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795179923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P1l8hjvVS49GyIA6u6rGG13XCHYYHrZ9VUNaIusOyIk=;
	b=OhjTY5YTcuoDbjWOWWYh62bB2E3Uh/h0WJ2tdy2TnyM6djSce7ywoWMkdtsKgguff975BL
	A8EUfdT6oTlpJweZR+etDaniqErkkZl7rBsBkzzMa/1iOe6hrijS6yT6m646Sq0OFF/z4Q
	tYqp7wRsS3gmSLEEFh7vWXVZSzebCLM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-b1cJpt2zOdWfuyPSFRu7Bg-1; Fri, 20 Nov 2026 13:05:20 +0000
X-MC-Unique: b1cJpt2zOdWfuyPSFRu7Bg-1
X-Mimecast-MFC-AGG-ID: b1cJpt2zOdWfuyPSFRu7Bg_1795179920
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4bb64c99bb8so6554875e9.1
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 05:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795179919; x=1795784719; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=P1l8hjvVS49GyIA6u6rGG13XCHYYHrZ9VUNaIusOyIk=;
        b=a7E5Q/ataALL+4CgEZhd1/J5a6wtd4Qr7q0QjAm+vqgoEh1WazQWKqUvtZeABshdr5
         BZ8w0ow4XI0vd6Aws7ckDJEyccq1QNcI6suKHQHvEEyvIjtiLTuCkowo8BpJyelOWYgy
         /UOE2YHL2iWIVODyvLYMaEPe0ANXjRSe/Cfh8QFcyZY053+EzqA+hW36Ez418LE4lU2R
         GzmNt8iAVXH5KSugNbLql1JDi1189UOHJ9DiE3xrrw4i5QCQEgMmNhL+m8oPavLfal/h
         qNslfkxBK16Akwij5pxzwWlixaepoQY02h3PBfIvbW/Zcgbzk3v2zKinRBjyeev8MdbO
         pUWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795179919; x=1795784719;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P1l8hjvVS49GyIA6u6rGG13XCHYYHrZ9VUNaIusOyIk=;
        b=o3qfcPRpcQEW0CQYEWEjPWMRYQDZlRS7kr206KkAgx1KrO7SSsJGqpueT91s0/slDJ
         1Caz60pf8YiGBRi5DToIY1UaJdHhBNgAr4ab/c3ALJ3ZRBo8jcUHWvH+j/X0wCDnpSdc
         fV7ZSriHcQBv+FHg5bXwibX/apU9Kk3ltbHZTnYoP9furmuY8Ghl9X1DYoY85sxQXOwV
         q1da59nQk6Dku1X17W5HMljSCn9xbNVuxVFrRvxIe4QKQXm3MMcH6PUhEgXYBT2MTXZX
         /jYXjD404EzCz3ei01BpJhHcMFFw14vPCmx9rS3oMNyO0iMnHErtAVfKszgczgKyrEIR
         TVjg==
X-Forwarded-Encrypted: i=1; AL+hErFEiYo+A3zKzJWVTl/25Q7s6IdkaYqt7UYbTFys1dEElimAlPIZlJOFr09Ls5ft/O54u4TKIb6X@vger.kernel.org
X-Gm-Message-State: APuU4Z9Z+fJtc8LZupQ3I/kYX9fWs8NSzhWRcnpaJGOIFOffYIuEE4Aq
	ARFT1q+b7AK0NdZSnC1HoS0/KWYDjs1S6Eaz5oMR7bbrcirumItIssJJdOaMK5v6IhG9K4ubWwT
	szLvzBco2ek33WMjkemMfyjwbvfQ5ychT+2DSgP7EEP9HP+UVbBHo3ZPhrgk=
X-Gm-Gg: AYBFou3TwSzSFA/7iujVjKRb1/I0m8jxoWqvh+bPGzaODEvOw1XWgSBtspHWPL9wxOJ
	oTTipj4jVEYnBYT8AHVi6wvBu9dqGNlYFFRm4zsdvmIVHQry0Egt7QaMP8wsxBzEQ0OMFQM56fI
	kl05VWuBzMaX/PMKNeLSaEo5TUvGsfPjTJSiX2fAPIGZvcvcFmETMFDp1nzFALDOCG012hVwuw6
	SA5+pzFKnEWpLstymhHZJNcuF6Wu7TNzBkSz+yqVa7mEsUVZe2mJQkVBvJbz38pt+UHTxWz2eRU
	L7fIOpxKcFhULPR230j7IQTgqY1jq59hGuSEa5UUgP/BPw+cZqXwuVl0Si4lKJhbt93hjTo9DD3
	AyidX+Flg8foKoZ1MoWeYRh7ekKT808ygAS5VbqQbeX99AyEH2ZVPGtCJ0E1R2AiMDoQ1YhcOPO
	HSEeM=
X-Received: by 2002:a05:600c:820c:b0:4bb:6f6a:1976 with SMTP id 5b1f17b1804b1-4bb887c2923mr64603005e9.2.1795179919584;
        Fri, 20 Nov 2026 05:05:19 -0800 (PST)
X-Received: by 2002:a05:600c:820c:b0:4bb:6f6a:1976 with SMTP id 5b1f17b1804b1-4bb887c2923mr64602195e9.2.1795179919119;
        Fri, 20 Nov 2026 05:05:19 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8849247asm85099165e9.7.2026.11.20.05.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 05:05:18 -0800 (PST)
Date: Fri, 20 Nov 2026 14:05:15 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
	tglx@kernel.org, will@kernel.org, boqun@kernel.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	luca.abeni@santannapisa.it, mathieu.poirier@linaro.org,
	longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
	bigeasy@linutronix.de, clrkwllms@kernel.org, parri.andrea@gmail.com,
	m.szyprowski@samsung.com, kayracizmeci@gmail.com,
	weihengqiuu@gmail.com, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v5 00/17] sched/deadline: first bandwidth accounting
 fixes and selftests
Message-ID: <awBFi0bwFt5KoEq-@jlelli-thinkpadt14gen4.remote.csb>
References: <cover.1795115075.git.mathieu.desnoyers@efficios.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1795115075.git.mathieu.desnoyers@efficios.com>

Hello,

On 19/11/26 14:06, Mathieu Desnoyers wrote:
> Hi Ingo, Juri,
> 
> This series fixes 14 bugs of SCHED_DEADLINE. Then it shows the deadline
> bandwidth of each runqueue in sched_debug, and adds two selftests. The
> fixes come first, so that stable can take patches 1 to 14.

Thanks for the respin. v5 passes here: deadline_switch_test 5/5 and
deadline_bw_test 46/47 (move_cancelled skips), also with scx_simple
loaded (the server cases run on ext_server, hotplug_server skips). The
sched_ext selftests pass 40/40, test_cpuset_prs.sh passes, and there are
no splats with lockdep on. So you can drop "not tested with sched_ext"
from the cover.

I replied to 10 separately, with a readability nit that is not a huge
blocker.

Peter, Ingo, I have the impression this is starting to look good, what
do you think?

Thanks!
Juri

