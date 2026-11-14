Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794694925;
	b=iF8HDD2uSIF/67334qafxnH0uoVZBWw5iiuid9oqG/MVdDEM29hAowqY8T/660G9gOFU
	 3edS2IWK0Qs2adxJrmdnCoFx1Tjcbi6sL30jm8syk1vtjvWzaqImhExyUD6JkuMMgZnNn
	 xq52y09VcSiyyOIgzFzhohpT97uU4ZuVtrv1ICpzQL/FrOiwqCp7mz/drDimiSLUS20py
	 qdtDhWg9QEpJ7Rx4piipwMslQ1HZ//mycvyejqo53ErtV1rDwnuFZ6sF6n2QwgT0h0fjD
	 MWzZHAJG02AuZkH2FTzb0sHZY4J3MPmzgby9flDDUunhsS4vRed9n4L+OaVuMsLawqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794694925;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=iWHBYSDDRbBFmboyivmyPuuxpV2Imqwe1ws4K2s/aOg=;
	b=ZQo5zJjqPssMxE0iNe6RFGc71tSnAW5mHIkMX71AJVH3fFjrz1EeU7ddbOZVPurQlCwn
	 Lum0KSC+W1j3qDauh2Owvi8VPk5EsvZ146Jc70Vo+LBAe7N6KTYjDWuxKBT4kyF7H+RnO
	 8UipNUzBKQEKnBHRvtA0+vX0X3CmTKL8zFaTmF4Ilw1oBVFnXZ4FH7NzOSK47jtBMZhbq
	 dA5hl7bSV/5sOCJ266l0kP6TE5OJkYBV8YUwElm7lxeBeHtkYJgp4+lA6LuOzZwbCMlvZ
	 Ma53c7XpeVjoONjWZOHmshgCH37aOBASQPygMJWH67yVxjqP5Qq3vdYSF9YQjNJj1Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=Zxzss+ER;
	arc=none smtp.remote-ip=74.125.82.176
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E128A606A330
	for <cgroups@vger.kernel.org>; Sat, 14 Nov 2026 22:22:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E128A606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=Zxzss+ER
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-37986eb6fa2so2062898eec.0
        for <cgroups@vger.kernel.org>; Sat, 14 Nov 2026 14:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794694924; x=1795299724; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iWHBYSDDRbBFmboyivmyPuuxpV2Imqwe1ws4K2s/aOg=;
        b=Zxzss+ER748UbQmvseUJT9YFqCpzoaHruE873lloL0Bm+hW0ZXaEfQM1C4Q36vGIoz
         CUtTDJq3fXyhpTSJicdrlkl2xk5FP5yT1nTWn9sOdLxbw6GwdXh47enPNcS0nIopq/kR
         71fiPE9eS0MtVa5QFdM+7faXZicWQEA70MuYM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794694924; x=1795299724;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iWHBYSDDRbBFmboyivmyPuuxpV2Imqwe1ws4K2s/aOg=;
        b=irSC6eXPWWaidUDGdYhoZMjyQK4lw4M84bSwH0rOcPeovS0XvXJtKvq/MXsgnOCT9W
         lZIgGVXQhVaCfh5P1TPkAlOkrbA1uQWrAE4lx3C1ptOO285nRbAuum8jYHSm98RxsKdd
         qTvh6l3xKU6wkT1PUI0+YITD3HFVNUiqMQ7A1Trn0KximG56l9lRzZqEHAmZ7xyIEK+9
         b+z2oNM5piGDQKe9MS1bhrcI98WIliknC4aRCDJZFmKB0Z5KF+fSYv6jVHjoiXPax9Ng
         EXlVrnTRhBHI1G9WihBlpNAjKi6jy2xTu8Qg/Hc0PHyhRv2EbiLHVMLOsW++mueSY6lx
         h6tQ==
X-Forwarded-Encrypted: i=1; AL+hErH+vUOa4lOpumyYA0KsJOGZ35ETlMK/EDhSdGfHuiUqaxTy+d8Yr/0CEfYgKxABHl7Oh7idxdeg@vger.kernel.org
X-Gm-Message-State: APuU4Z+a4Jq5UTNDTObCR9QX5TbSk6ezJ9gQy5T2zTxarNU3ZL/lqDLH
	mclFrcDludSBcVE76M+P594vwA4NVX6Vg1OZdSHRrXOwcq6TcaC994Ry8xZmr+zhINg=
X-Gm-Gg: AYBFou2EOSr26yLHxEe5MBU/kEuMSRp+EjS1HnOjqO9lwAAgTcNSqBw58KUI4mtG++A
	s8cvqltYrDuCSxdXpHuCppzFT/tGbDRAW8bSq1OnV+tlQPHkC765vgv1wih+fMn8yToq+pcHV3i
	/bNVvqIIkMWIkRAjlGZXaWDmqqZGzvwu3EMKWawpJxcTVvsTT+VnbiI+85d5REJDnHI0XZ32ojZ
	pA6IlOoEBJKUV3T9XJUwD9mApLNp78mnjFI1uDpzrTg2CHbLNIgKnbaJcruxBPZZJPQVPIjt4sb
	ApwdZAx+ReUBrDL8qhzpIIdkTmkcQx9Z1LWWj6PXoFVZvOpXtwh03Uv3FWUvSu5McoO4vmzfw63
	cYSP90AGpYSeSayLEEP249xRrKUeE7rHAtvXWFfQ43W9LKQ3v6N4SxHssBfwYtM9UN7wKWM/NhJ
	PXADJlSv8lLfAj0u9G5IpzvSgwuToMAdSAzD35fjJqTB4bHDHkQaTYAM+bEve80uNWkaSk3mTJO
	slVOF/YaQ4IZEYnQTh5xXTTg97DIQwuw/ZQSz2Zd4RV4R9Edg38n1z6NsTiNZ2MtUGisaAv5Keg
	WvGSW9cWCpxy6TbPgDoQXhuhLfi5dyljG+0mq++UzSryKNFdn9cVp2n1qWFyvomd5kMv8noZOC3
	up5Cv7HUd8Nfb8Vg3Btp8FnL+RWMb86m2fMraHhUE4oHsIncpFdRvowBzYz7V4qBINangxOD+bF
	4vB8ELDzWYx/3N+GGTZmVtMQ/jiCxXGTwd5auSWhDuRkarbe/0CVGwTxpA94NOb8Kd9UfT5aCa2
	rbTfBdBpA0=
X-Received: by 2002:a05:7301:4604:b0:376:703c:8819 with SMTP id 5a478bee46e88-379681c6998mr7125048eec.38.1794694923819;
        Sat, 14 Nov 2026 14:22:03 -0800 (PST)
Received: from [172.18.0.3] ([164.86.38.205])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379569b8389sm33509247eec.25.2026.11.14.14.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 14:22:02 -0800 (PST)
Date: Sat, 14 Nov 2026 14:21:37 -0800
From: Chris Down <chris@chrisdown.name>
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	Serge Hallyn <serge.hallyn@ubuntu.com>, driver-core@lists.linux.dev,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] kernfs: Build paths in linear time with respect to depth
In-Reply-To: <91fa9a5de005245ed3c1bde305fc6778@kernel.org>
References: <au_pnu4s141ylqHD@chrisdown.name>
	<91fa9a5de005245ed3c1bde305fc6778@kernel.org>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114142137.ecf5e6af6608b218@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Tejun,

Thanks for taking a look!

Tejun Heo writes:
>I don't think a 15,000 deep cgroup chain makes much sense as a use case.
>A lot of other stuff in the controllers will break down at five-digit
>depths, and quadratic isn't that expensive when the base number is
>small. Did you see this overhead in more realistic scenarios?

Agreed that nobody should be building anything like that on purpose, and
at the depths people actually use there isn't much in it. Here's the
median read of /proc/self/cgroup in a 4 CPU VM, with single character
names:

     depth    before    after
     4        304ns     258ns
     16       549ns     396ns
     64       2.8us     1.0us
     256      69us      4.2us
     1024     2.5ms     20us
     2046     12.0ms    43us

What bothers me more is that whoever picks the depth isn't the one who is
affected by it. cgroup.max.depth defaults to max, so anyone with a
delegated subtree can make a deep chain. Every read of /proc/<pid>/cgroup
for a task at the bottom of it then takes that long with css_set_lock held
and IRQs off. It doesn't take five digits for that to become problematic,
either. Here's the median fork() + exit on another CPU of the same VM
while one task does that in a loop:

     depth of reader    before    after
     (no reader)        51us      52us
     64                 56us      53us
     256                363us     60us
     1024               5.0ms     93us
     2046               21.9ms    117us

(In case you're wondering why 2046, that's about as deep as you can go
without brushing up against PATH_MAX.)

You're right that other things break down at depths like 15,000. Just
creating that chain takes minutes. But that only slows down whoever
creates it. This slows down fork and exit for everyone else.

>Even if it is worth doing, the implementation looks too convoluted. Most
>of the complication seems to come from supporting wrapping to keep the
>head of an overlong path. The only callers that care about what the
>buffer holds on overflow are debug outputs. How about changing the
>contract so that on overflow the buffer keeps the tail end of the path
>instead of the head, which is more useful anyway, and the function
>returns -E2BIG rather than the length?

Yeah, that's a lot nicer, thanks.

The one caller I found which relies on the start of the path being kept is
SEQ_printf_task_group_path() in sched/debug. Its fallback buffer appends
"..." when the path fills it, which will now be on the wrong side. That
code is moving to sched.h in tip at the moment, so I'll send the fix for
it there separately, rather than have the two conflict in -next.

Based on what you said, in v2 I'll also drop Fixes: and Cc: stable, since
this is now a change in behaviour rather than only a speedup.

Thanks!

Chris
