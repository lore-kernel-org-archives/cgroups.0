From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 1/5] mm: hide laptop_mode_wb_timer entirely behind the BDI
 API
Date: Mon, 9 Aug 2021 14:33:50 +0000
Message-ID: <PH0PR04MB74167976DB6951561F74DCF89BF69@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210809141744.1203023-1-hch@lst.de>
 <20210809141744.1203023-2-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628519653; x=1660055653;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=vACKBTJ1W3dbxi9/auoShIet6UycyPrHxIN1n7HzEck=;
  b=A2Qg2ATaAFTB64hSFcgyq0tPt8mptiFtprLiAcike+D+5LDX18ctnYWr
   wqkCPegX3oGuwqW7PKgqd73AOfM8UBms6pT4ygtol+ZGXYX6oWMAEJTTv
   S1YLA2g2Grm4wFu1IeyBGWWpb7r3BCwTksQyTjo4pd/G8BU0RQD3QOFYU
   mp6s7NLslJFFTPFHWJ2QsHo7y8ib6wESFIUaL74FpCeizW08qTjAQ7nFG
   580wstoBXWcu34X19O6YoSwA6S3yrSIeTNvOlZKP8j/Hjvlv3/rnCd1oN
   HzFQ8F1Y9yj9vAuXdqVFlIzPodPAOlYg0qpXUiU1iJZbZBDJzkS6lzo7n
   A==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vACKBTJ1W3dbxi9/auoShIet6UycyPrHxIN1n7HzEck=;
 b=F2jeqY6qFSbnSWLlvmpdOWHb0sisNxAbzI2HIegxBe+R3lTKN6pCQXaOFa9Uxdiwq/CvGdefk4l1pbqILZfdjcg07RVbQZ/mdKe55OZyMWzDGD5TdWOGhR8zZ4X6KFi8sgzMo7UbiNveo48ZM6gOcq7SwPS61zsE7bklk2o5tqc=
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>

On 09/08/2021 16:19, Christoph Hellwig wrote:=0A=
> Don't leak the deta=A6ls of the timer into the block layer, instead=0A=
> initialize the timer in bdi_alloc and delete it in bdi_unregister.=0A=
> Note that this means the timer is initialized (but not armed) for=0A=
> non-block queues as well now.=0A=
=0A=
And laptop_mode_timer_fn() is always present now.=0A=
=0A=
Other than that,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
