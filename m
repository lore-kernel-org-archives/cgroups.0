From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v1 9/9] memcg: do not modify rstat tree for zero updates
Date: Tue, 28 Mar 2023 14:50:21 -0400
Message-ID: <ZCM27V3Z/Z9TD2zL@cmpxchg.org>
References: <20230328061638.203420-1-yosryahmed@google.com>
 <20230328061638.203420-10-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112; t=1680029423;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iZSVb7anGXXb5zwCrWYt7xgUpKRegbsbYrM5HxY90BU=;
        b=1QR4XjLLHLwM3Zmsgaw3zWAa78I3csLORy/e4VsQEXzXCtITlQVpm9CWPmkA6lEcIE
         l9vmq5KaRQWWkY58REzTUL7Y/u5ZvmJs1xya/EdeYG29I/YbohF5pbuCFsfRBDGYlfpa
         p4+KCJ7vkwLoJ30cObjArAxVzTagZEWVhWKhny11ej+ktXnisgks1Ea5bw54UXSAFUJP
         EZNJCkG8Zn+gP472ONOhnUlgPe0T6dvbJ34PIKUqkH13xcjMBzi1bU5dV74ngPS+pWrQ
         xUZz6BK/4anNdLHeDCltA0sRYmjomO3FLH8/SVTCua/HLKFTspSzgbYC2LJ0qTlNrcOp
         Y5Qw==
Content-Disposition: inline
In-Reply-To: <20230328061638.203420-10-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Tue, Mar 28, 2023 at 06:16:38AM +0000, Yosry Ahmed wrote:
> In some situations, we may end up calling memcg_rstat_updated() with a
> value of 0, which means the stat was not actually updated. An example is
> if we fail to reclaim any pages in shrink_folio_list().
> 
> Do not add the cgroup to the rstat updated tree in this case, to avoid
> unnecessarily flushing it.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
