From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH cgroup/for-6.6-fixes] cgroup: Put cgroup_local_stat_show()
 inside CONFIG_CGROUP_SCHED
Date: Sat, 2 Sep 2023 08:45:45 -0700
Message-ID: <CAHk-=wha+VT3yC3BKS1046GpuH2JRPER+_MXVu_Z1V2K1Ja6Dw@mail.gmail.com>
References: <ZPMdTJ7zwrCkdMTu@debian> <ZPNX-jZAZbebizXA@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1693669563; x=1694274363; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sTVrfuoyyUEeTTw7w2mP5y9qGCPLtPAJX6CEnNqN/W4=;
        b=FB26Ycyu1cIsGTT9LUlS0ZkxWIET1Sa9jO8UKaxF26Ic0C9E/xBPy77hRRguAAg0CI
         Nat2q/FVG9Pw+4rBvU4Zn/qnCuNkzVXd1pnnpE9q5+tZNuZB+6WCSQEVx4E6WkAse+Dq
         2ZzA5qgv2e0eIZgyijtApB5G58rh0LlmL/p24=
In-Reply-To: <ZPNX-jZAZbebizXA@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, regressions@lists.linux.dev

On Sat, 2 Sept 2023 at 08:42, Tejun Heo <tj@kernel.org> wrote:
>
> Sorry about that. This should fix it. Guess nobody is building linux-next w/
> !CONFIG_CGROUP_SCHED. I'll send the pull request to Linus soon.

I solved it slightly differently by moving the whole function around
rather than adding yet another #ifdef.

See 76be05d4fd6c ("cgroup: fix build when CGROUP_SCHED is not enabled")

                Linus
