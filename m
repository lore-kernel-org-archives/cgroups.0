From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 0/8] cpusets: Isolate CPUs via sysfs using cpusets
Date: Sun, 06 Apr 2014 10:30:20 +0200
Message-ID: <1396773020.11763.17.camel@marge.simpson.net>
References: <cover.1396599474.git.viresh.kumar@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:content-transfer-encoding:mime-version;
        bh=is1CLrnmKl9actpmTHUTQMwg7G2JPeu2qBJrmO7ry50=;
        b=mqfUkY/CkB/uPmvEm08jCWjkNSBOPYoNbECN1UDr2Ux6Xy8+EH541Aw9RCpuVyMEGV
         ifitGMWIBQIiwrUMt1j2O1w+mHad5e9pf4c5VBqhN3YGZyHmjZmMS7KwWOky2DrMe6FE
         VxLRd3dS5mORJKrsfcpwksDAkHfKaZVLY6b2G5Ojon3fBsVW/Zl+qiHF9W2VC9j+dYst
         uyXroYAnvKWZh5xHWwGofj0oGYn7tcpZgHnervvx8+vA6U/rY+UmAk/EjTC7s031AehG
         rZ1bftdqf1hfdASIFieQ50hvTYRTGr0VtZiR3TdqYcJmyKiCN7d+yxRTvvPXjmu3x4KZ
         M0eQ==
In-Reply-To: <cover.1396599474.git.viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linaro-networking-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Arvind.Chauhan-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 2014-04-04 at 14:05 +0530, Viresh Kumar wrote: 
> We need to migrate away all the background kernel activities (Unbound) for
> systems requiring isolation of cores (HPC, Real time, networking, etc). After
> creating cpusets, you can write 1 or 0 to cpuset.quiesce file.

I wonder if adding a quiesce switch is really necessary.

Seems to me that if you don't have load balancing turned off, you can't
be very concerned about perturbation, so this should be tied into the
load balancing on/off switch as an extension to isolating cores from the
#1 perturbation source, the scheduler.

I also didn't notice a check for is_cpu_exclusive() at a glance, which
would be a bug, but one that would go away if this additional isolation
were coupled to the existing isolation switch.

-Mike
