Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBE833032B
	for <cgroups@vger.kernel.org>; Sat, 26 Sep 2026 05:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790400273; cv=pass; b=TrDkvHiyLoE81i2wvmYmFfcfCViODVPMkX8+TKltgzLJknpI5LmEGVrGk/goEvT39/NVhq1TgEKKga/w0rktZg4SudI0b6/mNbk7g4UYBHYYqMv9zXv+z6n+MH+gm3NaUf+gPf1XLn31TKuFKzc/342yq3yscdleDSEuPhrC6m8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790400273; c=relaxed/simple;
	bh=Ze+iI4MPN/oMczfNs2a3p2CNrjiokST60jo3zEacJNo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nPEJBacpAx/TTO0amxt4qur3PgQ5anRQQhJ9mf8Ac1Ba+Jl1vPKfaY2gP8f30EKEN2FH6kCS12Xhwes8BBSScPpfvcVwuQtKZoWgTVFmWIquzy6XYNA6srvETJ4PWtFu56fLhP1Ey6d4+Vr3Zak3pqlScryo8dnrgDWXTqUZ7U8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lhC413f0; arc=pass smtp.client-ip=74.125.231.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lhC413f0"
Received: by mail-oi2-f12.google.com with SMTP id 5614622812f47-4c4bf3defecso1145686b6e.3
        for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 22:24:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790400271; cv=none;
        d=google.com; s=arc-20260327;
        b=pUJZMeKakaa9bmX9/QDNFyT8LdMUohGNItfz/bkR0SyCNrYRVAcUKI6S0G8zXDgCNY
         qrQUkBigyWROSKC+NFnQYqp+jDK4po3ySQXsRF/Lu32+FV+CG/b47umgAy1yLvQ7EgrI
         yJeHJ+wyeO5mL4uEFd3nOOdCpiY3GNYBoTQtcAnmjxIaudjY5jPHfywkC80UqtC46ZgH
         eoIAn81rm94L9o/2los2SVS4/P1z/PLxgcHCqtGd/UBXSPD+gCtZcrLX8/1CbuvC84bU
         bp+coBdyqgW0AqwZ3lcQDVxivqoIGQDQBX04KH44SY7aSFXAJ+vDi5edzzIE/TQGBT10
         NcFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pVIiyRqhME2rfVYUFjEtU86And7QcpxR5cM22u9g16Y=;
        fh=0vit/4ZPrvnelFxJAuxYxi2Vw/xP0wq280xrVJ0fhNM=;
        b=iwx4wDUyZ7hu4YL9y9ozg73B2YN8l8TbqE2U68488Ymc4JaNWGu5k4dbvdDJUkw+qh
         UwBMcEfepcyUBFL9XYLL8dMJm5FrwbRRJknACjWj60HhzHw2pSpUMwT1bZJdnWTW7jWc
         fpr9VcSgsjriA4jX52zpQOvMg4sCMi2uQ2uskxwaa1zstTzn3prhU3gev2U01S7ejK1H
         /uDBqCa1NLl6g8qSqJUGpH4emTSDSSvpft8h8aGOepFLqIJgwgT5dOziAL+7MErb44gJ
         2gzUUEayhcuuk0iqsDXJhfKOPwoCXHw9vLX7rvzNh7vCOkN9TOHU1XAOEhYoC9+HERsM
         bS9Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790400271; x=1791005071; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pVIiyRqhME2rfVYUFjEtU86And7QcpxR5cM22u9g16Y=;
        b=lhC413f0KgQOdC+OVF69nUzsAbBPV2R89p7MwBEF/7uqDsT1WzPKVJvV/YGxJ3C1dv
         Ww475qQIypBc7OJKcWv7NtfbP6gZwG1NeE1X7UO6OQZKhL0AxjqQaJBJrpmHq2vzbqc7
         JfOcLAyXy8x2K9tyXEf/uywRrPoB8+HxiFmNo1Cefb4kkMsdj8iEdjW/y8ewFKygyw55
         1pGkzijpJQ+yyGP2LBZkvO5SnEu4TAnQ2hwvXY2Vrj2p0J0z1zv+B4Gxw9PrVzNz03q0
         6mMzXBMR3z4t3kQ6EczX1ZM5ZJaIuJqyEuhK70ICrpYUq+slBNo0EfOh0r56JHDtssgP
         bNnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790400271; x=1791005071;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pVIiyRqhME2rfVYUFjEtU86And7QcpxR5cM22u9g16Y=;
        b=keG5w6eGUtMmME3UIcLlsAS/kiyloEl/x7KzmMCpy1AE+N/MwjlGGNd1jJPkF97EPv
         tzgmFEhqdCp6PF0p/hKDdE95qyNk5qSGQJC1iSSJ/4HJIasARLJvO6jtAW/rWG7nfV6o
         ZwSq2y7EVTDyubOBkS2fgApVtaual+0LUAv1NS05G/JgpZTbgUfOzOzqfjWRcn0kRHFx
         5fUqf3DFkWAHk2Uc+kztRWxYI92HTh9cpELlbSE977pbZqIiVpvcWxx8KYfBULCH+Q/K
         hXp4PVaTL4FEuVSrUypsO2pPDsBaTB/dI0WFV3T+1W54gjnfMhuIY7/9fNVaq0oTrG9m
         DWxA==
X-Forwarded-Encrypted: i=1; AKwUvBwgFo/dlT0Wwoe+w0WkauAAIkp7fusmlocemUZFk0k72ViAyMVOllWcx0xxodY/rJ7wDLbLEOUV@vger.kernel.org
X-Gm-Message-State: AFuF++kiI4GsUmhIEtDU0FVVBCm8VvG8f8/qloVR44EK8NpOBO/5jOC7
	cDAHj+hMOM4xAFWuGBgwBgHQ4lWsxN8KAPyd1QTjBK5ZOZzFnNGRE8muRG5S8JxaIldIQwNBE2X
	FIVXkWaMqAoeonEGrXjWD0ziNov21fGc=
X-Gm-Gg: AYBFou2FEy4kS03hVMrbvABhn7GB20bHyHcjyrDfuCgqih5mOIE0nwqDk9fZVWfHnQ/
	UGlHOyVoDmA6PKmJwSbQkfUrvxYbT3XONbeeQ2E0e523iz1XVFQhIDISiRgMHVod91xhHKIguWO
	7gNKm9JufYpfMCCDVCPZRQPWOKO/OMOVNFbqyfNAvQtSunDKjsMInn1YgMJQVq/nMPhOeBLCoeB
	2cBOLO4MybUFNZtPvm/bs8T+TmPB858tBdmiDyVTkhjpgFSpG2KU6bR5SgPNoM9RU+b5TC8bryB
	0yfOBa+YjmxPYmAcOmxRH1dzw9mfr6p5/CWCuPsHghSqYyW+oVXv3s6QVYWSqHfEX0t2wm/rCDk
	ZAq/piZmM7uWBqI8/B0weoB0=
X-Received: by 2002:a05:6808:1782:b0:4d6:92d4:c806 with SMTP id
 5614622812f47-4d72be3a1f7mr8385532b6e.62.1790400270638; Fri, 25 Sep 2026
 22:24:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260923152653.40953-1-yupeng0921@gmail.com> <arP0TmdK3FnNfbwH@localhost.localdomain>
 <CAG3TDc0bQJATmJR5dF5j9RoDp1ti-tbAiUkLRGq4zX2CYD3unQ@mail.gmail.com> <arZFtIkV0vg_aQR7@localhost.localdomain>
In-Reply-To: <arZFtIkV0vg_aQR7@localhost.localdomain>
From: peng yu <yupeng0921@gmail.com>
Date: Fri, 25 Sep 2026 22:24:19 -0700
X-Gm-Features: AclHuK_i4TetM7wyRpEb-4NCnm73C_jTw7zDqMN5n0xOhknlW_0BTd0EVzLx3Ao
Message-ID: <CAG3TDc0zdhUaTYy1tk39VcSE6PipiTLDMXU0cUZ04yOijOgWOw@mail.gmail.com>
Subject: Re: [PATCH v3] nvmet: add cgroup_path to charge namespace I/O to a cgroup
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, 
	Jens Axboe <axboe@kernel.dk>, Maurizio Lombardi <mlombard@arkamax.eu>, cgroups@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 25, 2026 at 2:59=E2=80=AFAM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> On Wed, Sep 23, 2026 at 09:34:48PM -0700, peng yu <yupeng0921@gmail.com> =
wrote:
> > The LVMs are close to my real use case, so I mentioned them to explain =
why
> > I need this feature.
> > When I write the testing code, I try to demonstrate the usage in a
> > simpler way, so
> > I use RAM devices.
> > Sorry for the inconsistency.
>
> Understood.
>
> > > > * The subsystems are exported to different users.
> > > > * We should provide each user a specific iops/bps quota, thus a noi=
sy
> > > >   neighbor won't impact the performance of other logical volumes.
> > >
> > > Why cannot you place users into respective cgroups and configure
> > > appropriate per-device limits?
> >
> > I export the devices to nvme target. Per my understanding, the IOs are
> > controlled by kernel threads. The users are remote users, so I can't fi=
nd
> > a way to put them in a local cgroup.
>
> I see, so the core of the issue is that local storage is exported
> remotely as NVME (over TCP) and you want to regulate IO on the local
> storage.
>
> 1) resembles loopback devices where original task's blkcg is transferred
>    to the kthread issuing actual IO. Is there any userspace component
>    fronting the clients? (whose cgroup the IO could be associated with.)

I'm using tcp-nvmeof. Per my understanding, there is no local userspace
component. The tcp-nvmeof listens on a tcp port in kernel space and
sends the IOs to the kernel block layer. So I can't find a userspace proces=
s
and assign a cgroup to it.


> 2) it also resembles FC app ids (blkcg_set_fc_appid()/blkcg_get_fc_appid(=
))
>    Could you look at that whether a common concept could be used? (I
>    haven't looked into detail how the client side is handled [*].)

The FC app ids export the host side cgroup. But I want to not rely on the
host side information, limit the iops/bps on the target side. I'm not sure
what I can use about it. If I miss-understand anything, please let me know.

> Thanks,
> Michal
>
> [*] And now when I'm thinking about it, I'm not sure one can trust any
>     app ID that is sent over...
