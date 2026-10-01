Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18108351C27;
	Thu,  1 Oct 2026 00:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790814061; cv=none; b=WxPRoudf0jKfDoXpn77lsCfMPRNivft3jFr4tw49WgYGrWxE5KqyFTdbcPEQwxZ6XJ4ts6GWFqqTJtarqvRNpPcPuNIjJ6CTsamGnJ/8cISdGNb4zb9SeP+HwKg6g84VORh9bX2czA/3yYkVTnERW12s5fG12pAHSrjVgduy/Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790814061; c=relaxed/simple;
	bh=yuxORQlGnMOpW40kkc3YnhipWX5peIfy6092QZ5/UMY=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=ln4Y/j9Nag1+9muSTyl7BR3QQerrIqN9/t+LhUzyL206ZWrx6X9RohMrYX4ccD4Pd85lHYPb4FtM/+2DQlU7vCg8HXVeZuYK98rqawVsraqOFGnpbnF+oSFfhh69giswetJ1Zl8TgUXH2n0NobFL8MvPcXdLLG2fcE12neCol2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dylWqnLb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dylWqnLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402971F00899;
	Thu,  1 Oct 2026 00:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790814059;
	bh=seO9E854noC/3LuUfYHeeC5yA+NY/bP6dH3CPl3Ojno=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dylWqnLbxwpki/jkNGcysEtewyGj20XNw+Op3O/Uuc07cculTfxK9beJ9lpao25EN
	 qhCi8T78RJv7dC5lFg+V5CQ+hzOPW9zs3cUzRoqFRiayYsNVcBu0oYm46rn3wi1zo4
	 C6EXWKMgYJP2AqRV2eEAAjIImvDrFAHxdVik296WHiYF9XwAcRpMfIU/OFcITk7QkA
	 G1ZeWRv0NSfr0eoMjX/l7RWqih4QFENnR+RXKA/YLnKGBXpakjVHaezSUB2IpY/SPO
	 4C2Xi9jL7im6OQWBnTjovmr454cvtrtcQSG1vEYRJoWg1KxaoCI5TlemeZLptcilYJ
	 jG4KMNFmaaVpw==
Date: Wed, 30 Sep 2026 14:20:58 -1000
Message-ID: <7335927f4aeb61a7b92066aa58d45446@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com,
	ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>, ameryhung@gmail.com,
	alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v8 3/4] blk-iocost: add iocost_ioc_tick tracepoint for
 per-period device summary
In-Reply-To: <20260930075154.189958-4-cui.tao@linux.dev>
References: <20260930075154.189958-1-cui.tao@linux.dev>
	<20260930075154.189958-4-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Tao.

The following is a Claude-generated review.

On Wed, 30 Sep 2026 15:51:53 +0800, Tao Cui wrote:
> Add iocost_ioc_tick, emitted once per period from the tail of
> ioc_timer_fn() with the overall controller state: period_us, vrate,
> busy_level, active iocg count, usage percentage and running state.
> It fires every period the controller is running, including steady
> states, plus one final tick before the controller goes idle, which
> makes dormancy (e.g. a device saturated entirely by uncharged IO)
> directly visible.
...
> +		__entry->running = ioc->running;

The timer only runs while ioc->running is IOC_RUNNING and the switch to
IOC_IDLE happens after the trace call, so this field always reads running
except when racing ioc_rqos_exit(). The final tick before going idle
reads active=0 running=1, and dormancy is only visible through the ticks
stopping, not through the field. Can you either drop the field or report
list_empty(&ioc->active_iocgs), and adjust the description? The event is
also emitted before the vrate adjustment and the period transition, not
from the tail of the function.

Thanks.

--
tejun
