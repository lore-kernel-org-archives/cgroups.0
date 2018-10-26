From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] cgroup changes for v4.20-rc1
Date: Thu, 25 Oct 2018 17:16:41 -0700
Message-ID: <CAHk-=wgAHDD7gSOmM1EX_hOyef6_tBtoKT0H3p70f9zDKPzdDg@mail.gmail.com>
References: <20181025144029.GE4182586@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eptw+ZoNN1znnFanLIYW7GWriNq3uNAu7d4rCxtZ55w=;
        b=ND/0eDoSK9yb/l34zaQY77j0u/svhZQkSLY+t/BCwDvU7JGJgj83D4DxIxIb13URKx
         L0K8MUZlSaEuyCBnARk/N4E/i2Q6icqB8Z+EC4Yo/yohZToo4MAPeveYEqaciTRmNoUu
         xexeQ0ScM8qJzLsy5V7t/lBtek14YLiYp4y8o=
In-Reply-To: <20181025144029.GE4182586@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org

On Thu, Oct 25, 2018 at 7:40 AM Tejun Heo <tj@kernel.org> wrote:
>
> All trivial changes - simplification, typo fix and adding
> cond_resched() in a netclassid update loop.

Thanks, pulled,

                      Linus
