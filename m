From: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: counting file descriptors with a cgroup controller
Date: Tue, 07 Mar 2017 12:19:52 +0100
Message-ID: <7fbd9c4c-76ca-4073-9afa-1ab54364ec79@samsung.com>
References: <CGME20170217093725eucas1p12478baf297d25303f3020f4973fbf3b0@eucas1p1.samsung.com>
 <87poihtaya.fsf%l.stelmach@samsung.com>
 <9a57890c-d9e9-5719-e155-ce1161795a02@samsung.com>
 <20170306185820.GA19696@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20170306185820.GA19696-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, =?UTF-8?Q?=c5=81ukasz_Stelmach?= <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi

On 03/06/2017 07:58 PM, Tejun Heo wrote:
> Hello,
>
> On Fri, Feb 17, 2017 at 12:37:11PM +0100, Krzysztof Opasiak wrote:
>>> We need to limit and monitor the number of file descriptors processes
>>> keep open. If a process exceeds certain limit we'd like to terminate it
>>> and restart it or reboot the whole system. Currently the RLIMIT API
>>> allows limiting the number of file descriptors but to achieve our goals
>>> we'd need to make sure all programmes we run handle EMFILE errno
>>> properly. That is why we consider developing a cgroup controller that
>>> limits the number of open file descriptors of its members (similar to
>>>  memory controler).
>>>
>>> Any comments? Is there any alternative that:
>>>
>>> + does not require modifications of user-land code,
>>> + enables other process (e.g. init) to be notified and apply policy.
>
> Hmm... I'm not quite sure fds qualify as an independent system-wide
> resource.  We did that for pids because pids are globally limited and
> can run out way earlier than memory backing it.  I don't think we have
> similar restructions for fds, do we?

Well I'm not aware of such restrictions...

So maybe let me clarify our use case so we can have some more discussion 
about this. We are dealing with task of monitoring system services on an 
IoT system. So this system needs to run as long as possible without 
reboot just like server. In server world almost whole system state is 
being monitored by services like nagios. They measure each parameter 
(like cpu, memory etc) with some interval. Unfortunately we cannot use 
this it in an embedded system due to power consumption.

So generally now we consider two approaches:

1) Use rlimits when possible to limit resources for each process.

The problem here is that this creates an implicit requirement that all 
system services are well written and able to detect that they for 
example run out of fd and they will just exit with a suitable error code 
instead of hanging forever and responding to clients that they are 
unable to handle their request due to lack of fd. This is hard specially 
when service use a lot of libraries under the hood because they also 
need to return this error code from each functions which opens some 
files. This is especially hard when using some proprietary services or 
libraries for we don't have access to source code.

2) Use cgroups to limit and monitor resources usage

Generally systemd creates a cgroup for each service. cgroups like memory 
cgroup has an ability to notify userspace when memory usage reaches some 
level. So for example systemd could get notification that one of cgroups 
is using more memory than it should but as long as it's not a hard limit 
of the cgroup this service is not going to even notice this. So instead 
of returning error from for example malloc() in service, systemd could 
just send signal to that service and ask it to exit gracefully and the 
restart it. The disadvantage of this solution is the need of having 
cgroup for each resource we would like to monitor. For now we have 
suitable cgroups for everything we need apart from file descriptors.

What do you think about this? Maybe you have some other ideas how we 
could achieve this?

Best regards,
-- 
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
