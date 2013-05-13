From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V2 0/3] memcg: simply lock of page stat accounting
Date: Mon, 13 May 2013 13:03:30 +0800
Message-ID: <1368421410-4795-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer;
        bh=Cg6ZjW+pQEEc4NAm4XUpkHKsdFw48xNRmqNzC8mpbPg=;
        b=si/wSzmrC62oPRP8h3h5AmV9wxXmzmU568LapCIhhTAHvHAhD68lrSiTDFSZpw6USA
         mPz2Q1gZT5thFzKq3f1IRl91+LJGslbS9FCl+RQc+1/ENEUBEn+qxrhjDlM6CspTV/Fw
         P7ZZ7EOTF2psNLZv5bLbhv8XWcCsXEEQLYDnj6o/tGNjS/BaNYwo31XHECE6Ti60AxYk
         eYyptFbidU5/NFKfWBJNucE7zGDh5Y2yVR9c+irGPu4Lw1qJeFXbwrt4mcUOhozjP29B
         friOAE7hK0LgkaM8S1/dJilQekEy+DmwhYMk/dmjwt9iTg5XxnSUVXI3N4DAm51tAn9R
         OGhQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Hi,

This is my second attempt to make memcg page stat lock simpler, the
first version: http://www.spinics.net/lists/linux-mm/msg50037.html.

In this version I investigate the potential race conditions among
page stat, move_account, charge, uncharge and try to prove it race
safe of my proposing lock scheme. The first patch is the basis of
the patchset, so if I've made some stupid mistake please do not
hesitate to point it out.

Change log:
v2 <- v1:
   * rewrite comments on race condition
   * split orignal large patch to two parts
   * change too heavy try_get_mem_cgroup_from_page() to rcu_read_lock
     to hold memcg alive

Sha Zhengju (3):
   memcg: rewrite the comment about race condition of page stat accounting
   memcg: alter mem_cgroup_{update,inc,dec}_page_stat() args to memcg pointer
   memcg: simplify lock of memcg page stat account	

 include/linux/memcontrol.h |   14 ++++++-------
 mm/memcontrol.c            |   16 ++++++---------
 mm/rmap.c                  |   49 +++++++++++++++++++++++++++++++++-----------
 3 files changed, 50 insertions(+), 29 deletions(-)
