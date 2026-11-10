Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794339621;
	b=ryaFNcQgQQNdNqiufVk/rJezEC9hwdg33FjMqpX1TIZSkDHotLz4tyY9otrYuDsLxoIm
	 FEGgYw+168GXoaFT6HvyR1/lImCyUTKdsRkacwLPM87PW7Ac0zY2Ay2CsaqD1xeTGb7BI
	 TEY7GVRf4ZhKXTBCNuVmDsQ+I5r87MhPX6iDdaiQDtAqcP9URYLaoWyuRpU03bN/pTaJs
	 vCLxe8d2kEbLUsLSjxhb7Ds076YPWY+F8zoFjhAMUg9CstTSZ1jOTWwleOhIZYVgWWhbt
	 AHGKf5o7fhkwCX1gBN2ekqHlFWUlG0mWLPqjTZJHP8GGyxzW5dyNPROxYfc9JGjnUZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794339621;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=G73EY9C4EDTA4M9pcyoo0q/AnVA2mgjUcIBxeIwlhbg=;
	b=jxJ4CHR+IAlMwsGqDrujyo/QD9d8WM6/KwcqTf0YWV5iWqb8tCodwjCo0S1SoRsREWbG
	 59LrmgHlS2PQy7bJDK40dpoAzYxGAXDlq8n+JB1c2qRYPEce6dVtafrcMvfSA5ptaHPWY
	 VT13uFVlayZBJO2z/7vTz73V08/v3KK7o+NL4m2ew2gamtdXMg57JU+3cyj4SENgFno0D
	 00Hf7YorQeNes2fV0pVo6FyGE2OSCZP6x0WmD9BmCeXXht5tWOF7zwJ8vHGl2Owcpnnnt
	 TwsKEFe3Gbvg8ZR9x4sPn1bLLTNsgqrAh2B0kg2m+DCN5WQn6v/POf5XGjunpgRmwkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jolVrtOH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798BE606A326;
	Tue, 10 Nov 2026 19:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jolVrtOH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275BD1F008BC;
	Tue, 10 Nov 2026 19:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794339621;
	bh=G73EY9C4EDTA4M9pcyoo0q/AnVA2mgjUcIBxeIwlhbg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jolVrtOHWRVXPvbUc7zJiTa26lBRn0uUo4pfZLpn1ofBw4k3knn6PPZIGjAKomBnM
	 Jjtuqkjy2gC03w7F6uUmaHjyoFKjnnZHDdUNigqu8AQlHxwn7HDJ6n/2MGIy7XZYqo
	 8SiA14NEo+0ZB+UzDKttkjB/0FMut2AUH80e4M40Ya8wrMKgXDrD2AHoobEXDEb02S
	 /GVVoip3d/a70LKI+YrzoComxdI7WmE5gxMBldH/s/nmgP6bHuuegr5AvK4ob+NwBk
	 D1bChjXHIdDGbK4Z/lVqB1BGt4QMOdRkKUNMFkhZIvbPoiLWDVVuwLmxU9l1l9GPrg
	 PGdbZamv+KIEQ==
Date: Tue, 10 Nov 2026 09:40:20 -1000
Message-ID: <d81460af8053a51f9be8a73186025ce7@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Kang Chen <k.chen@smail.nju.edu.cn>
Cc: Yonghong Song <yonghong.song@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 cgroups@vger.kernel.org
Subject: Re: [PATCH] bpf: make css iterator stay drained after NULL
In-Reply-To: <20261110125110.2935707-1-k.chen@smail.nju.edu.cn>
References: <20261110125110.2935707-1-k.chen@smail.nju.edu.cn>
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

On Tue, Nov 10, 2026 at 08:51:10PM +0800, Kang Chen wrote:
> The css_next_*() helpers start from @start when given a NULL position.
> bpf_iter_css_next() leaves kit->pos == NULL after the last element, but
> keeps kit->start set, so a next() call after exhaustion starts the
> iteration over from @start again.
>
> The verifier relies on the iterator contract that once next() returns
> NULL it keeps returning NULL: process_iter_next_call() marks the
> iterator DRAINED and treats the result of later next() calls as the
> constant zero.  A restarted css iteration therefore hands the BPF
> program a kernel pointer while the verifier believes R0 == 0.
>
> Clear kit->start when the position becomes NULL.  bpf_iter_css_destroy()
> is a no-op, so no cleanup depends on @start after exhaustion.
>
> Fixes: 7251d0905e75 ("bpf: Introduce css open-coded iterator kfuncs")
> Signed-off-by: Kang Chen <k.chen@smail.nju.edu.cn>

Acked-by: Tejun Heo <tj@kernel.org>

BPF folks, how do you want to route this? It can go through the bpf
tree or I can take it through cgroup/for-7.4-fixes.

Thanks.

--
tejun
