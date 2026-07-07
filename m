Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C163B6BF5;
	Tue,  7 Jul 2026 07:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783408680; cv=none; b=eWknbSb4reJQXPUcQV8RWc0B/DJ2dkTcVsdhO1OktP09ZDwuYvg12hRgvt/+M8P/ozTpelPbpqroqb980swv+gZj4Ew/zBOl7OiIzV/kzhNCXjIfz8BTJQ/UogEJVMPmMpeajLXJCrDfOrI3sPjCdR86icSPE0wsC6clXgN5vOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783408680; c=relaxed/simple;
	bh=cGLCQh6wZ0aNinLvyIH26tvshxYDnjIqzlS5eWbWPRI=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 Content-Type; b=B8GMIXlgv7uZ+HikSLsQbZH7AjaKPTTxB5WBeXA7Gq72VUk+R9RmfQ7/cdlHbF1oc4SgNaFnRsMcWvbrHVMBfFBjKgk4dbp+2fdp/jCWpOPA5gR9nFz5IH3ywkYkQHEGZsVsUuVGbZ6cVCW+2yFcWQ52sn5X0USjY8sw6j+tN94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IZ4v3YUI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IZ4v3YUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7C31F000E9;
	Tue,  7 Jul 2026 07:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783408675;
	bh=lXCcLBiZs73hCRuS29KgoY30XduScKoRtjao+2aznS4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=IZ4v3YUIJO+O6k20Di4RG4lrocrUd6rg/TARc2N6bUjHBYVOWPHOnsVqrxGY1g4vk
	 DuqM8Jllph/OZ5tVYuYylFf11NdUELsEtiNwAfuh/kP/4u9PfHED00rooBs3LODPaF
	 4NBBw5ZMsI1RKoZ7bi6wKcTtFWQXqRoAgTwoyOq2G70qsaQy+SWbLO6jaEN1ZJEQg4
	 VNm4rnvjufwTtwW2kWdO2rWv7+UJjUY6vf6Diu2l2zLSEV5jwBmFX22SJUr4Ez8Aem
	 vp680cuePGWvDHheWrEGxzQInhA00ILkHq6SVuB9VR0DJF/29rs0jLtmRqY0XkDNMA
	 SIY2P5Uffbebw==
Message-ID: <148f56b82d506968c2eb567e87069ba6@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, =?utf-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Aaron Tomlin <atomlin@atomlin.com>, Guopeng Zhang <guopeng.zhang@linux.dev>
Subject: Re: [PATCH-next v10 00/11] cgroup/cpuset: Support multiple source/destination cpusets for cpuset_*attach()
In-Reply-To: <20260702214757.579012-1-longman@redhat.com>
References: <20260702214757.579012-1-longman@redhat.com>
Date: Mon, 06 Jul 2026 21:15:59 -1000
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

On Thu, Jul 02, 2026 at 05:47:46PM -0400, Waiman Long wrote:
> Waiman Long (10):
>   cgroup/cpuset: Make nr_deadline_tasks an atomic_t
>   cgroup/cpuset: Fix node inconsistencies between
>     cpuset_update_tasks_nodemask() and cpuset_attach()
>   cgroup/cpuset: Prevent race between task attach and cpuset state
>     change
>   cgroup/cpuset: Put all task attach related variables into attach_ctx
>   cgroup/cpuset: Add a cpuset_reserve_dl_bw() helper
>   cgroup/cpuset: Expand the scope of cpuset_can_attach_check()
>   cgroup/cpuset: Make attach_ctx.old_cs track task group leader
>   cgroup/cpuset: Move mpol_rebind_mm/cpuset_migrate_mm() calls inside
>     cpuset_attach_task()
>   cgroup/cpuset: Support multiple source cpusets for cpuset_*attach()
>   cgroup/cpuset: Support multiple destination cpusets for
>     cpuset_*attach()

Applied 1-9 to cgroup/for-7.3.

Thanks.
--
tejun
