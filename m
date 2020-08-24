From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock
Date: Mon, 24 Aug 2020 11:42:04 -0700
Message-ID: <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598294526;
        bh=Nd2awSgpg3NOzIIw5/W9KTQlYTFQWu5lPKGtd3+FdgI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NOVxsxxfKZUuSkWhhaeTdPaLhuV4A66ePOhaJl3iuBe698JtvkFNo6oULxqlhRKP9
         go5x9qm6wtG2ewR1N11GC7U8IRi2+zLl5jsMqJbl1fpfY+Ehcgt4iV8yyI/eb7Q/wE
         BKPTYrXANG2WV2orZF5CadUwCkVAyb6/6Ktcz9Hg=
In-Reply-To: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com

On Mon, 24 Aug 2020 20:54:33 +0800 Alex Shi <alex.shi@linux.alibaba.com> wrote:

> The new version which bases on v5.9-rc2. The first 6 patches was picked into
> linux-mm, and add patch 25-32 that do some further post optimization.

32 patches, version 18.  That's quite heroic.  I'm unsure whether I
should merge it up at this point - what do people think?

> 
> Following Daniel Jordan's suggestion, I have run 208 'dd' with on 104
> containers on a 2s * 26cores * HT box with a modefied case:
> https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/tree/case-lru-file-readtwice
> With this patchset, the readtwice performance increased about 80%
> in concurrent containers.

That's rather a slight amount of performance testing for a huge
performance patchset!  Is more detailed testing planned?

