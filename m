From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/6] cpuset: Allow to modify isolcpus through cpuset
Date: Fri, 16 Jul 2021 14:02:50 -0400
Message-ID: <8ea7a78f-948e-75e8-1c4f-59b349c858f6@redhat.com>
References: <20210714135420.69624-1-frederic@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626458574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xjAtGXPGZFlFZsipCtgSHU9hwzzeLIgV7DwDVA8X6EQ=;
        b=DdlHCGdq6mbFgvzMCNxu2wGKsli4+mNF/iZkiJselZUF+rF0oXL/Dec+2bVOtczT8fxEmP
        r2wtxcF9h23z/eb1zQLguFNI+E9a60m2MB6E17o+OeiqJUNUD+f4mo/mHAJk51fCdPWiAR
        AwKOkBNm7D1AN54gzAChS9/zpFr8zwc=
In-Reply-To: <20210714135420.69624-1-frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Belits <abelits-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>, Nitesh Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Nicolas Saenz <nsaenzju-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-LoxgEY9JZOazQB+pC5nmwQ@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 7/14/21 9:54 AM, Frederic Weisbecker wrote:
> The fact that "isolcpus=" behaviour can't be modified at runtime is an
> eternal source of discussion and debate opposing a useful feature against
> a terrible interface.
>
> I've long since tried to figure out a proper way to control this at
> runtime using cpusets, which isn't easy as a boot time single cpumask
> is difficult to map to a hierarchy of cpusets that can even overlap.

I have a cpuset patch that allow disabling of load balancing in a 
cgroup-v2 setting:

https://lore.kernel.org/lkml/20210621184924.27493-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/

The idea of cpuset partition is that there will be no overlap of cpus in 
different partitions. So there will be no confusion whether a cpu is 
load-balanced or not.

>
> The idea here is to map the boot-set isolation behaviour to any cpuset
> directory whose cpumask is a subset of "isolcpus=". I let you browse
> for details on the last patch.
>
> Note this is still WIP and half-baked, but I figured it's important to
> validate the interface early.

Using different cpumasks for different isolated properties is the easy 
part. The hard part is to make different subsystems to change their 
behavior as the isolation masks change dynamically at run time. 
Currently, they check the housekeeping cpumask only at boot time or when 
certain events happen.

Cheers,
Longman


