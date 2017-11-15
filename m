From: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH v3 0/2] Invert cpu_hotplug_lock and cpuset_mutex locking order.
Date: Wed, 15 Nov 2017 19:50:13 +0530
Message-ID: <1510755615-25906-1-git-send-email-prsood@codeaurora.org>
References: <20171115103742.xt7muaq2dfrs2cyd@hirez.programming.kicks-ass.net>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1510755648;
        bh=YufYL5Nt3v/hT0ZMM5HJUxyjr6YnOVwuX1P39cChDgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UNkiWb6YCo1mCmuzOZwu4sDec2UWu8zNEL1IeKR1qclhT6HK8M9ISEHf40HlwHCi8
         ZWm81WS+eOuy8nKVRuBUxbgpilHE24iVH07qzCwA5ygTncK28huvfKydZj0OzxgZka
         DyyyEtv7qbZCyZV7CssgIPbZndrBlycETSWmhZY8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1510755647;
        bh=YufYL5Nt3v/hT0ZMM5HJUxyjr6YnOVwuX1P39cChDgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mSiWKnWw0824W+1wf/DnzoJjR2sHrmvx6+kUXXu9tUGbYo0W8rz5WEztKFPHSFWzl
         jp+02Wsumx29sSg43wHIrYo5Sod2ZDmvTidN1r4EZfBmqyO4M98TLj6dSA7ZbmUnej
         UpGcTgM3yusK5SWXuBOaLjGaRA+A5K8WBi78YZKM=
In-Reply-To: <20171115103742.xt7muaq2dfrs2cyd-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clingutla-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

This patch does following
	1- Remove circular dependency deadlock by inverting order of
cpu_hotplug_lock and cpuset_mutex.
	2- Make cpuset_hotplug_workfn() synchronous for cpu hotplug path.
For memory hotplug path it still gets queued as a work item.

Prateek Sood (2):
  cgroup/cpuset: remove circular dependency deadlock
  cpuset: Make cpuset hotplug synchronous

 include/linux/cpuset.h |  6 ----
 kernel/cgroup/cpuset.c | 94 +++++++++++++++++++++++++++-----------------------
 kernel/power/process.c |  2 --
 kernel/sched/core.c    |  1 -
 4 files changed, 50 insertions(+), 53 deletions(-)

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc., 
is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
