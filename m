Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30E747F764
	for <cgroups@vger.kernel.org>; Thu,  1 Oct 2026 13:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790861345; cv=none; b=uzCoFE7XI5dFiMlQ/KvU3UV50clAf2ay2zEPM0Y5xiKS7UlyOR7AK7IJx3rhCbDxzQdtJVIipg05Hteg3fsO/jfRxaI84SuuyTOGQNGbFit1wuiaI/827/yT4O61Y/GXn8uy6SOraEstCiPXhz99D20YhWop+k8DIRajQXrMZWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790861345; c=relaxed/simple;
	bh=W5Z61Nq5ztKiixSzOg/KI+CWrMFLg5vyI2wky8v9fwc=;
	h=Content-Type:Date:Message-Id:Cc:Subject:From:To:In-Reply-To:
	 References:MIME-Version; b=TT8LLeiBuYjtJpJ9dojwegMP7M7av/PeXHeP/4F+F0TWMaWfJAlfolpZKZDqlYqapfWxcMZJQMXHZy2xO1ecJTp5LLSmtebDFW/i762vBCgYAdIRl6HZoo0cSdVWcpKebKU/YIO+PzljKtdUuvrRhv3qc0wMwxQ2GYNDz2gKmQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p+dPQ6Ip; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p+dPQ6Ip"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cbedd5aece4so230846a12.0
        for <cgroups@vger.kernel.org>; Thu, 01 Oct 2026 06:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790861343; x=1791466143; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=41trAFy/D/tRuSshg4paU2rmIdPH/gR2P5hv3iAAWQ4=;
        b=p+dPQ6IphpwIxRgcwWEZEA2sA7DrF0VLrDqOYBO8qziVvYdxIuDfAyjWtp8Wa9RPqM
         KH4q4SAzVOMaj+JRkfrXeb71FkAekMj4+IcaWrp7Qnf/5WPlWy4L6VItMpzzO0GYIe3d
         4nl2tUjcjHnqlqpowD1oIU2/TaAGgklhtV1q8DeoeTULFaAAcS2YyDFCEd8vpRVt5ONU
         xOaMV1iXUneSZGBacoaiWxG7UPP9vlJstglZNnNgBVfSeCU3YTVs2OcS0RpRoYyFSvCQ
         Ia8kJ52zq2rof+1MaM4VJEjWsIXCuZc+x/8AQwLpXax4YYICLyvGL1o1fYi7FUzcgJF0
         BPWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790861343; x=1791466143;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=41trAFy/D/tRuSshg4paU2rmIdPH/gR2P5hv3iAAWQ4=;
        b=oH2tEzNAreHfm7rg8Nfp/HBl0e6sXpsGQWzMbiyuHHTf8jxqtgRa9Vn695fy3mnqgp
         1JU+IuWfvVilWnMUqoA9OSjzg3+qsiXXMAxEIoq6fmJMU30n62YoAMj0WLwy+uDHDLZC
         GvuqQEelBlbpmL61mub5gAhWAXgclTV0jFm710faOwUf3vEcc19DoD1XZ9vpX+rFYqNc
         x0oUYTatGpne/whDLXbEd+2lMzHMFiPoiGQLIgvQGDFoJ8iKeiK7mypeu4HEEucW7/7n
         eWxjCvnUM/e6jThn+Sud175gSMF+7TOVqnpdOB456Oe6YoVYujlIqqstamgNYFUcqiXT
         GWgw==
X-Forwarded-Encrypted: i=1; AKwUvBxRSoyFYjFDE2E9iVH1BLfBJTSfKCGHu08yEy3BCckPOIq2z/xdb93wgtM8UmT0Jkk3orzRfGsN@vger.kernel.org
X-Gm-Message-State: AFuF++ncWInSqrmb7bY/UZWzusP6BfHkTerA9J+1Z2nWCFIuA7icoV9i
	OSHXd+s0g/JU4A/Vbf31qoVuM94u9nsIHzv+RrOGPJtQqYP8k7eV9WpLYOmjfyzF
X-Gm-Gg: AYBFou3K7+tAP8y8W+ZzCXxNS3AbtuZ+Vmj0lqETzkf/7c4se9f0IVPypDA3Hrx9qR4
	iQXyJ09Xmcljbd2hKUtk8fBPNAKFZPbKnJrrWb2SOb8P7zO4HjF26nBPk4CZmRNQ8SVbE9jrZfZ
	LT87Qx3m+7wpuPqMVBwXGVctmidKN7fC5M6nDWrtc0Qj5P0NAKLm2ZuI1rYX+3dpEmkaDRTpYqG
	vF9MmsxNa7z+4DrAOu1Vx98MtiNFir4rMwhJQ+FVknPdDWUcCyQbLZzNGiROnjn/fTmh9Y78CdW
	nEa8bIX+H1lhBKeeRQuiy839DBbN3eo09VHbm8c7lrPxjO5QrbBohI7hNM4FY0lC6c0zN7gbpn+
	6SDhkRZdSz/oBFxf1/S45EK/bKtuhI8CJQBGrvpL2emkTEdSyvrZkGC1JnGPub+m8/4d+wPZjcF
	X018nbg/Hnjklyo5c4TkV8L/5GpDclmMjUEW/07ukEYf3aWwP2UwnZQJFa7KRt0vUFwm25hT55j
	zciMaEkkhAssms0wu3YDZ8lSab0NOHhCW7m4sJMWNSSB46JO4CYwDNTwzuwMa39OO1vuIokSUiO
	G4XX0qPSTpsIhg==
X-Received: by 2002:a05:6a21:748e:b0:3dd:a9a9:396d with SMTP id adf61e73a8af0-3deace089c9mr2562419637.49.1790861342684;
        Thu, 01 Oct 2026 06:29:02 -0700 (PDT)
Received: from localhost ([153.61.198.250])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc7e5285aa8sm1549511a12.0.2026.10.01.06.29.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2026 06:29:02 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Date: Thu, 01 Oct 2026 13:29:01 +0000
Message-Id: <DLTJD2PTJ81W.FWH9UA1B59MR@gmail.com>
Cc: "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>, "Martin KaFai Lau" <martin.lau@linux.dev>, "Song Liu"
 <song@kernel.org>, "Yonghong Song" <yonghong.song@linux.dev>, "Jiri Olsa"
 <jolsa@kernel.org>, "Emil Tsalapatis" <emil@etsalapatis.com>, "Ihor
 Solodrai" <ihor.solodrai@linux.dev>, "Amery Hung" <ameryhung@gmail.com>,
 "Tejun Heo" <tj@kernel.org>, "Meta kernel team" <kernel-team@meta.com>,
 <cgroups@vger.kernel.org>, <bpf@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Yafang Shao" <laoar.shao@gmail.com>
Subject: Re: [PATCH] bpf, cgroup: fix cgroup struct_ops query for a second
 attach type
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Shakeel Butt" <shakeel.butt@linux.dev>, "Daniel Borkmann"
 <daniel@iogearbox.net>, "John Fastabend" <john.fastabend@gmail.com>,
 "Andrii Nakryiko" <andrii@kernel.org>
In-Reply-To: <20260930135159.3926039-1-shakeel.butt@linux.dev>
References: <20260930135159.3926039-1-shakeel.butt@linux.dev>
X-Mailer: mkdraft (claude review draft; edit before sending)
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, Sep 30, 2026 at 06:51 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> +#define cgroup_bpf_enabled_runtime(atype) \
> +	static_key_enabled(&cgroup_bpf_enabled_key[atype])

[...]

> @@ -1448,7 +1449,7 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
>  			return -ENOENT;
>  		from_atype = to_atype = atype;
>  		flags = 0;
> -		if (!cgroup_bpf_enabled(atype))
> +		if (!cgroup_bpf_enabled_runtime(atype))
>  			goto skip_count;

No need for a new macro.
When the key is off nothing is attached, so progs[atype] and
effective[atype] are empty and the loop below leaves total_cnt at 0.
All other attach types go through that loop without such check.
Just drop the check and the skip_count label.

pw-bot: cr
