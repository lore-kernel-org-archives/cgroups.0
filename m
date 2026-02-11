Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5C027FD56;
	Wed, 11 Feb 2026 15:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770822156; cv=none; b=cbVzQuAmyShKWpFGX9T5Ehoq82vF0doxiFGpO72RNiab/5P3dBNHA+TaBi1qopeJ6r1EBmtjEEQRma/JVS8XHLaRHWXGrhxHezHEEVPyhisxc4adQywgrwP+Rk00tDFhZnmnWU+ucMIc/09SruZZwWg0XGcoDX3ULzNzbXGunD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770822156; c=relaxed/simple;
	bh=rrvyiIc/o8FkZYCQ7mUHp/9VbmvT7q/TyTPBahJPoD8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=E1ntQ3fTCH/FkGFZ/t3zYsYbg/NM3T59xvcZZ9/LBup4sQshde65uL5aJPmpjgyxlbEoCxWgJgFh8KtsvG1ZZ2rzTAFeHjnrSzVhVit+BRo1J6iBbMWErY96Im2uVZVjRCF+1Vzv5BIzlYYmjWb1CZSvtHndHSEzs3JTIKux5gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=THxYDRk6; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="THxYDRk6"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net B569740C7C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1770822147; bh=EIbkpU9L1q/Nn/4cX/6BL8Iuu3XPE9u3NeZNNDIBeiI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=THxYDRk6VMiU4F937KJveX3oFXnsKmLrts04KYb7VIrQJHnSXwbpAqP5PyOBzv99i
	 WdUSlSI+NN2sy2xu7E9WohDoUN5nwnXzl/M1MBY/zCJHoQhJz7dlL21wlNymQ+cZZv
	 2Wf1mJIlZxbpiiuwdpDvJEaKawgC0Ay34EkluUGbeX3pSpYAJjn6jW+nNuMsoSuVvF
	 bhB7IPMl8OP7+B8BIRp958GzqE2QWZa2CMk1ZWWZPlxqE9BqOH4//3bFz11GO3h4Kp
	 4KuRQK9ss27/NXgE3a47534lp6LInMhapPvQQ6K8M2S1w5MZFUTu0x/hapt3GOkXLn
	 vhBYMtOharEGA==
Received: from localhost (unknown [IPv6:2601:280:4600:27b::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id B569740C7C;
	Wed, 11 Feb 2026 15:02:27 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Tang Yizhou <yizhou.tang@shopee.com>
Cc: tj@kernel.org, axboe@kernel.dk, hch@lst.de, cgroups@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, mkoutny@suse.com
Subject: Re: [PATCH] docs: Fix blk-iolatency peer throttling description
In-Reply-To: <CACuPKxnY0Uo6RU5Cw2_fS=hQcjUBwiA+G3U-LUaviVYyf0Pojw@mail.gmail.com>
References: <20260114110837.84126-1-yizhou.tang@shopee.com>
 <guqq2cm3mk5qf45rcman3twiu7vax4sgkrhj23jrjb26tt3sk3@bh2h6s7givfq>
 <CACuPKxnY0Uo6RU5Cw2_fS=hQcjUBwiA+G3U-LUaviVYyf0Pojw@mail.gmail.com>
Date: Wed, 11 Feb 2026 08:02:26 -0700
Message-ID: <874inn2uil.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Tang Yizhou <yizhou.tang@shopee.com> writes:

> On Tue, Jan 20, 2026 at 9:37=E2=80=AFPM Michal Koutn=C3=BD <mkoutny@suse.=
com> wrote:
>>
>> On Wed, Jan 14, 2026 at 07:08:37PM +0800, Tang Yizhou <yizhou.tang@shope=
e.com> wrote:
>> > From: Tang Yizhou <yizhou.tang@shopee.com>
>> >
>> > The current text states that peers with a lower latency target are
>> > throttled, which is the opposite of the actual behavior. In fact,
>> > blk-iolatency throttles peer groups with a higher latency target in or=
der
>> > to protect the more latency-sensitive group.
>> >
>> > In addition, peer groups without a configured latency target are also
>> > throttled, as they are treated as lower priority compared to groups wi=
th
>> > explicit latency requirements.
>> >
>> > Update the documentation to reflect the correct throttling behavior.
>> >
>> > Signed-off-by: Tang Yizhou <yizhou.tang@shopee.com>
>> > ---
>> >  Documentation/admin-guide/cgroup-v2.rst | 10 ++++++----
>> >  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> Not a big deal but it could've been confusing.
>>
>>
>> Acked-by: Michal Koutn=C3=BD <mkoutny@suse.com>
>
> Hi Jon, just checking in, do you think this patch is ready to be merged?

Tejun usually takes cgroup-related docs changes directly, so I was
deferring on this one.  If the preference is for it to go through the
docs tree I can certainly pick it up.

Thanks,

jon
