Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B0951AFC6;
	Wed, 23 Sep 2026 16:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790181540; cv=none; b=myHE8RTEYAz2/FLmUoBjncvPS8FatAE2HUUW5S7bdz9aYLUGMUZEX5BFslouneAyeu34Mh2j9v4Bmw3CgqrIuGXnLInHYXgEcwDsIIsNoKN/Vf6mwpVU8yHe42T+nKrix2OhNIw+IQW9rxAwmjxM/xg2uEIrWv6W54iIcHar8+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790181540; c=relaxed/simple;
	bh=0ctGyl1/2UPjYIv8Yr77mCJsig80+mZyHrMyZn+9SKk=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 Content-Type:MIME-Version; b=glfp2We0u69njUx2QNk7X9t2YkpKLJU2Df+9Cu8Q/CPhJ9e2ADBe+HT9Gzecxm0GjNwTOpSCrGkm3pqdnaMWclWB0BbIj62AHXM+s50w8xDb7cNLRwv2xTJfXD2JcAZ7VILafkpOJZae7qvO+L5t/B96PPGjltXQmd/9R04BdyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Owm43Dhk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Owm43Dhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16DD1F000FF;
	Wed, 23 Sep 2026 16:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790181532;
	bh=QgZUvBrrAuwrQe14rTlJOhArvVwE613lQBZdvtVkXCo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Owm43DhkUjfV0zbwB2N3JOtVKELcHE7IyuyRCQiySnRq7aWSFltqHyaUW5fyiywvG
	 Vd9bpsqpATnGbeaojI26R+lbJ64DA8QGKxzVFbK7jmGLZ5OB3U0f9entAkyqIxuJDq
	 kFr55421mEIXwwODWWb9BAwaMko0zB090EE/Ba9nA+1TipLMrJy0LxUeiYssL7Bkci
	 KyRl7/duHPFB8deQFySaEYVdCV/vcvLg5WaOFm/foothz38i7wVtu16fcFKEobK2O/
	 rWYgdiQAfb0xyiIEim7wwZrqbzF0dqk6ytJ4KZSreHqQBtsMA6lTg9R9tvrw5DvPU/
	 RJs8vFuBfdSoA==
Date: Wed, 23 Sep 2026 06:38:50 -1000
Message-ID: <700928ff02d35c58ccba15ec371f2e8b@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Peng Yu <yupeng0921@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Chaitanya Kulkarni <kch@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>,
 Maurizio Lombardi <mlombard@arkamax.eu>, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] nvmet: add cgroup_path to charge namespace I/O to a
 cgroup
In-Reply-To: <20260923152653.40953-1-yupeng0921@gmail.com>
References: <20260923152653.40953-1-yupeng0921@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello, Peng.

On Wed, 23 Sep 2026 08:26:53 -0700, Peng Yu wrote:
> Implementation:
> * Add a `cgroup_path` attribute under the nvmet namespace folder, e.g.:
>   /sys/kernel/config/nvmet/subsystems/nqn.2026-09.io.test01:bdev/namespaces/1/cgroup_path

Maybe take a cgroup ID instead of a path? Userspace can read it as the
inode number of the cgroup directory, and cgroup_get_from_id() resolves it
at enable time the same way cgroup_get_from_path() does now. The attribute
then becomes a u64, which drops the string allocation and freeing along
with the path validation. IDs are also never reused, while a path can
later name a different cgroup created at the same location.

Thanks.

--
tejun
