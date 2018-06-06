From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] cgroup changes for v4.18-rc1
Date: Wed, 6 Jun 2018 08:14:27 -0700
Message-ID: <CA+55aFy=a3nm+r7462mLq4D6eDxDsPXUO3_tviT=DqJPsohx5A@mail.gmail.com>
References: <20180605192157.GG1351649@devbig577.frc2.facebook.com>
 <CA+55aFzWdPavAPC--MY15RgwvU1QYgF+Uy7rMJmx2Dr3ddJdsQ@mail.gmail.com> <20180606150438.GM1351649@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hyv3VitDUAJRxJsCsDfD3Bi/4Pbfw3+Q8HNyDpeKqhw=;
        b=Kq1hKLkw4aAFIw6araKKk2DRz+k7J21F7GBg9fDt0M6OuiYSprU458laE5jci/p4bX
         Zm9MtBtvw2iFkrcBh18SYtGDU7FFv6fdjClti81OFq0R2ygknXTnwvOzJDIXLSnD01Tp
         sSozxxRud2YEVIYL43fvywkZAuuvASGn2wTYE=
In-Reply-To: <20180606150438.GM1351649@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups <cgroups@vger.kernel.org>

On Wed, Jun 6, 2018 at 8:04 AM Tejun Heo <tj@kernel.org> wrote:
>
> The notification implementation isn't super light weight, so the patch
> ratelimits the notifications by capping minimum notification interval
> interval to 10ms.

Yeah, I looked at the patch (and the code) to make sense of the explanation.

My reaction to that was that it might be a better idea to simply not
notify if a notification was already pending, rather than have the
timeout. Or perhaps in addition to. The path _to_ the fsnotify code
looked quite messy, though.

             Linus
