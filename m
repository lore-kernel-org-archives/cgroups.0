From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET for-4.14] cgroup, sched: cgroup2 interface for CPU controller (on basic acct)
Date: Fri, 11 Aug 2017 09:47:25 -0700
Message-ID: <20170811164727.3980027-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=CXh5lw0VCbALSX3J2K5PgjfP/06srBXqisPF7DeQpaU=;
        b=JfyAiYo01osfILeSdf4SwNeSgzhw+MFe9MUyRj7aGywa8s39qOFNxoGCzM8zFqghn4
         T84CISeHCkgnXYXuPgUu66Iff1cXlAiVjbkZfqqsRFNlpCpgj4xY5E+e//IBNG4p1CFm
         XMJBJA9J9Jd8fdtcmrWi6+OCipi5uytIyxokQkETuX2V04mYGBXhZa0dvMNO/2Ki4h1u
         cVkXmfQ5dXutqV9u1i+fg03x5G3yJcNKenwEfbvEZdZj0ZlDpgbHFf6xVbra6LScGN53
         ysgL+S5SC9beSDt8lbQ0cIjGg2/aRedbUJuur66idpfoXowoN+DR8tsqKPkGQeXc6mRx
         khkg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

Hello,

These are two patches to implement the cgroup2 CPU controller
interface.  Changes from the last revision[L].

* Updated on top of the cgroup2 basic resource accounting patchset[B]
  and now uses cgroup2's CPU accounting instead of cpuacct as stat
  source.

* cpuacct is no longer necessary and not converted.

This patchset contains the following two patches.

 0001-sched-Misc-preps-for-cgroup-unified-hierarchy-interf.patch
 0002-sched-Implement-interface-for-cgroup-unified-hierarc.patch

It's on top of the cgroup2 basic resource accounting patchset and
available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-cpu-on-basic-acct

diffstat follows.  Thanks.

 Documentation/cgroup-v2.txt |   36 ++------
 kernel/sched/core.c         |  179 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 187 insertions(+), 28 deletions(-)

--
tejun

[L] http://lkml.kernel.org/r/20170720184808.1433868-1-tj@kernel.org
[B] http://lkml.kernel.org/r/20170811163754.3939102-1-tj@kernel.org
