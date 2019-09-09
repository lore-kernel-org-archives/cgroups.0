From: Paolo Valente <paolo.valente@linaro.org>
Subject: [PATCH 0/1] block, bfq: remove bfq prefix from cgroups filenames
Date: Mon,  9 Sep 2019 09:31:16 +0200
Message-ID: <20190909073117.20625-1-paolo.valente@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B1DB8hLBI0DfoqSgN7BPkx2C4LPQLRBtlT6+2pkAJhs=;
        b=HKRj88wLIuKKvMVrlcCv44LZGStlBJSMMWn4leonTHif3dSsI6XAAv+OM86+GCrN1v
         /hOaBr4dA9agJJsMN2NYIiBjmsuYpTNf+QT52+rpd974601QbtgJW3WkeenkfG758vHI
         8ZxT/x+F2of1EhU+ByWFVGSyy1wTh1hM88FeSE1dPOx5hCgQYmVMy2M94iciqXojaTmL
         3VOUCnsFbF9Ancywa6eTxH/S//UOOLO/4AZLR5wRM1KS4iGmDekWn9sLA1XZwuc5p3s5
         QmPtliwpPqY1PJaqx6n0mXBW58VfnEJe87NWLZ/rah0/r1Rte+oSMwZzDYGlc18n3Dpp
         7wUA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Paolo Valente <paolo.valente@linaro.org>

Hi Jens,
now that BFQ's weight interface has been fixed [1], can we proceed
with this change?

In addition to acking this solution, in [2] Tejun already suggested a
reduced version of the present patch. In Tejun's version, only
bfq.weight is changed. But I guess that legacy code may use also some
of the other bfq parameters in cgroups, without the bfq prefix. Apart
from that, any version is ok for me, provided that it solves the
current confusing situation for userspace [3].

Thanks,
Paolo

[1] https://lkml.org/lkml/2019/8/27/1716
[2] https://www.mail-archive.com/linux-block@vger.kernel.org/msg35823.html
[3] https://github.com/systemd/systemd/issues/7057

Angelo Ruocco (1):
  block, bfq: delete "bfq" prefix from cgroup filenames

 block/bfq-cgroup.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

--
2.20.1
