Received: from va-2-55.ptr.blmpb.com (va-2-55.ptr.blmpb.com [209.127.231.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E6E28506C
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 06:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784789178; cv=none; b=uPpkDKI+tyZTbkB2Xp0rga9DlswMuusVo18RtR/hnpcQ+T6kxR6TRLvtyXRzwF06dWIaQ7LI7QJr2isJDME230gxQ72h3jNZNmvxXbufipIRSibnqrdQPUxb7J3TpFIos6Eu/CU7Jc7DR9LZi1wz8FEbevj6Ra2JkndzJUrw19c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784789178; c=relaxed/simple;
	bh=BfuMpD0JejPvki+J2+J+6Z24bwpQM3FqEhh7Rz1xsmU=;
	h=Subject:Date:In-Reply-To:Cc:Message-Id:References:To:From:
	 Mime-Version:Content-Type; b=uIwZLYGVA/tm74/PN4ldpT0L6XFL1MgnQeA/GbNMjpbOywbDxkZfDAJ5UbdeheTFw5cPyAyewQMMN0xLoprGyv8DBN8qe9AwbtO0OgGSfv8OQT9wCPsruNlPp6HbnujLakhnxHs+hDMcX/Xwg4ZheFY9Omb4rMY6Sd5b7daNJx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=HqH3s36S; arc=none smtp.client-ip=209.127.231.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="HqH3s36S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784789166;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=1VSRY8DjQjQuIUS0pS4CSBluQaqfLAGbzI2985QqDtI=;
 b=HqH3s36SOfVG7JXnwBbQWU979NzuEpHDhQJnXuyWL7tsbzwpjNitHDMyeaKK9YsdGyn2UM
 len8eDYFCC/MdYIwMlYINsjKIigow4tEib70K3fkwn7sFP5rKEpSx04A+iD9mMyfp2oF7p
 kpjZR7S1BpPln+NZHmiByo/9hRcZ7IiBNfEYqm72OVwRpT15JvnqfBRcT4ppd9O4V/b7dY
 4/KjNNM6Z4PEfIGAWfFlbp5w6CEJauhNDz7HHmSw+R+CJ8X+k+/6MhAyuuqfE0QWWEn4zO
 yY+ljvgbnw4MKBPQx0N/E8nMFi10EN1wQMe4MIUW4vVobl/tAhjezCVYhnjF5A==
Subject: Re: [PATCH v4] blk-throttle: fix divide-by-zero on legacy iops limit of 0
Date: Thu, 23 Jul 2026 14:46:01 +0800
In-Reply-To: <20260722102459.253189-1-cui.tao@linux.dev>
User-Agent: Mozilla Thunderbird
X-Original-From: yu kuai <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26a61b8ad+fe840b+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Cc: <linux-block@vger.kernel.org>, <josef@toxicpanda.com>, 
	<cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<david.laight.linux@gmail.com>, <haris.iqbal@linux.dev>, 
	"Tao Cui" <cuitao@kylinos.cn>
Message-Id: <cac8989a-d097-4f50-be01-d26d95555e64@fygo.io>
Content-Transfer-Encoding: quoted-printable
References: <20260722102459.253189-1-cui.tao@linux.dev>
To: "Tao Cui" <cui.tao@linux.dev>, <tj@kernel.org>, <axboe@kernel.dk>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.167]) by smtp.larksuite.com with ESMTPS; Thu, 23 Jul 2026 06:46:04 +0000

=E5=9C=A8 2026/7/22 18:24, Tao Cui =E5=86=99=E9=81=93:

> From: Tao Cui<cuitao@kylinos.cn>
>
> Writing a multiple of 2^32 (e.g. 4294967296) to a legacy cgroup v1
> throttle iops file (blkio.throttle.{read,write}_iops_device) silently
> truncates to 0: tg_set_conf() stores the sscanf-parsed u64 value into
> an unsigned int field with no clamping. The cgroup v2 path,
> tg_set_limit(), already clamps the same kind of value with
> min_t(u64, val, UINT_MAX), but the legacy path never did. Note that
> the "!v -> U64_MAX" mapping only catches an explicit zero and does not
> catch a value that truncates to zero.
>
> With iops stored as 0, tg_update_has_rules() sets has_rules_iops[] and
> the next IO reaches tg_within_iops_limit(), which computes
>
>      jiffy_wait =3D max(jiffy_wait, HZ / iops_limit + 1);
>
> triggering a divide-by-zero oops.
>
> Fix it in tg_set_conf() by clamping the value to UINT_MAX, consistent
> with tg_set_limit(). This closes the truncation root cause: with 0 no
> longer reachable as a stored limit, the HZ / iops_limit divide is never
> hit.
>
> Signed-off-by: Tao Cui<cuitao@kylinos.cn>
>
> ---
> Changes in v4:
> - Drop the defensive "iops_limit =3D=3D 0" check in tg_dispatch_iops_time=
():
>    with the tg_set_conf() clamp in place, 0 can never be stored as a limi=
t,
>    so the runtime check only guards an unreachable state. (Yu Kuai)
> - Drop the Fixes: tag: the unclamped write -- and the iops=3D0 behavior i=
t
>    can produce (calculate_io_allowed() returns 0, so no IO is issued) --
>    long predates the commit that added the HZ / iops_limit divide, so
>    attributing it there was incorrect. (Yu Kuai)
>
> Changes in v3:
> - Drop the (u64) cast on UINT_MAX: the kernel's type-checked min() accept=
s
>    two unsigned types of different width (both >=3D 4 bytes), so
>    min(v, UINT_MAX) compiles clean. (David Laight)
>
> Changes in v2:
> - Use a "void *field" local for the config write so the assignment reads
>    *(u64 *)field / *(unsigned int *)field instead of the
>    (type *)((void *)tg + of_cft(of)->private) casts.
> - Use min(v, UINT_MAX) instead of min_t(u64, v, UINT_MAX).
> ---
>   block/blk-throttle.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
