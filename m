Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FD937646E;
	Thu,  1 Oct 2026 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790869810; cv=none; b=t8e5FQxssCMryMlAJuW2aZ1q0ih3Z37GXcusg3usffWZfvxe7PuqRqWoNTh66+mdoqCUlLqmySPJB4MSQBTuLTuIDc782WOFju5e1oFblOtF1JSsb/LJNiHeKvIbIdiBveYTGje6YPMyaLL94dCRm4zGSva4Yj6tou5Jri5zTSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790869810; c=relaxed/simple;
	bh=PdF8p2ZI2uQejqtY9aserBwe4AxQkxlkqFwob8MRz6Q=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=V18U8c5AYl2wa16IE7YW+AhZWu5X/gdUZ0SSOcCRBhcbIfusCn3KNccF8vuv/Ay7D14nzyu56iNfLuHHqwRfwEaTfV7Wv6R1Yy4Sct/jo6JQ2R/1Vw9juJc5UGUztBJbYxPInUQfAcop0RztkvsRwma+MpVbTLz+gJdrQ+BUjM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dp56ESLh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dp56ESLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7F31F000FF;
	Thu,  1 Oct 2026 15:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790869808;
	bh=X+57FzkOegW9YBdETSFnlMg5tct64oHtPmLHW1sZowk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Dp56ESLhx15znR8kW1wb7d2z2HKct7zLXF7vkbF5r/vugtbt4x6UqPf8rADY8bUlW
	 4eNEFnNyaO/T/a5eAJZ2nupu9o0swBqcpPtJfMUC4VnQq/RJ0IUz9Otjrk1gSLx4r8
	 gxKFcnrzc+OtZzgg6y/EkAnlWV2YoVEHl9S4H8HFtpCT7sruTqzHXuYfCwsonMqwfB
	 BcNX1DvD1re523Y9jy046Jzv6z7sPnOcqG7dp3zuaWxl/GMZ1NJBdP5tBYiYdCvrj0
	 ty29WA8Izl6C+dzzhwtwOxD8oXwnn36pEdRMNy26YxIfqJ3ZlAqgQISvkO5TCOs7Wo
	 u4Ib2Z8vxMbLg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B4394381195F;
	Thu,  1 Oct 2026 15:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] bpf,
 cgroup: fix cgroup struct_ops query for a second attach type
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179086980753.2537503.5108865645630186229.git-patchwork-notify@kernel.org>
Date: Thu, 01 Oct 2026 15:50:07 +0000
References: <20261001141901.3225830-1-shakeel.butt@linux.dev>
In-Reply-To: <20261001141901.3225830-1-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
 andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, martin.lau@linux.dev,
 song@kernel.org, yonghong.song@linux.dev, jolsa@kernel.org,
 emil@etsalapatis.com, ihor.solodrai@linux.dev, ameryhung@gmail.com,
 tj@kernel.org, kernel-team@meta.com, cgroups@vger.kernel.org,
 bpf@vger.kernel.org, linux-kernel@vger.kernel.org, laoar.shao@gmail.com

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu,  1 Oct 2026 07:19:01 -0700 you wrote:
> Two things in __cgroup_bpf_query() work only because CGROUP_TCP_SOCK_OPS is
> the only struct_ops attach type.
> 
> It calls cgroup_bpf_enabled(atype) with an atype that
> find_atype_by_struct_ops_id() works out at runtime.  That macro is an asm
> goto and needs a constant.  Today the compiler can see there is only one
> value; add a second type and the build breaks with "impossible constraint
> in 'asm'".  The check is not needed anyway.  When the key is off nothing is
> attached, so progs[atype] and effective[atype] are empty and the count loop
> leaves total_cnt at 0.  The other attach types already use that loop with
> no such check.  Drop the check and the skip_count label.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] bpf, cgroup: fix cgroup struct_ops query for a second attach type
    https://git.kernel.org/bpf/bpf-next/c/b5a4aa31abd6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


