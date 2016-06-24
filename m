From: Aleksa Sarai <asarai@suse.de>
Subject: [PATCH 0/2] cgroup: pids: extend pids.events
Date: Fri, 24 Jun 2016 13:00:47 +1000
Message-ID: <20160624030049.13341-1-asarai@suse.de>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Kenny Yu <kennyyu@fb.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Aleksa Sarai <asarai@suse.de>

While reading the patchset by Kenny Yu, I realised that not having a
field for the "recent" number of failed forks means that userspace would
have trouble accurately deciding whether or not it should increase the
limits.

In addition, by having hits_since, we get to maintain the
on-reset-we-log-failures-again semantics that Tejun said he liked.

Aleksa Sarai (2):
  cgroup: pids: show number of failed forks since limit reset
  docs: cgroup/pids: update documentation to include pids.events

 Documentation/cgroup-v1/pids.txt | 18 ++++++++++++++++++
 kernel/cgroup_pids.c             | 31 ++++++++++++++++++++++---------
 2 files changed, 40 insertions(+), 9 deletions(-)

-- 
2.8.4

