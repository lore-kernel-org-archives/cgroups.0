From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] device_cgroup: lock assert fails in dev_exception_clean()
Date: Wed, 23 Jan 2013 08:41:18 -0800
Message-ID: <CAOS58YM65ZbHRAfLuL+DBDfSCOA2sPGYM9qZnVJjWXA2Dz=3vA@mail.gmail.com>
References: <1358460018-14717-1-git-send-email-jerry.snitselaar@oracle.com>
	<1358460018-14717-2-git-send-email-jerry.snitselaar@oracle.com>
	<20130117220642.GE16568@mtj.dyndns.org>
	<20130117231341.GA14588@cantor.us.oracle.com>
	<20130123043140.GA5913@cantor.us.oracle.com>
	<20130123142939.GC17632@redhat.com>
	<20130123163640.GB2373@mtj.dyndns.org>
	<20130123163849.GH17632@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=L0SMxk3QLffYE+eJXnx9CN5g92VMXqGmU2VRsxCx284=;
        b=Kv7QOXqnkpNPe69rPq6ZRSHM5VSFpfnE3am9jF0n/lM0jGgI+VRnziKEs13xUW+MWO
         e8034t1zkQvG2b/ShqG6jRRJQt69hU/DWDytmx7NYyJ2FUw5iTYFt6SZZcHLdxv/M5R8
         ee4EqqoAVkEq3ewLkfdjoQZZbG8aaAomMjGauRMhhnCYTztOMc7/t/04iVI6Ilzr1+wh
         8YmTszXSlbGcZ44owCnCBC62RVACD1uEFGMptNpazWDW1DJm+AMU3MkQi6FtEBy5/OYO
         ZnV0s7KQqNIFmXBknc0d7ZsZCuBrBC0PIpsLaMH28VeHaZ7jLEdNjLLUokC9yl1noaUD
         95Cg==
In-Reply-To: <20130123163849.GH17632-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Jan 23, 2013 at 8:38 AM, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> on a slightly subject, hierarchy support is still desired for device
> cgroups? I got the patchset ready by the time ebiederman submitted
> userns patches and like it was discussed before device_cgroup would be
> made obsolete once userns was out.

I think having hierarchy support is still a good idea. It's not like
we can disable devcg immediately. Maybe we'll be able to drop it in
say five or ten years if no one is ever using it and breakages in it
go unnoticed for a long time and so on but that's still a long way
out.

Thanks.

-- 
tejun
