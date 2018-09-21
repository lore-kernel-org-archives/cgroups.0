From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Cgroup v2 bug: "domain invalid" node can't be converted to "threaded"
Date: Fri, 21 Sep 2018 15:18:23 +0200
Message-ID: <CAKgNAkhHYCMn74TCNiMJ=ccLd7DcmXSbvw3CbZ1YREeG7iJM5g@mail.gmail.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc;
        bh=fSRwvwhOM0DKy71IgTaPgffXf+6iMoKDxt2k6I15FTE=;
        b=AEcfrXbnBy5AUFvarIpUgzacXp5/YWqVxLVHnBaQZaroY7uOKKAVi5dTAVD35ZqQuJ
         9ZQ7b1xtjdiWy6A3f5ec7vqorFfJsFW1xQQYfQtiiUsaZRiE1NrgVez4B3vO+Wzke8Dz
         JUiH8j9e0yfsbxMHrUgy2R9b+QzxtTQYUqC/SyXKjXU1u05RV2fNhkkOu7+KYncb1X6o
         Ww6Zl8IXJdhXI1Ane3EU/xysqamiY3YkkGNsr7XqgzZfXrncerW/q4Ga57TrYixFmZf1
         qGvDSIv2cLTOAYPEazqj3/cqGnqP8694+S2qq4eBSUYCevJOJei5fGG5dwwSx3h3YXEi
         poZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Amin Jamali <ajamali@pivotal.io>, Joao De Almeida Pereira <jpereira@pivotal.io>

Hello Tejun,

While experimenting with cgroups, we've found what looks to be a bug.
I eventually simplified this to what I think are the minimum steps to
demonstrate the issue.

The following shell session demonstrates the issue:

[Kernel was booted with cgroup_no_v1=all]
# cd /sys/fs/cgroup/unified
# cat cgroup.subtree_control    # show that no controllers are enabled

# mkdir -p mycgrp/a/b/c
# echo threaded > mycgrp/a/b/cgroup.type

At this point, the hierarchy looks as follows:

    mycgrp [d]
        a [dt]
            b [t]
                c [inv]

Now let's make node "a" threaded (and thus "mycgrp" s made "domain threaded"):

# echo threaded > mycgrp/a/cgroup.type

By this point, we now have a hierarchy that looks as follows:

    mycgrp [dt]
        a [t]
            b [t]
                c [inv]

But, when we try to convert the node "c" from "domain invalid" to
"threaded", we get ENOTSUP on the write():

# echo threaded > mycgrp/a/b/c/cgroup.type
sh: echo: write error: Operation not supported

Your thoughts?

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
