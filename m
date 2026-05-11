Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E183C4540;
	Mon, 11 May 2026 08:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778488559; cv=none; b=PHIzu0pa+sCW9psUlj4qcyhjP3JVImh9QYKebsLPERw0yw2Xd6gAyAX9brKVQWzJO8ZvQKoBOhs9Ku8PpO99mNT0JvgofUyUJOC+NiuZ3TPYeAH+sVLAhzCK9MQNbM+GTNR4J+JEVCfBe29wlAaDDroiFCTDLC5cSzsChMvJ0zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778488559; c=relaxed/simple;
	bh=/EBK9Za3dzKeST6xzL+uhXsqga85E68iUDnkuLoGL9Q=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=NnU5yQtdcGSx9ZOmtHXg1bedoXOz0yegggtoaDeulOcn0etFKnIaxOM1IM1fMmQEgsPmFFYRXx/tfzWcyM6x5EGLN5kwlqkH1JEZF7VsEfwHQbwujxkr93Iv/G5pAJhak9MGC+sEb1tV/t5UB1TnH5Ca0hJUQ/6648/PStfgt6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DY61d69C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DY61d69C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAC7C2BCB0;
	Mon, 11 May 2026 08:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778488557;
	bh=/EBK9Za3dzKeST6xzL+uhXsqga85E68iUDnkuLoGL9Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DY61d69CJfp19KazmqNOGXOlE0zodqOtGBXFfZqUT1fw5rJyP1eqzeA+fUqo0FX44
	 v/qlsgBJWvKRB7guPiVmcyg6aaYrRWyylje0MrvCj/Efy0hprOxKr+2VdmceYbKAbR
	 SlkIyQ1/Q/skQIzhyVAwxtmBnmDQTDnPSbulmSuqZa7m9fdpAkR1UE6FAvm6+BYirD
	 xl2aHdMkjHZ9bRUg8AzoCSf0boyJ/PkrMiKWPRzv5yZE63Pxxzqfd0FucZ+A5YyBYd
	 QT9GT+Hgqhco+O58i4MrG2PC3p2KfIDsLkvoGYnWpLA/h013/f8YhhiDFrO39vzOhD
	 xXQ2IzAsLxqRA==
Date: Sun, 10 May 2026 22:35:56 -1000
Message-ID: <60bda7187dc09b87588e47276174c71d@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
	jthoughton@google.com, seanjc@google.com,
	zhangguopeng@kylinos.cn, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: Add NULL check after malloc
 in cgroup_util.c
In-Reply-To: <20260511060853.1873161-1-lihongfu@kylinos.cn>
References: <20260511060853.1873161-1-lihongfu@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.2.

Thanks.

--
tejun
