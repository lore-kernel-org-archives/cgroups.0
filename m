From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH 0/2] cgroup: pids: fix invalid reference semantics
Date: Sun, 23 Aug 2015 23:10:30 +1000
Message-ID: <1440335432-4202-1-git-send-email-cyphar@cyphar.com>
References: <CAOviyag1ZOgjtNWmnpfMm=fDgkhDn9UGKoJXy6HLWQMGb-tQAg@mail.gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOviyag1ZOgjtNWmnpfMm=fDgkhDn9UGKoJXy6HLWQMGb-tQAg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>

I've discovered a bug in the PIDs cgroup. We aren't properly dealing
with css references (we grab a reference to a css in ->can_attach() and
then drop a reference to a *different* css in ->{cancel_,}attach(). This
is a quick patch I wrote which I believe fixes the problem by getting
cgroup_migrate() to grab a reference before ->can_attach() and once the
attach has failed or succeded.

Aleksa Sarai (2):
  cgroup: get a ref to source csses when migrating
  cgroup: pids: fix invalid get/put usage

 kernel/cgroup.c      | 21 +++++++++++++++++++--
 kernel/cgroup_pids.c | 13 +------------
 2 files changed, 20 insertions(+), 14 deletions(-)

-- 
2.5.0
