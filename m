From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: question about cgroupv2
Date: Wed, 22 Jun 2016 08:44:20 +0800
Message-ID: <5769DF64.1040406@huawei.com>
References: <5764ADC5.20205@cn.fujitsu.com> <5768D36D.3060606@huawei.com>
 <5768D8F5.1060107@cn.fujitsu.com>
 <9B0331B6EBBD0E4684FBFAEDA55776F92CD6983C@HASMSX110.ger.corp.intel.com>
 <5768FBF8.2060100@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5768FBF8.2060100-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, "Rosen, Rami" <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 2016/6/21 16:34, Ma Shimiao wrote:
> Hi Rosen,
> On 06/21/2016 03:38 PM, Rosen, Rami wrote:
>> Hi, Ma,
>>
>>> Ah, it seems work, but I'm not sure.
>>
>>>> Then, I executed:
>>>> # mount -t cgroup2 none /mnt
>>
>> It should work. The thing is, according to my trials from the past, it could be that systemd triggers mounting of cgroup V1 controllers. When I made trials with cgroup v2, eventually I turned on to disros which do not run systemd (namely, it was Ubuntu. You can set Ubuntu not to use systemd, even in most recent Ubuntu systems, where systemd became the default).
>>
>> What happens if you mount cgroup v2 now, after booting with cgroup_no_v1=all:
>> mount -t cgroup2 none /mnt
>>
>> And then try to unmount cgroup v1 controllers like memory ? 
>> Do you see anything under /mnt?
> 
> Yes, after booting with cgroup_no_v1, then execute
> #mount -t cgroup2 none /mnt
> #cat /mnt/cgroup.controllers 
> io memory
> 
> There are controllers io and memory.
> But, cgroup2 is not mounted in the system by default?

because systemd hasn't supported cgroup2 yet.
