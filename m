From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: remove dead bdi congestion leftovers
Date: Thu, 9 Jul 2020 07:58:58 -0600
Message-ID: <82e2785d-2091-1986-0014-3b7cea7cd0d8@kernel.dk>
References: <20200701090622.3354860-1-hch@lst.de>
 <b5d6df17-68af-d535-79e4-f95e16dd5632@kernel.dk>
 <20200709053233.GA3243@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ttUciq1R4DLXwSrCKOG8sMg2/ZhVL4qipuIgKqQy2hE=;
        b=coM9AtJu0ST+XR8OMgywQuHtTrKC9/b3RSDkB5xLiy4QzbX3T0Aw61rbH1CahgBBuR
         uHGxD5IVaENFxujEI50kNZMa4M546fERlVcPXVLx0073TNTIByYun/g+RHhX1WEDPk90
         nLVTJFCuIlptJdGLVxMiS/3WV+WEeYk/uPnJy7GYNSE5TcqY5Sk+XRfP9o7wxQhjTuBd
         OfxdrSK1xj7iSzi0tqotyg0P0tyJIhgxoopV77fateMyHS2NoNRk3u2YMgfEUz9jt+Mx
         I7oNOyQ+dlAawprLARe5BTTjR91BKrEJGHW7LfKtefXB0VFKSsrdcDKI81gtPbkU0jfv
         Jz9Q==
In-Reply-To: <20200709053233.GA3243-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 7/8/20 11:32 PM, Christoph Hellwig wrote:
> On Wed, Jul 08, 2020 at 05:14:29PM -0600, Jens Axboe wrote:
>> On 7/1/20 3:06 AM, Christoph Hellwig wrote:
>>> Hi Jens,
>>>
>>> we have a lot of bdi congestion related code that is left around without
>>> any use.  This series removes it in preparation of sorting out the bdi
>>> lifetime rules properly.
>>
>> Please run series like this through a full compilation, for both this one
>> and the previous series I had to fix up issues like this:
>>
>> drivers/md/bcache/request.c: In function ‘bch_cached_dev_request_init’:
>> drivers/md/bcache/request.c:1233:18: warning: unused variable ‘g’ [-Wunused-variable]
>>  1233 |  struct gendisk *g = dc->disk.disk;
>>       |                  ^
>> drivers/md/bcache/request.c: In function ‘bch_flash_dev_request_init’:
>> drivers/md/bcache/request.c:1320:18: warning: unused variable ‘g’ [-Wunused-variable]
>>  1320 |  struct gendisk *g = d->disk;
>>       |                  ^
>>
>> Did the same here, applied it.
> 
> And just like the previous one I did, and the compiler did not complain.
> There must be something about certain gcc versions not warning about
> variables that are initialized but not otherwise used.

Are you using gcc-10? It sucks for that. gcc-9 seems to reliably hit
these cases for me, not sure why gcc-10 doesn't. And the ones quoted
above are about as trivial as they can get.

-- 
Jens Axboe

