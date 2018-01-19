From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] string: drop __must_check from strscpy() and restore
 strscpy() usages in cgroup
Date: Fri, 19 Jan 2018 09:27:50 -0800
Message-ID: <CA+55aFxn2h8QN8gMbwm+43FjL0RapcmnS7gmsOR6610Dq=AHZQ@mail.gmail.com>
References: <20180108145223.GS3668920@devbig577.frc2.facebook.com>
 <CA+55aFzLYgX5WVAFASH65LkTtvSbn_g6eibxe1Psoc1Uc2hFkw@mail.gmail.com>
 <CA+55aFxSbAJe9gnL7jXHUO8KzY8TbrvSt7+jWsTZTJt7EMMzuw@mail.gmail.com>
 <20180108192801.GZ3668920@devbig577.frc2.facebook.com> <CA+55aFyQu8wTOJ8HdUjRA2NnLLdXRPvPyEyaws=5VULVJrDSxg@mail.gmail.com>
 <20180109152115.GH3668920@devbig577.frc2.facebook.com> <20180119165044.GA3460072@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=ltJ8p9hYIfyWUctrBR9zzSrJWMSPxexbQ1cgJSkyihU=;
        b=FHgQwx9XaGT7c0RcDv5oPKQLwNGprw5p5g6M0uI39QbvvkprfxCBh2f9Wwyj6AlzK0
         Ih/QaiSrxSk9z7dbCalMb6x6jpmqyTYf5zlvMMmZ0F13jQpb7xrKhkeUHrclZ9U0/Shs
         I3Jdkb9iZGsDbW+itr+mIkvpH7O1ayrkGWRlUbyWtlyJRXWy7P7+Z6V0g7GxB1ZdE0PW
         Pq1qwO8Ykhmy0vypNFaSLXpLzBQd9KzMyv62w+Kqy1Yb/GBJnUy8Tc7X9pKQ7PW3+3vf
         QuPyN8DogDfd79M0O9Uec1UgGkusQ774eQB7147xYizooTxkxkJnsrKVx0aQgUmn4gXy
         PA6w==
In-Reply-To: <20180119165044.GA3460072-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>

On Fri, Jan 19, 2018 at 8:50 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Applied to cgroup/for-4.16.

I did still have it queued up, but I was looking at other issues, and
hadn't gotten around to it. But if it's now in your git tree I can
just drop this from my queue.

Just as well. Thanks,

               Linus
