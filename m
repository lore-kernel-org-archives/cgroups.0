From: Yang Yingliang <yangyingliang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup pointed by sock is leaked on mode switch
Date: Wed, 6 May 2020 09:50:43 +0800
Message-ID: <c9879fd2-cb91-2a08-8293-c6a436b5a539@huawei.com>
References: <03dab6ab-0ffe-3cae-193f-a7f84e9b14c5@huawei.com>
 <20200505160639.GG12217@mtj.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200505160639.GG12217-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Libin (Huawei)" <huawei.libin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, guofan5-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

+cc lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 2020/5/6 0:06, Tejun Heo wrote:
> Hello, Yang.
>
> On Sat, May 02, 2020 at 06:27:21PM +0800, Yang Yingliang wrote:
>> I find the number nr_dying_descendants is increasing:
>> linux-dVpNUK:~ # find /sys/fs/cgroup/ -name cgroup.stat -exec grep
>> '^nr_dying_descendants [^0]'=C2=A0 {} +
>> /sys/fs/cgroup/unified/cgroup.stat:nr_dying_descendants 80
>> /sys/fs/cgroup/unified/system.slice/cgroup.stat:nr_dying_descendants 1
>> /sys/fs/cgroup/unified/system.slice/system-hostos.slice/cgroup.stat:nr_d=
ying_descendants
>> 1
>> /sys/fs/cgroup/unified/lxc/cgroup.stat:nr_dying_descendants 79
>> /sys/fs/cgroup/unified/lxc/5f1fdb8c54fa40c3e599613dab6e4815058b76ebada8a=
27bc1fe80c0d4801764/cgroup.stat:nr_dying_descendants
>> 78
>> /sys/fs/cgroup/unified/lxc/5f1fdb8c54fa40c3e599613dab6e4815058b76ebada8a=
27bc1fe80c0d4801764/system.slice/cgroup.stat:nr_dying_descendants
>> 78
> Those numbers are nowhere close to causing oom issues. There are some
> aspects of page and other cache draining which is being improved but unle=
ss
> you're seeing numbers multiple orders of magnitude higher, this isn't the
> source of your problem.
>
>> The situation is as same as the commit bd1060a1d671 ("sock, cgroup: add
>> sock->sk_cgroup") describes.
>> "On mode switch, cgroup references which are already being pointed to by
>> socks may be leaked."
> I'm doubtful that you're hitting that issue. Mode switching means memcg
> being switched between cgroup1 and cgroup2 hierarchies, which is unlikely=
 to
> be what's happening when you're launching docker containers.
>
> The first step would be identifying where memory is going and finding out
> whether memcg is actually being switched between cgroup1 and 2 - look at =
the
> hierarchy number in /proc/cgroups, if that's switching between 0 and
> someting not zero, it is switching.
>
> Thanks.
>

