From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 6/8] cgroup: remove cgroup->name
Date: Wed, 12 Feb 2014 16:52:18 +0800
Message-ID: <52FB3642.1050509@huawei.com>
References: <1391877509-10855-1-git-send-email-tj@kernel.org> <1391877509-10855-7-git-send-email-tj@kernel.org> <52FB2834.3090408@huawei.com> <20140212082713.GD7984@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140212082713.GD7984-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On 2014/2/12 16:27, Tejun Heo wrote:
> On Wed, Feb 12, 2014 at 03:52:20PM +0800, Li Zefan wrote:
>> The caller won't check the return value but pass it to printk/seq_printf,
>> but now cgroup_path() might return -ENAMETOOLONG..
> 
> cgroup_path() returns NULL on overflow which printk handles fine, no?
> 

Ah, right. My mistake. I didn't take an afternoon nap, and was a bit sleeply.
