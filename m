From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 12/14] bdi: replace BDI_CAP_STABLE_WRITES with a queue and
 a sb flag
Date: Tue, 28 Jul 2020 12:54:40 +0000
Message-ID: <DM5PR0401MB35918B36977C0B2EBB7F262F9B730@DM5PR0401MB3591.namprd04.prod.outlook.com>
References: <20200724073313.138789-1-hch@lst.de>
 <20200724073313.138789-13-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595940883; x=1627476883;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=i73cQScyOXtQNhKCgBM0j0yco6YrKjuowVHgFUDbKic=;
  b=KDHZem/fs0oWN6xNLGu8x57unl7jYSTLsjFyhe8uj+us84zFR8FjPXO8
   4gvVvRnWtrw2lBBCHedt4IKaH5bbIOESvFpmWEcqwQc1ESjDNhxu4tihW
   dlODcQxAY0ehMzLeuQzA3xHqxruIMshojvHGXmnJpb80LaPB+WqOwKP3c
   xc3yhnoettSq5xLdKjLSCoM/BcZozMWWAze4SxYeaTR+VGmbm7yNNrcTO
   YhWmfvXAxqT85ahFD8SiRuuex+MNOrGgsJ5BtJIkq5r6RPMWUxP4neso/
   mfsYmg6+5fYS3b5c3mS9JfC8mJB7IZt9rCDcBjHsLTRCKqKefKLftR0o2
   g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i73cQScyOXtQNhKCgBM0j0yco6YrKjuowVHgFUDbKic=;
 b=SUZQTNu9cUdP+Vnavdl52Et44KxjvwANxWJVvXmxxtSYAdo/8v+KLFKJA60/7IVtPeOv7evuYz5BLO3U6ZPU3NvN731SIjA71VcbqQ67J8QDluqaLAWkcJ+b4tr8kPYzFeP2oj0w5q1ueU5LqDVFdQn2V3jE/SrxRHMBsf/fWOs=
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
