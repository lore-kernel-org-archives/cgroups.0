Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794421037;
	b=ZKUg07AX6GbH44CEC7sLCnrVaTO3B9uIWYPwm0eYUjkNrLywI3CWcJhP1MDzXqEEa3ns
	 sBDFK1kCxAiBrnxRM+/mY5HneuVbt82b+X2bUlfFpStWwZFSRUwaozGhAyN1pGRLz+7Nc
	 39mud5C3phTAlH8pn85UVc+xy3KaCEE9s69F90YscD15H9s//8OrHcsUAyOUx2LZyZSU1
	 fSaqDINB8jhJT1Un5kDa9y6Xph9/qI61OVTajO6vSwa6U2m8eI3WPp4Zdc5cD+kpVSa9l
	 6WpileIuFGbZ/QN3Qp7rsj4ICco6MH1fetu3Yc+5Meed228E1PvIqAUwjWoE0RccYWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794421037;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JAFBic9FeqiTcoA9Sc56oOZoN08uUZIC/3Jq0YqoHLY=;
	b=wyZWaF+Osq0rLkxH998cR65k2GVwPhMiVr3SRg+huR0vmBINs41kzS6bPyalRAYtohuh
	 G5p0p2Ln4QahNXMuDf7hDC+3c5ruHZa+2akyif9Ay8mVEJpjC3NHBdQv2EFNDIoEJYmUc
	 iN/3LRsYKaOPbBwGkjNQSuvP5/0kZoAQM+GffpvQHHTwkRmaSne3afZXgHbhrDPRLZ7IT
	 pycZpJxKV+ZZvnU5ktLj32pvPnkXwgR5fLDkuf5hMYrbMDzXazTjG4TyuoSO51/j17YcZ
	 p2UzgqM/O4NkofAujP7P5MrG/Ql+od70iqVb8vawOGBbDMg1w2wnALSYsiMtapeLcbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UhRh2+QK;
	arc=none smtp.remote-ip=209.85.128.172
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606C9606C175
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 18:17:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 606C9606C175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UhRh2+QK
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8b0d63f60bcso46216657b3.3
        for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 10:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794421036; x=1795025836; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JAFBic9FeqiTcoA9Sc56oOZoN08uUZIC/3Jq0YqoHLY=;
        b=UhRh2+QKrJuMUqoVkAZwLp8mjesVP5rOdbeqxz4Qd7xPhFQ7cqnpBQcOCKce2Dv+Ys
         JDUyUFr3MiMLq6MxAJzkSqEfhTzdl76LeLgd+pOsMx2+XeQYBoYuKI7QkF1fp8IymDmk
         KJX1eeF9+XTsdNrPc8KEwUSLMb7634nwNpC+cTuxn0Z2TIOeFQMk9n/Y0ie3/+B/3X05
         7xZwGQl7MS/HdOcR4MHHCdM5R+x16qvI2Pj+MyhpUkNOORYFs5pTh9M9jPGXP7mIW18c
         9Sfu3b+GWiqTy1rQATsAE0TIfLiAlTwki7umXwi8lBrYXDH2KUD6EEKFHHhrwwKziBC0
         RgiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794421036; x=1795025836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JAFBic9FeqiTcoA9Sc56oOZoN08uUZIC/3Jq0YqoHLY=;
        b=x9Ph5rVYewh1F9EEI6yTlnNt1jUZZOhbRGDwAi3z+tF9oVOJNSLJR8BOS/B/Pkuggh
         bqpNsYyZiOjgXzzppSLC1ZnIVl8RCLNr3L46xW6CdIBx7rZyB4GUmVXAebqvVfZKaZJv
         eXSVB1ZQzOnI3Vs0g/FclQcx45x6FORkK+Vkel1fwipRgoijwG3ZXsxPQ0eDG0YlDU3S
         ypWEbJOLd3QjInT2kjSzgAaTRSFfAgj9lPqHiPA7UPUcSFfLT7dr/Uh2OQQhBWaEHN/F
         mUwyGLLbzGxixHtMm5AfBT5sWDa76msvvDDR6Tkhcl4zzq/FJzX6bjKTl+ivo5A+qnBR
         Ziqg==
X-Forwarded-Encrypted: i=1; AL+hErHKqz7GobCUC+AJapGwpyKBN0VQC/sqfJt8egy4Td3jc27slwt4o9jQORnah+PIqxZX6l6/Itnx@vger.kernel.org
X-Gm-Message-State: APuU4Z88OyUTiN9WCva9QBfJ16ZUbFsyPYtyNtB98pm32WzhkpUVffu9
	TxhzdZlu+JAd2TUTd70xLJtfUTfUTZYtcY50CGo6eocrLxRIKTBokcxS
X-Gm-Gg: AYBFou1IkXegM0ox+bfE+tEgjdNuiqMHEWOXNIffbkGFTVp2o7FjRyeWEcIrBc8pz+B
	kdmj0hl4MxWgcM6USMDSey0AjUgcFNC5otFc14M89Vcg5ScWt5BRfwpwjUFWFJCDFUM1CkWnbRE
	3VgLv5g0CCMpY///oOWQV2GPICRrft87CMElBoSszdQi2WNqkqJxYXhoyEL+noYLYFgNQtOp3av
	UMFKuMF/X8DbvdCSFghAJmg7MfphsdF754R7Up6kXuAR689eOKAkn++7DVuF3c31g3dfaEym2kp
	fHnY04WBs7Ok4k96mIF58y1sH3MHZcJhwETDxgPzKy2uv5d4a19YRgJ33a7zWE7/g5ydmVSTWyW
	8wt3l3MUFG3qZWkyzy74HaS+/Jlb7u+hWZLbXWjATRkC98l1+ny/lqssL20OFR4lz4xBqMHJ9Pm
	PjD682C2K7UQWR3RNEM5XStZUdTzoHUAoMJ4L/51F3bVk5QpjtsXNFWxEO3cF54AzRTmx86QFs9
	th968Yb4HzMT0oa4vLa3T9/Ypj8/neWHtQTlGpBSIfzh7v02IoQhx33wBze3DH9OR8A2Zn1NcjN
	6NcFWURe21rQUxtREsP69xjGQdbvuRefZwHQpU7P4JhhvJqWLU2jNme7jULDqDJO2duAe/zo8FA
	bhOwd+g==
X-Received: by 2002:a05:690c:4f07:b0:8b0:d837:364b with SMTP id 00721157ae682-8b3a7e3b702mr19660887b3.7.1794421036454;
        Wed, 11 Nov 2026 10:17:16 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:5b::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b39324c124sm49936597b3.6.2026.11.11.10.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 10:17:15 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Li Zhe" <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ljs@kernel.org,
	mhocko@suse.com,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC 0/2] mm: add source selectors to memory.reclaim
Date: Wed, 11 Nov 2026 10:17:13 -0800
Message-ID: <20261111181714.1463827-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019141401.11927-1-lizhe.67@bytedance.com>
References: 
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 19 Oct 2026 22:13:59 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:

> memory.reclaim is a useful proactive reclaim interface for memcgs, but
> tiered memory makes "reclaim N bytes from this memcg" underspecified for
> userspace controllers that manage memory placement across tiers. The
> kernel's reclaim policy is aging-based, and on tiered systems aging may
> demote folios before they are eventually evicted. Without a way to
> declare where reclaim pressure should start, userspace can only reclaim
> from the memcg as a whole and observe one aggregate progress value.

Hi Zhe,

I hope you have been doing well. I'm circling back to this discussion
to see if there have been any updates since we last spoke about this.

I'm wondering how feasible it would be to enforce some kind of placement
decision from userspace with this new tool. That is, I think I would be
interested to see if this solution was enough to grant fair placement
of memroy across tiers within a memcg.

Were you able to run tests to demonstrate how effective this was at
managing placement decisions for memory?

Of course, I think we should answer the ABI questions below. Maybe some
of the memcg folks could chime in a bit about what kinds of interfaces
they would like to see.

To start, I'll reiterate what I've said in the previous response, I
think we should keep this a node extension until we can demonstrate a
scenario where there needs to be tier-awareness (to be honest, I don't
think there is one).

Cc-ing Johannes who is a memcg maintainer but was not CCed in the
original series:
Cc: Johannes Weiner <hannes@cmpxchg.org>

Thanks, have a great day!
Joshua

> There is prior history here [1]. The old nodes= proposal tried to let
> memory.reclaim scan selected NUMA nodes, but the discussion left several
> ABI questions unresolved:
> 
> - nodes= did not clearly say whether the mask was a source selector, a
>   reclaim domain, or a demotion-target constraint.
> - The implementation did not apply the mask to the whole reclaim path,
>   so demotion could allocate outside the mask. If userspace interpreted
>   the mask as a domain or target constraint, the ABI did not provide
>   that.
> - Selecting top-tier nodes could become an implicit way to request
>   demotion without uncharge. That would make userspace depend on a
>   particular reclaim policy and could make future policy changes hard.
> - The separate completion-accounting question remained: demotion can
>   count as reclaim progress even though memory.current is not reduced.
> 
> This series takes a narrower approach. It adds a typed source= key which
> declares only the source on which the existing memory.reclaim aging
> pipeline should be applied. It is not a demotion target selector, not a
> demotion-only goal, not an eviction-only goal, and not a change to the
> existing completion accounting. Leaving source unspecified preserves the
> existing memory.reclaim behavior.
> 
> In that sense, this series extends node-scoped reclaim pressure to the
> memcg memory.reclaim interface. The existing node memory_reclaim
> interface can apply pressure to a node, but it is not scoped to a
> particular memcg. This series lets userspace apply the same kind of
> source-scoped pressure to a cgroup's resident memory on selected nodes
> or tiers, while still using the normal memcg reclaim path.
> 
> The main benefit of this series is to give userspace a steering knob
> for per-node and per-tier memory placement control. A tiering controller
> can observe the resident memory distribution across nodes or memory
> tiers, and then apply reclaim pressure to the source that should be
> relieved. For example, it can apply pressure to top-tier nodes so that,
> under the existing tiering policy, cold folios can be aged and usually
> demoted to lower tiers, or reclaim from a terminal tier when it needs
> actual charge reduction.
> 
> The existing memory.reclaim interface cannot express this. It applies
> pressure to the memcg as a whole, so on a multi-tier system the kernel
> may make progress in a tier different from the one userspace is trying
> to control. That makes feedback control of tier ratios ineffective: the
> controller can observe that a specific tier is over its desired resident
> footprint, but it cannot direct the next reclaim request to that tier.
> 
> Patch 1 adds source=nodes:<nodelist>, which is the basic source
> selector. Patch 2 adds source=tier:<N>, where N is the memory_tierN id
> exposed by /sys/devices/virtual/memory_tiering/. The tier selector is
> only a convenience layer over the same source semantics: it resolves the
> current tier nodelist at write time and then uses the same source-scoped
> reclaim path as source=nodes:<nodelist>.
> 
> The remaining issues from the old discussion are intentionally left out
> of this series. If userspace needs to control demotion targets, that
> should be a separate target/demotion-policy ABI rather than folded into
> source=. If userspace needs a strict "bytes actually uncharged"
> completion mode, that should be discussed as a separate accounting or
> goal extension because it would change the observable meaning of
> memory.reclaim progress. This series only adds source selection for the
> existing reclaim policy.
> 
> References:
> [1] https://lore.kernel.org/all/Y5bsmpCyeryu3Zz1@dhcp22.suse.cz/
> 
> Li Zhe (2):
>   mm: add source selector to memory.reclaim
>   mm: add tier source selector to memory.reclaim
> 
>  Documentation/admin-guide/cgroup-v2.rst | 29 +++++++++++
>  include/linux/memory-tiers.h            |  6 +++
>  mm/internal.h                           |  3 +-
>  mm/memcontrol-v1.c                      |  6 ++-
>  mm/memcontrol.c                         | 11 +++--
>  mm/memory-tiers.c                       | 24 ++++++++++
>  mm/vmscan.c                             | 64 +++++++++++++++++++++++--
>  7 files changed, 133 insertions(+), 10 deletions(-)
> 
> -- 
> 2.20.1
