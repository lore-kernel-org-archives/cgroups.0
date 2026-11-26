Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795671677;
	b=HPXPRCujHyMlBZRjrXA+iKiCNIAZdZGRULDhqeUloTNIoq8qQ1cMMg7aIpFhZXaEcq3h
	 np5fTU6V+2eto1nDcqv8Z7VeZ76YcjnRHk17INlrc6r+x8KNRIB2vUrY68J/Jq/68DL6A
	 kRnABG7sFBZz6HJrlLXS4/nVYvuTluDdhVyChTk4SPYY2fHikcXygVDlUYFYFJ3Qw6cPI
	 OIUwc/kaprTpC3sLrNMs4WbOZOukXLVYfrxr4fS3O/HkSObdM+FmfJTrV6zQAI+fejMDJ
	 eCM/Ot1o+bf6omehHSzbpqn0JeITqibG2scN4OubSFOaqf7GkA2XZuKwVHqYMC+JlKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795671677;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:Message-ID:From:
	 Subject:To:Cc:MIME-Version:Content-Type:Content-Disposition:
	 User-Agent;
	bh=p6WOCXUDLo3XBYvEGFmnbV8ReWfG0+FRoMB0FwCq/pM=;
	b=kbQuFTpA6jbVe5vNTlrBq9OgEWWD8KJHSXxU83RD4AzsC3+S4DX1wh+PA/5RirUA9rsl
	 5mh9dAFq0hOOiCXJObN6HDGcoWg7Lxdq98Qt7xFtpDQS3VVNuTiX+LZ682fo/VPRP3a6y
	 taQlUDdau2ip1oNqN4r6wA6qylbYZNX0zFn9+9ZWzTKI+kc85GTjRmJE/GJubV+h2WxCj
	 cHpU1aCW932tBUhUoWmfHR1OfDR0YyWt3JeG6HCDkSShD996VAXaH3EKRUadQZHzpx0zy
	 FkltXZubU+mX7iXcnMmXtKNCJ2BS5JBYagDD1ecdTRppwx3ijwW3gUpdm/MAQgU+2yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=DqvtMQS1;
	arc=none smtp.remote-ip=74.125.224.51
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C87606A337
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 05:41:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2C87606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=DqvtMQS1
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-67db3a48dc6so7931329d50.3
        for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 21:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795671676; x=1796276476; darn=vger.kernel.org;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=p6WOCXUDLo3XBYvEGFmnbV8ReWfG0+FRoMB0FwCq/pM=;
        b=DqvtMQS1VJm9HtcHJWTl6VFydhYSaZ/9Fxag7OAtZOi6zmABNA8kM6LeZL8F8lQLXP
         r+AcCfhEiLAkPlQLHL/LwkhfztaY+mOaR7qbvRABrgPQS+lLHJ1L7bEKZgfNHmZsB0vq
         Hz3fAFR6TBK6HIMqsU7h7RNrXSKgImEGp8cWM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795671676; x=1796276476;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=p6WOCXUDLo3XBYvEGFmnbV8ReWfG0+FRoMB0FwCq/pM=;
        b=p14KBCncwI4/GL5Ehq3UK0rYcEDVt8CfBLfgPpj7CHKFKQ75WdTyHvp+wrQsX8IMh9
         lO5vMmiXZ39HF3ZyPIjFdVtNak1ooqkf/1whqe9OIpUIb2wxM84L57tQfFRUtEEOv6Qa
         bFrHB4sIw/mfkT2uR62FWdv3+XwGoTW7pEsPPv1aXxD9tuBjpvHsud//qbajEWCer6Op
         o5Nk/RoPaStdcmCW46u4asvrAYNpmcV8zy1My/fxG03kc7DwA9tEV5UXmEo0QZiDWFEf
         3ozce5dJ4+XxuJDLsqUSHQYtgZ8Pi42v5pNMWxdw1f+alZNvTVPvr9/expiJnW2XWwTH
         0ZqA==
X-Gm-Message-State: APuU4Z9UwdJpX9WMGHtn8tDU8pJ2cBQxscFB2QUOQiaHtlou//Lp0aCi
	wDnVqA/be9S8j3/EkytBRZplDhiQ0WE/05CxbQZYyWAXiWe03pBKB4i01j1NAjxihgc=
X-Gm-Gg: AZFdTZdu5qIM5F0CghCiTJOrTJKBgmE3gYMk3bwtcsah2NDbFAmT4bBngLvJ+l3EnKr
	xuEvSf1xqb3pFA5376tzubmiZnvOwJ6eS3EiMZiVD7yYipXKJMGHR79a94xQY43e2M1Q5b6s63K
	U4K4Bi5fEFrQZnltabd87gyxSu7oJmHJ961V9jlP1bojd0nt/iNPPfMs1q2grgktb112QOrEsdh
	Qk1xeJw1lnWxA5H8SueQFQju4e1tU63PcrWovL3Xt8kyBvdroLGVqeHL16Qb5GiqPZH5gnJNMGh
	4/0T4yfcycFt9JwMX+tEnRb8QFgfknN3eaWb2wfycWw+0Yux9idQ17ZmtaZzCNJUNUTGIuLErEo
	vYwLyob51ulA3Zl28gY5WMnfZhko0EDvpS4Lw9rRHP/KTDtvGLxryVX2IjGFKC1tD7EbJD315tw
	MU2DPnFfRUqnRAgAszbjoJyAG0GtKp/LOIrnrHG7K0EudolIuS/9sC7DW+QiQfT2ki2pIP3ZbrE
	iiq/zr8mW8rtzukAVT7trZy/UZ4vvN7cGPmNoSFQfFacFdAyj4JOnF9IVY08IRQPWy88+FtZKvc
	Yix9RWD7RvCAzpnRxHKrhAT/iyRe+KibPvivwSuMUdi7gwDSGuK2v8rbJl0tjx+SsEdMfdC/bN9
	OrVsuGIFjOvh2RIIsj27p2yB4wnWiTzuoJ708tJnCYjVGEC+76mbCR3op0iWo+krLs4Sdq611j+
	ffxqFqBKxHjQjMApFrYQrgrjizOotCj/xe+xDO3yPejBw13pX4CgF0bLOTKces6eHzFwMpClgl6
	RGCKAIqoMVwgID8sfXmZQ4=
X-Received: by 2002:a05:690e:1c1e:b0:67c:642:8f7b with SMTP id 956f58d0204a3-67df43f3278mr6352760d50.37.1795671675787;
        Wed, 25 Nov 2026 21:41:15 -0800 (PST)
Received: from [172.20.0.2] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67df3378f59sm9198592d50.14.2026.11.25.21.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 21:41:14 -0800 (PST)
Date: Wed, 25 Nov 2026 21:41:12 -0800
Message-ID: <cover.1795671629.git.chris@chrisdown.name>
From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v3 0/2] cgroup: Fix cgroup_mutex deadlock through
	cgroup_parse_float() oops
To: tj@kernel.org,
    hannes@cmpxchg.org,
    mkoutny@suse.com,
    shakeel.butt@linux.dev
Cc: cgroups@vger.kernel.org,
    linux-kernel@vger.kernel.org
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
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

With CONFIG_UCLAMP_TASK_GROUP=y on x86_64 it is possible to get
cgroup_parse_float() to oops by writing 0.00... to cpu.uclamp.min.

This alone is not great, but it's even worse because the dead writer
leaves the kernfs active reference held, so cgroup_mutex gets stuck
completely. It's also triggerable by unprivileged users on delegated
subtrees.

v3:

- First public version
- Rebase onto current cgroup/for-7.4-fixes, no code changes

v2:

- Only parse the digits after the dot (Tejun)
- Drop the selftest cases for whitespace and signs
- Rebase onto cgroup/for-7.4-fixes

v1 and v2 were sent off-list, so they are not on lore.

Chris Down (2):
  cgroup: Fix divide error on long fractions in cgroup_parse_float()
  selftests/cgroup: Test parsing of long fractions in cpu.uclamp.min

 kernel/cgroup/cgroup.c                    | 29 ++++++---
 tools/testing/selftests/cgroup/config     |  4 ++
 tools/testing/selftests/cgroup/test_cpu.c | 71 +++++++++++++++++++++++
 3 files changed, 95 insertions(+), 9 deletions(-)


base-commit: c99f50e4acf86bfbbe313d79f281d83be1763260
-- 
2.56.1

