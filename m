Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CAC23817E;
	Thu,  1 Oct 2026 00:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790813425; cv=none; b=iwdGmIp3Z95Dop38+gyfxxQVubPdllUGE4MK5n6M6y8vmn9gQkKItxdC7sYnkWd8sJvp/u95YLKklM852rpIydU4+Waplk/4qNkPe+sQkCfIKMAwSGRWfiLN2nkfGH8qsegmUSfAwokSxDnRL1pW1ffi0ZT6M2UDB0T41CRuy4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790813425; c=relaxed/simple;
	bh=gI39+/PVuv54UQYKxWb6ENO6NXfD9TD576kkvRYJx/I=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bnhhXAhhYENDTAShIYnyGkOmBbKKXdnW/YLO2P/s9W7ugSdm9rtRYxXaFdCLh8oT+aZZpMtSAIi6y8H7PVPYSFwWQdBJjbD0pn5ubC3w6mb9fdwTBwzpeSGYh7gy6kV68BmqsUg2igcJSvb8xRO2A4zAMbJLjvW8goof3OXziy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mzUj2IMm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mzUj2IMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5451F000FF;
	Thu,  1 Oct 2026 00:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790813421;
	bh=gI39+/PVuv54UQYKxWb6ENO6NXfD9TD576kkvRYJx/I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mzUj2IMmVKj0/AwIbgUjU1HNebpxLwSuLAVPU4CQlroRQfNtvMmTX1XR9asWxa/zk
	 Tr05oaVGw6Ttw5xAXzc4NsLVHwStqu8J4s7RmRg1vLpRhepPReMgfT9h5Q3O+L9XYR
	 i1fWkCoJHAVQaqyCuWiXDhN1pUK9vrGmm5mfCs2QuaGcphVeMqDqg4KPJmaoZBETCq
	 1UERlVcsGSq4xOtGyxYzka9Et6a/Gg5tfyewa2qsSqEzQPc/BEVwGoNakaBg0RAs09
	 tk6oPaLZWiQ4cSaRzIuV/2L0iE43bepOgZa/wyI65Zs01w+fCuJN62YYtlgX9tMGri
	 YN9+pjVzR4VBg==
Date: Wed, 30 Sep 2026 14:10:20 -1000
Message-ID: <d4863576d83e373b00ecf9899b00dc73@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Waiman Long <longman@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH next] cgroup/cpuset: Move cpuset_update_flag() to
 cpuset-v1.c
In-Reply-To: <20260930023139.495964-1-ridong.chen@linux.dev>
References: <20260930023139.495964-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

On Wed, Sep 30, 2026 at 10:31:39AM +0800, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
>
> cpuset_update_flag() is only used by the legacy (v1) interface: its
> callers are the write handlers of cpuset1_files via cpuset_write_u64(),
> and cpuset_css_offline() which invokes it only on the legacy hierarchy
> (!cpuset_v2() && is_sched_load_balance()).
>
> Move it, together with its sole helper cpuset1_update_tasks_flags(),
> into cpuset-v1.c so both can go back to being static and drop out of
> cpuset-internal.h.

Applied to cgroup/for-7.4 with the description tweaked to say that
cpuset1_update_tasks_flags() already lives in cpuset-v1.c.

Thanks.

--
tejun
