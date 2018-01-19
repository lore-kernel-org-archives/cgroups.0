From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] string: drop __must_check from strscpy() and restore
 strscpy() usages in cgroup
Date: Fri, 19 Jan 2018 08:50:44 -0800
Message-ID: <20180119165044.GA3460072@devbig577.frc2.facebook.com>
References: <20180108145223.GS3668920@devbig577.frc2.facebook.com>
 <CA+55aFzLYgX5WVAFASH65LkTtvSbn_g6eibxe1Psoc1Uc2hFkw@mail.gmail.com>
 <CA+55aFxSbAJe9gnL7jXHUO8KzY8TbrvSt7+jWsTZTJt7EMMzuw@mail.gmail.com>
 <20180108192801.GZ3668920@devbig577.frc2.facebook.com>
 <CA+55aFyQu8wTOJ8HdUjRA2NnLLdXRPvPyEyaws=5VULVJrDSxg@mail.gmail.com>
 <20180109152115.GH3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8OBqcTFGbYG3Fw3v8O2nm+ZXcGhyfRV9Abq7v54lSOU=;
        b=oQamOY1UsX5oxwya3zA3zQsDdaSRSf0qrqJ/L+eJOVH9j3Yoeqjxg0E+CYPiCgYxJD
         Bl0/p3Qslq0f28Ha5zW6k1xXRFXScgQixa4FR8icUWoX8Sw9Yeo2IffEsVrGlj5hmUwp
         YFRz4Uxx89hITvfDVUv6kqiiqf0+A+fQp0wl80BoELwQkGBWmriJROXK0xdTOGfriOMd
         AJXXQRv1z/rFKhtAi6Bn4Ihue7GUVVprNcA84iVcV+d0LCB1zrCk4jEWZGPxrJWksM9p
         /XrYamxUh5ohguwO27PpiHjnvdQvPGsLhujDHHy9OxxSzV0oaK/WJXOe2s4dPm2diWyv
         /Pmg==
Content-Disposition: inline
In-Reply-To: <20180109152115.GH3668920-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>

On Tue, Jan 09, 2018 at 07:21:15AM -0800, Tejun Heo wrote:
> From ceb2d2b2e496f180be95adb670337bb254f89323 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Tue, 9 Jan 2018 07:00:29 -0800
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit

Applied to cgroup/for-4.16.

Thanks.

-- 
tejun
