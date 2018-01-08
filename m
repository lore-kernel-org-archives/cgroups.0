From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] cgroup fixes for v4.15-rc7
Date: Mon, 8 Jan 2018 11:23:03 -0800
Message-ID: <CA+55aFxSbAJe9gnL7jXHUO8KzY8TbrvSt7+jWsTZTJt7EMMzuw@mail.gmail.com>
References: <20180108145223.GS3668920@devbig577.frc2.facebook.com> <CA+55aFzLYgX5WVAFASH65LkTtvSbn_g6eibxe1Psoc1Uc2hFkw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=+m2+OJB21wGxK/hNF65UYL8vl/0xInXUGRRIJo6fA+U=;
        b=FPNZGJ7W2XfqUEVxZ1rw0PARb4x7qxruhhbMuC0zF4Y/DYhEl9qlHnrEbkMiKJ9TH9
         rD4SOw1+TYhuYiO1n13S0en1o5Dk9sKyxgqJD/TYZrSvOPYmXJcbMeXGT3sEiGF8WQy6
         ImRIhh28hLGze3L6CfpDHNYLHPV9jNF/aqjnryOIjHfzSM0+KKTSByVuYU7rQn8byaQS
         8i0POghOsaJXY38z+TQyjo0CQbDGZWLQekfI5XnTymhEFKt/dqKeyJhUEWdmLGf2ynMh
         ut4xnHjo3syXMXBihhm/DEMLY3RC97mAAER4jZWxCuXSodJwMwsN/jXNEZhRtc96Khlh
         ekyw==
In-Reply-To: <CA+55aFzLYgX5WVAFASH65LkTtvSbn_g6eibxe1Psoc1Uc2hFkw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups <cgroups@vger.kernel.org>

On Mon, Jan 8, 2018 at 11:20 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Use "strscpy()", which got this _right_.

Oh Christ.

It actually did that initially. And then it was changed to the broken
code due to some idiotic broken warning by tools that don't do the
right thing.

              Linus
