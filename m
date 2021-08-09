From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 5/5] block: remove the bd_bdi in struct block_device
Date: Mon, 9 Aug 2021 14:55:57 +0000
Message-ID: <PH0PR04MB7416DDFAE8DA52F3EEF8B7949BF69@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210809141744.1203023-1-hch@lst.de>
 <20210809141744.1203023-6-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628520961; x=1660056961;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=JvQrsVPY2FhRR1h++yG25uTnNjwEygvOG7+5O+XD13nj2jTuiUsQ/GRM
   pwDEFHWL5us8tB0+g+UMoI1I8i3AAP9mnQr2pH4oxxL5pX1uvbDo75NxE
   ZX7SRuKUVRwYVfJmHKI7Zk19cvJaOG/lvorUBo9vq7LGSa++nVS8vytvm
   D/j7xdb/0FK9hD9ykPnvRfiLvRjCpYXXDgWbXg1C6/hBWv4dL7hP2jkk7
   HRnyNq5Mt9RTD/ljW+D7qUswjR3hGWGokaszjDIP9WoZZUycHgNBoj0zU
   Y5NrrF/RMrG6K5UcMFf9Yncu+wk4pkE5YG/VgPfVUW5HkiwkCFojyChlb
   w==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=km8myhN5JcF51gV18iqi/5QjKm8HqhHs/GV2mQq6Wsmp0dw4E6uF1fhCG2vqOq3G0uS7lhyrAOF/oJPs4JR17OnzjSTC1PkjJqklikSt8nHe+ffkdW6SpEgeY/glS+8CLwjeX/Uja9XTtUlhxWbi0QHSKvhf8hrHYjG2zQeC0mQ=
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
