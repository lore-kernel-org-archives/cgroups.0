From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] cgroup fixes for v4.15-rc7
Date: Mon, 8 Jan 2018 11:41:01 -0800
Message-ID: <CA+55aFyQu8wTOJ8HdUjRA2NnLLdXRPvPyEyaws=5VULVJrDSxg@mail.gmail.com>
References: <20180108145223.GS3668920@devbig577.frc2.facebook.com>
 <CA+55aFzLYgX5WVAFASH65LkTtvSbn_g6eibxe1Psoc1Uc2hFkw@mail.gmail.com>
 <CA+55aFxSbAJe9gnL7jXHUO8KzY8TbrvSt7+jWsTZTJt7EMMzuw@mail.gmail.com> <20180108192801.GZ3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=l+kVfxJdABp9bcmUOvhC4Kbf6DCVBrmHDoIR1bwoYFc=;
        b=osBb6yVa4pHGl6g6FNpvwi506xImIr5ah+ZSTCafb1xBJxBXd2vqZKN0NaLo1T0NBm
         Cc/Ieo1ut4CQuo7P8Yv+4LtmcrTB8bdhr/KMbnNOELOHrJOwFBW2rZ7UOfodp922V5p+
         2oK1fkAm4KWtMr1sHNTuOvNPdpsW2v+sqQHAjbB01XWWYzDaNrySqIuPB2a0exCTFsiW
         lLy3iNEFCFfMOmN5D3Kq+Lxug3H2VCuqr133T3xMwZoxMZjh3Yb16DxORfKJWWnhSWoi
         WGoccfYqpivd0dbrYfVpldQFAKB+FpTMsk5SNEMFNAc5uO1HfUXSh0x8OqbU7Se5UXmP
         IQHg==
In-Reply-To: <20180108192801.GZ3668920@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups <cgroups@vger.kernel.org>

On Mon, Jan 8, 2018 at 11:28 AM, Tejun Heo <tj@kernel.org> wrote:
>
> Dang, I was reading the different str*cpy() functions and suggested
> strscpy() and then forgot about it and blindly applied strlcpy()
> blindly after the build warning report.  It'd be great to weed out the
> useless ones.  These are places where truncation is fine.  Would the
> right thing to do be adding (void) in front, which is kinda ugly?

Yeah, I don't know. The actual code looks fine, and I pulled it, but I
really hate strlcpy().

Having us have extra warnings for strscpy() that turns people off from
using the right function is all kinds of sad.

I do think KASAN was unhappy about strscpy() too, because of the
word-at-a-time optimization (even if that one is very careful to not
cross pages etc).

Ho humm. I don't know what the right fix is. But I do suspect we
could/should just remove the __must_check from strscpy(), because one
of the points of that function really is that it always does the right
thing regardless of what you pass into it.

But some people absolutely love those idiotic warnings, even when they
demonstrably result in people writing worse code due to them.

Because "not checking error returns is a bug". Bah, humbug.

If just removing the __must_check makes cgroup happy, I would suggest
you send me a patch with that removal and the strlcpy turned back into
strscpy. Because I definitely _will_ apply such a patch.

                Linus
