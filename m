Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC525399D00;
	Wed,  2 Sep 2026 22:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788387282; cv=none; b=doEk0djoYYdrRrbAHsuh7maas+Isl5yh401fJOmL5Tz6t7FUoP2eeZw8zOadfq3GRlJ/3MKQfswApyqJKSSfKxY0rYAqnJ5Lh2852xjZ82hbQ/osuIZJu6dtQ3BSxzHDO1j0+e5KDLTERstgc0hivGQIDqOphQZ2FD5c9z2dX+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788387282; c=relaxed/simple;
	bh=BAjamxGj/wFMLTNxeEQp1PfnEE1+30I76EKJavt1k7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/p2UDoztQEtmQykUvfvV1NHt+D2ZZGXabhqzzZwjAQNvFIM3FzDNxhyWy5W8A7LDtMxDZgo9+bdKGZcSvCJBab1GV2y/zcO13CpzroYSM9Gl+d2KZCfB2XNVKc+aYlgSPxImIM5bgw846eJABPKN2yvzjbbJ8fXJmUenw/GQho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uy+bWMTr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uy+bWMTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EEA31F00A3F;
	Wed,  2 Sep 2026 22:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788387278;
	bh=qvCw2zF6Fz/MF22kFxgK/v8zQKnEsm+eAZ1gWKfp13I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uy+bWMTrtqE+hEjkaA/Q+Po+G/E4Vs51xG9ikAx+LlYl8pPC7ck/lqhPOdPumpPTr
	 ijJaEqIr3d+9xrI8t6wegzRGlYhYqRTF8TrmoiuC807R0v2UxXsBJ4ow+j4I+3wy1Z
	 zOy3X3URcaZqX/a7ooW0Mk72pzDD9k0lFTAY6dFMnngXjDjjZeqp5L96YTlTNxVTfM
	 wCjKsUlL2ykV7hP0Bw0oIeMNEgHlEUExse6QtiRA8C+IhLRx2uG7YvWFC/2iaR/0Ac
	 X/o/SKqFgzuANjS1q2sbIqTtOwAEXUJ4V4I16ve8PuwGmyspBwyKPDHrqZIq0ebOoP
	 g7QEyYR+VM14Q==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: Re: [PATCH 6.1.y] cgroup/cpuset: Fix misplaced DL migration reset
Date: Wed,  2 Sep 2026 18:14:14 -0400
Message-ID: <20260902-daily-reply-0015-cpuset-dl-reset-6-1-ack@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260901131335.15553-1-kmehltretter@gmail.com>
References: <20260901131335.15553-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Mainline commit 4a39eda5fdd8 ("cgroup/cpuset: Reset DL migration state
> on can_attach() failure") puts the common error cleanup in
> cpuset_can_attach(). The 6.1.y backport instead placed that hunk at
> cpuset_can_fork()'s similarly named out_unlock label, while removing
> cpuset_can_attach()'s two existing targeted resets.

An ack from the maintainers would be great!

-- 
Thanks,
Sasha
