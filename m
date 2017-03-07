From: Tejun Heo <tj@kernel.org>
Subject: Re: counting file descriptors with a cgroup controller
Date: Tue, 7 Mar 2017 14:41:34 -0500
Message-ID: <20170307194134.GE31179@htj.duckdns.org>
References: <CGME20170217093725eucas1p12478baf297d25303f3020f4973fbf3b0@eucas1p1.samsung.com>
 <87poihtaya.fsf%l.stelmach@samsung.com>
 <9a57890c-d9e9-5719-e155-ce1161795a02@samsung.com>
 <20170306185820.GA19696@htj.duckdns.org>
 <7fbd9c4c-76ca-4073-9afa-1ab54364ec79@samsung.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gx5+vZEbLrW5ijT086dCD5sXQ0IP8vDsLAOhkDovRVs=;
        b=fXluCWckjX8+TBuG5UoVnRpLAQVHUFUrVuqDXXmKL0IN1theAK46wp05lxljebwn+r
         IaSRre9gKty8C6iDgi0RWFFzTOT5g8v8SnR8TXlOjRrCT1MQGIboLEdWBpxKivKGRmoE
         hyynDIX/9rCY+TF0McRKzORkHvRVbhOjzAxGw0OGWOeXKmigpu83l0xLCOeveLqT+pcO
         835rpm4CWVgCQenel6O6VqOrWrH8ehrh9e9HBnKbLXGM5iAYQPvwas6pgT0NlveZlHuS
         jGD0v6pb0V7WPfy/DAD1Pc/zCKRRLip2Ngr/OuLeyr0FdfHVkFzgl4EN0oD1WX+/Ttji
         f93Q==
Content-Disposition: inline
In-Reply-To: <7fbd9c4c-76ca-4073-9afa-1ab54364ec79@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Krzysztof Opasiak <k.opasiak@samsung.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>, linux-kernel@vger.kernel.org, Karol Lewandowski <k.lewandowsk@samsung.com>, cgroups@vger.kernel.org

Hello, Krzysztof.

On Tue, Mar 07, 2017 at 12:19:52PM +0100, Krzysztof Opasiak wrote:
> So maybe let me clarify our use case so we can have some more discussion
> about this. We are dealing with task of monitoring system services on an IoT
> system. So this system needs to run as long as possible without reboot just
> like server. In server world almost whole system state is being monitored by
> services like nagios. They measure each parameter (like cpu, memory etc)
> with some interval. Unfortunately we cannot use this it in an embedded
> system due to power consumption.

So, we don't add controllers for specific use case scenarios.  The
target actually has to be a fundamental resource which can't be
isolated in a different way.

The use case you're describing is more about working around
shortcomings in userspace by implemneting a major kernel feature, when
the said shortcomings can easily be controlled and mitigated from
userspace - e.g. if running out of fds can't be handled reliably from
the target application for some reason and the application may lock up
from the condition, protect the base resources so that a monitoring
process can always reliably run and let that take a corrective action
when such condition is detected.

This doesn't really seem to qualify as a dedicated kernel
functionality.

Thanks.

-- 
tejun
