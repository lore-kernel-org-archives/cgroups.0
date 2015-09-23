From: Aleksa Sarai <cyphar@cyphar.com>
Subject: PIDs Controller Limit
Date: Thu, 24 Sep 2015 09:42:38 +1000
Message-ID: <CAOviyajLPivBQLauYHWTW71PHyvF15X=Ocu8JDc-92s0k3XRwA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Does it make sense for the PIDs controller to allow a user to set a
limit of 0? Since we don't cancel attaches, a limit of 0 doesn't
affect anything (nothing stops attaches, and you need to have a
process in the PIDs cgroup in order for fork()s to be affected by the
limit). So I think that attempting to set pid.limit to 0 should return
an -EINVAL.

-- 
Aleksa Sarai (cyphar)
www.cyphar.com
