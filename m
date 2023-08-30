From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH -next v2 0/4] cleanup and fixes for
 'carryover_ios/bytes'
Date: Wed, 30 Aug 2023 10:15:41 -0600
Message-ID: <169341214128.126809.887499172246974697.b4-ty@kernel.dk>
References: <20230816012708.1193747-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1693412143; x=1694016943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=84+SP1mxCxPsszug4wWaDlsL3ZFBxN4ycBABvZrJaYs=;
        b=hmUElf4JG9R8Kjx9ZWVWNw+hT/pPkZgpgWENArPKg/gWpP/k/gpKOqMC4Wi4kdG7kJ
         I1gK8bx9hsfXv+uthThnLVcDepqXJz0TR5VAgS6yyF0sBD6En11UR6zITsyKD8m1r5ce
         4reyFvRGZjYHP3V6AoU+Pq8SJeObjQGYXeE32eD4pYpcw2BeDvNoU0oU+6ATpswJdkVr
         dpbIbQJfsWZ8BeqgBR9I5yh1xXE5tqenXo8ViY2eLz6nf+lxq2mS8N5Mo02kr/MQ4hz3
         75abj6z1ioLre/Cj0qk8lS7vEvkJ2f770J1k/m9KYxAYT9jrLduWQjoSXfQ8lsfJVwQa
         iDvQ==
In-Reply-To: <20230816012708.1193747-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
To: tj@kernel.org, josef@toxicpanda.com, yukuai3@huawei.com, mkoutny@suse.com, Yu Kuai <yukuai1@huaweicloud.com>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com


On Wed, 16 Aug 2023 09:27:04 +0800, Yu Kuai wrote:
> changes in v2:
>  - fix missing adjustment in throtl_log().
> 
> Patch 1 print signed value for 'carryover_ios/bytes' to user.
> 
> Patch 2 fix that comparation ”unsigned value < negative value“ will
> pass, causing that io won't be throttled in the silce.
> 
> [...]

Applied, thanks!

[1/4] blk-throttle: print signed value 'carryover_bytes/ios' for user
      commit: ef100397fac3e2e403d5d510e66f36e242654073
[2/4] blk-throttle: fix wrong comparation while 'carryover_ios/bytes' is negative
      commit: bb8d5587bdc3ab211e1eae2eeb966f7a7d1f9c0b
[3/4] blk-throttle: use calculate_io/bytes_allowed() for throtl_trim_slice()
      commit: e8368b57c006dc0e02dcd8a9dc9f2060ff5476fe
[4/4] blk-throttle: consider 'carryover_ios/bytes' in throtl_trim_slice()
      commit: eead0056648cef49d7b15c07ae612fa217083165

Best regards,
-- 
Jens Axboe



