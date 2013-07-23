From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroups and SCHED_IDLE
Date: Tue, 23 Jul 2013 11:56:34 -0400
Message-ID: <20130723155634.GD18458@mtj.dyndns.org>
References: <51CC7392.8080701@keymile.com>
 <51D139B4.8070407@keymile.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=OuQ8iG6vB5n9iOR9CVdNHl+0azswYjj9/7UNuLaLOV4=;
        b=blpD5zxV9z4TbLL/H/mE/xVnZY1+aWyc17lcIN+PITnaZCGwAVn/5BsRci69PLea30
         noNWWwHTuVwo/wQKiXSfzujyxy1DYcjCiaxV84IOMNl9NptCUW+Ds2LTNpdM5HRrsA0E
         IB6o+emE1aT20Am4i4Ri4WnC+YvCgEMuut5VYGwVKIRrA1JGk74blQEkm5W191bLEFOL
         x7+HVo0SBj17ZMZoGVk+o8SO9nnoKXXb7tMYSR3zQQr7tnoLGpuKwCnAUtGgicHsc4ra
         8ft1SlgZFMdmFhnyrBzdDgr8mn9XGbaSKXtJom8gH8UiiLn1qt6C73pFJTaSHvhdQK+Q
         g56w==
Content-Disposition: inline
In-Reply-To: <51D139B4.8070407-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 51CC7392.8080701-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Germs, Frits (extern)" <Frits.Germs-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

(cc'ing Ingo and Peter)

Hello, sorry about the delay.  Was traveling.

Ingo, Peter, it looks like when there are two SCHED_IDLE tasks in a
!root cpu cgroup, one of them is starved in certain configurations.
The original message is at

  http://thread.gmane.org/gmane.linux.kernel.cgroups/8203

Any ideas?

On Mon, Jul 01, 2013 at 10:11:32AM +0200, Holger Brunck wrote:
> Hi,
> small update on this.
> 
> On 06/27/2013 07:17 PM, Holger Brunck wrote:
> > I entered a problem when using cgroups on a powerpc board, but I think it's a
> > general problem or question.
> > 
> > Whats the status of tasks which are running with SCHED_IDLE and cgroups? The
> > kernel configuration for CGROUPS distinguishes between SCHED_OTHER and
> > SCHED_RT/FIFO. SCHED_IDLE isn't mentioned at all. If I create two threads which
> > are creating load on the cpu with SCHED_IDLE I see that they are sharing the CPU
> > load. If I move one of this tasks to a cgroup I saw that afterwards this task
> > eats up (more or less) all of the CPU load and the other one is starving, even
> > if both are still SCHED_IDLE.
> > 
> > It's easy to reproduce with this script (at least on my single 32 bit ppc cpu),
> > which set up a cgroup sets the current shell to SCHED_IDLE, create a task move
> > this one to the cgroup and start the second one:
> > 
> > mount -t tmpfs cgroup_root /sys/fs/cgroup
> > mkdir /sys/fs/cgroup/cpu
> > mount -t cgroup -ocpu none /sys/fs/cgroup/cpu
> > cd /sys/fs/cgroup/cpu
> > mkdir browser
> > echo $$ | xargs chrt -i -p 0
> > dd if=/dev/zero of=/dev/null &
> > pgrep ^dd$ > browser/tasks
> > dd if=/dev/zero of=/dev/null &
> > 
> > If you start top you will see that the first dd process eats up the CPU time.
> > 
> > If you skip moving the task you would see that both tasks consumes the same load.
> > 
> 
> On a single ARM CPU (kirkwood) I see the same confusing results similar to the
> results of the above powerpc example:
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>   232 root      20   0  1924  492  420 R 99.9  0.4   0:29.15 dd
>   234 root      20   0  1924  492  420 R  0.3  0.4   0:00.13 dd
> 
> I doublechecked this on my local host x86_64 multicore and here it works fine
> even if I force both dd processes to run on the same CPU:
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> 32046 root      20   0  102m  516  432 R 49.4  0.0   0:32.49 dd
> 32049 root      20   0  102m  516  432 R 49.4  0.0   0:13.39 dd
> 
> So either it's a problem for single CPUs or it's not allowed at all and works
> only by chance.

Can you please boot with maxcpus=1 and see whether that makes the
issue reproducible on x86?

Thanks.

-- 
tejun
