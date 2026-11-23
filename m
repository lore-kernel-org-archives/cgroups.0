Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795428691;
	b=C4ZSGxXLlgXlgoBdWarGqZerYsO5XP0hCKqEDkEw86pK/l9/dKj9aWKovOCv29JkajXi
	 ozs4TrjZDVO/5OX0zUCU19p6gp8e0ahr9vK/WdwH702kRPDbtfzuD7B6OZwYDEJHX3VMO
	 IBSOnwO9cjQkrsf86O1au0rVi85xxAzZexn53ypLx/r8dmUm59p43tT1ZjAcTC0IgpLeg
	 mo/Z/4naaaF/vKYJVnuIB4qBTsYpb5/X7MJ5xyhVUjJ9A0WVNqF0YktD16+K8DyLlrOcd
	 d6RXs8XYKBk6oFaH3MPlTWge6aRXb7gtk6Gq7nSucTWyh0+g2R5Eqy1lxRcL7SQMLtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795428691;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=DwLiyOh05b0NI0/gh6SV/G295VOAZ2Tu2Ln3fZH+sNU=;
	b=2cesE4FlnQptzrc+eF5Z588L9pviMw0RYAa/Z+B8ZiGmPkad+xo1/BmAF1j+1OQRydY5
	 9WH6+7CXU1EQ83H7tk03KZwAEdWsAVys7ihM0A2rD5lqqKqImnG2RPWnmbTookecLFxD+
	 imvP6Kl2Sr+kgtFIhfLKTLpnvXSWIAmbYKBbkZMq1jv5eRFXthmIM1viZhh0t1oQrJB1i
	 i6AaJ92x5wRBzHJly+J5WXcl/6+xa8ac4/6USwj+55s3A+wnk2EgRrzQG5r5ks9nt08nh
	 ILWIkt2WPh4wt1tSVAapWuXDiR1qy9mabKKQm6XMl7Dx4KWbMwxq/Nh7Hw3mUCjeGng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=AvOcnwmB;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4899606A680
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 10:11:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4899606A680
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=AvOcnwmB
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-490f38e9688so2118708f8f.0
        for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 02:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795428689; x=1796033489; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DwLiyOh05b0NI0/gh6SV/G295VOAZ2Tu2Ln3fZH+sNU=;
        b=AvOcnwmBq8inbiI9m2mNOhivNjDhZEVTlZDm2Ioz2x+q6HJmyvypkarwgoWjRWm0RH
         W7yDiHP3z22XFL8S3A5Rb+7TwkPsJf16FwO2E7VKKN2UqolgvoUAI+JXj5atwduzju9H
         OjuUd45u7LEXxAGUyCOHywYEx5CANlprVkxJw2OVA1xTJqcOlUDr5ExDhs0oBCv3CG/o
         TKwY3J3xacQ5dlCQ+7L4UTJJbQL0bxCvj6J5LIobbCngEdB+hJuqbeHHSiaTic6gLg8P
         gIF+bH92BY2pojuZMvGvM8LXsM1JnuQ2tGNdEtDhK+OV46jxW3kexYGxUCSgqpxXxSfn
         IfbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795428689; x=1796033489;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DwLiyOh05b0NI0/gh6SV/G295VOAZ2Tu2Ln3fZH+sNU=;
        b=10MQ/aM5yWES3VZpQomeyk5seY4N2B02/4PytWGT7tEVfnWc8xnb53dRz4KfCL05Kx
         ua5u4HiHbYZWtLSe1liiqjD6b0H9iv9RAd6ILxVVWopw+LpLNVT2aufIgGhlmQXVBph6
         uT5LieMffCq6cF1wGE2ayP7Uqhb4c/SFM1FJI3u53BZKBvi9D3WgyMbDln09LpJiWqa0
         5HPaTRr48ik2SZP30+pLJHosLXscrll7FymAG54O+EZIxW697SjiTsRod0V5lrqxTXXG
         SPqVJPnAq9wlXL1NHwsp2m2rpq/UcOfJl8sVlTbboub2p6t7QZHP0RHNsYVbShW+KANf
         hYvw==
X-Forwarded-Encrypted: i=1; AL+hErEcoH01djJRJGUCI0kjt441jEZ8OyT9nG+ro8FPMtts09arTLhVrYij6b/j3neKrR6Gp7VhzVo2@vger.kernel.org
X-Gm-Message-State: APuU4Z8XANaI14N3HMGzOT0d+C6PqYk3XCATuUQ/CaFinEoASUtRVHJd
	tcigNBZX7RsrmwFAFknDTZzGYCT80gscF97BRn6jPlXk8jKRdHSlhGoogwbs4NiB1OA=
X-Gm-Gg: AZFdTZf4xZbgsmd2yoPbSSjNq1VvXlw43rdoBoaaOrJ1TqTDK8gUB+a++2VMminUqkX
	csWjZh2G6H51n0oEFKhye4ok4cUJwQYIZWknzqiqkHhzOcR7QIfuEZwQ75P3r6CMloaabR/evNG
	fPXPVyxUlz9eWrK8pMIO2YGOYrUKTICXUOG62O3Lh1plvc7Cz42QWKk3EGnoXKCefNNVTi+2nzu
	T96VzdZvXA0mtlehOmf67aKcUT+u/Zr27V9hXXxSdCXdk/kX7biu9FFfYyJeYu3dJo5ts+m3eES
	BUFw++K/GPkWxnQUeuOsBridurevZ3bJtDfXZeIhmGRBNiO2omhaNuOvJCvhR9zyc8lnZpVekCE
	dCaeV0QeO2eI4ykZ06MLwOFkVqLMx42tPyWskJxTg3eCDBnHJKzeZ5rXDPquzvgh5Eywbi12+C/
	/Toi/kHSprhnOoMmPsomrl3pEDfb3B8IiaxsGz9XVdyN3fxFuKU3TPomCcWdZ5oIT+BrkByB8b1
	uE0W4aztsQJrFZNcMKzc+WiaxzQMDcP5DDMlLLij2jo31vamMVJXuHjoHwn3mH3YzyEfikwxq/y
	r/rfna6ociYMdZlUEacGkkFnBNSj8K1k9ciMxP8wA0Y=
X-Received: by 2002:a05:6000:2211:b0:493:72f7:1d5b with SMTP id ffacd0b85a97d-4aa5b235116mr26571679f8f.29.1795428689306;
        Mon, 23 Nov 2026 02:11:29 -0800 (PST)
Received: from localhost (109-81-82-199.rct.o2.cz. [109.81.82.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6a67fe75sm24009577f8f.24.2026.11.23.02.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 02:11:28 -0800 (PST)
Date: Mon, 23 Nov 2026 11:11:27 +0100
From: Michal Hocko <mhocko@suse.com>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>, Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	penguin-kernel@i-love.sakura.ne.jp, tj@kernel.org, mkoutny@suse.com,
	chris@chrisdown.name, cui.tao@linux.dev, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, zhanxusheng@xiaomi.com
Subject: Re: [PATCH v3] mm: memcontrol: don't miss processes whose leader has
 exited in OOM scans
Message-ID: <awQRT7InNqEF-K8-@tiehlicka>
References: <20261121073222.834282-1-zhanxusheng1024@gmail.com>
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
In-Reply-To: <20261121073222.834282-1-zhanxusheng1024@gmail.com>

On Sat 21-11-26 15:32:22, Zhan Xusheng wrote:
> Moving the exited leader along with its threads came up on v1, and
> there has been no answer from the cgroup side.  cgroup.kill had the
> same case: da13e0e72a73 ("cgroup: fix cgroup.kill for exited thread
> group leader") walks all threads instead of the leaders, and
> 5f4a3f743acc ("cgroup: don't kill migrated processes through their
> exiting threads") then had to keep an exiting thread left behind from
> standing for a process that has moved out.  This patch does the same
> for the memcg scan; the second case is what the live_elsewhere check
> covers.

Tejun, is there any strong reason to keep the exiting thread group
leader in the original cgroup? This makes CSS_TASK_ITER_PROCS iteration
really tricky and error prone as above examples show.

-- 
Michal Hocko
SUSE Labs
