From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v2 0/3] block, bfq: minor cleanup and fix
Date: Fri, 28 Jan 2022 12:27:49 -0700
Message-ID: <2579c500-549f-ff04-d1e1-6cf3db10b428@kernel.dk>
References: <20211231032354.793092-1-yukuai3@huawei.com>
 <164338111974.263985.3933987922467783334.b4-ty@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=44YundMarG4oJcqLVS+4O9jZDmTBDcQhSRUVkk3ZKW4=;
        b=nzXb4/P8PZ7yZyUUX6bta1uJ4avIKH+OTNZMoILFmYcqEFNTBgCmKiROLNV0+OmkXy
         Yy+iYbgFPQ7Sn9NwzwQ/PEjvsGe7KRpuNDASfopAeJS+786MEYBKUr01VYv5Gn8dOGpv
         FRyacLGvPbb0F4gGtmZtTw63lbdst8ml+siXk5Ld2C8fUyRe4y3JrjdR+yAbbA7AJ6H7
         T6unhvbXrf4FS1WhU6yBTa6D4XqXNBiO21JWt6qS6askgA6Ejac1T5gML9kvI0ybrUEK
         YGlHGbdDw6XCPqwIQoL+p0TVEO9cUclnfkWNzaRJjE1iOtvYJnFFjCOGugLrXBqwv4e5
         DJ1Q==
In-Reply-To: <164338111974.263985.3933987922467783334.b4-ty-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 1/28/22 7:45 AM, Jens Axboe wrote:
> On Fri, 31 Dec 2021 11:23:51 +0800, Yu Kuai wrote:
>> Chagnes in v2:
>>  - add comment in patch 2
>>  - remove patch 4, since the problem do not exist.
>>
>> Yu Kuai (3):
>>   block, bfq: cleanup bfq_bfqq_to_bfqg()
>>   block, bfq: avoid moving bfqq to it's parent bfqg
>>   block, bfq: don't move oom_bfqq
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/3] block, bfq: cleanup bfq_bfqq_to_bfqg()
>       commit: a9c77f6ec0b566439182a10b64dd3e60a0408849
> [2/3] block, bfq: avoid moving bfqq to it's parent bfqg
>       commit: 36ad7fe0ec7485ee435f7a40452c7a58598779d4
> [3/3] block, bfq: don't move oom_bfqq
>       commit: a0b98e6fba18a40aa9672cc3e0abf980456f3ae6

For all those pings, this patchset sure didn't see a lot of compiles:

block/bfq-cgroup.c: In function ‘bfq_bfqq_move’:
block/bfq-cgroup.c:648:40: error: implicit declaration of function ‘bfq_group’; did you mean ‘bfqq_group’? [-Werror=implicit-function-declaration]
  648 |         struct bfq_group *old_parent = bfq_group(bfqq);
      |                                        ^~~~~~~~~
      |                                        bfqq_group
block/bfq-cgroup.c:648:40: error: initialization of ‘struct bfq_group *’ from ‘int’ makes pointer from integer without a cast [-Werror=int-conversion]
cc1: all warnings being treated as errors
make[1]: *** [scripts/Makefile.build:288: block/bfq-cgroup.o] Error 1
make: *** [Makefile:1831: block] Error 2

Dropped.

-- 
Jens Axboe

