Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB5B3AB267
	for <cgroups@vger.kernel.org>; Tue, 23 Jun 2026 05:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782194336; cv=none; b=eenuFu5J+JBseIoiUYGMYGTs8y8nXrQ/EBR+L9gJe5zSQ/EYOzE9gzTpkoheSqJnaZ1oey6k+em2FazcfD8iEVA13l8Pwo6xSH6hqrIe/9qkWQKOLlI1VyizHFpsXFUkLMaZNXgfCQgg9mCc46Ac4TlgDCJaJTZ/U9U4n0dpJsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782194336; c=relaxed/simple;
	bh=BF+fnszT7Ayv5kvorYEhcGeVBctjq9mWvzd4D+GVK5s=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oQ0lz+mcN5E2tpgqCl6ewzzoAxf5D5WSrDBroOZC0bqEKo43QHDxfsPE9b0ZhfXPm/9HQF1SedeZwg2/D1Xmci5hWGXYD7Jead6ElJMLF0teZh7YotkEcP9r9/snemdvjkpRzR4aTaYhaqKfJj6SeMUUejcU4v4oSXCFX+jDZmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tajNv4dA; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tajNv4dA"
Message-ID: <5f3df3f7-87ab-47f4-a021-3fc1c367ddf5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782194323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/OETd/OZtVTRrWJlKdXZTAknAsVWCSn0UUVqxdY0ju8=;
	b=tajNv4dANbPUzSpI0XOwof87LP5yhX8ovKjw7LhFN1KGVhPA1cfo5u021j2ER3rCVH3SeO
	vuoIQLS0k9o1V4HR9OAn08KgbbN3EMvOa10fDhtJoD/pNtoD5unfpwKiRCLYMPoOhoOOHP
	QRxySrNX3YWj9HGfqyFJQrDVPcyOCYU=
Date: Tue, 23 Jun 2026 13:58:35 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] cgroup: Use READ_ONCE() for task->flags in
 task_css_set_check()
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
References: <20260623022946.525885-1-guopeng.zhang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260623022946.525885-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


Looks fine — this is a benign, PROVE_RCU-only race, and READ_ONCE()
documents the lockless snapshot with no functional change.

Acked-by: Tao Cui <cuitao@kylinos.cn>

在 2026/6/23 10:29, Guopeng Zhang 写道:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> task_css_set_check() uses rcu_dereference_check() to verify that
> task->cgroups can be dereferenced. One accepted condition is that the
> task is already exiting, tested by checking PF_EXITING in task->flags.
> 
> This is a lockless snapshot used only for the CONFIG_PROVE_RCU debug
> predicate. This was found by KCSAN during fuzz testing. KCSAN can report
> a data race when another task flag bit is updated concurrently. One report
> shows pids_release() reading task->flags through task_css_set_check() while
> do_task_dead() sets PF_NOFREEZE:
> ...
> The changed bit is PF_NOFREEZE, not PF_EXITING. PF_EXITING remains set
> before and after the update, so the task_css_set_check() condition does
> not change. This is not a race on task->cgroups and does not indicate
> incorrect pids charging or uncharging.
> 
> Use READ_ONCE() to document the intended lockless snapshot of task->flags.
> 
> No functional change intended.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
