Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566D94FDA51;
	Tue, 29 Sep 2026 16:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790699266; cv=none; b=oPk6smu4YW964HzE8C89cN2acJwV/gxIzYYglt/ZQOCb31g4g637LoTpvcDxgIV4BZDfIdEToBME01FdJ+zjSEvndXQikuoW/A5SB+ZEQyGZ3Lu1WnG3AzjKPH9Zt30gmNZMwGcjTX8QoGAKIzfr1TCdw2oDo7urPk/9kFfJcZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790699266; c=relaxed/simple;
	bh=D2ZKfF9YspKAP5iT4ciniEq/K+NfIL+7zwDn9cpefw8=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fpXmUaSM0eqrN42LbtXctgjoAFCJAxcVdsaI0gQQPOJVNw5w7PKL/9IWUwbr2Y5iEYalm1blSIZGZf4y7R3eISZLcgAP0DVBQo6j2q7AAKWfac1+o0zeSkb6WsC5ajgVok3lXSGepoFneADHaFDAhDloUXcRNpVIo756vvtoqXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=girpQtb6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="girpQtb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C522E1F000FF;
	Tue, 29 Sep 2026 16:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790699265;
	bh=FZPdz6cMQ4NSb3CWMqHoTjaKnk3EsCcWIyIogeWJilA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=girpQtb688FGKBFQnzGj59f7gLranESzV1pPRmq0dZFMG65c7GqiCmlrzpMwgf29H
	 6ZsphMkoKS9ULF3rLqj1m7zptLRKYLNeZGBq3e3NCekVXv4fRW8BjVbp7t8UKJkyAc
	 MuibzoODBJ2WhpQ3r3unNrTfTejfLlXVOWx8xUhjc2+qT4wGTVA89uHvz8PvL2h6x1
	 1x48YMNTFmfiWbCbKP5uCNRxG7iOObq7WpHBKX2k6fQ3PapCCRPlyoKWNEofpaX7gZ
	 o3LHd36G5wWZDkw57Jn6YZkq0hD1Ua0SSkmhZycJogitmW8ejRBZXvY2rSe8VuIdXa
	 GX5Mqt4URltBQ==
Date: Tue, 29 Sep 2026 06:27:43 -1000
Message-ID: <44f02289433805946d1e3272f626a925@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, ast@kernel.org,
 daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>, ameryhung@gmail.com,
 alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v7 0/4] blk-iocost: BPF struct_ops cost model
In-Reply-To: <4f1571a1-7e56-4264-aa7f-8dce32931ddb@linux.dev>
References: <20260924054549.2271705-1-cui.tao@linux.dev>
 <6f80eca83c87b60398110c3a6d735aec@kernel.org>
 <4f1571a1-7e56-4264-aa7f-8dce32931ddb@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Tao.

On Tue, 29 Sep 2026 21:39:00 +0800, Tao Cui wrote:
> To make sure I understood correctly: attaching switches the active
> model to the attached BPF model, while model=linear and model=bpf
> only switch between the attached model and the builtin model without
> affecting the attachment itself.  The attachment survives enable=0,
> and only .unreg removes it.  Please shout if I still got that wrong.

Yes, except that removing the device also removes the attachment, as
ioc_rqos_exit() ejects the model.

Thanks.

--
tejun
