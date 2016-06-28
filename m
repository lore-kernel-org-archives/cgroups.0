From: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: question about cgroupv2
Date: Tue, 28 Jun 2016 12:45:04 -0400
Message-ID: <20160628164504.GA5185@htj.duckdns.org>
References: <5764ADC5.20205@cn.fujitsu.com>
 <5768D36D.3060606@huawei.com>
 <5768D8F5.1060107@cn.fujitsu.com>
 <9B0331B6EBBD0E4684FBFAEDA55776F92CD6983C@HASMSX110.ger.corp.intel.com>
 <1466991769.2241.28.camel@HansenPartnership.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UKPZfSCN4JArrnx5cPs8d6Yle0IK+YEBIxxvrjkQysI=;
        b=p4l6tWaFApbXUzAMks0wxg8aKB7lXR/iF1qwkcauSh6gDgg7yS/wt5NgBTZSExoKPa
         PUBFN54WcMALK7bUMVQio/KR6GPnzhSAE0Jz46+GlWS9t9rB25vp1umssYKuEPOTHHzN
         b60191sKMjwG8HfPb+iXII7ZYFlD0biTooQtP8H8Nr94ZLqMc35t17NDGrz0QQWb4Czp
         lBY1OxmsKF/K6EjU/PDdrcenkgbdSQKccRQa5vMj/UC2HidN4nsHS6me8FxXwih8g+7m
         cbcTaqpK1ul4ymwsm4Vga5lj+rsxHSE4B1o9XtBWh9H8Or+uBRbw+qnAC9uRt+VCrI3R
         hQGg==
Content-Disposition: inline
In-Reply-To: <1466991769.2241.28.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "Rosen, Rami" <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Sun, Jun 26, 2016 at 06:42:49PM -0700, James Bottomley wrote:
> This is the right answer.   I've spent ages trying to figure out how to
> do it on my openSUSE laptop because I actually want to demo the v2 API.
>  However, it seems to be impossible.  You can't prevent systemd from
> mounting the v1 hierarchies and that means you can't get v2 ones
> running.  The only real way to do it on a modern laptop is to use a
> virtual machine (sadly you can't use a container because systemd has
> already contaminated the host kernel).  I tend to use debian because
> they have an installation procedure for dumping systemd:

* That's what cgroup_no_v1= option is for.

* For a while systemd had a bug where it created sub cgroups even for
  controllers which don't have any resource limits configured.  This
  has been fixed for a while now and you should be able to umount
  hierarchies with unused hierarchies now (it's ugly but does work).

Thanks.

-- 
tejun
