From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 0/8] memory recharging for offline memcgs
Date: Thu, 20 Jul 2023 12:11:57 -1000
Message-ID: <ZLmxLUNdxMi5s2Kq@slm.duckdns.org>
References: <20230720070825.992023-1-yosryahmed@google.com>
 <20230720153515.GA1003248@cmpxchg.org>
 <ZLmRlTej8Tm82kXG@slm.duckdns.org>
 <CAJD7tkYhu3g9u7HkUTFBtT3Q4edVZ2g1TWV1FDcyM9srrYCBLg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689891120; x=1690495920;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yyk+1akDqEk5I4HX+iaGF6X13C0u0JYMqRauqkNOe8U=;
        b=NA0WXFjj0OpKZjyiDZaTzkQ3U0kUE85I86+6zcqR7zjTAjF17ktJr20AQoERxT02kC
         2fR/wGnihnbW7LuV1LCk6+1Q4OEhkBDZdXqa0IdN4HU8ynq+somylkYx14dr75Fx24k9
         CLBBCw7T3bJnCIx6Tr6zC2NqMGPq6pZ9oJLN8x9DS3fpqLvCo4/DxwBYqyOwzbdOyx5d
         XjbJleeCani28OQgN52POgHzpVfc5CqvCXovkl8WTPLRoOY2bBzjcLqQs6faAVYdXr5B
         nHATugm7zOyFNUl6WNEG6XkwJYQZUk+lNHVxDGzZ7zReCzBrHKbTxHmsauvt/8JV6eKR
         IWMA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAJD7tkYhu3g9u7HkUTFBtT3Q4edVZ2g1TWV1FDcyM9srrYCBLg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Zefan Li <lizefan.x@bytedance.com>, Yu Zhao <yuzhao@google.com>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Iurii Zaikin <yzaikin@google.com>, "T.J. Mercier" <tjmercier@google.com>, Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

Hello,

On Thu, Jul 20, 2023 at 02:34:16PM -0700, Yosry Ahmed wrote:
> > Or just create a nesting layer so that there's a cgroup which represents the
> > persistent resources and a nested cgroup instance inside representing the
> > current instance.
> 
> In practice it is not easy to know exactly which resources are shared
> and used by which cgroups, especially in a large dynamic environment.

Yeah, that only covers when resource persistence is confined in a known
scope. That said, I have a hard time seeing how recharding once after cgroup
destruction can be a solution for the situations you describe. What if A
touches it once first, B constantly uses it but C only very occasionally and
after A dies C ends up owning it due to timing. This is very much possible
in a large dynamic environment but neither the initial or final situation is
satisfactory.

To solve the problems you're describing, you actually would have to
guarantee that memory pages are charged to the current majority user (or
maybe even spread across current active users). Maybe it can be argued that
this is a step towards that but it's a very partial step and at least would
need a technically viable direction that this development can follow.

On its own, AFAICS, I'm not sure the scope of problems it can actually solve
is justifiably greater than what can be achieved with simple nesting.

Thanks.

-- 
tejun
