From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 3/5] block: add a queue_has_disk helper
Date: Mon, 9 Aug 2021 14:37:21 +0000
Message-ID: <PH0PR04MB7416972333C98625F217B2419BF69@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210809141744.1203023-1-hch@lst.de>
 <20210809141744.1203023-4-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628519845; x=1660055845;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=IPN1pzxctyYC5S1XBcxyQNi/m4XayLfVwXW9rUgKFMRcdJrWNyhusXaW
   9XFZuqtclJMhdp7p17cBwOww0e+TiSjxpwElJQfyVMO7V24v6QxTXJWMQ
   Pzw8oL4svmQpby9HWPq2kRj7nmZkSPDRdiik3GbeNJCDT+bzTengdN3xK
   hUJZwigZ7TcThj/LXGxXZZeH2V97i2IQYAVcI013d6/+4SvhtFgViwKpE
   Q8iMTo+aPjodmC1mCdUmel+LNaRsmq5WcK2AD/pFOZcM7SB7yzBBqGAuF
   O+zvud1Nq5ghNiqqsec/80EkLoc7MUcoFCdz59Ke+0QadolC7vqEkkT8H
   w==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=qL238W4phnzZid2rmDxNjfcmEZGxlH5Xuz65IsuZJvrHgSCXT3o8lTHWjwG44Og6zyDN7B3twfi4wJq+Mx1yFErrn01GLRTtIac+jP5ol6qL9R0FoTivUkKvEA8iZ+q2dCKdQvYXSo1/gbbUg7NOGFd+b85uqfcScCFH9LS2LqU=
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
