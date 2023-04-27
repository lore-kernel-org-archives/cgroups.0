From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 1/2] memcg: use seq_buf_do_printk() with
 mem_cgroup_print_oom_meminfo()
Date: Thu, 27 Apr 2023 09:55:25 +0900
Message-ID: <20230427005525.GF1496740@google.com>
References: <20230426133919.1342942-1-yosryahmed@google.com>
 <20230426133919.1342942-2-yosryahmed@google.com>
 <ZElCHJrkOVsy79KY@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1682556931; x=1685148931;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yudVX7H4NIkiNzJ9h/7v+Ix6+CQ48FCh3vdWg2CCa+Y=;
        b=lyo5HpmPPSKolKBMxnPM231JTOTMTYvltSMnwkbTvdMQxeRwrvOaTo//K+J0zWJYLK
         4/53gNTzI3i5Cxkomb16kK3VD2XaUWL5wSilFWJwDKWwddRdABcgiKcy0yHgG9grtzT+
         OmsXMqq0zQHNDZphrGnQvCMOGHRkMLS9q32Jc=
Content-Disposition: inline
In-Reply-To: <ZElCHJrkOVsy79KY@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, Sergey Senozhatsky <senozhatsky@chromium.org>, Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.com>, Chris Li <chrisl@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On (23/04/26 17:24), Michal Hocko wrote:
> No objection from me but is it possible that more printk calls (one per
> line with this change correct?) would add a contention on the printk
> path?

It probably will have opposite effect: console->write of longer lines
keep local IRQs disabled longer and keep console_waiter printk spinning
(in console_trylock_spinning()) longer.
