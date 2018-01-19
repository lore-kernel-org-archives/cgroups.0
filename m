From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] string: drop __must_check from strscpy() and restore
 strscpy() usages in cgroup
Date: Fri, 19 Jan 2018 09:35:39 -0800
Message-ID: <CA+55aFwtAfvuBpiDTvwzr8E43jk5y0ZRMAHS273K1Uv_RJNjRw@mail.gmail.com>
References: <20180108145223.GS3668920@devbig577.frc2.facebook.com>
 <CA+55aFzLYgX5WVAFASH65LkTtvSbn_g6eibxe1Psoc1Uc2hFkw@mail.gmail.com>
 <CA+55aFxSbAJe9gnL7jXHUO8KzY8TbrvSt7+jWsTZTJt7EMMzuw@mail.gmail.com>
 <20180108192801.GZ3668920@devbig577.frc2.facebook.com> <CA+55aFyQu8wTOJ8HdUjRA2NnLLdXRPvPyEyaws=5VULVJrDSxg@mail.gmail.com>
 <20180109152115.GH3668920@devbig577.frc2.facebook.com> <20180119165044.GA3460072@devbig577.frc2.facebook.com>
 <CA+55aFxn2h8QN8gMbwm+43FjL0RapcmnS7gmsOR6610Dq=AHZQ@mail.gmail.com> <20180119173141.GF3460072@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=2ziTjAOXMKPnT0rysjkhmuvFMLhv82zEUESek2H7WiA=;
        b=bZkhv3kDdB6qDUENRIqvw1wEQbKbJ06TulU3iE+wOLdfypffpSrWD65/Sr08k1EigM
         HNop2r8jgya1/sl5Xm7RHVjK58ZhdOGbjOtJPOzloFS5qtDSvJIb+0YPy8NqVHSo6wmj
         yJL4txvVSFS6MiLcfsaByuyxv/R6lj9eX/iy4tkyqSSId6/kfzumQBJodWVyzMMJKne2
         /HFUJ2xe7Kqc7EkxhRmBdgzIeGID8Y1cxuSNTDnRE/y56xV9zdDzoyKxSHisis46uOLg
         p5b9FxYT2f1R5vLfPf449W7B35WXeSZgBk3pEDW6yAMr45x3dTFVtxwmVC93BdLcdEuW
         iK8w==
In-Reply-To: <20180119173141.GF3460072-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>

On Fri, Jan 19, 2018 at 9:31 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> I see.  I'll push it your way together with other cgroup changes once
> the merge window opens.

NP. This was a fairly unusual late rc window. It's normally quiet this
period, but first I was distracted by some of the Spectre detail
discussions, and then we had a few other random odd things come in, so
instead of using this week for going through my queues, I was spending
it more on discussion.

But the strscpy patch makes just as much - or more - in the 5.16 merge
window anyway, so it's all good.

              Linus
