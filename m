Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DD238B15E;
	Sun,  2 Aug 2026 21:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785706371; cv=none; b=mUbVPGgAvq15jCj6dcgUatXv8ccfkrG8Lba/sadgWbBKYyrmvfI19Q/NfTyK0ghljq/p3+Xsfv00AYMM56XAIJnvCHDX5IFXmSwIt22j8trRf8OmFl13r82rJHWYdMOexhFHegegKeD4nWKl5qZg4Xcxx6PpED7KPN0oIfOxGNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785706371; c=relaxed/simple;
	bh=KOljYON3jTRUwQm8eUqMu5CjveCeO2Eiom0kk+/OeRg=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=HfueIvj3iN7vvl2GcJGAOyw5dcHTPsZBOq2ztl/3jNRhnx+iPG3Sh9BAC5HfWBqqR6lz3S35Nu8ArVtpXVWKSXdbx3fV6JmXm5yA1t3WBBKYaZ9L01VgVFJMnste8h35X62HFpIKQBK4XN+TQdPxN+xjxCRoaNYgsDdWHTyytXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZPmjozn/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZPmjozn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F181F000E9;
	Sun,  2 Aug 2026 21:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785706370;
	bh=cDzhkG1w+YnSNaNsYPGfzaniZU7En9exAEkV+7q0Dbc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZPmjozn/UqJ6ojT7xQXerEt+1sQb5lqXKF1qpwS9oCcKg9L7LOxssF7ng18B9nENp
	 c3HiFce/7HjdmeFruI11cWzXwbmTuoEk7hXji7Njw94Dn43DTeSJGXuTGnf1QnPCcR
	 DOI7PXDaEVtLEDWZkc1WuOVab1jDjlNiLtPKlvH5hh1MphQvEv2+PDTPgBgl7dQAlK
	 cTk6yRmTsTSEwU5psGSY/Y8Mvdv9/2OZxbbOlGf1cZw/ULOslPsZOPRM23aXSFKFhd
	 qwkLk3Sww4gjh9D/ikwQt/UfSnKjJQfU0XxhD47PueMXQ6mySwpVzSP80EvelnOpZ+
	 9TK1cP27tGAEQ==
Date: Sun, 02 Aug 2026 11:32:49 -1000
Message-ID: <14bd63f0e59ce815ec1a1d066f578aa0@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net,
	skhan@linuxfoundation.org, josef@toxicpanda.com, axboe@kernel.dk,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	cuitao@kylinos.cn
Subject: Re: [PATCH v4] Docs/admin-guide/cgroup-v2: document io.latency rotational vs non-rotational behavior
In-Reply-To: <20260728095707.2398498-1-cui.tao@linux.dev>
References: <20260728095707.2398498-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

On Tue, Jul 28, 2026 at 05:57:07PM +0800, Tao Cui wrote:
> io.latency is documented only in terms of average latency and the avg_lat
> stat, which matches rotational devices.  On non-rotational devices a group
> misses its target once enough of the IOs in the window individually exceed
> it, and io.stat reports missed/total rather than avg_lat/win.
>
> Describe both cases: how a miss is detected, note that the avg_lat tuning
> guidance is rotational-only, and update the io.stat field list (mark
> avg_lat/win as rotational-only, document missed/total).
>
> Acked-by: Michal Koutný <mkoutny@suse.com>
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>

Applied to cgroup/for-7.2-fixes.

Thanks.

--
tejun
