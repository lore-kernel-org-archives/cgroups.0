From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: mainline build failure due to d1d4ff5d11a5 ("cgroup: put
 cgroup_tryget_css() inside CONFIG_CGROUP_SCHED")
Date: Sat, 2 Sep 2023 08:37:38 -0700
Message-ID: <CAHk-=wgmvf9OjxeiO7ZzN2hsmDZ7-HViP9AjQkRN84fuDXNATQ@mail.gmail.com>
References: <ZPMdTJ7zwrCkdMTu@debian>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1693669078; x=1694273878; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LqKOi6XeDft6JHIA0q1WMDUlAe87S892KnJGjksHzw4=;
        b=T2+qniJbJMdT6g+lEZ/gRb7HIjv3cAzfQ+3qGNh/H4lQ3Y7KUWDA7vJfRaNPlzd91p
         2YKWnAGlE2wooiWbMc+PKV8irlyqz1eIULvk0d7COUpt+y73oMLRQCwajEm7eEolqH7n
         0TmqXgR67mJPTsK/DscRzhjRcyAJn691d25C4=
In-Reply-To: <ZPMdTJ7zwrCkdMTu@debian>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, regressions@lists.linux.dev

On Sat, 2 Sept 2023 at 04:32, Sudip Mukherjee (Codethink)
<sudipm.mukherjee@gmail.com> wrote:
>
> git bisect pointed to d1d4ff5d11a5 ("cgroup: put cgroup_tryget_css() inside CONFIG_CGROUP_SCHED").

I pushed out a commit that should fix it (76be05d4fd6c: "cgroup: fix
build when CGROUP_SCHED is not enabled")

            Linus
