Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794336338;
	b=KFn4v4ifzBvlZA22wiJTzznDSvuM9d3NT3WwJJIN4U0O1L/tGC22Ec/H2Z7S3rU6nwGO
	 RbxwevcmitQElTHehWFaqoPpmtsAouwW6r1WiFNuLhRtd+7K/ohUKweC+aTKsDkpKfObN
	 NEgRU01PfMTilDU7HOT0insVoYRBWlSzC2wPFP3pn5ZIl0y7ln4mXPh6Hlautj6XkQvJO
	 1KygW2PWq+HEMHCOf0hCU71mXaqiX5/f7Bi2m1v3Ikn4bz5maistaCKI/UGwiTwyjw0Ca
	 mxpATax+OHyrk0XCU0HxoOAbf0URq3eTRUXPujLhKAsj9ORWWLvoC5QxMeM5LQ0II4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336338;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=jDn+kAHlJ1YKV/vSjJMTOq+sX3gPOQ26dm9cQX+T7Co=;
	b=3wq5odEzAhSqP9izttmh8hvoTiH1KKmIFtkC3zW4UcsFl8qurh4T18VnE6BkoyR8weHZ
	 4ySud70RReRzmyA//eR3usLdGehMoFFZWWUbGlfOC3H47OmzGZz9J702eHDJr9HuvIXnl
	 4Oyf7xa4Xv0dpnfUi/78ll+i01LVUGi2wtawlwPPZ/8HHQZycqmqbzfpimm2Xie+bF1OG
	 /Y/+LGTXly6+Yj6bYustpBren7yqHsNSZCCq0TS/lve8p3t2WLQ1/PVkumkh2MgVJodQu
	 aziW6pUB+E5Yr7BAWihQX3LZvKFF9D+At/E4A0AWtRcJdwImYV4+4ykFz30CMyursoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fhQiG7uu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EA3606A327;
	Tue, 10 Nov 2026 18:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fhQiG7uu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6381F008A2;
	Tue, 10 Nov 2026 18:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794336337;
	bh=jDn+kAHlJ1YKV/vSjJMTOq+sX3gPOQ26dm9cQX+T7Co=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fhQiG7uuYywqrnJ1To2XB3v7Jidj1RPi/wyyYjpeBPZsVAD2HJiQvdshP5yDQtNk+
	 4bTubfTT36iMuNB1Ux18/gUn2k3On06ctHzcZEuBQnMkgxqs+x4LUgW4of1uB7x2Ck
	 ec4z61FshOMCHLn6R8c1NPikkLK9oWiPbijkXnFJ1LB+MWK1wd1fcEFx6w5UwyMavF
	 CBauDfjcfYpa/CcWwAWFF6fB+st3chmIvfVWqHr1bB49moU8seP0H+MBmIR3+zaES+
	 05MS8ATN4ERryl56oZDf7o0kx+GHrN4E8Qln2FW0U3E1w9HdGDcgJ7Lp2BlODpAiVo
	 F5faYuv83ydDg==
Date: Tue, 10 Nov 2026 08:45:36 -1000
Message-ID: <3296ff1ecad6573e1719cb205d9128f7@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, zhao1.liu@intel.com, tim.c.chen@linux.intel.com, lizhe.67@bytedance.com, ziy@nvidia.com, mgorman@suse.de, bpf@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next v4 0/4] BPF-based per-cgroup NUMA balancing mode selection
In-Reply-To: <20261110032913.71974-1-laoar.shao@gmail.com>
References: <20261110032913.71974-1-laoar.shao@gmail.com>
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
Content-Transfer-Encoding: 7bit

Hello, Yafang.

I'm not going to engage further in this series until the situation
changes.

LLMs have made it much cheaper to produce plausible-looking patchsets
for new features. That makes it easy to keep sending iterations of a
feature which touches code that the submitter doesn't really understand
or hasn't thought through in depth. The reviewer ends up doing much of
the developer's work while the submitter sits between the reviewer and
whatever the LLM produces. I think this series is an example of that.

Some examples from v4:

- A folio belongs to a memcg and that memcg decides the policies around
  it. That's how memcg works for every other memory policy, and tasks
  belong to a memcg too. The series still splits NUMA balancing into a
  task side and a folio side with different semantics. DISABLED applies
  to tasks but not to their memory, and the two sides combine the
  hierarchy differently.

  On v3, I asked why. v4 moves the storage into memcg and keeps the
  split, but doesn't give a high-level reason why NUMA balancing should
  work differently from how memcg handles every other memory policy.
  More generally, the major design decisions come without the reasoning
  behind them, and asking didn't produce it. Each iteration only barely
  updates what was pointed out in the previous one.

- numab_memcg_mode() walks up to the root memcg and recombines the
  requests on every call. The callers include every load-balancing
  candidate in can_migrate_task(), every task migration, every NUMA hint
  fault and every page migration including compaction. This happens
  whenever any cgroup has a mode set, although the result changes only
  when a mode is set or a memcg goes offline.

- numab_memcg_active() reads css->flags once and the comment says that
  this makes the three state bits describe the same moment. However,
  nothing synchronizes those flags with the mode. In the lookups, the
  check is redundant anyway because offlining a memcg or disabling its
  controller already clears the mode.

A developer could cost reviewers time before too, but each round took
the developer much more effort in comparison. That kept the effort
balanced between developer and reviewer in a sustainable way, and it
made sure that the developer learned and improved while working through
each iteration. LLMs broke that balance.

I don't know what the right solution is, but at this point shepherding
patchsets like this doesn't make sense for me.

Thanks.

--
tejun
