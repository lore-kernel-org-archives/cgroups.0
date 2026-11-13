Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794597019;
	b=pOXC8yDrf67QUue1S2HevdnBT+PMrcUkUnNAsUaBcKfQysQlE6jIinJRgn4CwSVvJtRu
	 sX7LdNHX2p9vIiWG8XyquEq47bdWg38x3OvQuzyhuIDdnoBpSiiEnoAbVC7VpXIQIDjic
	 lUATsDQuwRcq+ddKCX4fqBGLYnJ7PYxztbYOOE/RDYtVs9PQr/JV9Wqe8dZg/cxgoLjrz
	 cRdW46JINKsjZdRPc2AYngPZ1lJrNWkltaAv6zRuNx1WhxGvE6ZFV2j1t1c/wqwloN0Qp
	 SGqsbYFucW4cUyBb8PYvnsHdxNaJQTZvK6w5W7xADNKumHI+L5KY0uN3q75seHbgHKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794597019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=/s5V4amWthoJVGjE0ildwj4nyghlFIlJY1SX4aQrQH4=;
	b=vR3F/br/2IfwO4ZOI4OdTarMrDUmLuL7H2NmfpaBDUgb1Mcg2ZWa4Cdx3l83ZSefZpKx
	 /g+9mhuej8DDCp3NdLB2MnYSS1InhLviHyQWGbg4h4FOJ0yei39NdtMjQJ3xwm3FDwpcj
	 xvC8zKMVoJYghHzOB0fS2PqSWvwjQTE3ZDfmT0v1dnOCBhDiMEL2R1EjJRgsVnKrH0YRY
	 pkekeED1EJlQTB8teFX9pWVrsqoUTY9X3F0tVQlC1/CDWQgHgfQu5bctdJlReUSvdOIK/
	 ZARcNy36l9zAR7tCRR43BtlCb5RewWxvR/Fhjo1mkfW6pMVwAuTCn8l/wvad903JbLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ba4bwLQV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9451D606A330;
	Fri, 13 Nov 2026 19:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ba4bwLQV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E8A1F000CD;
	Fri, 13 Nov 2026 19:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794597019;
	bh=/s5V4amWthoJVGjE0ildwj4nyghlFIlJY1SX4aQrQH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ba4bwLQVr+aVewsv3DQofPpLkWH4tJ9Au9R1WC4oJlCENuLgdck3uelZyv+Wsro29
	 NU3jsD1sNfMowMCNLgBLE8ITpaPDZsAaSoX6+P3tR4Krk58GbfY32Ypp8tB2tyJ14i
	 9TkvChgwNjmTUiElUs65VYIiaMxXfX4Bujf9sCW+BQEGSu/pxkzwa0hLn9SPh21IzT
	 5OVQSFSu3cB1ZQviZFsx+CyTQpP57B8UUAJ9noEPfb3ZdDPWXePNjF1C2hwkzwO0iU
	 ujpc+835REY9KFQe4pwfyYHFkZkniKaCtxt+UaotRgROaghI+LA8uNd9BFemARn31O
	 wzfuF8fBUVEAQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Tejun Heo <tj@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	reinette.chatre@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	rafael@kernel.org,
	dakr@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	shuah@kernel.org,
	jolsa@kernel.org,
	alan.maguire@oracle.com,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Christian Loehle <christian.loehle@arm.com>
Subject: Re: [PATCH AUTOSEL 6.12 486/486] kernfs: Use RCU to access kernfs_node::parent.
Date: Fri, 13 Nov 2026 14:10:01 -0500
Message-ID: <draft-0011-reloehlekernfs612@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <e274493b-0774-423e-a7e0-bd2c59333d93@arm.com>
References: <20250505223922.2682012-1-sashal@kernel.org> <20250505223922.2682012-486-sashal@kernel.org> <e274493b-0774-423e-a7e0-bd2c59333d93@arm.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 5/5/25 23:39, Sasha Levin wrote:
> Subject: [PATCH AUTOSEL 6.12 486/486] kernfs: Use RCU to access kernfs_node::parent.

On Fri, Nov 13, 2026, Christian Loehle wrote:
> I just stumbled over this issue on a 6.12 stable kernel,
> any reason this patch wasn't applied back then?
> Can we apply the backport now?

633488947ef6 ("kernfs: Use RCU to access kernfs_node::parent.") is a
preparatory refactor with no Fixes: or Cc: stable. It is part of a series whose
other patches are not in 6.12 either, and it has fixups upstream, so it is not
a clean backport.

What failure are you seeing on 6.12 (oops, lockdep splat, trace)? If you can
send it, we can look for the fix that addresses it directly.

-- 
Thanks,
Sasha
