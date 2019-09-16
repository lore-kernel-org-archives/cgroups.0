From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup changes for v5.4-rc1
Date: Mon, 16 Sep 2019 08:29:47 -0700
Message-ID: <20190916152947.GE3084169@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Ey0wD9SSrsgQ+GVE+vYc1coFKJxFcUoh6S5jBW7ZYvo=;
        b=r6Tdi/eeQB83Zu0TvOlrODrPbnDctrTtiVLezpx9OYq6F37NtaWbabg56gHTpdI46+
         4PLIar4hiAHgKcM1xNimBS6Yf83anB4wxsER40seAeriMGLA5vBDLGNJe7X65PPCVdrb
         cB7HaOl0pIOlEs6n0a1rqQUqcTCLkz0TupZDeojcFchmrQBGNXQW3ZnfchDR8SQZNCkV
         v6KMEVgJSEsQcXbHCd0qU9rHkuLW7gplk2XZNoejD2u/hd6FyX5Up46CqdLeJncyY7w2
         /RlNtrVqCHgO76Ma36XAB7w9caRNBZ9weXUnuxu9VsijfM2p9OACH2Ri4kYuglIb7mwp
         eXjw==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

Hello, Linus.

Three minor cleanup patches.

Thanks.

The following changes since commit ad5e427e0f6b702e52c11d1f7b2b7be3bac7de82:

  Merge branch 'parisc-5.3-3' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux (2019-07-23 15:34:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.4

for you to fetch changes up to 653a23ca7e1e1ae907654e91d028bc6dfc7fce0c:

  Use kvmalloc in cgroups-v1 (2019-08-07 11:37:58 -0700)

----------------------------------------------------------------
Marc Koderer (1):
      Use kvmalloc in cgroups-v1

Markus Elfring (1):
      cgroup: Replace a seq_printf() call by seq_puts() in cgroup_print_ss_mask()

Peng Wang (1):
      cgroup: minor tweak for logic to get cgroup css

 kernel/cgroup/cgroup-v1.c | 27 ++++-----------------------
 kernel/cgroup/cgroup.c    |  4 ++--
 2 files changed, 6 insertions(+), 25 deletions(-)

-- 
tejun
