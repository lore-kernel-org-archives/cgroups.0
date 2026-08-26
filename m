Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419AD2E7BD9;
	Wed, 26 Aug 2026 04:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787716985; cv=none; b=gk0IfeqjHo23lHMJfJDJgg12d0nEiDzbiyqjmA2kfXY3EHj2FDq4TOiBclB44Ugmr7cZ8nuq+2DKLJRx39AZRo5b9FzLiMjFhoYx48A9H/1JatuKOSXJOFatDK4h4KXirkoNTRv2wf6DykGxT5FGdp601PIX/auazpeT1yHpWeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787716985; c=relaxed/simple;
	bh=oSKUmApj8A/r/Z3eKgKJKQ1IYHurP+gfguTMP6shdK8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ujzuhj+Gl4wIvtLaZ7wR9YHNBy2R/1vdhkaAzikHcGNbBLQ0ODSdDiosLzcg+AK5c2lUHd6n8HkSN5tvdr8MdAFuPC93UHyszBn64z1k+7c/sQBc9B57TOrAbXceeBfeE+nplQ8Naw7qcTSJdA88OgoacHqdp5nyHI/HHPjtvR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=themaw.net; spf=pass smtp.mailfrom=themaw.net; dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b=aymhLPya; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=KRt2tV5t; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=themaw.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=themaw.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="aymhLPya";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KRt2tV5t"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 4955314000F6;
	Wed, 26 Aug 2026 00:03:02 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 26 Aug 2026 00:03:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1787716982;
	 x=1787803382; bh=dwxd4+63HyxL3KMioKnjM37MMiTen02ngxAeGGPT6jE=; b=
	aymhLPya69LkVYs8LL0Ikc2RoGghSD+EKkHW/UUp0Udz6xLFCbOFnRVfnqb6+dkh
	vysxJzyFBhPwFj4nIK7+QqudYEPu3Y2r1RhQQJFmPeJvD4gPMw232bwxhJAcV5g9
	Q/2GOdaaJGc82MqHCRY8Bvx1bTSYAtiQ69tdG9ZPhFFyH97Y2JMSSTxTQnhR/M8A
	1SQgLFW6e37PMlfxjflcO8qGCJU2b4wSknNI2l/NHBvkqSgE+TqaKocmIIeRLhdG
	zYBb+Y5mCPGcnoljpTxzmLS8hV+yV8MrQrkrumkvrgf15Hy/KBL0nVWsuQRGWty0
	sgZ9cSuBP47Y3Yt15Fd8nA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787716982; x=
	1787803382; bh=dwxd4+63HyxL3KMioKnjM37MMiTen02ngxAeGGPT6jE=; b=K
	Rt2tV5t91NKm83N6sjs4wfcBtilbFBQv4sO1/CC2k2lvx15NMsknfD7I7B/6bPAr
	4njW8F/2KROA+T4g4PHX6BVA596/zAw/hzPaoKm7U04RkedjEC+cllwgrhJ/NQIx
	CQwyfUyXUqIR1P118Sp263wrNGf7MMEH1bXRHwVbT38xg3nP9MRwzmWlpqksRm2m
	2JdUhDl9tB32W06C4jtbr04DRjBOxRIOWKt3qvEdZU1Xes35k0pThnbHTJU+EJAo
	2cVEh20YhqIbuLaW2z+Y5PTRBoxu37xy9xSYxXx37x416Ug/UXf7mtDKyjiEBYZ/
	9WfBciNJDd27jQ5Oiw7cA==
X-ME-Sender: <xms:dmWOavApknYY2Km1e9dsfwlnNEyypy-BXoWnZgMtkR6gs2PFgE8PJg>
    <xme:dmWOahh54Xf67hUA2fTCnT9IAzniXq24gmm_0nKBbfEGBRVD14go-3A7u5BBXNVof
    uSVwdGeKpolTGtxR6k2ToTEla48bJkqYVye1aYkMWeu5AwSNg>
X-ME-Received: <xmr:dmWOasxvr5Il9Q1qLRhUt71mjZ18VOh_0LX6kemklEptK0rf13d3s3pdvgZa1VrjhdfsWOJeckgjoA3tkXH1xP6NT3S-lvli3lnlPwl5dBAEADrLTP2uwlY>
X-ME-Proxy-Cause: dmFkZTGHK3bJ3zVasjqx/097U6zg3H8wmFcD+G3F9q1ByaitkMIRQgjC7MV/7gSthbtjsE
    9VbPv954Zov3OEAZInftX7vA4+nfEX6dYf/k3W5p8ywQ5NXJlUeMNal4Y+VPQdZM1ZxHB6
    P+N9NX4bG8Gum0eyydl3mrPF1WvbwTs1niUSwMEysmc7r4OMBvEjgDAel+x8T8Q9Q/zJFV
    sfXI4mVYxtsqFrXKAAl+FxFKa6X1ymFsgLmvixqXP5JSEh7xtKPDpqxg15NxXHCzYtItJs
    LU0GJ9zoMjgmig+w5TSYv8VDlcsW133d3NF/pTtcHXad5qpaEM1APWgiY8vhydLjDT6iAx
    JaxvDo41JWjSeFgGW65UdIC2zFCiiNTwZXFWkgN1fAyB+yRse3QXwt0SSLZkrZgneJC1Qq
    5QD2w7LMjH0sLbqbdWMJGw/ZdjCRF3b8iFbLuEBu7yqfk0Hv8C3h9tqBikbfRsoVO/xNB8
    IPLedS8zokJ6QzW0ixw3+zZpcimkLTPGIwPC1Xx7GGz5PtwThk/CuSlSIQWWaQO0PqqeA8
    5HBARhaiZOoOyBC9NE+5vnzV0B+4GC52XUk6F/O4oQBQ/6exa7OipGET3vudE6DYYeD+VK
    /cyvVIPX3W1t31YEUW2KD5J5CTzFVTfWKyaL8BdvpEfmBJpf1t3YxcY0b1Yw
X-ME-Proxy: <xmx:dmWOai3C5z2OG29ovBeObcPgl2MoIOlSIy0sylfG6e5hV6vpZvbwSw>
    <xmx:dmWOah_wuyLrYrpzTWzYk56XhYEc7qZvv4cgwU83xGrrHVP7jXIM-Q>
    <xmx:dmWOaqrM4e8sMSqrDvIdrE3RzoLEii1uJP0V_lC_i9b-nDSoIAueWw>
    <xmx:dmWOajQQPZs-P17A7f0h7NGaxalFfGFvYh_IZ1tJwUGOupmBivU57A>
    <xmx:dmWOaoptfUqyfNgnWmVtzOOC92b6HUgIM1lpqMLiaXj7K59y3OLC4oSE>
Feedback-ID: i31e841b0:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Aug 2026 00:02:59 -0400 (EDT)
Message-ID: <1c96890d-5ec9-4f2d-a897-8f8c46ea87f7@themaw.net>
Date: Wed, 26 Aug 2026 12:02:57 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] kernfs: remove kernfs_rwsem from dentry revalidation
To: Christian Brauner <brauner@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: Meta kernel team <kernel-team@meta.com>, driver-core@lists.linux.dev,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260821050507.2161607-1-shakeel.butt@linux.dev>
 <20260825-grabmal-erwachen-aufatmen-b62c5d6c220e@brauner>
Content-Language: en-AU
From: Ian Kent <raven@themaw.net>
Autocrypt: addr=raven@themaw.net;
 keydata= xsFNBE6c/ycBEADdYbAI5BKjE+yw+dOE+xucCEYiGyRhOI9JiZLUBh+PDz8cDnNxcCspH44o
 E7oTH0XPn9f7Zh0TkXWA8G6BZVCNifG7mM9K8Ecp3NheQYCk488ucSV/dz6DJ8BqX4psd4TI
 gpcs2iDQlg5CmuXDhc5z1ztNubv8hElSlFX/4l/U18OfrdTbbcjF/fivBkzkVobtltiL+msN
 bDq5S0K2KOxRxuXGaDShvfbz6DnajoVLEkNgEnGpSLxQNlJXdQBTE509MA30Q2aGk6oqHBQv
 zxjVyOu+WLGPSj7hF8SdYOjizVKIARGJzDy8qT4v/TLdVqPa2d0rx7DFvBRzOqYQL13/Zvie
 kuGbj3XvFibVt2ecS87WCJ/nlQxCa0KjGy0eb3i4XObtcU23fnd0ieZsQs4uDhZgzYB8LNud
 WXx9/Q0qsWfvZw7hEdPdPRBmwRmt2O1fbfk5CQN1EtNgS372PbOjQHaIV6n+QQP2ELIa3X5Z
 RnyaXyzwaCt6ETUHTslEaR9nOG6N3sIohIwlIywGK6WQmRBPyz5X1oF2Ld9E0crlaZYFPMRH
 hQtFxdycIBpTlc59g7uIXzwRx65HJcyBflj72YoTzwchN6Wf2rKq9xmtkV2Eihwo8WH3XkL9
 cjVKjg8rKRmqIMSRCpqFBWJpT1FzecQ8EMV0fk18Q5MLj441yQARAQABzRtJYW4gS2VudCA8
 cmF2ZW5AdGhlbWF3Lm5ldD7CwXsEEwECACUCGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheA
 BQJOnjOcAhkBAAoJEOdnc4D1T9iphrYQALHK3J5rjzy4qPiLJ0EE9eJkyV1rqtzct5Ah9pu6
 LSkqxgQCfN3NmKOoj+TpbXGagg28qTGjkFvJSlpNY7zAj+fA11UVCxERgQBOJcPrbgaeYZua
 E4ST+w/inOdatNZRnNWGugqvez80QGuxFRQl1ttMaky7VxgwNTXcFNjClW3ifdD75gHlrU0V
 ZUULa1a0UVip0rNc7mFUKxhEUk+8NhowRZUk0nt1JUwezlyIYPysaN7ToVeYE4W0VgpWczmA
 tHtkRGIAgwL7DCNNJ6a+H50FEsyixmyr/pMuNswWbr3+d2MiJ1IYreZLhkGfNq9nG/+YK/0L
 Q2/OkIsz8bOrkYLTw8WwzfTz2RXV1N2NtsMKB/APMcuuodkSI5bzzgyu1cDrGLz43faFFmB9
 xAmKjibRLk6ChbmrZhuCYL0nn+RkL036jMLw5F1xiu2ltEgK2/gNJhm29iBhvScUKOqUnbPw
 DSMZ2NipMqj7Xy3hjw1CStEy3pCXp8/muaB8KRnf92VvjO79VEls29KuX6rz32bcBM4qxsVn
 cOqyghSE69H3q4SY7EbhdIfacUSEUV+m/pZK5gnJIl6n1Rh6u0MFXWttvu0j9JEl92Ayj8u8
 J/tYvFMpag3nTeC3I+arPSKpeWDX08oisrEp0Yw15r+6jbPjZNz7LvrYZ2fa3Am6KRn0zsFN
 BE6c/ycBEADZzcb88XlSiooYoEt3vuGkYoSkz7potX864MSNGekek1cwUrXeUdHUlw5zwPoC
 4H5JF7D8q7lYoelBYJ+Mf0vdLzJLbbEtN5+v+s2UEbkDlnUQS1yRo1LxyNhJiXsQVr7WVA/c
 8qcDWUYX7q/4Ckg77UO4l/eHCWNnHu7GkvKLVEgRjKPKroIEnjI0HMK3f6ABDReoc741RF5X
 X3qwmCgKZx0AkLjObXE3W769dtbNbWmW0lgFKe6dxlYrlZbq25Aubhcu2qTdQ/okx6uQ41+v
 QDxgYtocsT/CG1u0PpbtMeIm3mVQRXmjDFKjKAx9WOX/BHpk7VEtsNQUEp1lZo6hH7jeo5me
 CYFzgIbXdsMA9TjpzPpiWK9GetbD5KhnDId4ANMrWPNuGC/uPHDjtEJyf0cwknsRFLhL4/NJ
 KvqAuiXQ57x6qxrkuuinBQ3S9RR3JY7R7c3rqpWyaTuNNGPkIrRNyePky/ZTgTMA5of8Wioy
 z06XNhr6mG5xT+MHztKAQddV3xFy9f3Jrvtd6UvFbQPwG7Lv+/UztY5vPAzp7aJGz2pDbb0Q
 BC9u1mrHICB4awPlja/ljn+uuIb8Ow3jSy+Sx58VFEK7ctIOULdmnHXMFEihnOZO3NlNa6q+
 XZOK7J00Ne6y0IBAaNTM+xMF+JRc7Gx6bChES9vxMyMbXwARAQABwsFfBBgBAgAJBQJOnP8n
 AhsMAAoJEOdnc4D1T9iphf4QAJuR1jVyLLSkBDOPCa3ejvEqp4H5QUogl1ASkEboMiWcQJQd
 LaH6zHNySMnsN6g/UVhuviANBxtW2DFfANPiydox85CdH71gLkcOE1J7J6Fnxgjpc1Dq5kxh
 imBSqa2hlsKUt3MLXbjEYL5OTSV2RtNP04KwlGS/xMfNwQf2O2aJoC4mSs4OeZwsHJFVF8rK
 XDvL/NzMCnysWCwjVIDhHBBIOC3mecYtXrasv9nl77LgffyyaAAQZz7yZcvn8puj9jH9h+mr
 L02W+gd+Sh6Grvo5Kk4ngzfT/FtscVGv9zFWxfyoQHRyuhk0SOsoTNYN8XIWhosp9GViyDtE
 FXmrhiazz7XHc32u+o9+WugpTBZktYpORxLVwf9h1PY7CPDNX4EaIO64oyy9O3/huhOTOGha
 nVvqlYHyEYCFY7pIfaSNhgZs2aV0oP13XV6PGb5xir5ah+NW9gQk/obnvY5TAVtgTjAte5tZ
 +coCSBkOU1xMiW5Td7QwkNmtXKHyEF6dxCAMK1KHIqxrBaZO27PEDSHaIPHePi7y4KKq9C9U
 8k5V5dFA0mqH/st9Sw6tFbqPkqjvvMLETDPVxOzinpU2VBGhce4wufSIoVLOjQnbIo1FIqWg
 Dx24eHv235mnNuGHrG+EapIh7g/67K0uAzwp17eyUYlE5BMcwRlaHMuKTil6
In-Reply-To: <20260825-grabmal-erwachen-aufatmen-b62c5d6c220e@brauner>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25/8/26 22:58, Christian Brauner wrote:
> On Thu, 20 Aug 2026 22:05:03 -0700, Shakeel Butt wrote:
>> kernfs: remove kernfs_rwsem from dentry revalidation
>>
>> At Meta, we are seeing important system daemons that poll cgroupfs and
>> sysfs geth stuck in kernfs_dop_revalidate() for minutes. The two that
>> hurt most are the ones we can least afford to lose: oomd, which decides
>> what to kill when a machine runs out of memory, and below[1], which
>> records the telemetry used to understand what happened afterwards.
>>
>> [...]
> Applied to the vfs-7.4.kernfs branch of the vfs/vfs.git tree.
> Patches in the vfs-7.4.kernfs branch should appear in linux-next soon.
>
> Please report any outstanding bugs that were missed during review in a
> new review to the original patch series allowing us to drop it.
>
> It's encouraged to provide Acked-bys and Reviewed-bys even though the
> patch has now been applied. If possible patch trailers will be updated.


I have a report against kernfs where I cannot find a reason for significant

contention, primarily on ->revaliate(), in either of two vmcores, exactly

the case described in this series.


I reviewed the series and it looks good to me.

The descriptions justifying the changes also look sound.


While I think renames and removals should be ok based on the descriptions

justifying the change (my biggest concern with removing the rwsem) I'll

continue to ponder its implications for a while.


Reviewed-by: Ian Kent <raven@themaw.net>


>
> Note that commit hashes shown below are subject to change due to rebase,
> trailer updates or similar. If in doubt, please check the listed branch.
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> branch: vfs-7.4.kernfs
>
> [1/4] kernfs: Use VFS lookup context in d_revalidate()
>        https://git.kernel.org/vfs/vfs/c/b3c97f5cb084
> [2/4] kernfs: Prepare directory revisions for lockless reads
>        https://git.kernel.org/vfs/vfs/c/272e0997df44
> [3/4] kernfs: Avoid namespace dereference in d_revalidate()
>        https://git.kernel.org/vfs/vfs/c/e1c629a8dbc7
> [4/4] kernfs: Remove kernfs_rwsem from dentry revalidation
>        https://git.kernel.org/vfs/vfs/c/8c6ad578e2f0
>
>
