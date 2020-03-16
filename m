From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 0/3] psi: cpu.pressure cgroup fix & MAINTAINERS update
Date: Mon, 16 Mar 2020 15:13:30 -0400
Message-ID: <20200316191333.115523-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hQ6KfYR9gsZkcfMfYyRVmhCMb80+DstZqdWe5a9vHYQ=;
        b=msdHOOStVPMDS4Mqi0Uw5qYY3xmOx/awlB/N7lszPYI/CkuBwbE2ctj8Cktbsgy/M/
         YhyH+WEXvueDCguQlgjMpZTsrtXUqpZzT4q9I74W0tplZSCZpgZDs5KsIkXdKGwjmhJ3
         WBjoWnH+yLuK/luBrjtZbREo1xGzazEEcK0iuQDrplBar6wkYUFAG5Ry1haIEijIC8G8
         uQGuyulp7IRd8+TMJuwRTO1exTFxEKvHkEyMq5aUs7EPp7zLQo47w7g9vtfod0B5YRBR
         X7M1JBEWs1VgBIR7abel2WyB1OUeuApmBML954516LCrA2QGW1K0r67VmqHE6dz4uglp
         lOJA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hello Peter,

Patch 1 implements the cpu.pressure fix for cgroups we were looking at
recently, 2 is the cgroup hierarchy walk optimization you proposed.

Patch 3 adds a MAINTAINER entry for psi, as at least one person tried
looking for it and couldn't find it.

If they look alright to you, it'd be great to get them into 5.7.

Based on 5.6-rc6.

Thanks

 MAINTAINERS               |  6 +++
 include/linux/psi.h       |  2 +
 include/linux/psi_types.h | 10 ++++-
 kernel/sched/core.c       |  2 +
 kernel/sched/psi.c        | 99 +++++++++++++++++++++++++++++++++------------
 kernel/sched/stats.h      | 21 ++++++++++
 6 files changed, 114 insertions(+), 26 deletions(-)


