From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] cgroup fixes for v4.15-rc7
Date: Mon, 8 Jan 2018 11:28:01 -0800
Message-ID: <20180108192801.GZ3668920@devbig577.frc2.facebook.com>
References: <20180108145223.GS3668920@devbig577.frc2.facebook.com>
 <CA+55aFzLYgX5WVAFASH65LkTtvSbn_g6eibxe1Psoc1Uc2hFkw@mail.gmail.com>
 <CA+55aFxSbAJe9gnL7jXHUO8KzY8TbrvSt7+jWsTZTJt7EMMzuw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Juch20WmN0Q9ri5stovJSxrGKmKXTIaci9vHNj8DQpY=;
        b=l+DlOATcjImPcz7cNWqhSYR+GWRIXcg5yPymtbT8Z+/86keiAAUExWqhmwAFo0sgLa
         iI1WuhMPBRJSBtkqMrwl7v32GTP11Uzd+2p0LEKNGopi5BjPwV1GHWXAg6CxCsoCbTl6
         Lvk/KcgWBigYXDZBjNduenPbX5LK7YXqyyIc2syZQPOKEfvlBhROJly4ZAYMkNkDQCTw
         bZu4zlebR3nvhikw9EkwjalBEB/mtCkGiNgxaDteqdSM5mr9YBoYPPWvtNAOW+DxBFzQ
         qKOAhwUmN8FXeAEX/8Y/NyDved/8pJ4uEI0SitgZ96NU0mZPShVUc8NgQa5Bkepq76zf
         5EmQ==
Content-Disposition: inline
In-Reply-To: <CA+55aFxSbAJe9gnL7jXHUO8KzY8TbrvSt7+jWsTZTJt7EMMzuw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jan 08, 2018 at 11:23:03AM -0800, Linus Torvalds wrote:
> On Mon, Jan 8, 2018 at 11:20 AM, Linus Torvalds
> <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> >
> > Use "strscpy()", which got this _right_.
> 
> Oh Christ.
> 
> It actually did that initially. And then it was changed to the broken
> code due to some idiotic broken warning by tools that don't do the
> right thing.

Dang, I was reading the different str*cpy() functions and suggested
strscpy() and then forgot about it and blindly applied strlcpy()
blindly after the build warning report.  It'd be great to weed out the
useless ones.  These are places where truncation is fine.  Would the
right thing to do be adding (void) in front, which is kinda ugly?

Thanks.

-- 
tejun
