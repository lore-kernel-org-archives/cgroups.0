From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH 2/2] block, bfq: delete "bfq" prefix from cgroup filenames
Date: Tue, 17 Sep 2019 21:04:52 +0000
Message-ID: <BYAPR04MB57492FC0194EFB7506147533868F0@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20190917165148.19146-1-paolo.valente@linaro.org>
 <20190917165148.19146-3-paolo.valente@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1568754295; x=1600290295;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=5L/3zDrhBByJdOrBbw28FOeLuhv56OkWr9EyUtoofrc=;
  b=f9apoqKocv6c7IQk9DYAylRWv5slcxrFMM8f3hMblQ5egMjU+JixiW9F
   QG5wPWciRVF+eeb/7HnwR53Xdyxv2FI6ytW7h4KttMbJuGjjy9OJs4y3F
   zwcHw8T1yQZY3/gGUJBJucqTYNrH9nXvZSnz9DWX18ko/K3+xznA/cFeh
   gckxkvqlodE0lMHDs5zOctbX3wPMhYRgtWgm1M0SDuGnsXLexufoYJgQX
   U+zL+UTuxkYEUrsBIBtHJhPATu+YOU0asl8nt6QSqK2mptWhY2F85+epQ
   BYhEteH5216X45+lMIFhcEPiyV5t53XCPzkEeNFghbhk7bz97N8XIIg7C
   g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5L/3zDrhBByJdOrBbw28FOeLuhv56OkWr9EyUtoofrc=;
 b=R7HwcDApQ6GY/xk7MdMBs/opg4kGGXrspxCiIXLtj+p+LE4qDbrEO0nmOno0w6iqOpGggZEayJSIfUMnrbcwz7TLmKdadKYDCdt6sfUL+nlkZGqibzP3bZkbUXzS8vD8aCliBs3+KMVr9/xmBLJGaS1PbrDI6ltuTr82+iY6Aqs=
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Paolo Valente <paolo.valente@linaro.org>, Jens Axboe <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>, "linus.walleij@linaro.org" <linus.walleij@linaro.org>, "bfq-iosched@googlegroups.com" <bfq-iosched@googlegroups.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, Tejun Heo <tj@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Angelo Ruocco <angeloruocco90@gmail.com>

Looks good to me.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
On 09/17/2019 09:52 AM, Paolo Valente wrote:=0A=
> From: Angelo Ruocco<angeloruocco90@gmail.com>=0A=
>=0A=
> When bfq was merged into mainline, there were two I/O schedulers that=0A=
> implemented the proportional-share policy: bfq for blk-mq and cfq for=0A=
> legacy blk. bfq's interface files in the blkio/io controller have the=0A=
> same names as cfq. But the cgroups interface doesn't allow two=0A=
> entities to use the same name for their files, so for bfq we had to=0A=
> prepend the "bfq" prefix to each of its files. However no legacy code=0A=
> uses these modified file names. This naming also causes confusion, as,=0A=
> e.g., in [1].=0A=
>=0A=
> Now cfq has gone with legacy blk, so there is no need any longer for=0A=
> these prefixes in (the never used) bfq names. In view of this fact, this=
=0A=
> commit removes these prefixes, thereby enabling legacy code to truly=0A=
> use the proportional share policy in blk-mq.=0A=
>=0A=
> [1]https://github.com/systemd/systemd/issues/7057=0A=
>=0A=
> Signed-off-by: Angelo Ruocco<angeloruocco90@gmail.com>=0A=
> Signed-off-by: Paolo Valente<paolo.valente@linaro.org>=0A=
=0A=
