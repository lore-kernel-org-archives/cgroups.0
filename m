From: Noah McNallie <njm-nmK/KmDn8IU@public.gmane.org>
Subject: Pam module seems to have an issue
Date: Wed, 6 Jul 2016 17:22:41 -0400
Message-ID: <e8aac729-3dda-d1b8-80e7-abe268813844@tptp.cc>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tptp-cc.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=VXEpbPGRSViT03EG3zctBf7bPmgRx1PJnk+mB7DlxzU=;
        b=q/vn/Qcw72S+NOyx8lDrC3W58wgSKh8/L+Lvlbi1D5zwISgEGoK3saRFeKH9CPvVam
         xmGM8uBY5mQiu7P3glfwtfy+Wf+Y7tuMOGypFEc4/ewEzZ0eGIL5dozQcRTNCcwKVodH
         kGvRo2GFSH/2uHEcQzdjzP3YdFltPjgqLm3O42v48G2zdpijn8PYrw7iTm39/9WMV+mr
         8p5c5BqZ3Slu5rKTOU9Zys/bTIZVO2rk6k9twq1pCyJmWrjBqjoDA5mwI7dlPuPa7jqP
         FSJxH1MIVfaH3xumx8U9ZLzEfat4Eyr8hAl78XYPPR3Tq3v0SV5IGuVM3WwArcfwf46S
         uBCQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi, I'm trying to use cgroups for cron and su and ssh login so I added 
the following in 'system-auth' which they all include gentoo:

session         required        pam_cgroup.so debug

My cgconfig.conf looks as follows:

#
#  Copyright IBM Corporation. 2007
#
#  Authors:     Balbir Singh <balbir-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
#  This program is free software; you can redistribute it and/or modify it
#  under the terms of version 2.1 of the GNU Lesser General Public License
#  as published by the Free Software Foundation.
#
#  This program is distributed in the hope that it would be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
mount {
     cpuset  = /sys/fs/cgroup/cpuset;
     cpu     = /sys/fs/cgroup/cpu;
     cpuacct = /sys/fs/cgroup/cpuacct;
     memory  = /sys/fs/cgroup/memory;
}

group users/alex {
          perm {
          task {
              uid = alex;
              gid = alex;
           } admin {
              uid = root;
              gid = root;
           }
         }
         cpu {
                 cpu.shares = 100;
         }
         memory {
                 memory.limit_in_bytes = 134217728;
         }
}

-- END --

And my cgrules.conf looks like this:

# /etc/cgrules.conf
#The format of this file is described in cgrules.conf(5)
#manual page.
#
# Example:
#<user>         <controllers>   <destination>
#@student       cpu,memory      usergroup/student/
#peter          cpu             test1/
#%              memory          test2/
# End of file
alex            cpu,memory      users/alex

-- END --

Now when I su to user alex I see this in /var/log/messages:

Jul  6 17:18:03 atlantic su[5583]: pam_cgroup(su:session): Changed 
cgroup for process 5583  with username alex.

-- END --

Except that pid is not in users/alex/tasks its in some task files 
related to openrc and it looks like the function 
cgroup_change_cgroup_uid_gid_flags is not doing a proper change:

[alex-q63CSc06zXvrDilwLfPoKQ@public.gmane.org][/sys/fs/cgroup]# ls
blkio  cpu  cpuacct  cpuset  memory  net_cls  openrc
[alex-q63CSc06zXvrDilwLfPoKQ@public.gmane.org][/sys/fs/cgroup]# find ./ -name tasks | xargs grep 5583
./net_cls/tasks:5583
./memory/tasks:5583
./blkio/tasks:5583
./cpuacct/tasks:5583
./cpu/openrc_sshd/tasks:5583
./cpuset/tasks:5583
./openrc/sshd/tasks:5583
[alex-q63CSc06zXvrDilwLfPoKQ@public.gmane.org][/sys/fs/cgroup]# cat memory/users/alex/tasks
[alex-q63CSc06zXvrDilwLfPoKQ@public.gmane.org][/sys/fs/cgroup]#

-- END --

Why is it not in users/alex what am I doing wrong?

Noah J. McNallie
