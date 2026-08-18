Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693CE33BBCC
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 23:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787094123; cv=none; b=RlwTB/JQAzIPfUumwaGY+FQx+xKd69PsOKErm53+eYdjWkV+U3Xw/wshd+T5lVJJ3Aiisix/yjIUW6RpGO05Z+6s3QO2Y53nX2qepswlXAiDHMGXm6yR/RYr0Jza8AZBoCyTwX3ZdAv7vdpwpCg/tjzkKpzm73P4JQRKQ38oAEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787094123; c=relaxed/simple;
	bh=LFNPoDeeTwavqXDYvxKz/k1t7gN3cxa/PZ/r6DBfaz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XUelhcvjxTENF8jN2IGwia4u0iJpockLfpzV1sKCyk662jUbdK9JSu5Yg8N6iiAbTgja9LZMSRFyr9Vnokk0vdIskt5JkEHzbSWgv9pvjLe5ExpQAGzQte0d28sx4zjRYMK4w2RvJKk1w8fb7XrDmfOuW97sPjVJ3XH31C1z8X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B/xOsERq; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B/xOsERq"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cc7e86e7aeso4035355ad.2
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 16:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787094122; x=1787698922; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jjfWQTULW6kpWj4uQcqe65fiA3Rop9X8RDu4HH8k3wc=;
        b=B/xOsERqIgCHWDOaMzy5GePw25OdJ9GeVqYJEzDQPsIyPRuRHWsfBJ7iAwZE4fZGC/
         l3fsT0PvL4SjsE49AnYsX1JiOi5gMeLe+nEvZK0AKBn+gx1GEp+8VJq2pHAGJjVqBS2n
         g/pasXB8FcgNvFReysZ8YVJQ91XHEnZEL9mnrSttJnjRKA9Kp5XDI+e6mYtqYk3/Wck0
         0Zr6QDaU9O20NrnyZCccqQYHXVpQePtC9oAum1JpSCQCiwFUBTFV4TsznhIz0wLeQ2lb
         jXRBR1ntij6h0j4ZYa8UtmMX/Oeq5dRwpSZTEHh1NOusZmHE/L/1SH66/yKgK8PMFVNG
         vUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787094122; x=1787698922;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jjfWQTULW6kpWj4uQcqe65fiA3Rop9X8RDu4HH8k3wc=;
        b=Jc3SPwqYYmhEt1LYsgxDlX5aGXR13xtDrtg/azf6Zohq3YBYS8PAC4UlkPgeytCcG+
         dpFPtcal18YAF8TiFaR9uTTDc7GTaInKO2GGnXeNe5FjLKiVycu14BELyOLbyz8taUX7
         1JQJoqr68Pfnv2cE+4pqIGOGbNHNwBVFEMqLYNx2/DpDmqjqB/Byd6qxaUsdTgxiDPvX
         41+CHFzsKRWRNHknQq3T2tuCYrjk//eSdKBw1ulXjLK1wzTRZGoPoLcWCDDBI9mi4z5b
         KnjtUZFLcoI7DjZ0ewOXyMffeEcQQZNJvsPg0TvuAkz4V631BxYD5yQ0kmBgeYz/0KGY
         HgTQ==
X-Forwarded-Encrypted: i=1; AHgh+RrUMJmmn+banTAaL0myhvrQtFbec+/jf/LfOJAtkD7HA6Pt1KEVPd3eGIbMNMK9fzi9A4IaqxdW@vger.kernel.org
X-Gm-Message-State: AOJu0YxzYecQ5aA28wM3qoPhoMjBoXZJBdKWyIJXq/uaROTu/lUAHYfq
	pHKMPkE5W/AYiID1YKf7rwxisWa8JS1/ICi1/pW93A7sz9VgXQI6V+ug
X-Gm-Gg: AR+sD11z1J+RJ3DpqVUtlRNcw91E0eQtxdtcop9PAICc1Qh3nQMrZeIPH39nFQaoAoC
	LPE4/IX5IUuFjvuAjYsRCLuDTVTwXcH/2BQM+oNrGJzhuy9C4hgwMmWmu36aoMqWg7jBsCWxA8J
	axNI25j4tICvEb0rAxeDa4RLg1WA2OKpPjiyHCiThd/KVHSy7Fv5fCta2FL9P2Vdh4YaH+KZuTY
	j1Jtj9iZSlltweHS5I9K8MWGtXteY56Z7i+khuhJmJQrryRtghNFHrNgP/W25uxCDk/N2THRVxR
	F/ane0ws+BvTPg9OBqGcLi5fFL9qEW+jb5ymm6yxN1xbi2jVddUEmiigL5WcGz+cv9wAGcgapqc
	rvRPPXwu6AgCU6MPiOnPgt/tD4xGq/iptdZWkFPSYcBKEHxQ71au5q4W5gApGPc0WJt+dT8wIyG
	H4r9ZIparVsuCH8msnkneki3ihSH05UUSXcPsTj/khsCMEEFM9jgYIMDC6CyGZbeE9VgCo8jsE4
	MZWjnwV
X-Received: by 2002:a17:902:f682:b0:2b2:67ca:5ff9 with SMTP id d9443c01a7336-2d5fd41d626mr5840475ad.0.1787094121673;
        Tue, 18 Aug 2026 16:02:01 -0700 (PDT)
Received: from devvm16600.scu0.facebook.com ([2a03:2880:9ff:64::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bef3bb51sm456874eec.6.2026.08.18.16.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 16:02:01 -0700 (PDT)
Date: Tue, 18 Aug 2026 16:01:58 -0700
From: Ziyang Men <ziyang.meme@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: kernel-team@meta.com, Jens Axboe <axboe@kernel.dk>,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>, linux-block@vger.kernel.org,
	bpf@vger.kernel.org, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] block: add BPF kfuncs to read blkcg io.stat
Message-ID: <aoTkZhQDoaQKpPe3@devvm16600.scu0.facebook.com>
References: <20260817214205.723267-1-ziyang.meme@gmail.com>
 <20260817214205.723267-2-ziyang.meme@gmail.com>
 <aoSUob1s8WBQ3buO@slm.duckdns.org>
 <aoTdQeLZZuRirNHE@devvm16600.scu0.facebook.com>
 <aoTf7u20mo9s6ADj@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aoTf7u20mo9s6ADj@slm.duckdns.org>

Hi Tejun,

On Tue, Aug 18, 2026 at 12:42:54PM -1000, Tejun Heo wrote:
>On Tue, Aug 18, 2026 at 03:31:29PM -0700, Ziyang Men wrote:
>> Ok I will add the casts bpf_get_blkcg() and bpf_put_blkcg(), and remove the
>> check of css->ss in above functoins.
>
>RCU_PROTECTED is probably better than get/put().

Yes we can make the blkcg* RCU_PROTECTED but then the bpf_blkcg_flush_stats()
needs to take the @cgroup* since it is SLEEPABLE. Does this work for you?

Best,
Ziyang

>
>Thanks.
>
>-- 
>tejun
