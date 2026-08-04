Received: from va-2-44.ptr.blmpb.com (va-2-44.ptr.blmpb.com [209.127.231.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4005D35202C
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 02:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785809321; cv=none; b=e++opHJDg0PgGwuia5tCYBNgtzZ774nZzk0VN0BV3auPE/vfueSqqBoCaJHLPaH5N7fSDYUQN2cpLr8O84X8AdXCJC9ojoWbC0c/5ksF6pNBxjRQ4h+EW0roSSI8aIP/YqtELMA8y0J+OiuJ+wu4iyfy0ecGymxujZ9jwzUy5cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785809321; c=relaxed/simple;
	bh=f5pWBpDwAmqLkxFm27SpU7R5Y96mXpFqFTCGbECKXPo=;
	h=Subject:Content-Type:References:From:Cc:In-Reply-To:To:Date:
	 Message-Id:Mime-Version; b=k9+DzObDTPz0ctolMPZQ2/3o30WCrHiC3fGYvCbomSRi+yw40UIdty1fehc521R5434ZNF76kcDBR6qaVGEa0t0y+ynBuQAUV0KabEjaxzs89UtXCIKnHFihuPa0gqwHn6bXUiEbUiIl90MK418O9QOMValTYdEQbRAYtcJ60pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=ZMPnnMn/; arc=none smtp.client-ip=209.127.231.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="ZMPnnMn/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785809301;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=3hIwKhkFZri1Kr5/Dpo2Qw69tJ9lrN2aZCXBNAcdgzo=;
 b=ZMPnnMn/Y03o41TmiaRAsVj14jTxO7YByj0OiH38CCBcomh9oh20c7myNjCRetl0OzpUd/
 OfviR7u6ywwp6fTLAihHRd7FnrjCDHVWQ6RiT7YlV4ZfA3Rv1KMDW5nLtHpBYc9u0RnMdz
 cDPJ+UBOFEwZjpEy6qpCehct9PXqmo8yLcCLecXQZPaB8JnsGiYEz+P3tl5kTgNGpELz2A
 5PovooBNbYNaWV8ksnqA5Hs9nV4LRNPC4cjvr4JgwWkjN2KGRokB/Cgsrd2O4jtgH/o4w/
 d8zF35f2bdJ4kEa2Z2dLWfmTFRd9nUG/uohZn2BNqyoBPNdTwRsU93QQNsctSw==
Subject: Re: [PATCH] block/bfq-cgroup: use data_race() for online test
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Tue, 04 Aug 2026 02:08:19 +0000
References: <20260803134104.138411-1-cui.tao@linux.dev>
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Cc: <tj@kernel.org>, <josef@toxicpanda.com>, <cgroups@vger.kernel.org>, 
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Tao Cui" <cuitao@kylinos.cn>
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a714994+c3b726+vger.kernel.org+yukuai@fygo.io>
In-Reply-To: <20260803134104.138411-1-cui.tao@linux.dev>
Content-Transfer-Encoding: quoted-printable
To: "Tao Cui" <cui.tao@linux.dev>, <axboe@kernel.dk>, 
	"yu kuai" <yukuai@fygo.io>
Date: Tue, 4 Aug 2026 10:08:14 +0800
Message-Id: <cc249ea0-b3d9-4fcf-b847-d282683af333@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

=E5=9C=A8 2026/8/3 21:41, Tao Cui =E5=86=99=E9=81=93:

> From: Tao Cui<cuitao@kylinos.cn>
>
> bfqg_prfill_stat_recursive() and bfq_bio_bfqg() read blkg->online
> locklessly, same as blkg_rwstat_recursive_sum().  Annotate with
> data_race() to silence KCSAN.
>
> Signed-off-by: Tao Cui<cuitao@kylinos.cn>
> ---
>   block/bfq-cgroup.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
