From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] string: drop __must_check from strscpy() and restore
 strscpy() usages in cgroup
Date: Fri, 19 Jan 2018 09:31:41 -0800
Message-ID: <20180119173141.GF3460072@devbig577.frc2.facebook.com>
References: <20180108145223.GS3668920@devbig577.frc2.facebook.com>
 <CA+55aFzLYgX5WVAFASH65LkTtvSbn_g6eibxe1Psoc1Uc2hFkw@mail.gmail.com>
 <CA+55aFxSbAJe9gnL7jXHUO8KzY8TbrvSt7+jWsTZTJt7EMMzuw@mail.gmail.com>
 <20180108192801.GZ3668920@devbig577.frc2.facebook.com>
 <CA+55aFyQu8wTOJ8HdUjRA2NnLLdXRPvPyEyaws=5VULVJrDSxg@mail.gmail.com>
 <20180109152115.GH3668920@devbig577.frc2.facebook.com>
 <20180119165044.GA3460072@devbig577.frc2.facebook.com>
 <CA+55aFxn2h8QN8gMbwm+43FjL0RapcmnS7gmsOR6610Dq=AHZQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1J4N1TlGLnrizIdZ2dO2JyftvSo9c/ZSRb+uQT24M2w=;
        b=GybklmulMd+Ov9wl2X8OMuVDhn3gEteLYnYRajcOwP7cHUUoH/vwOHvg9ZOY90ydYK
         K0i9SvEazJv4EW8hfNyk6fWSl0HuAO2rrgwbDk2vKPK/KPUwnda5qmQ5167CqJyGLOTQ
         R59UsZ2+bA6OSsgWvT67rDsUS1yWf7SS037W1YJ0F+9RLCrUVf2rPil9Bn6r3NmXdVaA
         /ixA9whXpxtdWMZCj+GHDVnceroDm4WYyjK7IcPLbWVp5C2S3VSv7axo+lnAGftUFRfS
         gz4fdIv6MVRW4puWaFMD0svid7zubWnZ31PrA4W6KJUiyI2Yw7o4eeSQ5oKkjJzIju3R
         Rqzw==
Content-Disposition: inline
In-Reply-To: <CA+55aFxn2h8QN8gMbwm+43FjL0RapcmnS7gmsOR6610Dq=AHZQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups <cgroups@vger.kernel.org>, Ma Shimiao <mashimiao.fnst@cn.fujitsu.com>, Arnd Bergmann <arnd@arndb.de>, Chris Metcalf <cmetcalf@ezchip.com>

Hello,

On Fri, Jan 19, 2018 at 09:27:50AM -0800, Linus Torvalds wrote:
> On Fri, Jan 19, 2018 at 8:50 AM, Tejun Heo <tj@kernel.org> wrote:
> >
> > Applied to cgroup/for-4.16.
> 
> I did still have it queued up, but I was looking at other issues, and
> hadn't gotten around to it. But if it's now in your git tree I can
> just drop this from my queue.

I see.  I'll push it your way together with other cgroup changes once
the merge window opens.

Thanks.

-- 
tejun
