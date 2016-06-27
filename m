From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: question about cgroupv2
Date: Sun, 26 Jun 2016 18:42:49 -0700
Message-ID: <1466991769.2241.28.camel@HansenPartnership.com>
References: <5764ADC5.20205@cn.fujitsu.com> <5768D36D.3060606@huawei.com>
	 <5768D8F5.1060107@cn.fujitsu.com>
	 <9B0331B6EBBD0E4684FBFAEDA55776F92CD6983C@HASMSX110.ger.corp.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
	s=20151216; t=1466991770;
	bh=4+5U0Xp9caKHN6h/Pkxl9wpsHByuWEFvxNBEolcDFiI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=fIWK520HnuAi0Vmq4355q3lckXe6T+ePt18Qkwbokhj0923Ahc5JtMVKBz4vT3fep
	 oEQ6Zc4twACal0Kv+j6WMlofL+mADjGn3pn2nTX00e5pG55G0Nuex/2TeDLa12rOTW
	 /bZm8EmCWv4lhZWIpg4AJjDDADMecJ780TDb6QLU=
In-Reply-To: <9B0331B6EBBD0E4684FBFAEDA55776F92CD6983C-cNwSTNrqBuVnIh7sxsoRyrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Rosen, Rami" <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Tue, 2016-06-21 at 07:38 +0000, Rosen, Rami wrote:
> Hi, Ma,
> 
> > Ah, it seems work, but I'm not sure.
> 
> > > Then, I executed:
> > > # mount -t cgroup2 none /mnt
> 
> It should work. The thing is, according to my trials from the past, 
> it could be that systemd triggers mounting of cgroup V1 controllers. 
> When I made trials with cgroup v2, eventually I turned on to disros 
> which do not run systemd (namely, it was Ubuntu. You can set Ubuntu 
> not to use systemd, even in most recent Ubuntu systems, where systemd 
> became the default).

This is the right answer.   I've spent ages trying to figure out how to
do it on my openSUSE laptop because I actually want to demo the v2 API.
 However, it seems to be impossible.  You can't prevent systemd from
mounting the v1 hierarchies and that means you can't get v2 ones
running.  The only real way to do it on a modern laptop is to use a
virtual machine (sadly you can't use a container because systemd has
already contaminated the host kernel).  I tend to use debian because
they have an installation procedure for dumping systemd:

http://without-systemd.org/wiki/index.php/How_to_remove_systemd_from_a_Debian_jessie/sid_installation

But I suppose this systemdless Devuan distribution might do as well
(not tried it):

https://www.devuan.org/

James
