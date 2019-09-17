From: Paolo Valente <paolo.valente@linaro.org>
Subject: [PATCH 0/2 block/for-next] block, blkcg, bfq: make bfq disable iocost and delete bfq prefix from cgroup filenames
Date: Tue, 17 Sep 2019 18:51:46 +0200
Message-ID: <20190917165148.19146-1-paolo.valente@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=evGS757tUJRmyH52cxf9DkgpsYSHsrNAYfq4amowEcw=;
        b=SzvpovQ546505iDrUP05F8IpyFdT1dpX3Y/0NcmUEIc0FreHeRRL31AHZUNYbgyPmU
         oC+YkPCDQz0FAXCkH7NGK1kJ7afkoEZMAXl4FCPEm5VmQfRkExTaPCvtYx/0mjpp7J+I
         T9SexfGNqMRUy7TsivzQIk3QYp3JuOrTVsInW+L/jqLujZ8BP+KbMzHgeEcV4GPmdv4r
         opVw2WZBeKC5M3PZUGrDRuECiMA5gr3eekLGkXE7NUkBzRdNmArqYjllfzUk2Xmdon+7
         a+nBopIS4wLmoETEBmcew/feLr37/N9H97NGyKsnhSwhywZFWt4ccP4ZjiWPyY3Bkg4N
         vF4w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Paolo Valente <paolo.valente@linaro.org>

Hi Jens,
here is the pair of patches from [1] and [2].

Thanks,
Paolo

[1] https://lkml.org/lkml/2019/9/16/469
[2] https://lore.kernel.org/linux-block/20190917151334.GI3084169@devbig004.ftw2.facebook.com/

Angelo Ruocco (1):
  block, bfq: delete "bfq" prefix from cgroup filenames

Tejun Heo (1):
  blkcg: Make bfq disable iocost when enabled

 Documentation/admin-guide/cgroup-v2.rst |  8 +++--
 block/bfq-cgroup.c                      | 48 +++++++++++++------------
 block/bfq-iosched.c                     | 32 +++++++++++++++++
 block/blk-iocost.c                      |  5 ++-
 include/linux/blk-cgroup.h              |  5 +++
 kernel/cgroup/cgroup.c                  |  2 ++
 6 files changed, 71 insertions(+), 29 deletions(-)

--
2.20.1
