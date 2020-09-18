From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET for-5.10/block] iocost: improve debt forgiveness logic
Date: Thu, 17 Sep 2020 20:44:51 -0400
Message-ID: <20200918004456.593983-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I4g8oZaM4I1PTgkVQKRiJNIBO3rGE09QsJ8U+iD020Q=;
        b=oqR+7x5dJyQcBEwZDtu1PVnUg0zlf4DCuy1Zp8tZ2FigjcnKMuj2pg78JL2AbnBQLM
         lpNqq/FRqu/ytyo8P0ug/B0NXdeHsnftsBfGkIM6w01ef/dTfOFlrd8uvz0wYDofxW2j
         XG2W1jvJ1QCpUQjZYlT3L7Y/KLFvXTba2Foj+z6KNYngQWofDOXSMuS9OfxiwO+OkcXo
         ngQeOqW5OMDzeAazkPzJ+x3uqMA5U3+dI26Nu8OaD8VY+C0DSbIWFjjQuaQDxENVb17v
         W8e68mbdDldx+0xBYRKbuIFe5WVgXpXmEniOLKGUU2XkHCRJE3SDflzZRT653J+gyPdT
         yMGw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, linux-kernel@vger.kernel.org

Hello,

Debt reduction logic was recently added by dda1315f1853 ("blk-iocost: halve
debts if device stays idle"). While it was effective at avoiding
pathological cases where some iocgs were kept delayed while the device was
most idle, it wasn't very effective at addressing more complex conditions
and could leave low priority cgroups unnecessarily harshly throttled under
moderate load.

This patchset improves the debt forgiveness logic so that it's more
effective at reducing such unnecessary throttling. This patchset contains
the following five patches:

 0001-iocost-factor-out-ioc_forgive_debts.patch
 0002-iocost-replace-nr_shortages-cond-in-ioc_forgive_debt.patch
 0003-iocost-recalculate-delay-after-debt-reduction.patch
 0004-iocost-reimplement-debt-forgiveness-using-average-us.patch
 0005-iocost-add-iocg_forgive_debt-tracepoint.patch

and is also available in the following git tree:

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git iocost-debt-forgiveness

diffstat follows. Thanks.

 block/blk-iocost.c            |  141 +++++++++++++++++++++++++++++-------------
 include/trace/events/iocost.h |   41 ++++++++++++
 2 files changed, 141 insertions(+), 41 deletions(-)

--
tejun

