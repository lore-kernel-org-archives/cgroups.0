From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/4] devcg: Store local settings for each device cgroup
Date: Thu, 15 Aug 2013 15:59:41 -0400
Message-ID: <20130815195941.GA10977@mtj.dyndns.org>
References: <1376580854-30929-1-git-send-email-aris@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=kG++/m8cCD3w7CGo/jS8+ue8Kt4y8s3Z48rJSAkci+U=;
        b=j1d9Vt5F8P1aNiMQkrl/mcN6N3L4nRUY7E+SLQ1q8ea00VwKQa3+wqaJAPU6RK1ueJ
         IgsmaKM2FyVnPO6NED4PNsWsZmGpuTsFUOPyS8OzYwkezOUve+wNTiTWNrLTB3mX2vAx
         lBUGK8EnBaMLqJzbhAfuhXZbjyyt6ZXxMd3Woe8J2h4UsxVZTjspk4c6nHfHePeVJrgY
         XEy2RlzzjdFN48zIlvcup/8uDaQbGsq/od8SxYTA1hDKS5hKVCBNIM+t26VhPeC0kwH+
         dXC38my8gUu0s998HbIL7AKWvXs5sCZNudidHcdUswCJXp9NRsE0NS/ntOxkQZ6Vf30V
         FMBg==
Content-Disposition: inline
In-Reply-To: <1376580854-30929-1-git-send-email-aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>

Hello, Aristeu.

On Thu, Aug 15, 2013 at 11:34:10AM -0400, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> With this patchset, the 'b 1:5 r' exception will be kept and whenever possible
> (more specifically when the parent gets access to more devices) it'll be
> re-evaluated and applied if allowed. In this specific case, since it's allowed
> again, the exception 'b 1:5 r' will be reapplied to B.

So, while this patchset is headed in the right direction, some stuff
still bothers me.

* The configurations are finicky and complex.  There are many ways to
  configure it and some may fail depending on some conditions.  I
  really wish it were a lot simpler, at least when sane_behavior.

* Using separate propagation paths for allows and denys feels a bit
  weird.  Can't config just update local config and always propagate
  the change downwards?

When sane_behavior, can't we have something like the following?

* Setting local config is not affected by what ancestors or
  descendants are doing.  It just sets local config and triggers
  propagation and never fails (except for things like alloc failure).

* Config defaults to allow-all unconfigured and there are only two
  modes - allow-all or allow-only-listed with an easy way to flip
  between the two and clear the list, which lists either specific
  maj:min or maj.

Thanks.

-- 
tejun
