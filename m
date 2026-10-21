Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792579755;
	b=ciExzBgUkr2MGE16eWd6D/PugkSNSadjJxAdTLX08uplReqe5GIWAz20KsBgbkvLiFRR
	 uxsF0kGth4du4RZX2Jq1B6ySTDcwo24PGrT/9mxMbeM5DT32icRDfpc94kYAL8Qj4N7ik
	 gUTOa+RgBEeyASWggzWORafI2vWykX9umTRHv8dHnZuBfkAh7K6wPTtnrfBut23YSbgjZ
	 PgalGmhtXPwK/Kf8mX/cD61FU45M0xoyPhtCFKwuAZzxeW/VobY/siCfcrBq2FQbzPrJo
	 xFEWrGSMQS4+iFC2mLi6aSg/HZezj8jgqL+N6m1kcG05/07xxWfwcxVl8b6gZlKZ+rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792579755;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=a6j8VvuZql8VshmBaFWvTWJSnRqnfgGGAQcEU92nPh4=;
	b=OHIc3zv8eXLpzaxVFBpiQHuqTgZKdzBc9Np+haYupQDLNKQjjTinpCeu5PRnh9VINGuo
	 Jv+QV3P9wRqDlgJ3dgvJaNKIWdC3RoAC4U85cVKjxn74dGuIGRKaPla5utbKPfUkOsFe+
	 gqZspPYjXpo/nUIFllIlFH3Fnna44SazPvp13MW+JenI5YOqD6rvbq0tFZM7mqLKNNOEm
	 ZnI7dpJF+4dWu1FutQv2hFTN0CPUSuITsS5N5JHBTddBJLn/DFRU6xkYfpvatziH7vs3O
	 Ezn+IGRXYNLtASjoaHs2ntm9MjnCEk16Y4N+UAweRekrinWKq8VLG111FZEEU5GINvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ktTFZgSa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03A3606A323;
	Wed, 21 Oct 2026 10:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ktTFZgSa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2974D1F000C9;
	Wed, 21 Oct 2026 10:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792579754;
	bh=a6j8VvuZql8VshmBaFWvTWJSnRqnfgGGAQcEU92nPh4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ktTFZgSaXewBcZAJ7e4n0ylcCZtDk0VstshZqq5L+H5wUm+DlyHaZY4sBgoz+KoPa
	 ENG3oelI37RsleO3YYEZO+unP/LpyOCn1vdAlOlguRoyr1MLEAvQ/4xPOi+OwriRcj
	 1DyriKqEpho5M/Y2DZtLa38IoEt81Ztubhzkf0LIu2TQ5YKpSBWVOdjqvvwfXKaY1j
	 twFxsKgHQ6lFYBGDyniCBCFZGKcgHHFR5eG/VYt6WdnTYp0FO56Y5EoNPC2dpd+dXT
	 z175Q6JppgyH+z5XFxNXLbNpsI7f2R0EEGXRo2xSPqHShS6kBKROa7xVufU63GDN++
	 ZoKOdBzBZPCQA==
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>, 
 Liz Fong-Jones <lizf@honeycomb.io>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, ian@honeycomb.io
In-Reply-To: <20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io>
References: <20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io>
Subject: Re: [PATCH v7 0/3] writeback: let foreign flushes reach dying
 cgwbs
Message-Id: <20261021-anbot-mahlzeit-bankwesen-0c79e6d05fe2@brauner>
Date: Wed, 21 Oct 2026 12:49:06 +0200
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1646; i=brauner@kernel.org;
 h=from:subject:message-id; bh=48o0GEFu3mgqTW8sPyMN6GkxqnwEI0p4H1ZDHkTr9zM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTdmLFU/a3Iiziezj9uslPWMUslzCxZ87Lhru9V/7sKs
 XFC3o/mdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwk+RMjQ1vuqnOHSoMV9gut
 rUxUfHPT55Hrpv8rNrddzTSIVEvzesnIMFkktz0z3C7W/uPcXbde2YfU76kun2OmwDvZb9GWtWW
 P+AE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Thu, 15 Oct 2026 11:40:46 +0000, Liz Fong-Jones wrote:
> writeback: let foreign flushes reach dying cgwbs
> 
> At Honeycomb, a container that reads from Kafka and writes columnar
> files to a host volume stalls for 30-60s after each deploy replaces it
> (v6.18). We're increasingly confident this is the cause: the stall
> looks the same as in the reproducer (little CPU use, lag growing
> linearly and then recovering), and the mitigation it predicts, moving
> our final syncfs after the last write, worked in production (below).
> We haven't caught it with probes in production yet.
> 
> [...]

Applied to the vfs-7.5.writeback branch of the vfs/vfs.git tree.
Patches in the vfs-7.5.writeback branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.5.writeback

[1/3] writeback: clear the old wb's dirty IO state after switching inodes
      https://git.kernel.org/vfs/vfs/c/d70ddc66a4ed
[2/3] writeback: let foreign flushes reach dying cgwbs
      https://git.kernel.org/vfs/vfs/c/27f228cac83e
[3/3] writeback: switch a replaced cgwb's inodes to its successor
      https://git.kernel.org/vfs/vfs/c/90158789e8a5

