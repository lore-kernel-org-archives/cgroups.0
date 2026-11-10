Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794288252;
	b=byPQgw5g8+XAboriUGPOm2/ys6Li3YJLB/hPiWsjTZrPhK8lfL5WgIR8zoTRIHi3LDIq
	 01ZGRd1rq1/52uE+qn2YR/IhyHZ9IbpemRsWZNQKp/knMHettVFtYmh51XMhXtuzHlV8B
	 kD68F7/SBNrwSqt6Nb5AlQHQwkqGlbhEVZZamU1i+9nJgagY4A7L3EcAptqsESCRJ40/h
	 P+VqrEXyBQ1MfZhEIQiSY3ivMHPfR9bgSQzp3KAx5WySH8gtwHIt/BnAZCuurhDkWOSQe
	 YLepsSRIiOZcJxm85LXikBkeJG/xhIK75ccLn2m0Bii+VjC7ntacH6UA8irS5XawW7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794288252;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=tql7eR5er24MenGv5PCYQqqSyChkhlwFStj9pdPekzo=;
	b=ujYOKj6vqOSNbJRqWZtOrDbeS+YkI3pWmr9aPAx8gJpJuTzU9ue5mghrjwoe9tS9P4+t
	 Q2DdXm+MM70wQP7w5JccsK9u2PvWseIOYYMcKKGHCyTZSUL3WW9QldeCMrkvdwQMRpb9L
	 RxOyp/b07sUUBO6QzzckXjSYTSfDsmwXsIwzQJk5qEyeYbjxBpGwvD4FBfOZapaIBtcyF
	 FoKFSfJVnHrd3N6l9E82E76RRdNsnriKmbrgntYrKSwCjhppeCNY6G354wfi9my1UqnpD
	 ueYSENZ2eTGFdYOlFvd2nqT9zFPeunThlmEt8j1MU53XaDB0P7J6C2nExGOs01YijiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="T5/HMq9H";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24030606A31C;
	Tue, 10 Nov 2026 05:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=T5/HMq9H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D101F0089F;
	Tue, 10 Nov 2026 05:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794288251;
	bh=tql7eR5er24MenGv5PCYQqqSyChkhlwFStj9pdPekzo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=T5/HMq9Ho6wBHSn2SyLD+V0y7apDVcIEcxsAbM9bnQuCbLvHw6LbrS3L8oQWoJdLS
	 xDaM8FBlCgcuAoUBNXFa7Xb8i2/V+MMB+YSg/oc1v0bC6dFoqwUkeA+EGUyi4PZaBm
	 fJDST0/5AG8QCpg5dZFPoHB52xvaiVPnB2IDMaeQ=
Date: Mon, 9 Nov 2026 21:24:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mingyu He <mingyu.he@shopee.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org, Muchun Song
 <muchun.song@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 littleswimmingwhale@gmail.com
Subject: Re: [PATCH] memcg: keep propagating stats updates to ancestors
Message-Id: <20261109212410.ca24bffef1abcd50b3f58c13@linux-foundation.org>
In-Reply-To: <CAAoBcuRfhFf4p5qfWZnNs5=4foeE6jtGFggG5XHmMi6cXwje9w@mail.gmail.com>
References: <20260911032905.63683-1-mingyu.he@shopee.com>
	<aqRXqcynCx88D2QK@linux.dev>
	<CAAoBcuS=sqOAPFr9Gda9aTwuCMHMPzBMEee8qvPNHtNxrRWKuw@mail.gmail.com>
	<asy_L2s1TNcN7bOK@linux.dev>
	<CAAoBcuS5VJwsYyw9=77SaBUf3N1hL8NfRtGwpBhmyUUhT4+T8w@mail.gmail.com>
	<CAAoBcuRfhFf4p5qfWZnNs5=4foeE6jtGFggG5XHmMi6cXwje9w@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 10 Nov 2026 11:17:37 +0800 Mingyu He <mingyu.he@shopee.com> wrote:

> hi, gently pin this email.

I think Shakeel is suggesting that the bpf caller be altered to also run
css_rstat_flush() regardless of the update threshold.

Your custom in-kernel caller would need a similar alteration.
