From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: question about cgroupv2
Date: Tue, 21 Jun 2016 13:41:01 +0800
Message-ID: <5768D36D.3060606@huawei.com>
References: <5764ADC5.20205@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5764ADC5.20205-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On 2016/6/18 10:11, Ma Shimiao wrote:
> Hello,
> 
> Sorry for disturbing.
> 
> I want to test how to use cgroup v2 on kernel 4.6.2.
> And I have read https://www.kernel.org/doc/Documentation/cgroup-v2.txt
> According to the above document, I added kernel parameter cgroup_no_v1=1.
> But, system still automount the v1 cgroup.
> Then, I executed:
> # mount -t cgroup2 none /mnt
> 
> But, cgroup.controllers in /mnt is empty.
> 
> I'm not sure if I made something wrong or cgroup v2 is not supported on kernel 4.6.2?
> 

cgroup_no_v1=1 is wrong, try cgroup_no_v1=all. :)
