From: Krzysztof Opasiak <k.opasiak@samsung.com>
Subject: Re: counting file descriptors with a cgroup controller
Date: Wed, 08 Mar 2017 10:52:18 +0100
Message-ID: <50e07c29-295a-62fd-e0ad-7e52d5b55c7d@samsung.com>
References: <CGME20170217093725eucas1p12478baf297d25303f3020f4973fbf3b0@eucas1p1.samsung.com>
 <87poihtaya.fsf%l.stelmach@samsung.com>
 <9a57890c-d9e9-5719-e155-ce1161795a02@samsung.com>
 <20170306185820.GA19696@htj.duckdns.org>
 <7fbd9c4c-76ca-4073-9afa-1ab54364ec79@samsung.com>
 <20170307194134.GE31179@htj.duckdns.org>
 <9ee62e45-6645-454b-11b5-85be746bc81a@samsung.com>
 <20170307204825.GH31179@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20170307204825.GH31179@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, =?UTF-8?Q?=c5=81ukasz_Stelmach?= <l.stelmach@samsung.com>, linux-kernel@vger.kernel.org, Karol Lewandowski <k.lewandowsk@samsung.com>, cgroups@vger.kernel.org



On 03/07/2017 09:48 PM, Tejun Heo wrote:
> Hello,
>
> On Tue, Mar 07, 2017 at 09:06:49PM +0100, Krzysztof Opasiak wrote:
>> Personally, I don't want to use rlimit for this as it ends up returning
>> error code from for example open() when we hit the limit. This may lead to
>> some unpredictable crashes in  services (esp. those poor proprietary binary
>> blobs). Instead of injecting errors to service we would like to just get
>> notification that this service has more opened fds than it should and ask it
>> to restart in a polite way.
>>
>> For memory seems to be quite easy to achieve as we can just get eventfd
>> notification when application passes given memory usage using memory cgroup
>> controller. Maybe you know some efficient method to do the same for fds?
>
> So, if all you wanna do is reliably detecting open(2) failures, can't
> you do that with bpf tracing?
>

Well detecting failures of open is not enough and it has couple of problems:

1) open(2) is not the only syscall which creates fd. In addition to 
other syscalls like socket(2), dup(2), some ioctl() on drivers (for 
example video) also creates fds. I'm not sure if we have any other 
mechanism than grep through kernel source to find out which ioctl() 
creates fd or and which not.

2) As far as I know (I'm not a bpf specialist so please correct me if 
I'm wrong), with bpf we are able only to detect such events but we are 
unable to prevent them from getting to caller. It means that service 
will know that it run out of fds and will need to handle this properly. 
If there is a bug in this error path service may crash.
What we would like to get is just a notification to external process 
that some limit has been reached without returning error to service itself.

3) Theoretically we could do this using bpf or syscall auditing and 
count fds for each userspace process or check /proc/<PID> after each 
notification but it's getting very heavy for production environment.

Best regards,
-- 
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
