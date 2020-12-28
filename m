From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v5.11-rc1
Date: Mon, 28 Dec 2020 12:45:28 -0500
Message-ID: <X+oZuAwO1/GcBeqy@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=VbG+zWmEgZSccqMOdqNiSByvxNCbGh0yLNOk1f1Ikbg=;
        b=CJ5P1bSSL+8ExHCZ5JT4yd04Na/kEdSxzFPpPKJjoxZM1eUJxput5Ox5G37ptu+TEU
         q2LCCopmGNJPTYJZONTtPUeM3NkAlnRnM+sgzpBOdN1tBFh5cWNBACH20yIoLIPVdejv
         52SUA6Y0rGtkfFKWqzFMWyRfXsBtGYfXfIOcrj6W/NsCfAfsI+Qw78rcElhFoewWe5Rr
         /Mi9JOrvAtPFVy3o6y3pbIPwWgcQ92RaSb7gINmTIS9XpOK1K1HfiJ9lF5mGXkHAA32H
         HqNQYSuSK6732j45nCcjOi2AWUVZaADif9sLLnMwz3V3vIlLh3VJ6JbMZFg4FwZoSvGE
         jYwQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

These three patches were scheduled for the merge window but I forgot to send
them out. Sorry about that. None of them are significant and they fit well
in a fix pull request too - two are cosmetic and one fixes a memory leak in
the mount option parsing path.

Thanks and happy holidays!

The following changes since commit 127c501a03d5db8b833e953728d3bcf53c8832a9:

  Merge tag '5.10-rc5-smb3-fixes' of git://git.samba.org/sfrench/cifs-2.6 (2020-11-24 15:33:18 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.11

for you to fetch changes up to 2d18e54dd8662442ef5898c6bdadeaf90b3cebbc:

  cgroup: Fix memory leak when parsing multiple source parameters (2020-12-16 10:10:32 -0500)

----------------------------------------------------------------
Bhaskar Chowdhury (1):
      kernel: cgroup: Mundane spelling fixes throughout the file

Hui Su (1):
      cgroup/cgroup.c: replace 'of->kn->priv' with of_cft()

Qinglang Miao (1):
      cgroup: Fix memory leak when parsing multiple source parameters

 kernel/cgroup/cgroup-v1.c |  2 ++
 kernel/cgroup/cgroup.c    | 30 +++++++++++++++---------------
 2 files changed, 17 insertions(+), 15 deletions(-)

-- 
tejun
