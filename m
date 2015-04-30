From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: questions about hugetlb usage
Date: Thu, 30 Apr 2015 16:11:45 +0800
Message-ID: <5541E3C1.8020908@huawei.com>
References: <5541D5A6.7010804@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5541D5A6.7010804-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2015/4/30 15:11, Ma Shimiao wrote:
> Hello,
> 
> I'm new to cgroups.
> I'm not sure whether this is the right place to ask questions about cgroups.
> If not, I will be very sorry for disturbing.
> 
> Recently, I'm researching the usage of hugetlb.
> I have got a problem, but don't know why and how to solve it.
> 
> # cat /proc/meminfo |grep -i huge
> AnonHugePages:   1894400 kB
> HugePages_Total:     192
> HugePages_Free:      188
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       2048 kB
> # cat /sys/fs/cgroup/hugetlb/hugetlb.2MB.limit_in_bytes 
> 9223372036854771712
> # cat /sys/fs/cgroup/hugetlb/hugetlb.2MB.max_usage_in_bytes 
> 8388608
> # cat /sys/fs/cgroup/hugetlb/hugetlb.2MB.usage_in_bytes 
> 8388608
> # echo 10240000000000 > /sys/fs/cgroup/hugetlb/hugetlb.2MB.limit_in_bytes 
> -bash: echo: write error: Invalid argument
> 
> It seems I cant write values to hugetlb.2MB.limit_in_bytes
> Could anyone give me some advice?
> Thanks very much.
> 

Looks like you were trying to write to the file in root cgroup, which
is forbidden.
