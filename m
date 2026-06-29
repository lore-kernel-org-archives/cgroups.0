Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7135839768D;
	Mon, 29 Jun 2026 19:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782760361; cv=none; b=VtWH8hsg3oYAEIO+DIVrVHOyWipqOwIGJqBcNNZwbSwtvuKtJjsN5ljKWp5E0vPb09Ogf314t7JvXmjHUDG5/az2BsFTbjgWOngMoUlMPME6IqcAqgjaayYplXKDrAvIpMJvvRcukqaRhcHF72wcSpvvHF2lQRInXK3U1U2jFok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782760361; c=relaxed/simple;
	bh=IgkyJKi60WXCmh17XYm05cccG/GD8qQaAxSY1ZxWgM8=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date; b=MpAP8OflRT7oc8/QUVY/zbXzb4gXSrzxCsrhTYHTcJXsPVitXdin+G0a7fInbO/dLXINfBj2E6Zmbm8GygUOCFFloBakx4yuIXvv/6xSYiU/j5C9yQUebRCWH0gFnd5FQw4hIJ6QMyWSW5bTAL1D2RHhOM5ix6Y2lgKjXpxBxg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVDJShgk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVDJShgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05ED1F00A3E;
	Mon, 29 Jun 2026 19:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782760360;
	bh=IgkyJKi60WXCmh17XYm05cccG/GD8qQaAxSY1ZxWgM8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=YVDJShgkl9W7Qs4eDRHslRHnUeWnBlD6YYUGobJ3aUNjsTlrvLMX4Sb3D5ESZfnqq
	 zynaP+5QnPQKJ2hme9z0xc7W9NaAhzZCm1XXyKjdBil4SEjrRl+NIaHuPsgxz6VbzF
	 vQjc6wYNTdKueojtx25AfSsPJhnmLk6xqRlGdIx7XtBm8Ml4t4TibYjlTP5kAXzkLp
	 ywOIDLOdFqkvbmfW7yj9STYDJDl+Hq2KR9+OqxNV5XKG5B8E61vEjZjO6gWP9CDV8q
	 rIrJsgFvV9ZUMlEtn2sUB0nSo9WGFDo5jafDPGA/GekrROGRZWkjoK5n8sYnO8JVhv
	 ViMxKgtmgzUbg==
Message-ID: <d1d34d4bdda5608c13c89d2c7a0a9671@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Joe Simmons-Talbott <joest@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutný <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	cui.tao@linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	nphamcs@gmail.com,
	Waiman Long <longman@redhat.com>,
	li.wang@linux.dev,
	sebastianchlad@gmail.com,
	zhangguopeng@kylinos.cn,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] selftests/cgroup: Adjust cpu test duration based on HZ
In-Reply-To: <20260626202925.1527524-1-joest@redhat.com>
References: <20260626202925.1527524-1-joest@redhat.com>
Date: Mon, 29 Jun 2026 08:55:12 -1000
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.3.

Thanks.

--
tejun
