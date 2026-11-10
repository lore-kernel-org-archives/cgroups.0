Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794338859;
	b=C4MKcqw09fxrfWaXqfo61l6UdMBpA4dqh/g/XaGs25+zF6/Xywre9CBMIHd+p6kDWaes
	 eLFXjNovXELxD9y5aY5DcR2vuCT/6Lw/3iZEJue5OFJMhavm106sDTj2CIvCLpLoWsXL7
	 sNWrDoEC60123M+FmRTX3Fql05AQEC1Sq1mm1yh5WKXgtoWWHP6DVFIPvMFxMXRYL1dIq
	 NeZpZFNjPQYxPzbBVjuGt8poxDuFmFWvfxUoUVk11YWpoLBkdA6dajUYAZmbzmtMESDm/
	 3F58jrOPt3nyBbn14zQB3fRSQtQ77tD3rDtTYcfjxx4SoK3rS6KUuHkO2RiFuBmsv6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794338859;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=JhoX3osY26F1MqRN+osOMk8T+9PdZqeDfzPnj4Ocp3w=;
	b=DJGjYcov3mXooexhPigxQYM54feauDxbBFHy9shfUjyl9ArpqzInjZlEuPZN2sp3iyJg
	 5dXP8OrJ/y9rw1ESqtGY4mYbFsfH7fgJ4lrK+CHB+ClDsTBheE/kGWzYzFhgZx3yfIOdn
	 yismgo4MXBCM+eqpvk2epnQlPHOYnWaT6KIfjDLjW1mP+e7ks1Mi2lQROmK9g/9vb4zx9
	 rVrpT7ihnyitDVNPwUuyyPHuzrXHAbGdEDg9n60yczt7Yt+PCxEb5C5xdNZWopzFTz6Ac
	 JZsEc1XuPxk4UmTTu1eZ5cT4l435kHh8xrWTnCDa2uGLnYsyEKIABe+yEHwmdT2TXwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ikmk3pxA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B17606A321;
	Tue, 10 Nov 2026 19:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ikmk3pxA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3D91F0089F;
	Tue, 10 Nov 2026 19:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794338858;
	bh=JhoX3osY26F1MqRN+osOMk8T+9PdZqeDfzPnj4Ocp3w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ikmk3pxAY/SwBAYX+1FYoDk3XIXo2sUOx1rH6r9L7YDZesC1mmOQWEnxPSYekP9be
	 1TBo2gykXeNCtYlkdIJs/TzgKHeeArN+ocJLcAnSNsQN42DeV02puqaDsYdwpnJp0o
	 h08CFPnRir1nUEHWrdXn7qHKuaKWFLO8Q+PCQIItmZL5f+iRsojmX9s9FncJDJ1CkP
	 LGpAIW1wyib35VLfsATFLHggCyfcXgP8ga36rVT6wlaAtO8WbOFBRR75eGik0x9HJR
	 6Jn8lvvtbIWfplTGC4y3NqENeV7i2CbTe/FAVmpzRqfH+xnmLGn9N/qYTdoIeFCWN8
	 xoam6TraMLnWA==
Date: Tue, 10 Nov 2026 09:27:37 -1000
Message-ID: <898b08d81ed8e3f1ee7d4985e4b47992@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>, sashiko-bot@kernel.org
Subject: Re: [PATCH-next v2 0/5] More fix patches
In-Reply-To: <20261109190955.1398611-1-longman@redhat.com>
References: <20261109190955.1398611-1-longman@redhat.com>
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

>   selftests/cgroup: Fix "test_cpuset_prs.sh -v" failures
>   cgroup/cpuset: Correctly set cpus_updated in
>     cpuset_hotplug_update_tasks()
>   cgroup/cpuset: Fix incorrect partition invalidation logic in
>     cpuset_hotplug_update_tasks()
>   cgroup/cpuset: Protect current->mems_allowed read in cpuset_fork()
>   cgroup/cpuset: Correctly set isolated_cpus when switching partition
>     state

Applied 1, 4 and 5 (5 as v2.1) to cgroup/for-7.4-fixes with the following
changes:

- 1: Nonexistent commit ID 6e4834ba8986 in the description corrected to
  362212853cd0.
- 5: "update_cpumasks_heir()" typo in the description fixed.
- 5: Missing trailing "\" line continuation added to the first line of the
  two new TEST_MATRIX entries in test_cpuset_prs.sh.

The following tags were also added:

  Reviewed-by: Ridong Chen <ridong.chen@linux.dev> (1, 4, 5)
  Tested-by: Ridong Chen <ridong.chen@linux.dev> (1, 5)
  Cc: stable@vger.kernel.org # v6.8+ (5)

Thanks.

--
tejun
