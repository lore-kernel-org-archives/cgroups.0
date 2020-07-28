From: Jens Axboe <axboe@kernel.dk>
Subject: Re: bdi cleanups v3
Date: Tue, 28 Jul 2020 13:20:09 -0600
Message-ID: <08ded32a-cf3a-55b0-6a88-19d201edac93@kernel.dk>
References: <20200724073313.138789-1-hch@lst.de>
 <0b2b59d4-da4c-33df-82b4-0d4935b91e6e@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6vfxP0xAICcExvQMz/4lQvBsGt+MbkdQCG7TPtmY2IU=;
        b=Y9eOezwVV/XNy3ss0E8zEQZN46Jwp7Vwk2F4dYKq4GF+o38CPH9bXtrUXOyKXIv0qi
         IxCEGapawUVePV3q40k2ellTesiBEzVplHJE1NvfhyL5RCl83HKGBpQJX0QM6eO0a6fq
         K4eY6mGRbq51nbLdHdV0aIyuHM8uJTGXUryQRTt7Lj0uw/Rn/vzZ7q/sGIcO2+P5vKXM
         D+ek+rXJ/oXKvUiOA/SsGJJtECe80pX2lqhwV2Mek5vNpO9+e9YTmFR2Dc+dekaVJzW8
         tm1bitx5pVI4Q4Wm0OEfzMIXB/vw2Lt3V5PNJbWz7GH/REb/D7Ra0sQgFciGhg/c8Ve4
         LbsQ==
In-Reply-To: <0b2b59d4-da4c-33df-82b4-0d4935b91e6e@kernel.dk>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Christoph Hellwig <hch@lst.de>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On 7/28/20 9:41 AM, Jens Axboe wrote:
> On 7/24/20 1:32 AM, Christoph Hellwig wrote:
>> Hi Jens,
>>
>> this series contains a bunch of different BDI cleanups.  The biggest item
>> is to isolate block drivers from the BDI in preparation of changing the
>> lifetime of the block device BDI in a follow up series.
> 
> Applied, thanks.

Dropped:

  CC      block/blk-sysfs.o
block/blk-sysfs.c:608:16: error: ‘blk_throtl_sample_show’ undeclared here (not in a function); did you mean ‘blk_throtl_sample_entry’?
  608 | QUEUE_RW_ENTRY(blk_throtl_sample, "throttle_sample_time");
      |                ^~~~~~~~~~~~~~~~~
block/blk-sysfs.c:563:10: note: in definition of macro ‘QUEUE_RW_ENTRY’
  563 |  .show = _prefix##_show,   \
      |          ^~~~~~~
block/blk-sysfs.c:608:16: error: ‘blk_throtl_sample_store’ undeclared here (not in a function); did you mean ‘blk_throtl_sample_entry’?
  608 | QUEUE_RW_ENTRY(blk_throtl_sample, "throttle_sample_time");
      |                ^~~~~~~~~~~~~~~~~
block/blk-sysfs.c:564:11: note: in definition of macro ‘QUEUE_RW_ENTRY’
  564 |  .store = _prefix##_store,   \
      |           ^~~~~~~
block/blk-sysfs.c:657:3: error: ‘blk_throtl_sample_time_entry’ undeclared here (not in a function); did you mean ‘blk_throtl_sample_time_store’?
  657 |  &blk_throtl_sample_time_entry.attr,
      |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |   blk_throtl_sample_time_store
block/blk-sysfs.c:608:16: warning: ‘blk_throtl_sample_entry’ defined but not used [-Wunused-variable]
  608 | QUEUE_RW_ENTRY(blk_throtl_sample, "throttle_sample_time");
      |                ^~~~~~~~~~~~~~~~~
block/blk-sysfs.c:561:33: note: in definition of macro ‘QUEUE_RW_ENTRY’
  561 | static struct queue_sysfs_entry _prefix##_entry = { \
      |                                 ^~~~~~~
make[1]: *** [scripts/Makefile.build:281: block/blk-sysfs.o] Error 1
make: *** [Makefile:1756: block] Error 2

from "block: add helper macros for queue sysfs entries"

This has not seen a full compile test even...

-- 
Jens Axboe

