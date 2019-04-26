From: Roman Gushchin <guro@fb.com>
Subject: [PATCH 0/2] cgroup v2 freezer follow-up patches
Date: Fri, 26 Apr 2019 10:59:43 -0700
Message-ID: <20190426175945.2559865-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=I69yex02ZDfSNGZEwjXGsGyUJRCnW8gVyFqR8Q8tfUU=;
 b=DXYVVDnaj6nQj536siLMon43I6/AKsE16SGOuP0BGyR65THbS6q1r7k5p0U6a8URfBu5
 jNCoslGyZxHWSUbNZFc0bLRuZhzSm8XZQi8uvNRVa6ES4baplpiDiXn5tEeUyUOo575e
 nWhFCU+UHBJwg/C7okCo3HGcJzJBvvuMHTo= 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

Hi, Tejun!

Please, pull these two follow-up patches for the cgroup v2 freezer.

These are a fix for a spurious state transition, which could happen
due to a race condition, and a cleanup of some dead code. Both patches
were suggested by Oleg Nesterov.

Thank you!


Roman Gushchin (2):
  cgroup: prevent spurious transition into non-frozen state
  cgroup: get rid of cgroup_freezer_frozen_exit()

 include/linux/cgroup.h  |  2 +-
 kernel/cgroup/cgroup.c  |  5 ++---
 kernel/cgroup/freezer.c | 26 +++++---------------------
 kernel/signal.c         |  2 +-
 4 files changed, 9 insertions(+), 26 deletions(-)

-- 
2.20.1

