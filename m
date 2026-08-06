Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CB548B37F
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 18:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786040710; cv=none; b=ZoiQUuuyqhziT/IhDq1QF0aC2CuaW8tAn8NYa0G0UJOAeKJvRtmNyp3n5Yj5ZPp+ypoBrUc8I/y81Hv3do/+7FH6dJOZ9d75t/5m/dJU9ITu5I7/OhFiv3ER7xRZfEWMDj8UTA/S0Mno4qSYKvgMRH8rJ1R9S42nJCg9n9V79N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786040710; c=relaxed/simple;
	bh=OAnGXhoMWN0VX4aRXp3qSN6EwUoruIJ70j69kxghWfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GreeK/jo8q5119S9SnG68FUldJ02FnQ0wBGw7bVS+n4zn3oSCVjxFQstCZK3X42pULMdjaTLwqwhctElVknGIoF9ARq0aWy7kftMoPpA2r18apnL0fQxitk0Q/OrqnvBUVwWK2bWi1WgMcxUCWOno7PhT1sHB5cKB/zsc3wTP38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rNN3IMG1; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rNN3IMG1"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38e7109321dso1701560a91.3
        for <cgroups@vger.kernel.org>; Thu, 06 Aug 2026 11:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786040708; x=1786645508; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eRxIpMxQf2eH73MswyccHSNChNNfT/J5n/NCnkKxEHE=;
        b=rNN3IMG1BNlGchnOjZlFZrkh2BI0nTwD6or5ACQrLo2bfQYsxI4LX8sKNjYEiew29w
         d7NlyengXoAoaRY6LL8O8zFGtGG8r1dXVYGAr4hzEGxxYD8AH+Ojh00kISYTcYrQvwST
         Pb3jXyPVZMU8MusBD+A0pIPluCWmxCH4Y9gfY3nLdG2RPWH9mzPXo1lxSeVFyTRasuV3
         jI+iII9LvtQHQLRX5lilQEw2PrhRsj62shYDOvIGX+lIJCKoODd5h12wLoalfAw+qBEd
         MsrtW4hsc0krY8hWLd88cS/kL0J1Iuj7Cnh2ngid9CB2RirbLRXCBopExXv2KwP/nOLp
         h7GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786040708; x=1786645508;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eRxIpMxQf2eH73MswyccHSNChNNfT/J5n/NCnkKxEHE=;
        b=AsD4kfX+/NnMxPjmzgzRWi9MITKIbB6MdRhNR5odj4loQWWiKR5hxOyjL29gFz9YSX
         IQoylOBXZekQj34l/uQ6e/aBp1xWYgo98TNC3UAPk+I8GVWj5iBKXTomlMNeYKxBcW4t
         UOUCxwoHa8XmPRXM2aeMUgFzG4L6kKCYawlyB2Iyl+v62fPbriUSCxqgOq05+b2n/mlQ
         UuIlUwodrDmMo/TBs9mXFoO5r7qBbfDYyxOLJ2iz+8T/sMTXmw4uOb4tt3azk3YA/uaE
         OqoT5yruL87MYepkvdEDPFxhBhIO18ZD92g1GDzQQP4EDabAkXtjfnkB01kVu+aBWIq5
         APDw==
X-Forwarded-Encrypted: i=1; AHgh+RqPSK7aLyOH2tP9yRLsZnP6coDY978rwSll8ysFB1Bjnq/XY3AtVHUV5cNsVu28nBSgdWmXZpsQ@vger.kernel.org
X-Gm-Message-State: AOJu0YzAym6HQBUaJFJ/kq0McViIYcmkWtvUV4vlpU0DJxjSV5V+5CP0
	ILFnZ/g6dY9WiTJHL9NGbgnR8/8V2J4FSLahZrg7jY1E4zeNiaHlwhz3
X-Gm-Gg: AR+sD13XfnIrusxf4PMJJGnnPWf9c+J9SSYjvANboweybz4XjwOe/3RuNTWQfqY8W1h
	nTRtjjpSk6UGnjjXH+XLWvFJTC7Nbn7spH+Y65XV2eN9P6nDozuHjcqVb4F0lBaAHTwZL4UoPqP
	XnuB68aSXnK5AL2n1VaeeggvaokXWaq7aAmBdHFqEIZ6AcRCQzkDuXJQCj1oaxKka8ehclFZUgh
	J+vYDRU0JwPAZJ6nT97srmTdtSfbGG41ZdEkiKVGFurhzfxssDM+L2F2gWa/0VkoriK5RmiMWAV
	bgu1uvARekf9PbrR8vOi9+gP7QXrU5iVtTWyLzYChswCDytaNP4ta6u4qr+5eQzchp5saFpC2eM
	80CF6tY/xzAUYSmqmDZBQL7k0pA4yNVck8Cx75AL9LO0THp8psE/Csoq9LhKQUWwieCMolpoEkD
	+nOxhZkqN+w13TcWfze0Zt+YIsWInrZcRBYpijY7rcQQOxx2sdDGC3aopn033EtDgSb/0pUSh3T
	J6eLiFc
X-Received: by 2002:a17:90b:3889:b0:381:973e:fa08 with SMTP id 98e67ed59e1d1-3903c5cfba2mr14353244a91.18.1786040708017;
        Thu, 06 Aug 2026 11:25:08 -0700 (PDT)
Received: from devvm16600.scu0.facebook.com ([2a03:2880:9ff:6e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315867bc261sm29668669eec.28.2026.08.06.11.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:25:07 -0700 (PDT)
Date: Thu, 6 Aug 2026 11:25:04 -0700
From: Ziyang Men <ziyang.meme@gmail.com>
To: JP Kobryn <jp.kobryn@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	David Vernet <void@manifault.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mykola Lysenko <mykolal@meta.com>,
	Nathan Chancellor <nathan@kernel.org>,
	linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org,
	linux-input@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-mm@kvack.org, kernel-team@meta.com, bpf@vger.kernel.org,
	llvm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] selftests/cgroup: add memcg_stat_cross_cpu
 correctness test for flush
Message-ID: <anTRgIZe5wgAsdCU@devvm16600.scu0.facebook.com>
References: <20260721174833.1232771-1-ziyang.meme@gmail.com>
 <20260721174833.1232771-3-ziyang.meme@gmail.com>
 <f83b6c93-b32e-434a-94b7-68628a2e8527@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f83b6c93-b32e-434a-94b7-68628a2e8527@linux.dev>

On Wed, Jul 22, 2026 at 11:42:58AM -0700, JP Kobryn wrote:
>On 7/21/26 10:48 AM, Ziyang Men wrote:
>>Add a test_progs selftest that verifies the memory-cgroup BPF kfuncs
>>return values that agree with what userspace reads from cgroupfs, across
>>a whole cgroup subtree that has been charged on many CPUs.
>>
>>It complements the existing cgroup_iter_memcg test.  cgroup_iter_memcg
>>calls the memcg kfuncs on a single cgroup (BPF_CGROUP_ITER_SELF_ONLY) and
>>only asserts each value is greater than zero, so it never checks that a
>>value is actually correct.  This test compares the kfunc values against
>>what userspace reads from memory.stat, and checks every node in the
>>cgroup tree.
>>
>Can you extend the existing test instead of adding a new one?

Hi JP,

Good suggestion. Actually extending the exisiting one was the plan in the v1.
However, existing selftests with similar purpose is the cgroup_iter_memcg, which
is in the bpf/. After discussed with the bpf reviewer in v1, we think this
selftest may suit better in the cgroup/ rather than the bpf/, since 1) it tests
the cgroup functionalities (bpf is a tool), and 2) together with the selftest,
this patch serials also ships a common Makefile lib.bpf.mk for easily compiling
selftests for other subsystems using bpf. Currently there is no other selftests
in cgroup/ relies on BPF and we think it is good to put this selftest here as
the first consumer.

We appreciate any possible suggestions. Thanks very much!

Best,
Ziyang
