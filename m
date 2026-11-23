Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795430259;
	b=nnKbv1Sq83BmW39SFgqlKfpJg9eZqokYDB5r4k2dj6CoOkINO9bZ2F8l/NiIwJ1ZYVNO
	 /4PLT/a+BlIkZE0eiffR/MsgAaOF2Xyt9qqKz4+YPMQWEx7dSa94qBQKJeS3egEidlZLp
	 9TlpJaXxy0TI8Mk2BUAnowP03sOEGAg1KXuzr5SUXeomofhfbV2VJG7gCSyK/82yjM2q7
	 twIAgLQ+Tig50o+zszmrkGq9R0M+sYGlra5RyV181yb3mSfnVl0FB5UBIpwYsG2qkV6C1
	 gHtNdPRkjP4D472Z0wSJozN0hyyvWeu9+jm2uuy/L29AdxN3Fzi1GwuiNrV/dHE4ViQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795430259;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=mwYlBRWdZ3gFwsHepnNOkOBTBycCVdR7tH8mv3xZmo4=;
	b=tDQstIeml7lonimercNYMnu9uHSVsLGl54gnM+HBzVIjVVNNXcIWUuPwVBVNpPR8lGBo
	 3goFk9S+QV44qfgQpfZMRYKLWzeXg/8jt77zh17Ar/ce9nnPfciOZNwLJMoTR5jlWRuu6
	 B/h2OaOvmtDeEf9BFIK7IDQW/c1dShxO+qI4eqSvIAn/LoZ5V3cq9nISDiQVaA2NDmdb6
	 clySKnjH1feBPyKC+18AeY2lAG9Eww67rLmHzFc5n9NQmeRWVBj+8zt+Glp6C+kjkpFmx
	 5+hPYI7JO8LrDZu7RSsxWLrDm/IbCXHOTeKdtcMB6zjh5RzbfFF69bJA1NtHA6tsSBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WsaSxFIM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6AD606A31E;
	Mon, 23 Nov 2026 10:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WsaSxFIM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA7C1F000CF;
	Mon, 23 Nov 2026 10:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795430259;
	bh=mwYlBRWdZ3gFwsHepnNOkOBTBycCVdR7tH8mv3xZmo4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WsaSxFIMuIykh52LUipSEAH1TwSfSoxQ+xJxDgTKEj0yNFSvtHUaBADnVCWu9bhen
	 8VCQKJnyLAVhvLsc+XbeS/LFNWNyBPZdZNMUjCCEVQyBnp9wzxj6hvLUdzVXGA94Ey
	 fcAYs5f7A4zTcAYSDwR4tMj6JNVu340DwTrPN5yqJmxBe1rzVjurEQSp1ZmTTrxKGw
	 5bw5BRrSzo05JVuuH7vW75PBkJlWAVxSJkEH7xTxCXca3ZODd7eyyPRdRV6t2BzUKM
	 G2mmxjYYiQnYEjE7Eo6AjJxmndU9WisRyYS1UJxkRE73Oo7PEH4lUjWH+mX+WU3yWs
	 kMDMtBHJNtXjw==
Date: Mon, 23 Nov 2026 00:37:38 -1000
Message-ID: <80074feae68df690b254531b3768d096@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Kurt Lin <lylin1023@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: cgroup: fall back to an unlinked file without O_TMPFILE
In-Reply-To: <20261105011824.1143947-1-sashal@kernel.org>
References: <20261105011824.1143947-1-sashal@kernel.org>
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

Applied to cgroup/for-7.5 with the Fixes tag dropped and the following tag
added:

  Tested-by: Kurt Lin <lylin1023@gmail.com>

Thanks.

--
tejun
