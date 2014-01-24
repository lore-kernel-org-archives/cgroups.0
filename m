From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cpusets: Allocate heap only when required
Date: Fri, 24 Jan 2014 02:51:12 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1401240243260.24372@chino.kir.corp.google.com>
References: <8622e93b9c49c66ffdc9ef0aa8371c322718edd5.1390475530.git.viresh.kumar@linaro.org> <alpine.DEB.2.02.1401231330530.7313@chino.kir.corp.google.com> <52E1C8BD.2010500@huawei.com> <alpine.DEB.2.02.1401240230190.9846@chino.kir.corp.google.com>
 <20140124103631.GB4101@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=sgVrP05tOYaUShzYf2T1P9F600j1vge11KB3BuzA9Oo=;
        b=HE7byUfjQEEv2bO4WpIEVISTEd13vwYPabRZd1YCNOxx0K/W/bOvVKFc8LhEuedDRo
         7G8Abft2+pLp0QRJkMDDhzS5GVRQGgslJGivFFJjt8gd5u7d/G28u9HZwau5q2rdLANS
         ++IGXBLfjtkaqVEKpCZJh72gPpnBCOzqx8rltJgqMzQXZiLTwH5R9XZvrySffsb6perV
         AS/k0SsFTvyqtjt+DWUnVYZxL5Gs6Bf101Ycak+a9GuPe4lXCXXT4GcNSFqZIahHDAwF
         Ixt0/i9Y3we4xhMIYS+U0oGE4reyV3n7DOIdMellSn1Cu5/F8vSIQTCdzweXpIhDAmiE
         Rwgg==
In-Reply-To: <20140124103631.GB4101-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, 24 Jan 2014, Tejun Heo wrote:

> > It's not harmless, if heap_init() fails with -ENOMEM then the write fails 
> > even though it may not be for memory_spread_page or memory_spread_slab, 
> > which is the minority of the callers of this function.
> 
> And depending on details like that would actually be more harmful.
> Please remember that all writes through cgroupfs may fail under very
> high memory pressure.  There's no "this specific set of writes to this
> specific knob isn't affected by memory pressure" guarantee.
> 

Nobody is depending on shit, the patch is removing a completely pointless 
memory allocation in braindead cpuset code.  What you think is "harmful" 
or "more harmful" is irrelevant, but nobody said anything about depending 
on that behavior to do anything.

Thanks.
