From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH 04/14] bdi: initialize ->ra_pages in bdi_init
Date: Mon, 20 Jul 2020 13:58:22 +0200
Message-ID: <CAFLxGvxNHGEOrj6nKTtDeiU+Rx4xv_6asjSQYcFWXhk5m=1cBA@mail.gmail.com>
References: <20200720075148.172156-1-hch@lst.de> <20200720075148.172156-5-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oyadEz0eZwOz4veMiu/99Xwk84Lj2bAOI1P6STGAbTM=;
        b=pzO5UY59E2I78nkbHVVchIb8xSq5dpsUcOpNS7Gkxof5sNSjCEODEhGzsvVVjAfJyl
         VSwzSp6U1Zs9krrRKUF/u2Bk2AkyMb7A4vyZNN5lBySozBpWv75kuuSymSQ75I0lOQIq
         /aNfumnu9UNKeQqzNIgsFnNCRnWlLEXCl5HKsdcBqoLY2AX4WupdTDUkutMtkReFDd/p
         7rLcMb8CsQvVO2aMkGCvC0cISIr9opF8PILSUSavYLWpTTSmyGJ8atrT4DsGICF1czPS
         GjukeM8re+7Is53uuqLc1gz9fVVpsyasqxmhyXdVNJb4jwNSaNcNEMbvPaz5r/mI8alC
         KLmw==
In-Reply-To: <20200720075148.172156-5-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org, cgroups mailinglist <cgroups@vger.kernel.org>

Hello Chrstoph,

On Mon, Jul 20, 2020 at 9:53 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Set up a readahead size by default.  This changes behavior for mtd,
> ubifs, and vboxsf to actually enabled readahead, the lack of which
> very much looks like an oversight.

UBIFS doesn't enable readahead on purpose, please see:
http://www.linux-mtd.infradead.org/doc/ubifs.html#L_readahead

-- 
Thanks,
//richard
