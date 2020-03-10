From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v5.6-rc5
Date: Tue, 10 Mar 2020 10:41:07 -0400
Message-ID: <20200310144107.GC79873@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=zPdEJtfsWlHG8dbwVXY1UpzdzNB128A7aRa0k6lQHIw=;
        b=sA6mq68sWeiOnv4cAOeCHl2yqaec100bLnaugDj+ojD5TqX1jGIVOlurFThAETQ2w6
         Art7sk0xX3cW9CyolyGK/VJ6temfhI9jJ3i/BskQ1Tq6M9rSRRiSCrCD8uqMWFPH4C84
         FbAuFKHRgJP12WOg99EuW8gKe7HZ9lCdC92x52GlyoB6lGL6lViNPOtWyPBYqfTZ8WxQ
         aY18b7C1UB/5CjhjNRY+TnFENEgIFYxlkISxDwTZcBuvghmqZDZDwyOKpHCY34M57qqR
         tVJESZ/bP2mNEoc2b/o+LU9EQi+kRrFPaWHHnWH0bNd4fssZSm3hCW/iUklOO/HHMPCf
         Os2Q==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

* cgroup.procs listing related fixes. It didn't interlock properly
  with exiting tasks leaving a short window where a cgroup has empty
  cgroup.procs but still can't be removed and misbehaved on short
  reads.

* psi_show() crash fix on 32bit ino archs.

* Empty release_agent handling fix.

Thanks.

The following changes since commit 0bf999f9c5e74c7ecf9dafb527146601e5c848b9:

  linux/pipe_fs_i.h: fix kernel-doc warnings after @wait was split (2020-02=
-12 11:54:08 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.6-fixes

for you to fetch changes up to 2e5383d7904e60529136727e49629a82058a5607:

  cgroup1: don't call release_agent when it is "" (2020-03-04 11:53:33 -050=
0)

----------------------------------------------------------------
Michal Koutn=FD (1):
      cgroup: Iterate tasks that did not finish do_exit()

Qian Cai (1):
      cgroup: fix psi_show() crash on 32bit ino archs

Tycho Andersen (1):
      cgroup1: don't call release_agent when it is ""

Vasily Averin (2):
      cgroup-v1: cgroup_pidlist_next should update position index
      cgroup: cgroup_procs_next should increase position index

 include/linux/cgroup.h    |  1 +
 kernel/cgroup/cgroup-v1.c |  3 ++-
 kernel/cgroup/cgroup.c    | 39 ++++++++++++++++++++++++++-------------
 3 files changed, 29 insertions(+), 14 deletions(-)

--=20
tejun
