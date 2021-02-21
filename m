From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v5.12-rc1
Date: Sun, 21 Feb 2021 16:12:22 -0500
Message-ID: <YDLMthAFbC6OTeh9@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=LCUI5qaT8pUqYdarYBDd4M2SdOdGcx4WAwh3rcV5wfE=;
        b=K2xYpI7uhz0ocTvxg1i4Gss/Fjo22LSFsmuhD+/1uZccNj0kMo9XZkOgCFXxi2tT4D
         VMOksXOVCCbE6jmKoavxIN7iR0kN5SQkskoEUqmZbP3q3PkiBwMNTgzZw49p7+J9GqNN
         V92osIH3Ok/wPvBSW7gQHFfp0jAdckcgjmECOC2LrjtmSttm0K8LF1+gkcRVduV7Cugj
         2j4i9E77cSUzKiP3jdbJvEVclicSHNgdmzBqp7PpZHyU4fI7HYfOtHW/FZcjZpvAYOBv
         aWe3S9rkHwuGEenkL8pKw1k4sgAjX5X9ZF7RSsuD17YAvM3BVReJ7VnEGabdiiiexE38
         3vYA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

Nothing interesting. Just two minor patches.

Thanks.

The following changes since commit b5e56576e16236de3c035ca86cd3ef16591722fb:

  MAINTAINERS: Update my email address (2021-01-15 15:33:06 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.12

for you to fetch changes up to 415de5fdeb5ac28c2960df85b749700560dcd63c:

  cpuset: fix typos in comments (2021-01-15 15:36:41 -0500)

----------------------------------------------------------------
Aubrey Li (1):
      cpuset: fix typos in comments

Michal Koutn=FD (1):
      cgroup: cgroup.{procs,threads} factor out common parts

 kernel/cgroup/cgroup.c | 55 +++++++++++++---------------------------------=
----
 kernel/cgroup/cpuset.c |  6 +++---
 2 files changed, 17 insertions(+), 44 deletions(-)

--=20
tejun
