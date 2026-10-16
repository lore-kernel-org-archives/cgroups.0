Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D47598C12;
	Fri, 16 Oct 2026 17:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792172999; cv=none; b=W18jYOtIYsfQaFjGEY5n+BGtSzCMDMfmHy6Tkwt8AkUjbzM2qfLIFLFe4MEGWONfwK4m1TWCf0dMLLNWVwmmw/z9Mm2axpfnaegC5qVBw7nTQOz+p2kkZTSJfWmr1fbk0VIe0UqEjxoypeFGTajrT0+LEaDtwaqQNL5eUXF00nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792172999; c=relaxed/simple;
	bh=a8R9Nykw0vbuP24B1Ce0ytty22BYJFKBHLQ5ty5mZ2E=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QchkekeYP7kd9XsLyYByUD7g6erkhU4tM24ZQ4eHn6Qjjmv1NEArfPazFTrXTwmqbC6zaTp9HUnsrMqGZNGdTqPd9QuOBPv2Xt+HlG6qfwXv84P80RQ47RZdol9hdm+DesV/rX9nNe4lEx1ZWN3Wk9VpZHKRdHtijSB8g2V13TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RTs9n4Gm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RTs9n4Gm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E842A1F000C6;
	Fri, 16 Oct 2026 17:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792172998;
	bh=HysAQR1U8FxlpDQ2eAHgUp6NObu+wWu6L6vjwHvn4Rc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RTs9n4GmATQ7G7/Iv15fue3wfPGrGf2i8PV3e+PabIOU2N29auxQmLTwM+QFay/xs
	 UdgTkd3uA2R9CSEBUhYLSgpr3xFtkW0a3uvAp2JYyX2XrEi5BBOYOhK2W8u7C3tlCB
	 CsnyaHI9SFSyxZmsejcaPs7vpleMhqqM8jbBXxb6PKjI15/2jx0NKcL6ouQbJQWhKN
	 E5fMPJtj8v9cdrG8me/5gweIACeWlNG9v+S20Ew/BDuQewDa3D9Oilo4TV7+8mWUa1
	 DqSB+yJM/eE3YVdZDM9kZobZ8q7EAmuqRFsn+rFyAy+HRgYJqjEdOPA+Ri1Col6lTr
	 EW3gCybai1jzg==
Date: Fri, 16 Oct 2026 07:49:57 -1000
Message-ID: <b76b821edba101b68f085f03e8613d7c@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, ast@kernel.org,
 daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>, ameryhung@gmail.com,
 alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v10 3/4] blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary
In-Reply-To: <20261003124045.1289305-4-cui.tao@linux.dev>
References: <20261003124045.1289305-1-cui.tao@linux.dev>
 <20261003124045.1289305-4-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Tao.

On Sat, 03 Oct 2026 20:40:44 +0800, Tao Cui wrote:
> + * Periodic per-device summary, emitted once per period from the tail of
> + * ioc_timer_fn().  Unlike the state-change events above, this fires every

The event is emitted before the vrate adjustment and the period
transition, not from the tail.

> +		/* whether the controller still has active iocgs */
> +		__field(int, running)

nr_active counts every entry on ioc->active_iocgs, and ioc->lock is held
from the count to the emit point, so running always equals active != 0.
Maybe drop the field?

Thanks.

-- 
tejun
