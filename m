From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: Re: [PATCH 2/4] mm: support nesting memalloc_use_memcg()
Date: Mon, 24 Aug 2020 13:13:14 -0400
Message-ID: <20200824171314.GA17113@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
References: <20200824153607.6595-1-schatzberg.dan@gmail.com>
 <20200824153607.6595-3-schatzberg.dan@gmail.com>
 <20200824161901.GA2401952@carbon.lan>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GaHc2bZckrs8e79oDtFVB7aLWMuGUzPJWwj4xMv5ZQ0=;
        b=sACWAqxr/VwqSbPYqQIyY1frS1wWBS77a9KLyRsBUtLvjhHrsnouo257CI/pZAU3NE
         HUToM7TEMwjOrJ5fQ8PE7xoK3iL68yjtoax+Fn1Bz/MIMoK1Pmdg1aWH2M5Zx5gbc5Nj
         vHMMGR6V44/vv023nXAYwemwySEZ1tzxw8Iu9QY/xZQ03pWZPdrL1LZGRv6aMAHv8dY8
         cWv9WjHc10HWc9Rjgfnt8zBZcMgIUFhQRNTFt/LqcqxFq3Anq8QSqkS+FSrTGsYc6/1J
         n438QmKE/gclk0V8c6ow5eP7xWRsU4Ldw1v/6UpgJvn//xaVZG2cTGULug7GOI42Ee+l
         bBTg==
Content-Disposition: inline
In-Reply-To: <20200824161901.GA2401952@carbon.lan>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Naresh Kamboju <naresh.kamboju@linaro.org>, Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Yang Shi <yang.shi@linux.alibaba.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Daniel Jordan <dan>

On Mon, Aug 24, 2020 at 09:19:01AM -0700, Roman Gushchin wrote:
> Hi Dan,
> 
> JFYI: I need a similar patch for the bpf memory accounting rework,
> so I ended up sending it separately (with some modifications including
> different naming): https://lkml.org/lkml/2020/8/21/1464 .
> 
> Can you please, rebase your patchset using this patch?
> 
> I hope Andrew can pull this standalone patch into 5.9-rc*,
> as Shakeel suggested. It will help us to avoid merge conflicts
> during the 5.10 merge window.
> 
> Thanks!

Yeah I mentioned it in the cover letter and linked to your patch. I
had not realized the naming change, so I can rebase on top of that -
I'll wait to see if there's other feedback first.
