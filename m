From: Daniel Dao <dqminh@cloudflare.com>
Subject: Unexpected EINVAL when enabling cpuset in subtree_control when
 io_uring threads are running
Date: Wed, 8 Mar 2023 11:42:29 +0000
Message-ID: <CA+wXwBQwgxB3_UphSny-yAP5b26meeOu1W4TwYVcD_+5gOhvPw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <io-uring-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1678275761;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EDKdC+6hyofhr4T6hi4EtGoiKJnWevsXeOWcKWN7al0=;
        b=nFRaw4lRKgq21mLnujYmx7aDGXo5bh4wBopYEpo93z1WAKMfKlsOTX5UtBEAlFj4MK
         NCQPbZe2kI80OUzdMDRmaye8z4jLpSLUpNCnK0oY5eq+Y5EKN78F11gcPvMcIPRfUu7y
         pWqD3EErABEaYqSL3mw5BPC3CLoRQYQ72UxW4=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@cloudflare.com>

Hi all,

We encountered EINVAL when enabling cpuset in cgroupv2 when io_uring
worker threads are running. Here are the steps to reproduce the failure
on kernel 6.1.14:

1. Remove cpuset from subtree_control

  > for d in $(find /sys/fs/cgroup/ -maxdepth 1 -type d); do echo
'-cpuset' | sudo tee -a $d/cgroup.subtree_control; done
  > cat /sys/fs/cgroup/cgroup.subtree_control
  cpu io memory pids

2. Run any applications that utilize the uring worker thread pool. I used
   https://github.com/cloudflare/cloudflare-blog/tree/master/2022-02-io_uring-worker-pool

  > cargo run -- -a -w 2 -t 2

3. Enabling cpuset will return EINVAL

  > echo '+cpuset' | sudo tee -a /sys/fs/cgroup/cgroup.subtree_control
  +cpuset
  tee: /sys/fs/cgroup/cgroup.subtree_control: Invalid argument

We traced this down to task_can_attach that will return EINVAL when it
encounters
kthreads with PF_NO_SETAFFINITY, which io_uring worker threads have.

This seems like an unexpected interaction when enabling cpuset for the subtrees
that contain kthreads. We are currently considering a workaround to try to
enable cpuset in root subtree_control before any io_uring applications
can start,
hence failure to enable cpuset is localized to only cgroup with
io_uring kthreads.
But this is cumbersome.

Any suggestions would be very much appreciated.

Thanks,
Daniel.
