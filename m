From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [RFC PATCH 0/2] cpuset: Skip possible unwanted CPU-mask updates.
Date: Wed,  2 Nov 2022 11:55:28 +0100
Message-ID: <20221102105530.1795429-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1667386537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=D0FW0b/1WHA3pe2JpXTTJOEUmgWexZzuhgg+GpdrFgY=;
        b=IvdgJTDDUaI9QzBzlBMg4HxV+xJxttyE9N1cZs4v9fLHBENkDECqySXBUV/oV0UgnYo84L
        B0PNw6OSW5j2VrwHd7bZq5kBDVM5r4kHdIq9JXsj2IFGT0yhXgO3a5BdK4e7aZiG2ZIMT2
        5t0iu8WKA1d3ZDUY+Sqius1ce3FLdk/5nbN+XU0hMgFuCTXzTRsyQtl2GQBNqEK4SWzKe9
        au9GYGfzkdzGFzGfPvlV4UDq9MzMebN6riffl2WrK4gScUD1pdo1DOOThRiMRBm9fcGD+y
        eXfwBrU1o3zlq8zorUBimBNy9R3yfXJ0Ckkp1yfF6CxV9ml1w0OerbkQ/QwDuQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1667386537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=D0FW0b/1WHA3pe2JpXTTJOEUmgWexZzuhgg+GpdrFgY=;
        b=SmbCsybukksEX+Jp2ezg0+ebHgoyKCNWaBuFZzrLSroeBHCddWUXdSoFZbTlxnhA7BA0nx
        63YV3182tbO1U5CQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Hi,

while playing with cgroups and tasks which alter their CPU-mask I
noticed a behaviour which is unwanted:
- Upon enabling the cpuset controller, all currently set CPU-mask are
  changed. Here one could argue how bad it is assuming that the
  controller gets only enabled once during boot.

- While having a task limited to only one CPU (or more but a subset of
  the cpuset's mask) then adding an additional CPU (or removing an
  unrelated CPU) from that cpuset results in changing the CPU-mask of
  that task and adding additional CPUs.

The test used to verify the behaviour:

# Limit to CPU 0-1
$ taskset -pc 0-1 $$
# Enable the cpuset controller
$  echo "+cpu" >> /sys/fs/cgroup/cgroup.subtree_control ; echo "+cpuset" >>=
 /sys/fs/cgroup/cgroup.subtree_control

# Query the CPU-mask. Expect to see 0-1 since it is a subset of
# all-online-CPUs
$ taskset -pc $$

# Update the mask to CPUs 1-2
$ taskset -pc 1-2 $$

# Change the CPU-mask of the cgroup to CPUs 1-3.
$ echo 1-3 > /sys/fs/cgroup/user.slice/cpuset.cpus
# Expect to see 1-2 because it is a subset of 1-3
$ taskset -pc $$

# Change the CPU-mask of the cgroup to CPUs 2-3.
$ echo 2-3 > /sys/fs/cgroup/user.slice/cpuset.cpus
# Expect to see 2-3 because CPU 1 is not part of 2-3
$ taskset -pc $$

# Change the CPU-mask of the cgroup to CPUs 2-4.
$ echo 2-4 > /sys/fs/cgroup/user.slice/cpuset.cpus
# Expect to see 2-4 because task's old CPU-mask matches the old mask of
# the cpuset.
$ taskset -pc $$

Posting this as RFC in case I'm missing something obvious or breaking an
unknown (to me) requirement that this series would break.

Sebastian


