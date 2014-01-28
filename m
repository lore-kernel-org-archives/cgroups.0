From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET cgroup/for-3.14-fixes] cgroup: four misc fixes
Date: Tue, 28 Jan 2014 10:32:01 -0500
Message-ID: <1390923125-4369-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=DzRJaTAFHWjNkhHzo4JrAc1U79fEPmAEaEmr5o9WJTg=;
        b=Oo83SIjbthKP5+QWg7I4VuMyCGu8rVpI8Uzn6+EaHKtXIMUzY6gF1FEFz+Avn7Moqp
         hBchxdqqQ8QvRDLVvmFgV6QKdFdzpzT1bRj9xSH5paOYpLNGBL6NegHSnpvqGDLpngp0
         d/IHfVNaN+FO5ORBqxqG6I3+ZPAnMqfJN9pXwV7CcLOUWQYYMQqf4ydI/ir8JH8pr6gw
         52rxn5RqtuTDHS469cGlni9qXwa3Wbph6f14pn0p0Byszsq5N8VvRyPu+HDxNhVmKctJ
         LQy8bVsmQNi9/mYzuOsbBtdV4qdUGRyXrWm/+54WftliTL1Eyu1AFpTDJ780g89YfBRy
         4FeA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

This patchset contains the following four fixes found during
conversion to kernfs.  0001-0003 are marked with -stable.

 0001-cgroup-fix-error-return-value-in-cgroup_mount.patch
 0002-cgroup-fix-error-return-from-cgroup_create.patch
 0003-cgroup-fix-locking-in-cgroup_cfts_commit.patch
 0004-cgroup-move-the-one-off-opts-sanity-check-in-cgroup_.patch

The patches are also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-3.14-fixes

diffstat follows.

 kernel/cgroup.c |   46 ++++++++++++++++++----------------------------
 1 file changed, 18 insertions(+), 28 deletions(-)

Thanks.

--
tejun
