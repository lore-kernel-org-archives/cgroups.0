Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443078;
	b=DPW26RGBBnrutViqg/Xk7WA6M0DnGcaOgbLcnnMQVwuL5SSxENGwHPNRDpZxjifxg2qa
	 wT/pad1E+v2lGNpsT2+w/jp4ydzq/wMTeRfuWtg4f8qXGoNY0kLofO9toW0N8gYS3zZ43
	 n3TNZgpVdVZfutxgj71pVUoqvxbm3Qtjx5WKCCwz0ysxqmUJiObJ3lDFDr2OyvMhui67s
	 XnfatNhX6J8+JKPd5nogXXAC+iGilP5pu8JqIXsOm2h1V+1icrIOHrG58ahq5RjR9lDIx
	 XIGJPyKpigUyUgI2kKccrvGWifDwquzDGL1f6Tjd/14TUfBkoM5n4Hel2XkW84zDHfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443078;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=zfW8vKVwAPFLCJpFfrgthdURXxETyav5wwNzczUFP3s=;
	b=C+e3a2hTeZYtpC9I0TGoUyviYXQE8Ww2hpPMoblReTK5dpeWvdZ+79RiV/Y8+mgDWMYg
	 A8SufojDC1dGZvP6krPV2ofinBbdUrXsLlERuYtomcaec3flj7d1MOa7pDoJ/yO56B+7E
	 uvU8IBaCeZLBuHCdwX0ArZ6abu5XMfJ8pQYpoQkkefkxR3HaK7NDtONanZ4kyw2T80UQN
	 kaxus/WLiIETGw26gsj5tvttw33rI7ucGP8Mz5bjclq9dWDWmOgr4nBY+lixkHho7R83n
	 tdeOyEw7SAKr5Nd/pCoy3CqN7TaAliVhlvODDMipIlKjQBywcjNNXUxyrzHyRK9r8DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vmp6keEJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095D560A6F44;
	Mon, 19 Oct 2026 20:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vmp6keEJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0811F000C5;
	Mon, 19 Oct 2026 20:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792443077;
	bh=zfW8vKVwAPFLCJpFfrgthdURXxETyav5wwNzczUFP3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vmp6keEJklR0Umt8EXKRhsUO2hQfqfjmQ0Rmidhw9JbHI2lIHe8ajRRlhYME+5ebr
	 hTa7EjQVgBwDbXJWhOmik/zYMOA1MRblF1etj7at3M8c3lnruXusHWZIh0th0SPoGj
	 KT6Y6sMgTXkm46T2n9GNUGi3zfnHvnIN623q1M4OJt3H8u6IyegQXB1kBb4Ushu+qy
	 ekTfFHKpiHMHjBdtKYYJi1yyLG2X/dzxt+Xt41otof9u+iKllVzEI2jMzengyzTMPP
	 YMbzqPRHRJywt5mBy7qculoeJII5RIBwA5q7PakMjTA0U+T9tgqUqpDnSS//rabHmo
	 CD0QspKsPHV0g==
Date: Mon, 19 Oct 2026 10:51:16 -1000
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Hui Peng <benquike@gmail.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>
Subject: Re: [PATCH-next v4 0/9] cgroup/cpuset: Fix various housekeeping
 check problems
Message-ID: <ataCxJxYwg_uhS-j@slm.duckdns.org>
References: <20261019181020.1069325-1-longman@redhat.com>
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
In-Reply-To: <20261019181020.1069325-1-longman@redhat.com>

On Mon, Oct 19, 2026 at 02:10:11PM -0400, Waiman Long wrote:
>  v4:
>   - Adjust a number of patches to fix issues reported by Sashiko and
>     Guopeng Zhang.
>   - Add more test cases to test_cpuset_prs.sh to improve test coverage.
> 
>  v3:
>   - https://lore.kernel.org/lkml/20261014140548.575122-1-longman@redhat.com
>   - Further revise the code based on feedback from sashiko and
>     reviewers.
>   - Add a new fix patch which fixes a bug found during the testing process.
>   - Add a patch to impose a new restriction that creating a child root
>     partition under an isolated parent partition is not allowed.
> 
>  v2:
>   - Update patches 2 and 3 to address bugs reported by sashiko.
>   - Add a new test_cpuset_prs.sh patch to skip the test if some of the
>     required CPUs are offline.

Can you ping me after -rc1 drops?

Thanks.

-- 
tejun
