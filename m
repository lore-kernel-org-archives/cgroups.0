From: Paolo Valente <paolo.valente@linaro.org>
Subject: [PATCH 0/2] block, bfq: make bfq disable iocost and present a double interface
Date: Tue,  1 Oct 2019 20:33:14 +0100
Message-ID: <20191001193316.3330-1-paolo.valente@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JiHkBcFF9QGKSMF3hIUTLU+zid7TMdspW3045+AEJlQ=;
        b=ZPycgWvl2h+aHUHp06XdvjewtgM29fzf/AeUg8xKzELsCUN7fqdxZ2Ko8wyH1v3OgO
         6cbI5fFQok9nm7zF0Sdezj0f/ayPXceaD/BIC6Pfym9Zbvu1vbKqpd/5CdpS5WWgb0mM
         JFzb7RKoBj53G4DkOlFcppmGEoOzCdAw++138O/YF6JonUrHobCbwZWZibNesC+AKZBI
         tMDSqXbxo3j6jcvm/zRn7A+doKunH4UgdY+XNJN/+ziuhdZmBElCqkwK6ZEkx0iVmZDQ
         wL+tn+Rjnklt9C/+ESpvIF634AiWYbN1LKE60Y3bupfg70QqCS0nSvmWM6UGX8gDDMfW
         HjTQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Paolo Valente <paolo.valente@linaro.org>

Hi Jens,

the first patch in this series is Tejun's patch for making BFQ disable
io.cost. The second patch makes BFQ present both the bfq-prefixes
parameters and non-prefixed parameters, as suggested by Tejun [1].

In the first patch I've tried to use macros not to repeat code
twice. checkpatch complains that these macros should be enclosed in
parentheses. I don't see how to do it. I'm willing to switch to any
better solution.

Thanks,
Paolo

[1] https://lkml.org/lkml/2019/9/18/736

Paolo Valente (1):
  block, bfq: present a double cgroups interface

Tejun Heo (1):
  blkcg: Make bfq disable iocost when enabled

 Documentation/admin-guide/cgroup-v2.rst |   8 +-
 Documentation/block/bfq-iosched.rst     |  40 ++--
 block/bfq-cgroup.c                      | 260 ++++++++++++------------
 block/bfq-iosched.c                     |  32 +++
 block/blk-iocost.c                      |   5 +-
 include/linux/blk-cgroup.h              |   5 +
 kernel/cgroup/cgroup.c                  |   2 +
 7 files changed, 201 insertions(+), 151 deletions(-)

--
2.20.1
