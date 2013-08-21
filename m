From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 00/11] cpuset: separate configured masks and effective
 masks
Date: Wed, 21 Aug 2013 10:21:55 -0400
Message-ID: <20130821142155.GL19286@mtj.dyndns.org>
References: <52148F52.0@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=HOX1MUap0px2cqY3lqeaep8bwdla+3Kf4uidXTgIEgA=;
        b=SfS7NRA1JEu1yzGTlyzOlobL5pPDxffFTDw2E4f27guc5peL+YahRfN6MkxxZb938j
         OhHsRAXgQ0Fg19P/RIX3QeiBShal9F8hWrIHkYmlq2iYnzfar02reGJlDg70N4LoNPUY
         bFrjKb6vsQ8RMFwe7g3162//dx/FZfrtmDhNmod5GnrnjDhkD65ah+aRL7kVvwGPamw5
         xAYgDFKgB7Pjjk7g2E2p8Gnu3IRtYsfFAX5VIyIX/nyTz+RPQ0arhR2Qi0XfwYlMU2nY
         Jd2jF4J2Vzw909OSY1L4ygRfsg9MzChvcawcLRX7jLrM8VG2A4txWg/4ZWrr5tvmy1LQ
         GVBQ==
Content-Disposition: inline
In-Reply-To: <52148F52.0-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

Hello, Li.

On Wed, Aug 21, 2013 at 05:58:42PM +0800, Li Zefan wrote:
> This patcheset introduces behavior changes, but only if you mount cgroupfs
> with sane_behavior option:
> 
> - We introduce new interfaces cpuset.effective_cpus and cpuset.effective_mems,
>   while cpuset.cpus and cpuset.mems will be configured masks.
> 
> - The configured masks can be changed by writing cpuset.cpus/mems only. They
>   won't be changed when hotplug happens.
> 
> - Users can config cpus and mems without restrictions from the parent cpuset.
>   effective masks will enforce the hierarchical behavior.
> 
> - Users can also config cpus and mems to have already offlined CPU/nodes.
> 
> - When a CPU/node is onlined, it will be brought back to the effective masks
>   if it's in the configured masks.
> 
> - We build sched domains based on effective cpumask but not configured cpumask.

Overall, it looks great.  Thank you so much for doing this.  Most of
my reviews are concerned with patch descriptions and documentation.  I
wish they showed clearer what are changed how and why that doesn't
affect !sane behaviors.

Thanks!

-- 
tejun
