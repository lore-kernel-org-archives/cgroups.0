Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794950428;
	b=ekl1wjfLhIX//WQ4EUAVv9WSTwSV/tAMld6D3G1p1x0/G76HnJ1QrHtrD8h22ct0eAOW
	 XA+733ulxgav/1h4yivPGas3uTrBA5R9AhEPuEutfkWY991BBXtdEhMfZlcf/DFVuxpvQ
	 GNk/fd6xNkzAUPd+CM9tl/PffET8PrEN5ITdTyOPzYO735TCMhB585mQMoowZalJ8RZRB
	 NrYzPEPDgr07ZxYPsbVLQAfliEfpiGqIv094dCHBs8P0FoeWweruycnrWASKHd5MWT0Em
	 W2Xi+L4OieLs7RF3fK+myrhVnbUhsw5KhePTeuYp2IWbl1XqC0V3uIHG1t8xgGZrSOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794950428;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=DheqoHKPiK2wYR7ZSru1q0/iSSyu0uoVd6RuyNzgFAM=;
	b=wtoy4eYANZhD64ECrdKFRqe/O94nELaoUmFVYLFn9vHZvhn4UkYHirzY3opblp2uJ1U5
	 r6KwRWkyoQgda1wmtDitDjPn3zxXVD04jIcEzQ7sAvPzlQnM0MaVoAPocLv9g55JVhv2F
	 Wm5XsF5HT4pW1GqoEk+rmdhgkYHj1vDj5gGbH+cGrOw2LzYs/PZP8IxDiXy+E9ECty5Rz
	 oOi6e7SwBL/z3mwuztoLxScpWKowYmIWGSGazi6cBGXCtI84gh/sW/ZfLdWuAkXmeSUJF
	 VG+Wscln053bgu86H53iEqh4BeA0rFY6kp4m+W8Rh4Jw1fAX2mFBBqCL9t0d2sRYB9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WdI5DEdQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEC7606A31C;
	Tue, 17 Nov 2026 21:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WdI5DEdQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C7A1F000CC;
	Tue, 17 Nov 2026 21:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794950428;
	bh=DheqoHKPiK2wYR7ZSru1q0/iSSyu0uoVd6RuyNzgFAM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WdI5DEdQdZ3fV1EGq0oRY4/NzPMI3slniVFwwbMflkvfPMj2fwyxvfhoWM29R3rW5
	 SqUQ3x5bMLJnJHUzI/txe81vZWIGxmTLt9mW60OW19uKm3YziUAdt6D87tnM0JaNqI
	 2ZzkgzYMbXL5hLdl4kJj0jgZsYNlg8kDUwHy9AFLLGtgJmzTDi6uI2g2oolZ1xh02D
	 otz2aa2AiX0wtmjwiaChD3Niq3deBWxvcrm8qVsnWdpLlYpMlq4qpy93S4ye6GePDo
	 KOh7/pTqSegXUVK1YOuRLK/UgX5yx2CwxmJuc6HJOGUHN/VngRTJuf4qOUNAVsovYV
	 NsFrYoDqLlJJw==
Date: Tue, 17 Nov 2026 11:20:27 -1000
Message-ID: <4a8412ecdace6db2f1f3099e30d04efc@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Yu Miao <yumiao@kylinos.cn>
Cc: cgroups@vger.kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, jiayuan.chen@shopee.com, nphamcs@gmail.com
Subject: Re: [PATCH] Docs/admin-guide/cgroup-v2: add missing npn tags to zswap stats
In-Reply-To: <20261117062620.346767-1-yumiao@kylinos.cn>
References: <20261117062620.346767-1-yumiao@kylinos.cn>
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

Hello,

On Tue, Nov 17, 2026 at 02:26:20PM +0800, Yu Miao wrote:
> The zswap, zswapped and zswap_incomp entries never show up in
> memory.numa_stat, so add the 'npn' tag to all three.

The npn tags are off in other places too. Can you fix them all while at
it?

- swpin_zero, swpout_zero, zswpin, zswpout and zswpwb aren't in
  memory.numa_stat either and are missing the tag.

- pgscan_{kswapd,direct,khugepaged,proactive}, the matching pgsteal_*
  and pgrefill are in memory.numa_stat since e4f4fc7aa8b7 ("mm: move
  pgscan, pgsteal, pgrefill to node stats") and shouldn't carry the tag
  anymore. The pgscan and pgsteal totals are still npn.

Also, this should go through -mm. Can you please cc Andrew Morton
<akpm@linux-foundation.org> and linux-mm@kvack.org when reposting?

Thanks.

--
tejun
