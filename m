Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AD530F815;
	Fri, 29 May 2026 18:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780079341; cv=none; b=q0D5P1RrCE4dptWaDrbmhl3nal+k4aiFZadUBSewDuzRSDhIUZhi16erfIK4bC60qlKOff7OR+vlpBJZj24CC5LDpK05C/4db9N3sF7zMGW2dvjmAB1dRnmjO5MsXKaeYIAeBX2I2e3xwAIqkvWGqZtv3ZIC6QzVRO+BmHSc+Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780079341; c=relaxed/simple;
	bh=aHE7dg8zR1n2cV+21RjFRqDg+YTC8jxfFWgZhu+jLWM=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=Ge4WSZWZ7QKYfeZekeBPAdBLvXKFelTtldd/QadUhYRBCF397LYct0W42T6L9O9aOmsVbySwZpQlxYDNxPLVNbZhxfWNeCZWaZtx2xnq26E9pboIoVwBexnJYYUI5YZOKCYE2LdXdrMTPIMrR2UsB6PQYaLsl0JXN1bRoyPa7UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kglDwHUF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kglDwHUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE911F00893;
	Fri, 29 May 2026 18:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780079339;
	bh=aHE7dg8zR1n2cV+21RjFRqDg+YTC8jxfFWgZhu+jLWM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=kglDwHUFRvAurfkeV5IWCbs5lkftOcFs6tOGuNCHv2JmwCpi2OUuTG5GqdC6DypIY
	 6Lylo/U1aJ7e8QQR6HgWV3lvI1UrGuniVSipbF6UNwjWsejmupA2PfoaUJWkv1++ES
	 0/TOhUlW/C0xSpHJYaaPR/JwJk6dJ8yAYrnrwZCFnpfU0xXdmlq/qcw5/m5PXmtitx
	 B60L80ICuqhXl8YSlD9qp5vuuTl9QQ4xNfwyi/omYr3xAgzBepNzVpg1coMkRMf05o
	 4MtsIAJhqFQPW4k28kNVgkj9fUOzoQ3Rz/TTO+XjXn6FG+Pq/NdorKFSXY5WZ9GbKU
	 Za69PYHT6lklg==
Date: Fri, 29 May 2026 08:28:58 -1000
Message-ID: <42685aa3cdaaaf17051558637a36c879@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Waiman Long <longman@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutný <mkoutny@suse.com>,
 Chen Ridong <chenridong@huaweicloud.com>,
 Guopeng Zhang <zhangguopeng@kylinos.cn>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup/cpuset: Free sched domains on rebuild guard
 failure
In-Reply-To: <20260528093742.1792456-1-guopeng.zhang@linux.dev>
References: <20260528093742.1792456-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.2.

Thanks.

--
tejun
