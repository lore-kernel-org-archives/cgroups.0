From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] string: drop __must_check from strscpy() and restore
 strscpy() usages in cgroup
Date: Fri, 12 Jan 2018 11:38:18 -0800
Message-ID: <20180112193818.GM3460072@devbig577.frc2.facebook.com>
References: <20180108145223.GS3668920@devbig577.frc2.facebook.com>
 <CA+55aFzLYgX5WVAFASH65LkTtvSbn_g6eibxe1Psoc1Uc2hFkw@mail.gmail.com>
 <CA+55aFxSbAJe9gnL7jXHUO8KzY8TbrvSt7+jWsTZTJt7EMMzuw@mail.gmail.com>
 <20180108192801.GZ3668920@devbig577.frc2.facebook.com>
 <CA+55aFyQu8wTOJ8HdUjRA2NnLLdXRPvPyEyaws=5VULVJrDSxg@mail.gmail.com>
 <20180109152115.GH3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=h3Vw0vhxVzi+qjlNGw+fk1F6x2wuPMImh5Ah+8gbIQY=;
        b=tWIj5Gz2Lyxtl4OaxZE3xIb4PphKddGru9lunFj4vPG37UwEOWOXPSSdOTMwaWehlV
         PfjfNC4tWZpOykPQYF5uvQbG0RwbtdTzGneIqgLq/ivMe19VRAgimWDqHVT4ATtjgilu
         Sfxqx/TaPVwPg2K6vv1Nt0MJ2ym/0XCt5SB7gzAajMV+qYiLTX0IfKaN0kZ9eJCCcFcQ
         Xsb/+wMvLVbBtIp2lPtH32WSwzA7x9lZyjzJqe2xiSlLtU2bAHUcfwMQX/JX8Lp/fM0J
         nzTMLVw9bHDga212Rk+ECYr48F6xPaOCb6h3/urqJY3eGXOe3+FIsM/KTWlvSf0dHDu9
         iS2g==
Content-Disposition: inline
In-Reply-To: <20180109152115.GH3668920@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups <cgroups@vger.kernel.org>, Ma Shimiao <mashimiao.fnst@cn.fujitsu.com>, Arnd Bergmann <arnd@arndb.de>, Chris Metcalf <cmetcalf@ezchip.com>

Hello, Linus.

On Tue, Jan 09, 2018 at 07:21:15AM -0800, Tejun Heo wrote:
> From ceb2d2b2e496f180be95adb670337bb254f89323 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Tue, 9 Jan 2018 07:00:29 -0800
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> e7fd37ba1217 ("cgroup: avoid copying strings longer than the buffers")
> converted possibly unsafe strncpy() usages in cgroup to strscpy().
> However, although the callsites are completely fine with truncated
> copied, because strscpy() is marked __must_check, it led to the
> following warnings.

Do you want to pick up this patch?  If not, I can route it through
cgroup tree.

Thanks.

-- 
tejun
