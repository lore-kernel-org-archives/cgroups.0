From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg: flatten task_struct->memcg_oom
Date: Wed, 25 Nov 2015 16:02:07 +0100
Message-ID: <20151125150207.GM11639@twins.programming.kicks-ass.net>
References: <20150913185940.GA25369@htj.duckdns.org>
 <55FEC685.5010404@oracle.com>
 <20150921200141.GH13263@mtj.duckdns.org>
 <20151125144354.GB17308@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151125144354.GB17308-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Nov 25, 2015 at 03:43:54PM +0100, Peter Zijlstra wrote:
> On Mon, Sep 21, 2015 at 04:01:41PM -0400, Tejun Heo wrote:
> > So, the only way the patch could have caused the above is if someone
> > who isn't the task itself is writing to the bitfields while the task
> > is running.  Looking through the fields, ->sched_reset_on_fork seems a
> > bit suspicious.  __sched_setscheduler() looks like it can modify the
> > bit while the target task is running.  Peter, am I misreading the
> > code?
> 
> Nope, that's quite possible. Looks like we need to break up those
> bitfields a bit. All the scheduler ones should be serialized by
> scheduler locks, but the others are fair game.

Maybe something like so; but my brain is a complete mess today.

---
 include/linux/sched.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f425aac63317..b474e0f05327 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1455,14 +1455,15 @@ struct task_struct {
 	/* Used for emulating ABI behavior of previous Linux versions */
 	unsigned int personality;
 
-	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
-				 * execve */
-	unsigned in_iowait:1;
-
-	/* Revert to default priority/policy when forking */
+	/* scheduler bits, serialized by scheduler locks */
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
 	unsigned sched_migrated:1;
+	unsigned __padding_sched:29;
+
+	/* unserialized, strictly 'current' */
+	unsigned in_execve:1; /* bit to tell LSMs we're in execve */
+	unsigned in_iowait:1;
 #ifdef CONFIG_MEMCG
 	unsigned memcg_may_oom:1;
 #endif
