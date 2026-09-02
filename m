Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BB5428463;
	Wed,  2 Sep 2026 22:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788387288; cv=none; b=gOBUq5ZFCsa0vs+FmfaBzBG4Ra9FoAXAKQaqlTSCKpkAzDODR0GLcjVyRQdMFuR7pyEPXcJVK2LPWzNpd8GbLuylwV/Dh2sFEcIFBclD6yBBoxWcA+yQxHGH4adcQlJNr04Epr5RKyh6cUtNK4TJAjfCDiRBsUDrKdJcEJBJU6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788387288; c=relaxed/simple;
	bh=EEJFNEat66I8t0erMgBOZQC8NL25EHlKmhZug8wnvbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heXxZ8G8SUIdYLjYXgL5/iNtnuEP38YDzYrnpn+ziZgPFVx7Q+oUIu+kFss6MQHv3Lcg+Jdm2P9Ud7eyZ1uM6y6VmiP1SoAiwMc1Bdv1UOCQuc3wk0Z+I8MuOwheAAhEce+ltllta4idHH/NwJaH0r9fzV12W7IvoOAXGjKfA1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QdJkm5Id; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QdJkm5Id"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC2D1F00A3A;
	Wed,  2 Sep 2026 22:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788387280;
	bh=2TDhcdB+BVqQGz7cgg1RxxPz32FZPU+zBGN0aCJbf1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QdJkm5Id9VdsEniRvRqbFp3tSB688ZZ3jH4FO59+NmnXYOYStDTOUZPB0/8YSyuH/
	 PMkNxTxlQ6Pkrq2C9wzCLyt5LdU3CLhY4euRQlfvvdpbVR9ODYYDCZ5+mGoGvWtBno
	 9016MH4nGzliEGL7/JgqrGr4kGszo2HsRzOXypWJwxydCDjIp00VSBvLx/Xms+xE6q
	 +tA3J39zbJ1x7BuQKWEsANvNyZCAmw8bwhIXK2EEl/Cks2Bqu+nSeXIsr9dGN5OSn9
	 tmKZ4ZNz1Gb9uBBmBkm5l5CIiz5bOMpQcXZrmrs+RQ0ecqap3bTlIi0yQPToOsa+MV
	 LwID+eRjhUh5w==
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
Subject: Re: [PATCH 6.6.y] cgroup/cpuset: Fix misplaced DL migration reset
Date: Wed,  2 Sep 2026 18:14:15 -0400
Message-ID: <20260902-daily-reply-0016-cpuset-dl-reset-6-6-ack@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260901122642.11571-1-kmehltretter@gmail.com>
References: <20260901122642.11571-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Mainline commit 4a39eda5fdd8 ("cgroup/cpuset: Reset DL migration state
> on can_attach() failure") puts the common error cleanup in
> cpuset_can_attach(). The 6.6.y backport instead placed that hunk at
> cpuset_can_fork()'s similarly named out_unlock label, while removing
> cpuset_can_attach()'s two existing targeted resets.

Same like the other mail, maintainer ack will be great.

-- 
Thanks,
Sasha
