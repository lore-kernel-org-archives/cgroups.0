From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v4.7-rc5
Date: Wed, 29 Jun 2016 09:29:49 -0400
Message-ID: <20160629132949.GD24054@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=mTCQRT6bSuyyJtkvAtII4+Lt0QVWJttkWA0kcnF+gIY=;
        b=d4mEeVWHSp6+EWlGPi0eURj3tSK9tdi6Y0cALEL5LFZzjIHWG2V3n9qcoLUPXb0+NP
         gYMydQbhtAt0D0qp0lbtc2OEyN+JRomC71WAtvyKWc8z8kgEEpYqV6nCMQDuEtnzw/CM
         iPB034Pewe0Wx/59rpcOO4P4qzlI5U3nccOMnSVP9hIT2aat4JtnB2XeTcNnrttkhxFL
         MsNHJzEu0G7gNTItxuJ0kw7tfLvzWewDisyRFKX8FMDC5X2UyK78zYUUc+I/W23zLuGl
         ctn5J/rveB/jeekvsyyJNuTOfAVTDhgWtPmgMMD3hKiTq3asx8EpYHjNSqAbCrl9uUhb
         BACg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

Three fix patches.  Two are for cgroup / css init failure path.  The
last one makes css_set_lock irq-safe as the deadline scheduler ends up
calling put_css_set() from irq context.

Thanks.

The following changes since commit ea8ea737c46cffa5d0ee74309f81e55a7e5e9c2a:

  Merge tag 'nfs-for-4.7-1' of git://git.linux-nfs.org/projects/anna/linux-nfs (2016-05-26 10:33:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.7-fixes

for you to fetch changes up to 82d6489d0fed2ec8a8c48c19e8d8a04ac8e5bb26:

  cgroup: Disable IRQs while holding css_set_lock (2016-06-23 17:23:12 -0400)

----------------------------------------------------------------
Daniel Bristot de Oliveira (1):
      cgroup: Disable IRQs while holding css_set_lock

Tejun Heo (1):
      cgroup: set css->id to -1 during init

Wenwei Tao (1):
      cgroup: remove redundant cleanup in css_create

 kernel/cgroup.c | 148 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 76 insertions(+), 72 deletions(-)

-- 
tejun
