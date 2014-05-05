From: Raghavendra KT <raghavendra.kt.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.15] cgroup: implement unified hierarchy
Date: Mon, 5 May 2014 22:07:47 +0530
Message-ID: <CAC4Lta1rmtXeFBAJB_YA8wS9BHqkMSLAsV6q=obf_aQ--aud-Q@mail.gmail.com>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
	<20140414154556.GA9552@redhat.com>
	<20140414175236.GB15249@htj.dyndns.org>
	<CAC4Lta0qd2vW4ENSOpzK+0i06MorzfmsZZZuW9xUtpZ_gWA9gA@mail.gmail.com>
	<20140502151250.GB10204@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=kkhPSI9JxJ0Wd5brJ3PJtz8tPxSqgSK4MLrkOYNIfw0=;
        b=jQAcG9/Rr1i1bR19YVgylrbB+aJDPBx1P6Fj50zYamV2xzfM3u/m9a327ie482FR1R
         hDwQlZ9hwQkvxDEP+a1AMH+N92GvmMCA2jXmt6mNrvq3z9v6qhAq46aIhb4qNU0EEXYb
         NDfd24g80PnjIEOO/RLlrRdha5LwFUz+OPG9jse3Fx+47B6weAsKzpcfHM4cGyOHJFon
         a13M9Sw0XddoMoTzKLiDLaXRZKlvwP0zZvGH9AYNRZW8rIsZtKADk8om1Hx8DJxHh70h
         rHv6+grwORDK68w8Xh5E5AczokSDv60uKP5ba+dXDuAgGdU2Vp1Tw52uTcwn1fEyIBBv
         stTw==
In-Reply-To: <20140502151250.GB10204-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 5/2/14, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Wed, Apr 30, 2014 at 04:27:51PM +0530, Raghavendra KT wrote:
[...]
>> Because all the way along, though we have freedom to make the cpusets
>> exclusive and move tasks (say VMs) into them,
>> making sure they do not interfere with each other, we can not prevent
>> the other tasks spawned in a system eating into cpus of
>> exclusive cpuset since they go to root automatically.
>
> I believe the right thing to do would be starting / confining other
> tasks in the appropriate non-root cgroups.  cgroup already provides
> mechanisms to achieve that.  The rest is upto userland.
>

Thanks Tejun for the reply. I agree.

>> Do you think having a knob, to make sure new tasks spawned go to say a
>> default  directory under root makes sense?
>>
>>  I understand that we could easily have a userspace script which could
>> achieve intended goal, but kernel solution
>>  would really make the exclusive cpusets have exclusive access to cpus
>> it should have.
>
> This would just be a more reliable implementation of an ad-hoc
> mechanism when it can already be properly achieved by managing cgroups
> of all processes in the system.

Correct. Perhaps your answer clears my dilemma to go for a userspace
since I donot have any strong reason except convenience to go for a
kernel solution.
