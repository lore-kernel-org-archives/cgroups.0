From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup changes for v6.3-rc1
Date: Sun, 19 Feb 2023 13:25:50 -1000
Message-ID: <Y/Kv/v/zdeHfwgcc@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=TVsbXUpnD9I9/F1PvXMGIEd9MiHz9LD4rwNzvGPEVYo=;
        b=RfltPZ9lK1PJDPSiB2nr1+OyTnFqPHeFURn46UrC4hgv+pd4AFDf1epKZEXn3Yk97y
         L8XFxJkekyn6fwf+aBihZHmAHNQ4gSit4MxvGU4tyE5KVOsvdF/9rRu8n5Y9ZVyzlMZ7
         jgvlHr/bLgAfbRRQqFoPYgzLvZCe8hlItXbpg7qVrLA69l0Jth0NeyinmWgil6aMuSQG
         q0k6yYfk+Ul7SqUOoX1vJj9B2lX8p9VPOS/mMzSoxKCBgZQAjVW1QD/FbQ5Fv5PsrKm4
         3dS8PNplovpOiBnj/HyPEWtBG5nQDC1puEjxKz2AXQpcM5r/53Gsj4BStYXOf3OWztjk
         3sGA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

The following changes since commit 512dee0c00ad9e9c7ae9f11fc6743702ea40caff:

  Merge tag 'x86-urgent-2023-01-04' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2023-01-04 12:11:29 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/ tags/cgroup-for-6.3

for you to fetch changes up to 32a47817d07557ffca9992964c514fd79bda6fba:

  cgroup/cpuset: fix a few kernel-doc warnings & coding style (2023-01-10 12:28:17 -1000)

----------------------------------------------------------------
cgroup changes for v6.3-rc1

All the commits are trivial. Doc updates and a trivial code cleanup.

----------------------------------------------------------------
Bagas Sanjaya (9):
      docs: cgroup-v1: replace custom note constructs with appropriate admonition blocks
      docs: cgroup-v1: wrap remaining admonitions in admonition blocks
      docs: cgroup-v1: use code block for locking order schema
      docs: cgroup-v1: fix footnotes
      docs: cgroup-v1: move hierarchy of accounting caption
      docs: cgroup-v1: use bullet lists for list of stat file tables
      docs: cgroup-v1: make swap extension subsections subsections
      docs: cgroup-v1: add internal cross-references
      docs: cgroup-v1: use numbered lists for user interface setup

Daniel Vacek (1):
      cgroup/cpuset: no need to explicitly init a global static variable

Randy Dunlap (1):
      cgroup/cpuset: fix a few kernel-doc warnings & coding style

 Documentation/admin-guide/cgroup-v1/cgroups.rst |   2 +
 Documentation/admin-guide/cgroup-v1/memory.rst  | 284 +++++++++++++-----------
 kernel/cgroup/cpuset.c                          |  15 +-
 3 files changed, 162 insertions(+), 139 deletions(-)

-- 
tejun
