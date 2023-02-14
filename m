From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/5] Revert "blk-cgroup: move the cgroup information to
 struct gendisk"
Date: Tue, 14 Feb 2023 14:24:38 -0700
Message-ID: <167640987873.61344.17492950909127302009.b4-ty@kernel.dk>
References: <20230214183308.1658775-1-hch@lst.de>
 <20230214183308.1658775-2-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MX/2U0qYb3miU8ugNFw4fmPtYLQym+1ZkvFlchf7Fsk=;
        b=o0cBXrctIG0/VVG6AanOILi6i4olxBWvLbiD3ix7XrjyUo+/eMB4tkcevgZkqr0eNI
         VUETZSob1FK/k2+k/ZxsvahEkExSs8P6wtKGsVj9/WxPefFh14EqyEPHSPDEIc1nGvtT
         prNg71bIjXUCwlaJnDitdYlUuI50DT9zRkcBjJfMQZ2uq9YrFzN5Id4j3Egi9sW3I/hj
         HNLuxxG+2UUDrSQ0g15ewhK4sOlvJcvBOi12UuABTDK6xKrtRbBArVymKVEwj8tpS2YB
         QTdDdtfgn8Vmgj7Is82hfwYRhmTa2sohB0rp7woi4HZ+TOQieQ7PaCuJcabc2kbUxdOx
         EnKQ==
In-Reply-To: <20230214183308.1658775-2-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>, cgroups@vger.kernel.org, linux-block@vger.kernel.org


On Tue, 14 Feb 2023 19:33:04 +0100, Christoph Hellwig wrote:
> This reverts commit 3f13ab7c80fdb0ada86a8e3e818960bc1ccbaa59 as a patch
> it depends on caused a few problems.
> 
> 

Applied, thanks!

[1/5] Revert "blk-cgroup: move the cgroup information to struct gendisk"
      commit: 1231039db31cf0703996d0b1797c2702e25a110a
[2/5] Revert "blk-cgroup: delay calling blkcg_exit_disk until disk_release"
      commit: b4e94f9c2c0822265a6942741d270aa16d229331
[3/5] Revert "blk-cgroup: delay blk-cgroup initialization until add_disk"
      commit: b6553bef8cdc2983943f60edb8dc5e49361ebb3b
[4/5] Revert "blk-cgroup: pass a gendisk to blkg_lookup"
      commit: 9a9c261e6b5512e0b8d9ae9b1c1746c743a15a48
[5/5] Revert "blk-cgroup: pin the gendisk in struct blkcg_gq"
      commit: a06377c5d01eeeaa52ad979b62c3c72efcc3eff0

Best regards,
-- 
Jens Axboe



