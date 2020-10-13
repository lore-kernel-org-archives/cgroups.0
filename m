From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup changes for v5.10-rc1
Date: Tue, 13 Oct 2020 10:07:03 -0400
Message-ID: <20201013140703.GA3845@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=zlJunIPW8Wajc0MiN91i37/1o2rvLQm/+3y/Aoom9SU=;
        b=nsZug78+5p7pGKmm3DsDTOBfTQHjEv5AvUhIvb5ixEWe/iSqrf6Z/zZyayKI+2iRPK
         MVbDBepFDBAfZ+kDIDXs6LK/CkLLlbfCZDSX6IM6CZFBfDhiodhl3Z4t4yxLo8A9Hph+
         g+5rw80BsqfDOzW+U7wZmFf4Nmt2BWUktKEB3i1KpzXeLmuIQl/C5FKk0U8hMtwRqvIG
         UuLcG4GpzbkDTL8oXHK7Rpv1nEj4RuAmOJ/m6iLK6zLGUb66NgsZeTi60cv6ZrRWSPiq
         pY5j1LdT9TQhVMD8iOzG3VA+S3JpRe29B3PBLx+UR4TpFULac0bkFMMs6W3JvOkz7Uoh
         LCQA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: torvalds@linux-foundation.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello, Linus.

Two minor changes. One makes cgroup interface files ignore 0 sized writes
rather than triggering -EINVAL on them. The other change is a cleanup which
doesn't cause any behavior changes.

Thanks.

The following changes since commit 02de58b24d2e1b2cf947d57205bd2221d897193c:

  Merge tag 'devicetree-fixes-for-5.9-3' of git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux (2020-09-29 17:56:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.10

for you to fetch changes up to 65026da59cda16baf6c3e98b74ec439f366e468f:

  cgroup: Zero sized write should be no-op (2020-09-30 13:52:06 -0400)

----------------------------------------------------------------
Jouni Roivas (1):
      cgroup: Zero sized write should be no-op

Wei Yang (1):
      cgroup: remove redundant kernfs_activate in cgroup_setup_root()

 kernel/cgroup/cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
tejun
