Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793218167;
	b=HhiiRcvrWbpl4b0ENP46wOrIGFUhWZVmWsuQqdKYK7ZdVEj5lNi7DtbtVwksqnQF30XM
	 wsf6ffW4j0UpFLPyAiBULHpTF5xh8w1CdPiP3Dkj9sLqBdron5+PVe0aMwTMxM1iEFxpo
	 HEMzQGdD0ZvzLvITgd0CVuFTdpKHuuNla0awV7Pb0mL+ZLvBvZWzbi1NAbXvYqQToTi2h
	 ydEAoeA77OIm+fE4n2jgG+mFK8yv6R35j2nWvWvfzVtGwuOdVbDSbKoA9pzLoiZz//ek7
	 asUJ9d6BqVRQLd2nZQDrPzWcbFjvvlAEuo7m62ao8gsIwvfHEzUhdP+KQK7gQiMNqwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793218167;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=HLLTx977/XiNs5a/nHogEoQbG0b+A1UTK+BJ10ry0Is=;
	b=5kUypYoBL017wsyL+lxe/hXCFQOOVrPEcKHIwmtzm/zruEdHuaC9kCGioASImPd7qeBy
	 YQt18jpTEaMguw5OGYJsjMzBdUS03+GGcPppynGBG5BF30mIyBC7TkinQBuni1XOfUbDT
	 eq/I9gGGRtdzYhIicoWoj/5Z6CZrE/9+pgzq3Cl75qDVzEzywwuE4TYHtUzdNvfl5kFZB
	 0rWJTcKRbt19U9VwRGcJ/LiiZWMtNcmA0/oei1P99ra8qe6V3u4er8IoX8BCl1JlTy2uu
	 82OIE2c1Pz6kp+emcV2STYziZQ/8IEOiLyQ0ZxK33Fwwy+Eqqfuj8df79+W5v8K8xtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="gbXKN/L1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1ED606A32C;
	Wed, 28 Oct 2026 20:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gbXKN/L1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FFD1F01825;
	Wed, 28 Oct 2026 20:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218166;
	bh=HLLTx977/XiNs5a/nHogEoQbG0b+A1UTK+BJ10ry0Is=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=gbXKN/L1PsBmJ2qqjKTiwBhecF+1mm/ymT4VrmUx4Q2qfqSRmLXAvgk+1bka0X6V0
	 t26KXeeeDDVMdxXHeGkAcbHu++dpPLLODvT+lqHGkVHWqcKYHhAJpFPY6Ug/x3KIFN
	 gtiuAUYCvvAITBhDJhm+6rB6JxKpl3Mbpj/dlN6aL6QqXOv5lBJ1x+V+xzg4ndxmkU
	 ZUYhBZs54nV5pUEyAxaC0Oxlzfm7ZCngS+B24RFVLsYIjzkRKV43Eu4I5I9ZE27WPC
	 MdUiss/2Mb4ZObXGLPDFyqOdG6qV//NFyzd9+6/68asdHgb/E6ATE8Th3d0aoqjLbG
	 vXU1YdS8Jwgyw==
Date: Wed, 28 Oct 2026 10:09:25 -1000
Message-ID: <07deddf44be391f58d6c3f2e4843582b@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org, cuitao@kylinos.cn, ameryhung@gmail.com, alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v11 0/5] blk-iocost: BPF struct_ops cost model
In-Reply-To: <20261028143534.135968-1-cui.tao@linux.dev>
References: <20261028143534.135968-1-cui.tao@linux.dev>
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

Hello, Tao.

Besides the restructuring agreed in my reply to Alexei, dropping
iocg_init()/iocg_free() and moving everything into blk-iocost.c, the
series still has problems, which I replied to on the patches. The cover
letter is still long and narrates mechanics, and it still carries the
v9 and v10 changelogs.

Thanks.

--
tejun
