From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Cgroups v2 bug: incorrect reporting in "domain threaded" cgroup.procs
 file
Date: Wed, 7 Nov 2018 20:46:30 +0100
Message-ID: <fdb057a2-342a-d49e-587a-f1ca8680033e@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=WX4o1b9CfavJF7tL72poCIr5V1AP6JICSuMh15MN7FA=;
        b=toGPkD/u9gsg5XYh+1AjF+hDC5yB4AYYOI/hIgwSp6LaV5gIj6TAGcxovhEq6l2Vmt
         AdwEWMmSICVS5svbYv7QvgMEnFI+cO9TYWG95OQHsQ1N7Nd9tEHeUmqXPWCuXi8LpTrR
         6GQuGbyAQmIjT7VLOCaRfYOCoxUmFqKSJK94nhuIQX8NaEOyZH4ay7fObNflqi8WXji9
         ouWTFoNKzd3vlUXR+bw744TeG3eN2IaOw+h+uW09I7B915DQ/DlhrvFO5t8pQDJPxCzl
         QbrLsZwK44f7KcR+/kpJqhLi4J4Ifc4tsDM9zNw1G8d6+fq3UX4/GvKgXcM231t2WFUs
         Nctw==
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: mtk.manpages@gmail.com, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>

Hello Tejun,

I've discovered what looks to be a bug in the reporting
of PIDs in the cgroup.procs file in the "domain threaded"
node at the root of a threaded subtree. The following
demo is on vanilla kernel 4.19.

Suppose we have the following multithreaded process:

$ ps -L 654
  PID   LWP TTY      STAT   TIME COMMAND
  654   654 pts/12   Tl     0:00 ./cpu_multithread_burner 100
  654   655 pts/12   Tl     0:01 ./cpu_multithread_burner 100

Now suppose we create a threaded subtree in the v2 hierarchy:

# cd /sys/fs/cgroup/unified/
# mkdir -p x/a/b
# echo 'threaded' > x/a/cgroup.type
# echo 'threaded' > x/a/b/cgroup.type

Then we move the multithreaded process into x/a in 
the threaded subtree:

# echo 654 > x/a/cgroup.procs 

Now we visualize the set-up using my visualization
program[1]:

# go run ~mtk/lsp/cgroups/view_v2_cgroups.go x
x [dt]
    PIDs: {654}
    a [t]
        TIDs: {654 655-[654]}
        b [t]

The above is as I expect.

Now, we move the thread group leader (it has to be the 
thread group leader to show the bug) to a x/a/b, and again
use my visualization program:

# echo 654 > x/a/b/cgroup.threads 
# go run ~mtk/lsp/cgroups/view_v2_cgroups.go x
x [dt]
    PIDs: {654 655}
    a [t]
        TIDs: {655-[654]}
        b [t]
            TIDs: {654}

Note how the *thread ID* of the non-thread-group-leader
(655) is being reported in the x/cgroup.procs!

And just to verify that this is not a bug in my 
visualization program:

# cat x/cgroup.procs 
655
654

Your thoughts?

Thanks,

Michael

[1] https://www.spinics.net/lists/cgroups/msg20710.html

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
