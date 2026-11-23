Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795427868;
	b=3Y7g2tlkvKr/rXPhOngGmXxzVRKBm5DttOvLFg/qDI/j3bCrT2fXEAwLt5rEuvfpdEA/
	 lXkWA+0VABcpxNjyifXcTPH0j+NyfL5emOFH9a8B91XY+k/N4V56+Rh3rHI3TMKYjSr/3
	 WdP3MW6Blm0NrQ+dM3OLWSW3i0Z+MAbMbFUNTd3etUYyzetwA/2NqOLzqz60sI2wuBPue
	 6Sm2XjBQgqMSHhSb2KuqWnnIH8Wj5NdYAESDAHiZumy3/hrhhDcVpa1ndmdxsyhoamh4d
	 OM2K1zfHryxCxb77jgR0nMF0hZGjYvExPYegNtogwjn4MLIhGxDTkp7jtxf8rmZdXIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795427868;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=WTFuQc6i6+r7Yax6msNOhi9M7pReI0uM+YxrhN0XcL0=;
	b=vEITU2zMEc2CSfvJ5Qc4e4pJ37xBx1PDaWHOtAnkHMupRrPKyXC62ZAKPyGZQkTWgUMF
	 tWfhaf+HcSvG9cnwppe1YhaNjSyjsiJbyuiYr0lNdF0cW4pdXOBhF+Mly5SRkUJSpEpvh
	 uo50PHoDty1eOTmYQ+IKspbskdHkoWwksUL5yHBn+T+ChOb5mhxs9lkPgDCiNqa0knqTw
	 0V9QnFEJir6q32Dbr2vb9I43LSufjFR/bZOictk0I8hdCHqgUeZXC5Pk3zTpHrGhlMsUq
	 +wO5TEl8tZzsdtV8UiQaTa0ndHA3RoYZtlQVkfzPDZX9dSXsRSxVZ4wDHby0QjrcbWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XfZDo0CS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE03606A31A;
	Mon, 23 Nov 2026 09:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XfZDo0CS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7001F000CF;
	Mon, 23 Nov 2026 09:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795427868;
	bh=WTFuQc6i6+r7Yax6msNOhi9M7pReI0uM+YxrhN0XcL0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XfZDo0CSOcgqJsXbhlpqo0nf2f7UEIUCDlHRmfne9SjuLX0Gfu5SL4BdNuDA/CHLs
	 vczhpXRbyX1ipgZAy98LyiLHkgNXnQVjazfIkhEvp4HtC50AykpAyECx5cR5UmQGhF
	 YxxigPEToQK1YVU8QL16VHPD65ESdAiBQWpbnZILa1T856fauCYTtREhtVpOZTM2mu
	 WtBarUDSFlGRTsPLJkUkjNzsxezdjgm2vTKtjzUCGHiMlmkMldonhwLqLXUDaUBINn
	 oiJZsnTbH7W/LWXGexSv8ZzrRUgHGYLlFL1iDoBqtuJ/pZzODKgcHMqIggAQa6SBfq
	 Q9TNjLSX2S9UA==
Date: Sun, 22 Nov 2026 23:57:47 -1000
Message-ID: <03f83d9625a179d35d7e4a5c2ad0e09e@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Suho Son <suho.son@samsung.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, io-uring@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, ngeol564@gmail.com, KiYoung Lee <kiyoung77.lee@samsung.com>, JinHeon Kim <jinheon09.kim@samsung.com>
Subject: Re: [RFC PATCH RESEND 0/3] block: cgroup-based and explicit write stream placement for NVMe FDP
In-Reply-To: <20261123051521epcms2p2445107f926f3acaa2d51c5e12abea90e@epcms2p2>
References: <20261123051521epcms2p2445107f926f3acaa2d51c5e12abea90e@epcms2p2>
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

Hello, Suho.

On Mon, Nov 23, 2026 at 02:15:21PM +0900, Suho Son wrote:
...
>   - whether io.stream belongs in io.* under cgroup v2, and its
>     interaction with the existing io controller file hierarchy

It doesn't. cgroup controllers and their interface files are for
hierarchical resource control and this isn't that. If you want to select
write streams per cgroup, feel free to identify the target cgroups by
cgroup ID and use the internal APIs, but the configuration doesn't
belong in the cgroup interface.

For the cgroup interface,

Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun
