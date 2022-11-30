From: Tao pilgrim <pilgrimtao@gmail.com>
Subject: Re: [PATCH] mm: memcontrol: protect the memory in cgroup from being
 oom killed
Date: Wed, 30 Nov 2022 19:33:01 +0800
Message-ID: <CAAWJmAYPUK+1GBS0R460pDvDKrLr9zs_X2LT2yQTP_85kND5Ew@mail.gmail.com>
References: <20221130070158.44221-1-chengkaitao@didiglobal.com> <fd28321c-5f00-ba94-daed-2b8da2292c1f@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bbgF/8QJth7Q6iZLlIiOpcOOnk+o4nClIAC+d8Lf9z0=;
        b=cgrBYVcGGaOmhs4NUM2DMBzEteSqsnNo+s1OWAu0xrFfR8SfGHhoYWl6cON5bJQf5H
         kBXo+HTMLYJlc0NNqyXTeNHVsKFqrN9RnSJvYMAt9wsTzoHjoBDz54HyrId55uPzhcey
         WrkHDI90HmJoIfjTMzlxSFuMRM+ZEK+h+tp2CXCTYTjqjx+4Ho1p2q1qT5Xh0Pe1NIpw
         kh3Ph4481EH6HJsaTRzldrzwYx9ab3Q4uT9o4p32qRaA2tLn+Hf0w3FMTq1prgn3d5jp
         NtxVXq9wW/MEdgV2FWkhhU7TsMvsvlWqvebJsqA+xk8HaXGX4H+zuKYU5RX6czhqRUDe
         TW5g==
In-Reply-To: <fd28321c-5f00-ba94-daed-2b8da2292c1f@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, akpm@linux-foundation.org, songmuchun@bytedance.com, cgel.zte@gmail.com, ran.xiaokai@zte.com.cn, viro@zeniv.linux.org.uk, zhengqi.arch@bytedance.com, ebiederm@xmission.com, Liam.Howlett@oracle.com, chengzhihao1@huawei.com, haolee.swjtu@gmail.com, yuzhao@google.com, willy@infradead.org, vasily.averin@linux.dev, vbabka@suse.cz, surenb@google.com, sfr@canb.auug.org.au, mcgrof@kernel.org, sujiaxun@uniontech.com, feng.tang@intel.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, chengkaitao@didiglobal.com

On Wed, Nov 30, 2022 at 4:41 PM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
>
> On 11/30/22 14:01, chengkaitao wrote:
> > From: chengkaitao <pilgrimtao@gmail.com>
> >
>
> Yikes! Another patch from ZTE guys.
>
> I'm suspicious to patches sent from them due to bad reputation with
> kernel development community. First, they sent all patches via
> cgel.zte@gmail.com (listed in Cc) but Greg can't sure these are really
> sent from them ([1] & [2]). Then they tried to workaround by sending
> from their personal Gmail accounts, again with same response from him
> [3]. And finally they sent spoofed emails (as he pointed out in [4]) -
> they pretend to send from ZTE domain but actually sent from their
> different domain (see raw message and look for X-Google-Original-From:
> header.

Hi Bagas Sanjaya,

I'm not an employee of ZTE, just an ordinary developer. I really don't know
all the details about community and ZTE, The reason why I cc cgel.zte@gmail.com
is because the output of the script <get_maintainer.pl> has the
address <cgel.zte@gmail.com>.

If there is any error in the format of the email, I will try my best
to correct it.

>
> I was about to review documentation part of this patch, but due to
> concerns above, I have to write this reply instead. So I'm not going
> to review, sorry for inconvenience.
>
> PS: Adding Greg to Cc: list.
>
> [1]: https://lore.kernel.org/lkml/Yw94xsOp6gvdS0UF@kroah.com/
> [2]: https://lore.kernel.org/lkml/Yylv5hbSBejJ58nt@kroah.com/
> [3]: https://lore.kernel.org/lkml/Y1EVnZS9BalesrC1@kroah.com/
> [4]: https://lore.kernel.org/lkml/Y3NrBvIV7lH2GrWz@kroah.com/
>
> --
> An old man doll... just what I always wanted! - Clara
>


-- 
Yours,
Kaitao Cheng
