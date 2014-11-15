From: Hamilton Turner <hamiltont-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Potential documentation error for cpuacct
Date: Sat, 15 Nov 2014 15:14:46 -0500
Message-ID: <CAFow3A9jryRRctZHdp+YHBiMT1Uh0R2xq_of7+7M2cbm59WfpA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=gJAUABaNyY3w4BZF0EvAKkw1s2B8NPe6PC2ItWpmpfc=;
        b=vu8IJJb2nmNkDBDLHmV++xQdbLGqyMM1AbNicth7RyI+rs6y/L8MJaWBwQXfJ470+A
         tfsOo0dR/mSsXQkTKgGH/7Mkp0vuUbr/R6bdTXWVVDX1d5HT8YPxFStJ6Bd1bHBzSEtr
         sXw3Q7AjosqPzd3REJbwRvsRKvxkCK3IvO90nIerCgmaDx/BnSKnG3jfzjEDUAPJgRjA
         aydbvjMCEpv6CRfNXxk4p3lITc+BftW+3eXKgSEg9vlXkPVsjrAt5xzib1QMmztT4Goy
         VKWI58VxEc4gyFMwMyqwERCFWqvM+zYV6K2PScmPNlOAEok9RrkGWlNNjtzfiRO1Omsc
         /xQQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I see a discrepancy between my system and the documentation at
https://www.kernel.org/doc/Documentation/cgroups/cpuacct.txt

Specifically, the references in the following paragraph to
/sys/fs/cgroup appear to be incorrect on my system, and should instead
be references to /sys/fs/cgroup/cpuacct

Doc:

New accounting groups can be created under the parent group /sys/fs/cgroup.

# cd /sys/fs/cgroup
# mkdir g1
# echo $$ > g1/tasks

The above steps create a new group g1 and move the current shell
process (bash) into it. CPU time consumed by this bash and its children
can be obtained from g1/cpuacct.usage and the same is accumulated in
/sys/fs/cgroup/cpuacct.usage also.


Best,
Hamilton
____________________

root@4:/sys/fs/cgroup/cpuacct# uname -a
Linux 4 3.13.0-39-generic #66-Ubuntu SMP Tue Oct 28 13:30:27 UTC 2014
x86_64 x86_64 x86_64 GNU/Linux
root@4:/sys/fs/cgroup/cpuacct# lsb_release -a
LSB Version: core-2.0-amd64:core-2.0-noarch:core-3.0-amd64:core-3.0-noarch:core-3.1-amd64:core-3.1-noarch:core-3.2-amd64:core-3.2-noarch:core-4.0-amd64:core-4.0-noarch:core-4.1-amd64:core-4.1-noarch:security-4.0-amd64:security-4.0-noarch:security-4.1-amd64:security-4.1-noarch
Distributor ID: Ubuntu
Description: Ubuntu 14.04.1 LTS
Release: 14.04
Codename: trusty
