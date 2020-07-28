From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 05/14] md: update the optimal I/O size on reshape
Date: Tue, 28 Jul 2020 12:18:18 +0000
Message-ID: <DM5PR0401MB3591D718B1F2A18968A0CF629B730@DM5PR0401MB3591.namprd04.prod.outlook.com>
References: <20200724073313.138789-1-hch@lst.de>
 <20200724073313.138789-6-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595938701; x=1627474701;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=l0kRjycEZhiyXiP4rEfFmnR8DdQ1o9bEmEM3lVywktpciPkaUSpQsIm8
   lariAnS+ytpEQ4/eE3aA7zADJLOIxVuFC1585XOCTqm4kNxRTCt9eyuix
   eO2Fp8lMn5UHh47H7oToY6M/LqIfyCexQZNt/sDQQMzMwc4Ba/UvqN8xp
   CxRTGrF1HNeMLzr5FRZLZ4z8p/6sJKnBc+5sFvOdWGV8eLCc83AOSMhpX
   198Dl/9NTxCRQZqAiyvh1JzSVw6SWQk53rpHNcFRYhXK2FLx9iaf0XSXv
   6+7lAfplJLFub0GHb/rYXmnxywNZ8Bc5MU+S5elL6lvL3aPmkDlbdhqOC
   g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=if2E/t3flnnBCzC6GbKinqQ8jpDLhuEzTasUy9HbV0RPH0C91NsTj105cvESjCKRTTz/lYQrLC2iKUAjmK29ZpiOWd/75GnFuSAf1HEM2Ig+vy8C305iRhF1EtqTwKlS0zWvLTvfOi7QUefJYuCAyfSrWhjJ4LP7u7Mt65ibI5k=
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
