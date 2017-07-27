From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET for-4.14] cgroup, sched: cgroup2 interface for CPU
 controller
Date: Thu, 27 Jul 2017 15:51:36 -0400
Message-ID: <20170727195136.GK742618@devbig577.frc2.facebook.com>
References: <20170720184808.1433868-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=m0ksy1DpaNigYZpNobphDo4xHxu4hivlLF1zLVdhxyQ=;
        b=VPhNsPX7kAyugPtIBFdUUSmsQqEYDYFMN7QnP4Of0KdkXKb6skomR2OimBycBuOyI5
         GKdoLYaRjsTpxH4IV/PJxacpkaTerrHHBauoGYqAC7TUAIlqKl3Lx2mhiiZWJiyUgWk+
         TCBEW2kRx1Q1Hqz8x0JOTdoS2MS6WWu5c6u6lp37TxdESsARIAJLrIRgn2CqSAjlF/jK
         uhee+Gn0fHKf/AHdf7+Smnc3ZtHKX+513opvAlDtd4Md4VZDWA/JhU43mX/9g30esq5l
         NxXccQ1Oz0exTHRL4QcpxFecHuLcL89ddk8IVcqQlqjFAVb5VvXwfLpq3zSRDU/25UJ5
         dO+g==
Content-Disposition: inline
In-Reply-To: <20170720184808.1433868-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello,

On Thu, Jul 20, 2017 at 02:48:06PM -0400, Tejun Heo wrote:
> These are two patches to implement the cgroup2 CPU controller
> interface.  It's separated from the [L] previous version of combined
> cgroup2 threaded mode + CPU controller patchset.
> 
> * "cpu.weight.nice" added which allows reading and setting weights
>   using nice values so that it's easier to configure when threaded
>   cgroups are competing against threads.
> 
> * Doc and other misc updates.
> 
>  0001-sched-Misc-preps-for-cgroup-unified-hierarchy-interf.patch
>  0002-sched-Implement-interface-for-cgroup-unified-hierarc.patch

Ping.  Any comments on the proposed interface?

Thanks!

-- 
tejun
