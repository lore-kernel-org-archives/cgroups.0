From: Tejun Heo <tj@kernel.org>
Subject: Re: cgroup pointed by sock is leaked on mode switch
Date: Tue, 5 May 2020 12:06:39 -0400
Message-ID: <20200505160639.GG12217@mtj.thefacebook.com>
References: <03dab6ab-0ffe-3cae-193f-a7f84e9b14c5@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bv8d5auwv8WPKBW85dEhvwg9llp+d9U+MUHdBWxQ/AA=;
        b=YXZUrR/FBzuSZDfpKyddp1h4Q3IEai/+synGatezI1urLNAo/GqDaNbGAM9LoDkeJA
         gzaObuXQxJdC3rrvG/FR/5EeiUTZlK6odsPf1p2j4udJUVYqoD/ixxWPQ3wlnh6Ugoj0
         vYy2wGt9ujB5Jsvwcbjm+GoiqKD2A2/exauGq8LvJ2S4UBZhS+fXlOwif5kPyc9klZmB
         9pp6rHNVpVcYYqLKhsd8OLFqIo0pi5jKkzudk8kKoFvPirFDS9eZPbtzFjaqUlvibmD1
         zA1nh/SEvZlB/pAWTKki+2g6j2zyhskCgHDaHXMFDI2s+KdFCtrcgdJ2wtHFQf42tAqX
         W3kQ==
Content-Disposition: inline
In-Reply-To: <03dab6ab-0ffe-3cae-193f-a7f84e9b14c5@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Yang Yingliang <yangyingliang@huawei.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org, "Libin (Huawei)" <huawei.libin@huawei.com>, guofan5@huawei.com, wangkefeng.wang@huawei.com

Hello, Yang.

On Sat, May 02, 2020 at 06:27:21PM +0800, Yang Yingliang wrote:
> I find the number nr_dying_descendants is increasing:
> linux-dVpNUK:~ # find /sys/fs/cgroup/ -name cgroup.stat -exec grep
> '^nr_dying_descendants [^0]'=A0 {} +
> /sys/fs/cgroup/unified/cgroup.stat:nr_dying_descendants 80
> /sys/fs/cgroup/unified/system.slice/cgroup.stat:nr_dying_descendants 1
> /sys/fs/cgroup/unified/system.slice/system-hostos.slice/cgroup.stat:nr_dy=
ing_descendants
> 1
> /sys/fs/cgroup/unified/lxc/cgroup.stat:nr_dying_descendants 79
> /sys/fs/cgroup/unified/lxc/5f1fdb8c54fa40c3e599613dab6e4815058b76ebada8a2=
7bc1fe80c0d4801764/cgroup.stat:nr_dying_descendants
> 78
> /sys/fs/cgroup/unified/lxc/5f1fdb8c54fa40c3e599613dab6e4815058b76ebada8a2=
7bc1fe80c0d4801764/system.slice/cgroup.stat:nr_dying_descendants
> 78

Those numbers are nowhere close to causing oom issues. There are some
aspects of page and other cache draining which is being improved but unless
you're seeing numbers multiple orders of magnitude higher, this isn't the
source of your problem.

> The situation is as same as the commit bd1060a1d671 ("sock, cgroup: add
> sock->sk_cgroup") describes.
> "On mode switch, cgroup references which are already being pointed to by
> socks may be leaked."

I'm doubtful that you're hitting that issue. Mode switching means memcg
being switched between cgroup1 and cgroup2 hierarchies, which is unlikely to
be what's happening when you're launching docker containers.

The first step would be identifying where memory is going and finding out
whether memcg is actually being switched between cgroup1 and 2 - look at the
hierarchy number in /proc/cgroups, if that's switching between 0 and
someting not zero, it is switching.

Thanks.

--=20
tejun
