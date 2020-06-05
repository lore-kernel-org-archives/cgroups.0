From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v5.8-rc1
Date: Fri, 5 Jun 2020 16:06:01 -0400
Message-ID: <20200605200601.GJ31548@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=JTkFUvaRvYSG6ygtt1GZV9UfYQcME0QUIQgnCNhspzw=;
        b=LujWpYSX9TMTA4Reh58wuCm3r1H0Yl5Mifzj7Q9qRPX8q4rB2cXcnuI7G9ELPvtpTF
         dgro1uYoKRf1Gnvcc8GSjfxy2GlyibIg60ztwrMN5t0kJZoHlGF2e/zLLeiw/gMii0CL
         f+duJNpaVmhE8t12pBVy/xvYlv0YzP6gNBEiYBum8vpszAqUs361QZdFZtg2MhXVFW6d
         cfkH7Pp/5xbe25VKKgmMnWdy6cvSAlguFc3SpyfEHhGu8y/VAOox9N++Q6unj5HdxT14
         zzy7S+7NUmLZOX0Y0vA6YVvwqTuNS2+cycw/30J2LR+P1xdfjPpDlIq/aHOkfXQqrjGx
         amLA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

Just two patches. One to add system-level cpu.stat to the root cgroup for
convenience and a trivial comment update.

Thanks.

The following changes since commit eec8fd0277e37cf447b88c6be181e81df867bcf1:

  device_cgroup: Cleanup cgroup eBPF device filter code (2020-04-13 14:41:54 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.8

for you to fetch changes up to 936f2a70f2077f64fab1dcb3eca71879e82ecd3f:

  cgroup: add cpu.stat file to root cgroup (2020-05-28 10:06:35 -0400)

----------------------------------------------------------------
Boris Burkov (1):
      cgroup: add cpu.stat file to root cgroup

Zefan Li (1):
      cgroup: Remove stale comments

 Documentation/admin-guide/cgroup-v2.rst |  6 ++--
 kernel/cgroup/cgroup.c                  | 10 +-----
 kernel/cgroup/rstat.c                   | 60 ++++++++++++++++++++++++++++-----
 3 files changed, 55 insertions(+), 21 deletions(-)

-- 
tejun
