Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792451548;
	b=nQbXBKaQWSsjX9L+okjgKJo4Ksk1WF7YgPXobhIlDbH/VJ0f8UEJ0qLEqo/LAyBslZxs
	 jbf+KRwuBKbmr1ODseHbTUpE0yJpqPTY/a/cJlodzxHC22XBBSFVF7yAoSGkax3hmOC6B
	 QBz9R14Xx4DLse3JsVFW772U4xDbG/Aq7MsnWlQx0XM4lP8/371snJGjG2mhEqDFeGfkE
	 Ad5EVT/ak/zYTeK/TcCk3vtPOnAq3AfBlzG+FDAr6JuMIuo21+sH6ZP64KCmcfqlpFafA
	 R39MR7a2ORSIrdx8qMZoxWKXKJWHFEUWz7CyNBopiWvxpXuLJrLMsx5quQ3vja4qQeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792451548;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References;
	bh=BI7Ojd0zS+qTT+iN7I7QYDaSDNVEbbWRYAizSN3cOgk=;
	b=YlNT/gNVJuiIDX026OjpIla4LvQt+WEIPVRHqVOL3he/Jv3eVjetP+0Vpazkz7/85nLc
	 d++3V+qBRXzpCp/imVaevGvAncnyiPj874HJYsRyHr5AbPunWwvtmbbkT2TpCg9kkNL+P
	 6C5RphTUToV+jXgnAsdgaeeGQof19OsVMf+RkkljAE7jE1F+HRWm2Pq1+CPHYQiF5zsN+
	 i/oMXDbmW+Y6r2MBzgUPXkU1e98X2SN2OVt/Z+5VVRirVRjo4ZmNVTn/VcVfBO/pKfe9x
	 tv01Xf0bo52ZBMStkxAxqat/XCdrWaRTVVvFVgNI4NFKCOf6o0L8jhK+SJkyKPuKusw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z2Cnt89d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC76606A319;
	Mon, 19 Oct 2026 23:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z2Cnt89d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC301F000C4;
	Mon, 19 Oct 2026 23:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792451548;
	bh=BI7Ojd0zS+qTT+iN7I7QYDaSDNVEbbWRYAizSN3cOgk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Z2Cnt89dXs9ce+/vvtZT5mTYPyyp51CIQfZ13iaGR+lSQuytUiUBylbPQ/6QJD5jB
	 XjreEu2pE+zmgTLjs+/huF1m9hKhZ9R3eQ6d+VGRWN+x9GIKDVfAtIfitLnQJm6gJK
	 XITYCnhlTxJyuf2ZLuzqC+yQPT+B0CmghXC2b+vnZhQU+t6jN3RYlVyit3jLmWjsFz
	 JIC70HKv969eC34ZjbpYMJTLizVImgL4VtlKYFf2vwYbUxUaOORl4Rm8t11+XSGZbe
	 C8EwwLa1TyRPPSVLn5wGIPEqyBC3SWGkyZKWTUYXUh9+WpdIRCT/MGo6BKyyBPaOxI
	 XpqN4RAlsANXw==
Date: Mon, 19 Oct 2026 13:12:26 -1000
Message-ID: <367b95affe8bb5e7971f35d30b30780b@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Kunhai Dai <daikunhai@didiglobal.com>
Cc: axboe@kernel.dk, josef@toxicpanda.com, yukuai@fygo.io, cui.tao@linux.dev, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] blk-iocost: fix hweight cache publication and donation fail-safe
In-Reply-To: <20261019125412.3123895-1-daikunhai@didiglobal.com>
References: <20261019125412.3123895-1-daikunhai@didiglobal.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

On Mon, Oct 19, 2026 at 08:54:10AM -0400, Kunhai Dai wrote:
> This series fixes the blk-iocost hweight cache publication race and adds a
> fail-safe for invalid donation weights.

For the series,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun
