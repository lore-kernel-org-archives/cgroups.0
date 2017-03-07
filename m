From: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: counting file descriptors with a cgroup controller
Date: Tue, 07 Mar 2017 21:06:49 +0100
Message-ID: <9ee62e45-6645-454b-11b5-85be746bc81a@samsung.com>
References: <CGME20170217093725eucas1p12478baf297d25303f3020f4973fbf3b0@eucas1p1.samsung.com>
 <87poihtaya.fsf%l.stelmach@samsung.com>
 <9a57890c-d9e9-5719-e155-ce1161795a02@samsung.com>
 <20170306185820.GA19696@htj.duckdns.org>
 <7fbd9c4c-76ca-4073-9afa-1ab54364ec79@samsung.com>
 <20170307194134.GE31179@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20170307194134.GE31179-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, =?UTF-8?Q?=c5=81ukasz_Stelmach?= <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 03/07/2017 08:41 PM, Tejun Heo wrote:
> Hello, Krzysztof.
>
> On Tue, Mar 07, 2017 at 12:19:52PM +0100, Krzysztof Opasiak wrote:
>> So maybe let me clarify our use case so we can have some more discussion
>> about this. We are dealing with task of monitoring system services on an IoT
>> system. So this system needs to run as long as possible without reboot just
>> like server. In server world almost whole system state is being monitored by
>> services like nagios. They measure each parameter (like cpu, memory etc)
>> with some interval. Unfortunately we cannot use this it in an embedded
>> system due to power consumption.
>
> So, we don't add controllers for specific use case scenarios.  The
> target actually has to be a fundamental resource which can't be
> isolated in a different way.
>
> The use case you're describing is more about working around
> shortcomings in userspace by implemneting a major kernel feature, when
> the said shortcomings can easily be controlled and mitigated from
> userspace - e.g. if running out of fds can't be handled reliably from
> the target application for some reason and the application may lock up
> from the condition, protect the base resources so that a monitoring
> process can always reliably run and let that take a corrective action
> when such condition is detected.
>

In theory that's what we plan to do but we are looking for an efficient 
method of detecting that this particular application is using more fds 
than it should (declared by developer).

Personally, I don't want to use rlimit for this as it ends up returning 
error code from for example open() when we hit the limit. This may lead 
to some unpredictable crashes in  services (esp. those poor proprietary 
binary blobs). Instead of injecting errors to service we would like to 
just get notification that this service has more opened fds than it 
should and ask it to restart in a polite way.

For memory seems to be quite easy to achieve as we can just get eventfd 
notification when application passes given memory usage using memory 
cgroup controller. Maybe you know some efficient method to do the same 
for fds?

Best regards,
-- 
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
