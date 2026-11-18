Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795009743;
	b=IwD8zWwW8EBnYyfm89ah8efRVAD0XvPYEUGkDmIZ20vT9PwBsmVkz+aMGSEreh1Njb7U
	 ZvMN6E0btjnCuK4of4/QiPbnKPzlq1GTOSEufALuhtWqN3wDmJtVN8ah6OhVlKgO8wynO
	 M48lyEcjb+8T5dbvimm8ZgJKCpVI3QmSWIN7lz5t07vL+GI1fwvn6sV2vjLRoC/4ZP6Ll
	 AeUZyFaNdrq/mQ/ilitYOzx2vYH+W07zHeQma1LREgDtOvO+qhzGXmkgVG/FoBANtV7Pn
	 lTRcx/xLJIiqMNKGgGrhEoSk44lloF8BVop92CE9piAYh7Vp3kFuXik2xYYy4nQqCWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795009743;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=kg3/2WSEF48K16S8eY4N4mkOOBWAKgW1uoUfjVNWPkk=;
	b=ipOYthHYSqINryu0KGig7Bz6J6Z2snznaw2c70mAMcpM/4Ynt4124ZNkWSRhO7x8sKat
	 4nKKqFtga/KqdxZKZrg2ttSVlfb8yK1Zle58VclLyFg47s3DTCGoTfWQNlDNUrXPyPiw0
	 yAeVvY2qAfr1UOWwZ+jqCrlTL+PUmfVcAbSOKiaDnrBl/H/pu/iXxUSB+5uPWvE4QAlBG
	 C7QieQnAq/QE0ynh6+vlTQrd+FZF4zKWtU8vjCvF9Xu3nQCMLWjOmePJOfTGutjBnYYR/
	 a7JT/Yoc+CMc0u74RVYVJui3u8HCviCOto+lz4aLIi0QG1b231BH9X+/TM4uBJa8aBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O2xESez+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC9C606A31C;
	Wed, 18 Nov 2026 13:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O2xESez+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D291F000C5;
	Wed, 18 Nov 2026 13:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795009742;
	bh=kg3/2WSEF48K16S8eY4N4mkOOBWAKgW1uoUfjVNWPkk=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=O2xESez+TAx/K2PNND/MnGPq3e+0wdgpkE0oBA/E/e2hPwcDzEVA6mxva0EGoOxlX
	 +v032pL0SOQjI23Lo6tEoSuCAZxDIsEE0TuoWVIPnSwuyub4YyMe4hfSzSXV0pXqSa
	 cg7Hbc0R6hD6OrpN43zIt6CeLVaSKpnZJhD5/vd68bmXPDV5UE9oixW/H5XPNcx7JE
	 NWiEF0+0JD9OZDFe2ogB1pNz/kbCnnyviL2WtCMUO+gd95NbBnMLDT50SxIcgxpnL6
	 /zdlQA95RdjtkG+yeWdOTseeEskzCnuO8ITKHXCN2mQ+dGuGEr1mAsHkyvcH/HBLlX
	 a7K1Su7631TEw==
Content-Type: multipart/mixed; boundary="===============8556325825995458152=="
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <8823762c289ef6a65710cf359f0bd7e930fb53b08c98852d2bd759a9f437fcc3@mail.kernel.org>
In-Reply-To: <20261118131029.797007-3-cui.tao@linux.dev>
References: <20261118131029.797007-3-cui.tao@linux.dev>
Subject: Re: [RFC PATCH v14 2/4] blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary
From: bot+bpf-ci@kernel.org
To: cui.tao@linux.dev,tj@kernel.org,josef@toxicopanda.com,axboe@kernel.dk,ast@kernel.org,alexei.starovoitov@gmail.com
Cc: cgroups@vger.kernel.org,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,andrii@kernel.org,eddyz87@gmail.com,daniel@iogearbox.net,linux-kselftest@vger.kernel.org,cui.tao@linux.dev,cuitao@kylinos.cn,ameryhung@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 18 Nov 2026 13:49:00 +0000 (UTC)

--===============8556325825995458152==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary

TL;DR: The new iocost_ioc_tick tracepoint comment describes vrate as relative
to VTIME_PER_SEC, but it is likely vtime per usec (VTIME_PER_USEC is 100%), so
users following it would get values 10^6 too small.

> diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
> --- a/include/trace/events/iocost.h
> +++ b/include/trace/events/iocost.h

[ ... ]

> +/*
> + * Periodic per-device summary, emitted once per period before the vrate
> [ ... ]
> + * vrate is the current vrate in vtime units, where one IO time second
> + * is VTIME_PER_SEC (2^37) vtime and cost.vrate in io.stat reports the
> + * same value as a percentage of that base.

Is this description of vrate accurate?  The field is filled from
ioc->vtime_base_rate, which is vtime per wall-clock microsecond:

    __entry->vrate = ioc->vtime_base_rate;

and io.stat computes cost.vrate as a percentage of VTIME_PER_USEC, not
VTIME_PER_SEC:

    unsigned vp10k = DIV64_U64_ROUND_CLOSEST(
            ioc->vtime_base_rate * 10000,
            VTIME_PER_USEC);

ioc_refresh_vrate() does the same with
div64_u64(ioc->vtime_base_rate * 100, VTIME_PER_USEC).

Someone following the comment would compute vrate * 100 / 2^37 and get a
value 10^6 too small, since the nominal 100% value is 137438 (2^37 / 10^6).

The commit message points readers to this header for the exact meaning of
the fields.  Could the comment say that vrate is in vtime per wall-clock
usec, with VTIME_PER_USEC being 100% as reported by cost.vrate in io.stat?

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44312765238
--===============8556325825995458152==--
