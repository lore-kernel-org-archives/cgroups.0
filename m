From: Johannes Thumshirn <Johannes.Thumshirn-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH 4/5] block: move the bdi from the request_queue to the
 gendisk
Date: Mon, 9 Aug 2021 14:38:44 +0000
Message-ID: <PH0PR04MB7416F6DEEC0E6FC1ABCA3F4C9BF69@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210809141744.1203023-1-hch@lst.de>
 <20210809141744.1203023-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628519927; x=1660055927;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=B7cenyg0F20pF6uiAghkofD3AOVBKwJi8dxHVoMj3kUzeapuZiDUISU5
   KKnpHeId90llpjnmHi24CDzF4NUWTMa9yoWn6xfl2QG0QNCYGLljUJk9g
   rkWbY5s8eXOjdhkiNFTt4iyDYibPvX4IQ+EDV0ntadOZm46tetE2xsySU
   hJYHotLrCMp0zPmKvMgPiQBm7tvAqr5rfm4aBoqEjWP2jzK3lOKusuxXD
   LQDe2p9NOFPXgmAH5B/AuyRF9D5bnFIoBF9iWRt/6kHUKinF/CGpx7BZ7
   M4QI+rCTG7sMCn0vRx1rkMIv4uDFk0pnz9h1J87YWsi0aweqy8LYiu8+9
   Q==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=kaokVoi/t2Yc7Pbmzar10pKZssWmQAChPkpovOUccp6Yfk8ijhWRaupxXR72NeV9Ja4vVG/bRD1IUW3oD3jO0WA4RUdDDktBJRAZejITP6i9RzuZis3u6H9lZSEUj4Dn1PZNsSS0cgXbl6yETjE93Ebi7wFGAZTLEEROTmeaGI8=
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn-Sjgp3cTcYWE@public.gmane.org>=0A=
