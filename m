Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2461A6811;
	Mon,  2 Mar 2026 21:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772488601; cv=none; b=IbuBLtQZAD/R3v8rsfhQWBEdgsZASkdTzJJ5FkafMeLBoTbtAYPt1Wcb12Df1PVnrpTZQVpo7jlO64t+q2BkIqYnL30RoaF4BhlKGlhJVlHN49rrjUSb3y3bwMuxOGt+z4mdhD+Vj3aShg67dkAs1Hd1dLYhoF4xAEhVRhqrzAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772488601; c=relaxed/simple;
	bh=UE2MVOl289ObbgK0+40wIBB2si4+wyFn2M+IMfT4G3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NtZFIlRdeWVZlpjnYFMvx2IohTurDJ6n2JJvQDGVTfZ/MhBk1CpGoj+pqNNgX8wALSqdo71ZE8wYVg4oZ5yhQbxLzcFFrHmC0wxBSHIx+GpVAoYZoOXdla62yPNe8tLzmyDv83dIjXbWhKho86heoIW8d5yPwgPCt3uF8ydgRXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kRvxKUmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kRvxKUmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56991C19423;
	Mon,  2 Mar 2026 21:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772488601;
	bh=UE2MVOl289ObbgK0+40wIBB2si4+wyFn2M+IMfT4G3U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kRvxKUmquy0pQpYUBrRNOmty6cnaQzc/xUveZw3X4JhzmeQZNQo2CUgli3772ZeIS
	 8k+sESJBNU7mB/f3N1RyAdCsVBzN7Yk23kuj73wG5PRN0/s3beVW8l0KxWHqv5kRm5
	 rahmkQTelJulzchyJtogFpRArYc9yoxhCVSwFLW5tC8GLZoJl1kgUcCrXkJ1Sy6HLm
	 wt6LSi77uYEK2X9e2BipShejoI0CdxWAWY33kc6crgBtGHc37HsZcePeIyeODpS8aP
	 Pm5+icuMZDfMBh3czHAlwlE7opHaq3vDYrqrtFR3WPOepGA2DAV2jYBV7UM3crsUTg
	 KASxeDsHqvpgQ==
Date: Mon, 2 Mar 2026 11:56:40 -1000
From: Tejun Heo <tj@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-devel@lists.linux.dev, cgroups@vger.kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Bert Karwatzki <spasswolf@web.de>
Subject: Re: [PATCH] cgroup: Don't expose dead tasks in cgroup
Message-ID: <aaYHmCV2CW-tOT-Z@slm.duckdns.org>
References: <20260302120738.6KkDipsR@linutronix.de>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302120738.6KkDipsR@linutronix.de>

Hello, Seb.

On Mon, Mar 02, 2026 at 01:07:38PM +0100, Sebastian Andrzej Siewior wrote:
> Tejun, with this change, would it be okay to
> - replace the irq-work with kworker? With this change it should address
>   your concern regarding "run in definite time" as mentioned in [0]. So
>   it might be significantly delayed but it shouldn't be visible.
>   This would lift the restriction that a irq-work needs to run on this
>   CPU and the kworker could run on any CPU. 

Yeah, that's fine.

> - would it be okay to treat RT and !RT equally here (and do this delayed
>   cgroup_task_dead() in both cases)

I don't see why we'd bounce on !RT. Are there any benefits?

> @@ -5283,6 +5283,11 @@ static void *cgroup_procs_start(struct seq_file *s, loff_t *pos)
>  
>  static int cgroup_procs_show(struct seq_file *s, void *v)
>  {
> +	struct task_struct *tsk = v;
> +
> +	if (READ_ONCE(tsk->__state) & TASK_DEAD)
> +		return 0;

Does this actually close the window for systemd through operation ordering
or does it just reduce the race window?

Thanks.

-- 
tejun
