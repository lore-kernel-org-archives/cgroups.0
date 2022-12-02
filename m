From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH -next] blk-cgroup: Fix some kernel-doc comments
Date: Thu, 1 Dec 2022 18:22:38 -0700
Message-ID: <7aa9e496-747d-46ae-b250-d504d84af6e5@kernel.dk>
References: <20221202011713.14834-1-yang.lee@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ha7o0eCHmk2nS/stJvaRFac3CxHDSLDcs+LGCRqIPBY=;
        b=BuUEFSdIuuRDAjVFKVAhHELsh2BTyw5NoWSVDMZq1DGpduTVgVQpO+7R5WrmoIx13M
         M17M+w1VUbCDiexAf14moFi1WiPv5byymNaQeBzbnNxhv7ZEgDDE4rrQ5yrgFdX+5OQk
         SMfw+xxJKUuemgj7vBvIg7ae5dRpRRx63khUXhSoX7VuLzyVPS08OClh9OJtTo2WieSs
         s2eVSCczZxx7r8aGifEn1xk0+06SAwsbh3KN2NuIRxyJmSHmrAsiyOs6B5CdKbo84sx0
         Q8MkiaW+nBe0rxzoIHJnvyn139jE7veJt1/9E1oQBFtsdQHOysYhnyb90VnNvUPxHr/M
         FFQA==
Content-Language: en-US
In-Reply-To: <20221202011713.14834-1-yang.lee@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yang Li <yang.lee@linux.alibaba.com>, tj@kernel.org
Cc: josef@toxicpanda.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>

On 12/1/22 6:17=E2=80=AFPM, Yang Li wrote:
> Make the description of @gendisk to @disk in blkcg_schedule_throttle()
> to clear the below warnings:
>=20
> block/blk-cgroup.c:1850: warning: Function parameter or member 'disk' not=
 described in 'blkcg_schedule_throttle'
> block/blk-cgroup.c:1850: warning: Excess function parameter 'gendisk' des=
cription in 'blkcg_schedule_throttle'

Please always include a fixes line:

Fixes: de185b56e8a6 ("blk-cgroup: pass a gendisk to blkcg_schedule_throttle=
")

--=20
Jens Axboe


