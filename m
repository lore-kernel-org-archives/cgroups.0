From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: change memcg->oom_group access with atomic operations
Date: Mon, 20 Feb 2023 23:06:24 +0000
Message-ID: <20230220230624.lkobqeagycx7bi7p@google.com>
References: <20230220151638.1371-1-findns94@gmail.com> <Y/PhmEPc/qYeZ52T@P9FQF9L96D>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YmN4phAlQkhzlJhZTnkt2lPmMnV0UPOAfOT82kiHHdI=;
        b=fi/UHzhloZhXYA+Bx7TCopexrAPK2VRGIvfjdEkvebvlmvA7Vhlp9PfNoezaPzsbuV
         j1rR6Ma/LX95ho2r3qSmsrznFmm8x297iifdcowOAhWGE+ijcNKeo2ks7u1lyAF0Veza
         UdxKl4vDG/x6FlnVq/I8CHEE9/uSCXM62sF2Ov75EUQcHkSCdNfEh/OdaJaQ6NDx+zkN
         CDdxer4hj6ukRwtzKenR4RIhDTJi4m39HVdeYt6BKy2Emo/v/dLGc43ptginipQN3JcQ
         C7nmPm2P7N0E60CT5foRxvrRZp116dAaWLwq57rks/KBO8t7XPkHFneGSAByUlOK6gVZ
         Q8lA==
In-Reply-To: <Y/PhmEPc/qYeZ52T@P9FQF9L96D>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Feb 20, 2023 at 01:09:44PM -0800, Roman Gushchin wrote:
> On Mon, Feb 20, 2023 at 11:16:38PM +0800, Yue Zhao wrote:
> > The knob for cgroup v2 memory controller: memory.oom.group
> > will be read and written simultaneously by user space
> > programs, thus we'd better change memcg->oom_group access
> > with atomic operations to avoid concurrency problems.
> > 
> > Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Hi Yue!
> 
> I'm curious, have any seen any real issues which your patch is solving?
> Can you, please, provide a bit more details.
> 

IMHO such details are not needed. oom_group is being accessed
concurrently and one of them can be a write access. At least
READ_ONCE/WRITE_ONCE is needed here. Most probably syzbot didn't
catch this race because it does not know about the memory.oom.group
interface.
