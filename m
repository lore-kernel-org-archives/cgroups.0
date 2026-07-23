Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8BC387588
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 06:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784789262; cv=none; b=rmZT9bbRPKppBGMkB4Ex+CwRFR/HW2p6iJA5gfG0VvCyO3tGrbXnNneQgSFSSEAIjzUnRdpoaeh19en/vbdJivfkgW5Y/LZNhxZO8iII3Cz6t/dm1vleEnJd6plQ0DTFg9gHn0EDTe+2PldtPzvMKwFEOBf8c23VFIZ9it4fxQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784789262; c=relaxed/simple;
	bh=YdzApvx5wWv8zrydjgZp0CCocv3EAfExkyadx6vI6Ig=;
	h=From:Message-Id:In-Reply-To:Date:Mime-Version:Content-Type:To:Cc:
	 Subject:References; b=q3t88fQ4gaF8WAQcIc985/VMD5+/xyGBawl9aSmQ/HYxURxeJan2MxeIRXWeiYn67i3oHvvbAci8AJ/4hYeUy3QfDde2qt7nvuSWVYKbRQSfemhU8j9oC3faBqzdHukPPqK74sOOPl58w2kKCx7044W9HfIVF9VoqgrYegzCXkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=C0yCcbeq; arc=none smtp.client-ip=209.127.231.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="C0yCcbeq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784789246;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=D7A4X1tgGoU46zA3yseHcKl2kFvINpyo6Rr9IDKr7x0=;
 b=C0yCcbeqjxf6XLY2QmTR0ARgbllXu5XgcXCFXchY+tJ4bWGckSXBQFxlzp2/tbRjHsq6G9
 RxtpbLjVMVKm8BT3WUb5M8mb8o/aP1ao+ZZMqGdfCduZcwHkFnNxqq5uQgleqCt3fXzq+Z
 93pitV1ccZJimWH8ZYrI5xCcUkf9dcAtOI1Z4zujIvnbluWk09h/wDeZOceiRyVD3O6er3
 xUtHRkoHJMnaS85Fvj+a1Dk692wMeXVOVw/1/qJpzMwO2Ez+zRWTgCBg+ix7lCmFznmgHC
 ApBRDaB+fO9hxRaiRj9G2szmDWB4Fti+1EGSucxZwZmkBP7SIeX3y+cZ6LZ9dA==
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <0261d326-138d-44b0-82f5-0d09dbda898b@fygo.io>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26a61b8fd+aeba99+vger.kernel.org+yukuai@fygo.io>
In-Reply-To: <20260717102049.2080768-1-cui.tao@linux.dev>
Reply-To: yukuai@fygo.io
Received: from [192.168.1.104] ([39.182.0.167]) by smtp.larksuite.com with ESMTPS; Thu, 23 Jul 2026 06:47:25 +0000
User-Agent: Mozilla Thunderbird
X-Original-From: yu kuai <yukuai@fygo.io>
Date: Thu, 23 Jul 2026 14:47:21 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Tao Cui" <cui.tao@linux.dev>, <axboe@kernel.dk>, 
	"yu kuai" <yukuai@fygo.io>
Cc: <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<cgroups@vger.kernel.org>, <tj@kernel.org>, <yukuai@kernel.org>, 
	<yangxiuwei@kylinos.cn>, <cuitao@kylinos.cn>
Subject: Re: [PATCH] blk-cgroup: remove unused blk_queue_for_each_rl stub
References: <20260717102049.2080768-1-cui.tao@linux.dev>

=E5=9C=A8 2026/7/17 18:20, Tao Cui =E5=86=99=E9=81=93:

> From: Tao Cui<cuitao@kylinos.cn>
>
> blk_queue_for_each_rl() was added by commit a051661ca6d1 ("blkcg:
> implement per-blkg request allocation") to iterate over the root request
> list and per-blkg request lists for the legacy (non-blk-mq) request
> allocation path.  The request_list code, including q->root_rl from
> struct request_queue, was later removed in 2018 by commit db6d99523560
> ("block: remove request_list code").
>
> The macro definition left behind in the !CONFIG_BLK_CGROUP fallback
> branch of the private block/blk-cgroup.h header now references the
> removed q->root_rl field, and has no callers in-tree (it would fail to
> compile if expanded, so it cannot have any out-of-tree users either).
>
> Remove the dead stub.
>
> Signed-off-by: Tao Cui<cuitao@kylinos.cn>
> ---
>   block/blk-cgroup.h | 3 ---
>   1 file changed, 3 deletions(-)
Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
