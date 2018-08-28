From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 8/9] psi: pressure stall information for CPU, memory, and
 IO
Date: Tue, 28 Aug 2018 16:56:25 -0400
Message-ID: <20180828205625.GA14030@cmpxchg.org>
References: <20180828172258.3185-1-hannes@cmpxchg.org>
 <20180828172258.3185-9-hannes@cmpxchg.org>
 <6ff71c29-3b6a-4849-6f2a-3d829bbd43e2@infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Qe4URwpF2ELDwboL1mzyrFlyVo74zo76mUZy91AnNQM=;
        b=btS19MrMqzoJxXouoy8fD9Wo2MIC15tki4oHYx1m/8Xw4qsaLPGu5ry8MdYgmtz4pd
         dgR5x46uYjmE7yg2ATQqtuH4JNS+bT42xw4sGAY3sFjqMMjt1MsXEOrSjXf317B4ZwUl
         feTH8WAR7vduDXJ3dUopA1QDPlOX6byxtgFV1tHScuJFsN33d3PHuDtxjVvC044H61L6
         k+8FXx4zw+MmpIXCoxzqhTcZasHwqzxqQ63SyOrb0FONuvbhgJSsbq/Luz5x65Iz+AAp
         erRChajIfrdz12xAXRVrAAUKpMB4tKmZ1veH3X4Lz85Jnocik5ctlu3hXEzH7gucwUHC
         KqRg==
Content-Disposition: inline
In-Reply-To: <6ff71c29-3b6a-4849-6f2a-3d829bbd43e2@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Peter Enderborg <peter.enderborg@sony.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Aug 28, 2018 at 01:11:11PM -0700, Randy Dunlap wrote:
> On 08/28/2018 10:22 AM, Johannes Weiner wrote:
> > diff --git a/Documentation/accounting/psi.txt b/Documentation/accounting/psi.txt
> > new file mode 100644
> > index 000000000000..51e7ef14142e
> > --- /dev/null
> > +++ b/Documentation/accounting/psi.txt
> > @@ -0,0 +1,64 @@
> > +================================
> > +PSI - Pressure Stall Information
> > +================================
> > +
> > +:Date: April, 2018
> > +:Author: Johannes Weiner <hannes@cmpxchg.org>
> > +
> > +When CPU, memory or IO devices are contended, workloads experience
> > +latency spikes, throughput losses, and run the risk of OOM kills.
> > +
> > +Without an accurate measure of such contention, users are forced to
> > +either play it safe and under-utilize their hardware resources, or
> > +roll the dice and frequently suffer the disruptions resulting from
> > +excessive overcommit.
> > +
> > +The psi feature identifies and quantifies the disruptions caused by
> > +such resource crunches and the time impact it has on complex workloads
> > +or even entire systems.
> > +
> > +Having an accurate measure of productivity losses caused by resource
> > +scarcity aids users in sizing workloads to hardware--or provisioning
> > +hardware according to workload demand.
> > +
> > +As psi aggregates this information in realtime, systems can be managed
> > +dynamically using techniques such as load shedding, migrating jobs to
> > +other systems or data centers, or strategically pausing or killing low
> > +priority or restartable batch jobs.
> > +
> > +This allows maximizing hardware utilization without sacrificing
> > +workload health or risking major disruptions such as OOM kills.
> > +
> > +Pressure interface
> > +==================
> > +
> > +Pressure information for each resource is exported through the
> > +respective file in /proc/pressure/ -- cpu, memory, and io.
> > +
> 
> Hi,
> 
> > +In both cases, the format for CPU is as such:
> 
> I don't see what "In both cases" refers to here.  It seems that you could
> just remove it.

You're right, that must be a left-over from when I described CPU
separately; "both cases" referred to memory and IO which have
identical formats. It needs to be removed:

diff --git a/Documentation/accounting/psi.txt b/Documentation/accounting/psi.txt
index e051810d5127..b8ca28b60215 100644
--- a/Documentation/accounting/psi.txt
+++ b/Documentation/accounting/psi.txt
@@ -35,7 +35,7 @@ Pressure interface
 Pressure information for each resource is exported through the
 respective file in /proc/pressure/ -- cpu, memory, and io.
 
-In both cases, the format for CPU is as such:
+The format for CPU is as such:
 
 some avg10=0.00 avg60=0.00 avg300=0.00 total=0
 
