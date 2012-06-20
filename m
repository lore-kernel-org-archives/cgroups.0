From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH 0/2] Show per-cpu data in cpuacct stats
Date: Wed, 20 Jun 2012 15:38:14 +0400
Message-ID: <1340192296-15939-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

Hi,

Peter, Paul, and others:

Since Peter is currently reworking put_prev_task/pick_next_task, I split
my cpu stats series in two: the part that touches cpuacct is not dependent
on that at all. So please let me know if you are comfortable with merging this.

Is basically the same code as my last submission, which gets rid of the
key:value mapping to expose the information, resorting to the seq_string
interface.

Glauber Costa (2):
  account guest time per-cgroup as well.
  expose fine-grained per-cpu data for cpuacct stats

 kernel/sched/core.c |   47 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 6 deletions(-)

-- 
1.7.10.2
