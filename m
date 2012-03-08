From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v2 0/3] cgroup: add xattr support
Date: Thu, 08 Mar 2012 17:03:50 +0800
Message-ID: <4F5875F6.9010804@cn.fujitsu.com>
References: <4F4F1459.4080300@cn.fujitsu.com> <20120304180516.GB20787@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120304180516.GB20787-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Tejun Heo wrote:
> Hello, Li.
> 
> Sorry about the delay.  Was on vacation.
> 

Me too. ;)

> On Thu, Mar 01, 2012 at 02:16:57PM +0800, Li Zefan wrote:
>> This can be used to attach metadata to a cgroup, which is required
>> by systemd.
>>
>> As lazy as I am, here just quoted from Lennart for the detailed use
>> cases:
> 
> I much prefer this version but would prefer to deal with this in the
> next merge window as we're already on rc6.  On a cursory look...
> 

I'm fine with this, especially I'm busy with other stuff.

> * I'm not sure kmem_ is a good prefix.  It sucks that xattr values are
>   stored in kmem w/o size limit and we probably want to improve on
>   both fronts in the future.  Wouldn't it be better to name them
>   simple_*() and put them in fs/libfs.c?
> 

Ok.

> * I don't think we want CONFIG option for cgroupfs xattr.  Let's just
>   add a mount option.

Ok.

> 
> Thanks.
> 
