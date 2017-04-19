From: =?UTF-8?B?5byg5pys6b6Z?= <zblgeqian-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cgroup writeback support
Date: Wed, 19 Apr 2017 17:58:56 +0800
Message-ID: <CAEC-ZVGrPu6_BZJX3SBbysMnccOHiCXAzskwqZnRhK1=bN7dbg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=z1k+giqvZkpjdr1A0Kly0MUEZLuKpvVtrSC9ZwOMIew=;
        b=eOL1kWP9F23FxNejHfLM75D3DgrsZFCeHsho1AJpeaT1BIc/lBQf+HQeMGv4oC/g8G
         3z62DSu9k+BGRwy316r6y6cwmx8cEG0zXicwYYHQHe4eBJANg6p8fpXJmQnw3aXUbySf
         25WE1s659JIDp7dgeePez61ODF1GXt/SXv5aON9LUDi9ssPuxHw9j1j1AaF4Ng0TdwTo
         mh0v8IPSQZVq+bX316epUocyD3chjP/31PAMorGgoCdhI+CNZl1M3RVFXHe8oOrDfrrk
         L+xMedXtoSIHlUapjTXVCgFE5D4MZ1lnuWQQrgNQOkCQk4tnmRxSjJObZI7tfRmSSxWh
         JSWQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Tejun & cgroup,

I encountered several questions playing with cgroup that I really hope
to get your answers.

I referred to this LWN article for writeback support
https://lwn.net/Articles/628631/ and did following steps:
- clone git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
and checkout branch review-cgroup-writeback-20150106
- compile and boot with option cgroup__DEVEL__legacy_files_on_dfl
- umount all subsys then do mount -t cgroup -o __DEVEL__sane_behavior
cgroup /sys/fs/cgroup/
- found blkio memory already in cgroup.subtree_control as default
- created new group /sys/fs/cgroup/bash, and play with IO throttling
both with iops and wbps, both on my sda ext4 and sdb ext2
Then I found it's not working... I realized the article states only
ext2 was adapted but it's not working either : )

Then I turned to this page
https://kernelnewbies.org/Linux_4.2#head-8f54d7519fca6b2504f5f26290f46081d6cb6927
saying Linux-4.2 has writeback support. I did similar steps as above
except cloning from linux-stable.git, and it's not working either. I
noticed this code is largely different from the
review-cgroup-writeback-20150106 branch based on 3.19.0 (e.g.,
dirty_context).

However Linux-4.3.3 and Linux-4.10.0 really works, except that control
files have changed in 4.3.3 and we can directly use cgroup2 in 4.10.0.

Is it because I did something wrong or missed anything? As I find many
branches exist in kernel/git/tj/cgroup.tj, it would be great if you
could help explain the roles of the different branches and how the
repo works in general. Especially, I want to know the first repo
branch/linux release that has writeback support so it's easier to
learn how it's built up step by step from the commit log.

Thank you very much!
Benlong
