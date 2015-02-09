From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v3.20-rc1
Date: Mon, 9 Feb 2015 07:50:31 -0500
Message-ID: <20150209125031.GC3220@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=75rD98g4pxUAJNHHecwxoD+bgV5p88OMbL1lesvuLTQ=;
        b=oMnOCaUju6xT1Bf/6FxiUdh2+y1at6weyNVa9A5msL5Aplpk3TVkJD/hhzDDr4gO2N
         6bNh+D0r0aK0uNtzcWaUtCp4nHFNkPBD1/C+FXx94EGGAUspR69F6NsHgQbTwyTxeusb
         rvfrfglhTjjCESA8/Q3aglErEeBhcnxZvlionYK1dB9723QmAYd2xo/YAaNQMAGXxa95
         dI2n8WtiMVG74/+FIhI/rdw2gI8tiRW0u0DQrp5kqLVYquMTzx8w8jeAKcIdjy8GKocE
         mFnRF3ijBzT0zbEG8TThH78Are6LGw+wA8p2d0FMIj98z6t8HiDvXk/CrwJq7lPEqPxI
         DXmQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello, Linus.

Three mostly trivial patches.  The biggest change is that blkio is now
initialized before memcg which will be needed to make memcg and blkcg
cooperate on writeback IOs.

Thanks.

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.20

for you to fetch changes up to f3ba53802eff25e3eedb60d7afe5262710e20bd5:

  cgroup: add dummy css_put() for !CONFIG_CGROUPS (2015-01-06 12:02:46 -0500)

----------------------------------------------------------------
Henrik Austad (1):
      Update of Documentation/cgroups/00-INDEX

Tejun Heo (2):
      cgroup: reorder SUBSYS(blkio) in cgroup_subsys.h
      cgroup: add dummy css_put() for !CONFIG_CGROUPS

 Documentation/cgroups/00-INDEX | 2 ++
 include/linux/cgroup.h         | 4 ++++
 include/linux/cgroup_subsys.h  | 8 ++++----
 3 files changed, 10 insertions(+), 4 deletions(-)

-- 
tejun
