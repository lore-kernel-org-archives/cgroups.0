Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794683407;
	b=VddxYQ168anXAXv0M7xrjUsXaxEMwFxeUa6aq47OoFr4HXfKrjgu5VXRMM6znISewDxw
	 bwa8SzmT8pcTCQtIRgs2klXDVZOjVWc3In34SMo+8dlYAd+nuVex9Gwfg7FVUWMCBaHny
	 LR+RHRqn1J4BJ7s8VZXayJk9ODrqUf+7ta1I7x5elzm/AxC+nMIAGX9GCVfPugxyKUq74
	 iCMJPrjLvURU2F8nxBDN8GCl4dSK13DhljUJkXgDH8g3MlOLU9YJ7fRz4FcO2WZjBMF/c
	 7drqNWgqXqw5UlPSROU0vba78XHZ22nCCUv1Zf+jCUuxtL5gbjoKvBs8h3fHAAhh4ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794683407;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=tKT6x4msThxj0gozIVJttaxZay8pW0TdepjyA9p1YpA=;
	b=UaP7iy9XnpZeAf3COZ8u5iwQ0siAaA15/pWBrF7kQpV4fncccTjCc7NRnHxE5ifk9m4B
	 NTbtVG+orKCpIuAsDt0OQdKJBZBYWqKBFWKvtbpZ01DMX4T2pz6xnBhzD7QUOKVQvG5ME
	 5p3DBOOQ+VbGZrbZP6KQaFSIC0fjKVMZ5dP8YeZuzEfOcqSOQ26SIEheYTRj9MWGCohew
	 sqcaDjuge1kBhc+5gDh5NZgIK8lRgqJ3WuqP/0mlSUuyfa1g/jdirm5RWK+K/7KSig5Ln
	 s/D4N4Wkk3nLox2Wpvgl2ySUcwm3eVf/hCwl6zOthUYbWPQstjTx6kUdiPjJCA1qLww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bsZzNwuY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AED606A327;
	Sat, 14 Nov 2026 19:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bsZzNwuY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AD51F000C4;
	Sat, 14 Nov 2026 19:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794683407;
	bh=tKT6x4msThxj0gozIVJttaxZay8pW0TdepjyA9p1YpA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=bsZzNwuYRG6dqootzkmC0PXDAZfKQigfM6YLQIYBhwwlnmjQr+JryGxNEZDe0eK8r
	 bCgbPFcxHgCBhnpKmRSId1jpUo28sEi6NhUMpy7UPbenmYxbl0MHdgpUh4kff/vWwn
	 +8BiGQ/zpdJ7JtOf2iU/v6IoqDXk6RKBux5GxR9N91NXnBo5TObhzObDF9HTWwn5Fj
	 VYgEgrD95eujp8gnb8SKR7Rc7sR5syIupCDiN/hVDqpZV/vca3qJDDNbidiDVVRiiv
	 TZMgUFZjGjd4zQlmiBH5cyD5L409ZXH/pDoLT5iLdTNtgrXh1kQvQudACMWuH/kJ5D
	 1zFyhO6Bpv0Iw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A409380821F;
	Sat, 14 Nov 2026 19:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/3] bpf,
 cgroup: Don't wait for cgroup_mutex to read or free cgroup bpf state
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179468340603.2344194.2562831381781655798.git-patchwork-notify@kernel.org>
Date: Sat, 14 Nov 2026 19:10:06 +0000
References: <20261112172721.440275-1-shakeel.butt@linux.dev>
In-Reply-To: <20261112172721.440275-1-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com,
 song@kernel.org, yonghong.song@linux.dev, john.fastabend@gmail.com,
 jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
 roman.gushchin@linux.dev, ameryhung@gmail.com, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, kernel-team@meta.com,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu, 12 Nov 2026 09:27:12 -0800 you wrote:
> In the Meta fleet, BPF_PROG_QUERY callers, link-info readers and the
> cgroup bpf release work often wait minutes for cgroup_mutex. The holder is
> almost always a cgroup mkdir or rmdir stuck on kernfs_rwsem. In one day,
> hung-task reports showed this on 1,075 hosts (query), 94 hosts (link info)
> and 458 hosts (release work).
> 
> Patch 3 gives the cgroup bpf state its own mutex, so these paths no longer
> take cgroup_mutex. Attach, detach and replace still take cgroup_mutex
> first, because they walk the descendants.
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/3] bpf, cgroup: Don't read freed effective arrays in BPF_PROG_QUERY
    https://git.kernel.org/bpf/bpf/c/90f4e698f9c1
  - [bpf-next,2/3] bpf, cgroup: Don't attach to a removed cgroup
    https://git.kernel.org/bpf/bpf/c/b2e007371909
  - [bpf-next,3/3] bpf, cgroup: Protect cgroup_bpf state with its own mutex
    https://git.kernel.org/bpf/bpf/c/40aec6bab02e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


