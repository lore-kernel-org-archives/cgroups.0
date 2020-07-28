From: Jens Axboe <axboe@kernel.dk>
Subject: Re: bdi cleanups v3
Date: Tue, 28 Jul 2020 09:41:28 -0600
Message-ID: <0b2b59d4-da4c-33df-82b4-0d4935b91e6e@kernel.dk>
References: <20200724073313.138789-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vSWx1/Sr/gJvV92Fd2QuTQjvx6hegEt2EdSzZRTJZXM=;
        b=eOS9kCUGWozMEgHSZJcSVDFO0AHLhz5u13Hzr4euy1SfrsO3wctZ6YAEcFh81LUEFe
         qKEx883RdFNlnU/ciLWMOG+Vj2O3UtdPLRGu3wVgO4m2BQ37DnVzwEQRW6UlEXPC6X4+
         6qy3MKLhkiUeg2Gj1Hl5rFfX2WIKMSYf+TvHUXJLRYjJhA2RqWzGfAYi3i7oAIMDIOGN
         kWmCj7CoLh5z5B/OHRT7/QrMunwFyL57wmiHBTZtYJy1FwxdlHKoWKtw+zsNgVUo2ZHx
         EpjXSF+5KBb5kwwDmys2D0JqmY/qrmWuFn2WVlWcfsS5xNRgrwNQRXJP5bi8Bs1TigZW
         btwA==
In-Reply-To: <20200724073313.138789-1-hch@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On 7/24/20 1:32 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series contains a bunch of different BDI cleanups.  The biggest item
> is to isolate block drivers from the BDI in preparation of changing the
> lifetime of the block device BDI in a follow up series.

Applied, thanks.

-- 
Jens Axboe

