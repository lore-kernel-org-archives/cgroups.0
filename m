From: Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 0/6] psi: pressure stall monitors
Date: Fri, 14 Dec 2018 09:15:02 -0800
Message-ID: <20181214171508.7791-1-surenb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SQH8taIQkjdsZM4vXe8YuYSXfYbFmiDD/sxQ2CNRa+Q=;
        b=VMlcDc6pBbefgdLgbx3BcKdCAoBNsxf/QXyvozcie1dZ7JHxwPkvj+fpOcvPhlxdCD
         Aor+gaWOgpUb/+t5BxoCW1Zf56LnakBSXB7vCmyXudReJIdR5rm+k6CPIo6E1inL/Aw3
         V9g8MO/sbuDMPNP0PILBab5iuBBuV1+hKwsVbnihgRz5ZZDffEC4ejVIYBcIw3FghUM1
         2htQ844fjf/54XM5IWxGpdqSuvJLtBNhNuZePcROUtK8iuWon/vjfh1Q4sTGuotxzZ1t
         PVEfrcG8EQoRG9WQ4mzZy8YmG7coFYwxA1htS7YNPMyoSZojqhCZsFpNhgLPcZwc8nSE
         Cn1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh@linuxfoundation.org
Cc: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, peterz@infradead.org, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com, Suren Baghdasaryan <surenb@google.com>

Android is adopting psi to detect and remedy memory pressure that
results in stuttering and decreased responsiveness on mobile devices.

Psi gives us the stall information, but because we're dealing with
latencies in the millisecond range, periodically reading the pressure
files to detect stalls in a timely fashion is not feasible. Psi also
doesn't aggregate its averages at a high-enough frequency right now.

This patch series extends the psi interface such that users can
configure sensitive latency thresholds and use poll() and friends to
be notified when these are breached.

As high-frequency aggregation is costly, it implements an aggregation
method that is optimized for fast, short-interval averaging, and makes
the aggregation frequency adaptive, such that high-frequency updates
only happen while monitored stall events are actively occurring.

With these patches applied, Android can monitor for, and ward off,
mounting memory shortages before they cause problems for the user.
For example, using memory stall monitors in userspace low memory
killer daemon (lmkd) we can detect mounting pressure and kill less
important processes before device becomes visibly sluggish. In our
memory stress testing psi memory monitors produce roughly 10x less
false positives compared to vmpressure signals. Having ability to
specify multiple triggers for the same psi metric allows other parts
of Android framework to monitor memory state of the device and act
accordingly.

The new interface is straight-forward. The user opens one of the
pressure files for writing and writes a trigger description into the
file descriptor that defines the stall state - some or full, and the
maximum stall time over a given window of time. E.g.:

        /* Signal when stall time exceeds 100ms of a 1s window */
        char trigger[] = "full 100000 1000000"
        fd = open("/proc/pressure/memory")
        write(fd, trigger, sizeof(trigger))
        while (poll() >= 0) {
                ...
        };
        close(fd);

When the monitored stall state is entered, psi adapts its aggregation
frequency according to what the configured time window requires in
order to emit event signals in a timely fashion. Once the stalling
subsides, aggregation reverts back to normal.

The trigger is associated with the open file descriptor. To stop
monitoring, the user only needs to close the file descriptor and the
trigger is discarded.

Patches 1-5 prepare the psi code for polling support. Patch 6
implements the adaptive polling logic, the pressure growth detection
optimized for short intervals, and hooks up write() and poll() on the
pressure files.

The patches were developed in collaboration with Johannes Weiner.

The patches are based on 4.20-rc6.

Johannes Weiner (3):
  fs: kernfs: add poll file operation
  kernel: cgroup: add poll file operation
  psi: eliminate lazy clock mode

Suren Baghdasaryan (3):
  psi: introduce state_mask to represent stalled psi states
  psi: rename psi fields in preparation for psi trigger addition
  psi: introduce psi monitor

 Documentation/accounting/psi.txt | 105 ++++++
 fs/kernfs/file.c                 |  31 +-
 include/linux/cgroup-defs.h      |   4 +
 include/linux/kernfs.h           |   6 +
 include/linux/psi.h              |  10 +
 include/linux/psi_types.h        |  90 ++++-
 kernel/cgroup/cgroup.c           | 119 ++++++-
 kernel/sched/psi.c               | 586 +++++++++++++++++++++++++++----
 8 files changed, 865 insertions(+), 86 deletions(-)

-- 
2.20.0.405.gbc1bbc6f85-goog

