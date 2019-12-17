From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm: memcontrol.c: move mem_cgroup_id_get_many under
 CONFIG_MMU
Date: Tue, 17 Dec 2019 14:37:20 +0000
Message-ID: <20191217143720.GB131030@chrisdown.name>
References: <20191217135440.GB58496@chrisdown.name>
 <392D7C59-5538-4A9B-8974-DB0B64880C2C@lca.pw>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UOW3PJT7DR1Clt88oSFTkiVAEW1rUNAQCHLVMZndGtA=;
        b=rd71+yX/Y3zYrvfVV0ocR9HmI+QhbtozLkZX8U/xhZ3MvWkP8M45IIwe5JLcvFqmx4
         eU1/11ACeoRAG78LOllpOsqgjuF8jIsHETbh7DAYF19cesIvYRXneiL9fkYUdL1NIFkE
         aAi8jir3zKgxfr1bqJHDJx8czIhCWivZvyMl4=
Content-Disposition: inline
In-Reply-To: <392D7C59-5538-4A9B-8974-DB0B64880C2C@lca.pw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Qian Cai <cai@lca.pw>
Cc: Michal Hocko <mhocko@kernel.org>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Qian Cai writes:
>__maybe_unused should only be used in the last resort as it mark the compiler 
>to catch the real issues in the future. In this case, it might be better just 
>ignore it as only non-realistic compiling test would use !CONFIG_MMU in this 
>case.

While that's true, I'd rather not end up with getting more patches based on 
tests like these. On balance the risk of adding __maybe_unused here with a note 
to remove it later seems better than having to reply to every patch removing 
warnings :-)

I struggle to imagine a real issue this would catch that wouldn't already be 
caught by other means. If it's just the risks of dead code, that seems equally 
risky as taking time away from reviewers.

We should probably also review the coding style doc again, since this looks 
suspect:

>If you have a function or variable which may potentially go unused in a
>particular configuration, and the compiler would warn about its definition
>going unused, mark the definition as __maybe_unused rather than wrapping it in
>a preprocessor conditional.  (However, if a function or variable *always* goes
>unused, delete it.)
