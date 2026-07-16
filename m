Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5804132C923;
	Thu, 16 Jul 2026 19:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784230959; cv=none; b=eIV1DACaYpi2f5quvrUK4hW0Jftc5LBenle7kyYQJR1LizzrGeoLXC2G2WxmMoGVoSyf05F/5s29UH3PL6iwRVtNpcxxmyXR1Wq2b53tksG4UwUlc/TvDB15aPpwsaCvyVzeXjUVS9J3HFH+YAskXE2bKO7yJCkBOrBlhkiR1yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784230959; c=relaxed/simple;
	bh=qS3+3x5gA6CR1I9NWsMBJyDvs5SUwEtVDUSXomZSiPU=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=faBtmKdeVbnHragInLXVvaffHW1LXTZsl9dnG3GofXnVKYGoPfJT/o7HCy3mYSuAJuLR/TRM+BVjKfhPhmhvpmJPI6zfwaSB44mMJOyIpvNmpUzaGZc8s51Cvg4h83qlto0gOwWplsYxPdfweVzknlD7MjT55dQIixh3kSG2dBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=boBx3YHq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="boBx3YHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E022A1F00A3A;
	Thu, 16 Jul 2026 19:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784230958;
	bh=LJY2m8VsmTxXcmThShd1jFDWvm/vMLxqsuY+n15n1v8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=boBx3YHqNF50gk84vRNJ/zEoQsOOFHLFGahQfKj9pV6YE+gM1Cw/Ima74LIpufBLz
	 YF7gjxeW1vALhYaQU9SB4zu0iOjuToXmdD87yDdgbTbv9+LsfaQyhFRtHLCqeY+9s9
	 cxcfcFp0LayCxgZSubLsLfx+MRc8JXwGZjiEmRSO7OWQObfScR1kOi11vMSEPqUZNx
	 fthFxgj23zSO5p8LU7z80yxISLp9MKx4cxvG8ZFgkifs7lAEfLN+4Hsv7I9OLr1awc
	 WUOQU3dVHsqk5eJB39jJrLmQsR+UBqATc/tZ5cjOZ7dRLyYtsjgLUWie1ocj/uUcnc
	 MNNSXrn7ESfCQ==
Date: Thu, 16 Jul 2026 09:42:37 -1000
Message-ID: <597fd8e0d3c2de61aeecd3645a7b8198@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutný <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH-next v3 0/3] cgroup/cpuset: Support multiple destination
 cpusets for cpuset_*attach()
In-Reply-To: <20260712235510.373125-1-longman@redhat.com>
References: <20260712235510.373125-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

On Sun, Jul 12, 2026 at 07:55:07PM -0400, Waiman Long wrote:
> Michal Koutný (1):
>   selftests/cgroup: Add test for cpuset affinity on controller disable
>
> Waiman Long (2):
>   cgroup/cpuset: Support multiple destination cpusets for
>     cpuset_*attach()
>   cgroup/cpuset: Handle the special case of non-moving tasks in
>     cpuset_can_attach()

Applied 1-3 to cgroup/for-7.3.

While applying, fixed a comment typo in patch 1:

-			else if (cs->dl_bw_cpu >= 0) /* && cacnel */
+			else if (cs->dl_bw_cpu >= 0) /* && cancel */

The following selftest issues remain. Let's address them with follow-up
patches:

- cpu_set_equal() iterates sizeof(mask) bytes rather than bits, so only
  CPUs 0-7 are compared, and the assert compares a byte count against
  CPU_SETSIZE bits so it always holds.

- thread_b doesn't wait for thread_a before advancing test_phase to
  AFFINITY_THREADS_READY, so the main thread can read affinity_a_before
  before thread_a has written it.

- On a machine which doesn't have both CPUs 0 and 1 online, the test
  fails instead of skipping.

Thanks.

-- 
tejun
