Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33E73BA236;
	Mon, 11 May 2026 08:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778489789; cv=none; b=VMoDA620V9Qxj8wqpb27lY+uV52s72F1B2zcZaghSHf7dAzz0PGVDtAuliJznDMDD+I/46G9Uh4lmynuBn6lGolcthhWF4phr64zMoYyFjsMqIPj8c/1C+pbc4jQ3kR6xPKxZ9ejAkU5e93u+ox8qiWk6PSnDjwIP7Q8TNCTF/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778489789; c=relaxed/simple;
	bh=gC+RHphujy9tYpY6Ftxmqt6cBXPJRmd1kggH1Lnlp7I=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TMQpVXJ9Omfac+UoQAZ00jTq024zagwSKdy3a42Fia8ryQlHGoHZNQtdo/fHDC6PyGIoIQsNe6O6wsJmfsIzRpj/qnQeDzMqihPr2D/oM3qZPgu0f9BTwzOv7dXjI4xA1dHFXH87ckQruwSJ9/2aYdFAR74YE2OJ6Wn8i/Cwct4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jzgJCHF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jzgJCHF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70830C2BCC9;
	Mon, 11 May 2026 08:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778489788;
	bh=gC+RHphujy9tYpY6Ftxmqt6cBXPJRmd1kggH1Lnlp7I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jzgJCHF5Z9ldAS9a9yEaO+fYZMFFY5Yjbxrb1i1nIwqYgW87ffK9FC921yGfoNCJC
	 /naLPUXSHUL5ZIVrn5awtUXQyuguzIoMP3skxnKyLEtHFKo1u1OTw3FWu6l2glsywY
	 DxFpN9V3O90QBZFSlQ7U7+C2dxqPGxCaGNooIcsB0nasaftMTqDUCEgJv++/OpebeP
	 DRi+AWzT5mcG0XiyDYCqIAc130sVh6v8E91aAeQ6Q/fO6OeVWK5VTHYAMFI+7srqnY
	 ZqjshKeYBgB3a4ihqhOGW53LwW17Oqx0PlOsfvKv6Pi5jWLs4f6XsvyugAYK/KbzDI
	 ZcI6Z8LJv6UKQ==
Date: Sun, 10 May 2026 22:56:27 -1000
Message-ID: <8440961feb374c1a7eb6a751d2d9ae0c@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutný <mkoutny@suse.com>,
 Yi Tao <escape@linux.alibaba.com>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: Keep favordynmods enabled once per-threadgroup rwsem is active
In-Reply-To: <20260511081607.83490-1-zhangguopeng@kylinos.cn>
References: <20260511081607.83490-1-zhangguopeng@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello, Guopeng.

Thanks for the patch.

I don't think this is worth changing. The mechanism is one-way, so on a
disable attempt show_options has to lie one way or the other: clear the flag
and it reports nofavordynmods while per-threadgroup rwsem is still in effect,
keep the flag and it reports favordynmods after the user asked to turn it
off. The pr_warn_once is what actually tells the user what happened. Neither
flag choice is meaningfully better, and the underlying ambiguity is out of
scope to address here. Without a stronger justification I'd rather leave the
existing behavior alone.

Thanks.

--
tejun
