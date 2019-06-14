From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 10/10] blkcg: implement BPF_PROG_TYPE_IO_COST
Date: Fri, 14 Jun 2019 07:52:39 -0700
Message-ID: <20190614145239.GA538958@devbig004.ftw2.facebook.com>
References: <20190614015620.1587672-1-tj@kernel.org>
 <20190614015620.1587672-11-tj@kernel.org>
 <e4d1df7b-66bb-061a-8ecb-ff1e5be3ab1d@netronome.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0HRENCM8//S+WGvQP1amFcQvEAKniYiMn7pbWKjyBdY=;
        b=TyVTGaOw5AtNg2y27QJA4f/taFVIo21wtfv0z2WUTclnFvohafgQjLOdGAtM5sZjXW
         adxtI18hJyHbxrjCmeTqI5/YcDHRTN18D/p+P3g7LxhBb9i/TZyjFv5ovj/yGzc9KUQA
         MbczNKRAp+ZOOgSP68Ob/KUtH/hvR53lN3fW4o5r3g0E2lgB3/KxZiKdQN+lhgVbdz5C
         UT+VL8iM+atG9nsnoEHBJwMm4lJ/iMsWfeLI/K00ZPAV5JToGPU8DtMi885Y5RptlX8k
         LSahdR7G3TjPGrSvg49LHEn6jf5N8lKBY2/FfkBq0ZysPLQoLvgJCeuCLpz9r+ImsZe9
         orgg==
Content-Disposition: inline
In-Reply-To: <e4d1df7b-66bb-061a-8ecb-ff1e5be3ab1d@netronome.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Quentin Monnet <quentin.monnet@netronome.com>
Cc: axboe@kernel.dk, newella@fb.com, clm@fb.com, josef@toxicpanda.com, dennisz@fb.com, lizefan@huawei.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, bpf@vger.kernel.org

Hello, Quentin.

On Fri, Jun 14, 2019 at 12:32:09PM +0100, Quentin Monnet wrote:
> Please make sure to update the documentation and bash
> completion when adding the new type to bpftool. You
> probably want something like the diff below.

Thank you so much.  Will incorporate them.  Just in case, while it's
noted in the head message, I lost the RFC marker while prepping this
patch.  It isn't yet clear whether we'd really need custom cost
functions and this patch is included more as a proof of concept.  If
it turns out that this is beneficial enough, the followings need to be
answered.

* Is block ioctl the right mechanism to attach these programs?

* Are there more parameters that need to be exposed to the programs?

* It'd be great to have efficient access to per-blockdev and
  per-blockdev-cgroup-pair storages available to these programs so
  that they can keep track of history.  What'd be the best of way of
  doing that considering the fact that these programs will be called
  per each IO and the overhead can add up quickly?

Thanks.

-- 
tejun
