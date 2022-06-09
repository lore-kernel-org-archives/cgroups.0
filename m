From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [cgroup] 3c87862ca1:
 WARNING:at_kernel/softirq.c:#__local_bh_enable_ip
Date: Thu, 9 Jun 2022 16:55:49 +0200
Message-ID: <20220609145549.GA28484@blackbody.suse.cz>
References: <20220609085641.GB17678@xsang-OptiPlex-9020>
 <b39cdb9c-aa2a-0f49-318b-8632b2989433@linaro.org>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654786551; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OP+FCzdv75xf3AHqKnJ+4LChpmPuksRBqF0JcYhkehA=;
        b=SQObC06khT/SS84YZt1lyljm9Cr5+NeogHGlZxt5pxfF9ZvnQLukKnj55bh+5fUCYBr7Yi
        NlraG861F/YQs96MkzjDx/3/U+FfUtp5HlV7liTe3y13/Ld9SWoy9qp1WgypBmB1npDRMw
        KIkohhqcvxF2/4K0d+30WALHcLZjlZg=
Content-Disposition: inline
In-Reply-To: <b39cdb9c-aa2a-0f49-318b-8632b2989433@linaro.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tadeusz Struk <tadeusz.struk@linaro.org>
Cc: kernel test robot <oliver.sang@intel.com>, 0day robot <lkp@intel.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, lkp@lists.01.org, netdev@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org, syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com

Hello Tadeusz.

On Thu, Jun 09, 2022 at 07:30:41AM -0700, Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
> Are you interested in fixing this at syzbot issue all?

The (original) syzbot report is conditioned by allocation failure that's
unlikely under normal conditions (AFAIU). Hence I don't treat it extra
high urgent.
OTOH, it's interesting and it points to some disparity worth fixing --
so I try helping (as time permits, so far I can only run the reproducers
via the syzbot).

> Do you have any more feedback on this?

Ad the patch v2 with spinlock per css -- that looks like an overkill to
me, I didn't look deeper into it.

Ad the in-thread patch with ancestry css_get(), the ->parent ref:
  - is inc'd in init_and_link_css(),
  - is dec'd in css_free_rwork_fn()
and thanks to ->online_cnt offlining is ordered (child before parent).

Where does your patch dec these ancestry references? (Or why would they
be missing in the first place?)

Thanks for digging into this!
Michal
