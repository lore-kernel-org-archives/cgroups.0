From: Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH v6 0/7] psi: pressure stall monitors v6
Date: Tue, 19 Mar 2019 16:56:12 -0700
Message-ID: <20190319235619.260832-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kx1U4HzcGCDUD7FXkKAwi3uQa2G8CItUW21Wgf4ughs=;
        b=TWam6T+qQmrNZ7BniGuFoFdA0Bom65bX9YYOcvGrtw+jSpwzeqDyGdcmm0fjhAgkD+
         5BAR3ZlcHWxbchcmC0Or5zypwA+ur2abK3ZEa+RtFtFWaCHmQ8xiRDw/CrQEBu4wZnuc
         FGpXzWPyLYYxrKlUTQZnEK7A3OfpkBwWp/U5QEB1flxIyHjq0ZcxXy5EOZj6P4NwAPMv
         hw5VrtC2hptHTLyyO/3W0bZpBIko9kaDlaIeHMT+4URsSZRzhdtzsf1dwIULDqHiVqLZ
         4Ypbj7cH7GT7qOb/s+OZUS/VWIhK1IGe/EXblQTIkr1zZKwZHpKUPpEvs+D/fV8Cqzdd
         ucmw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org
Cc: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, peterz@infradead.org, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com, Suren Baghdasaryan <surenb@google.com>

This is respin of:
  https://lwn.net/ml/linux-kernel/20190308184311.144521-1-surenb%40google.com/

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

Patches 1-6 prepare the psi code for polling support. Patch 7 implements
the adaptive polling logic, the pressure growth detection optimized for
short intervals, and hooks up write() and poll() on the pressure files.

The patches were developed in collaboration with Johannes Weiner.

The patches are based on 5.1-rc1

Suren Baghdasaryan (7):
  psi: introduce state_mask to represent stalled psi states
  psi: make psi_enable static
  psi: rename psi fields in preparation for psi trigger addition
  psi: split update_stats into parts
  psi: track changed states
  refactor header includes to allow kthread.h inclusion in psi_types.h
  psi: introduce psi monitor

 Documentation/accounting/psi.txt | 107 ++++++
 drivers/spi/spi-rockchip.c       |   1 +
 include/linux/kthread.h          |   3 +-
 include/linux/psi.h              |   8 +
 include/linux/psi_types.h        | 105 +++++-
 include/linux/sched.h            |   1 -
 kernel/cgroup/cgroup.c           |  71 +++-
 kernel/kthread.c                 |   1 +
 kernel/sched/psi.c               | 615 ++++++++++++++++++++++++++++---
 9 files changed, 836 insertions(+), 76 deletions(-)

Changes in v6:
- Fixed psi averaging regression introduced in 4/7 and caused by lack of
checking for avg_next_update before calling update_averages in psi_show
- Fixed missing header include in spi-rockchip.c causing kbuild test bot's
warning in 6/7

-- 
2.21.0.225.g810b269d1ac-goog

