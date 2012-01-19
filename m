From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFC] splitting cgroup.c
Date: Thu, 19 Jan 2012 15:26:30 +0800
Message-ID: <4F17C5A6.50501@cn.fujitsu.com>
References: <4F177C67.6070907@cn.fujitsu.com> <20120119022401.GH21533@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120119022401.GH21533-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

>> So I think for the sake of readability and maintainability, we'd
>> better split cgroup.c into smaller pieces:
> 
> I agree that splitting is necessary but IMHO splitting usually tends
> to go too far.  Maybe we can split it into two and think about further
> splitting later on?  e.g. internal logic vs. userland interfacing.
> 

This isn't feasible. The feasible way is to split by functionality,
which I think was the way taken by perf developers.
