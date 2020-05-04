From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] memcg: oom: ignore oom warnings from memory.max
Date: Mon, 4 May 2020 07:57:05 -0700
Message-ID: <CALvZod5T9pYG1xVHqNM=c68jgKPVXtKjuvV0DSAR+Ld_Mm1c4A@mail.gmail.com>
References: <20200430182712.237526-1-shakeelb@google.com> <20200504065600.GA22838@dhcp22.suse.cz>
 <CALvZod5Ao2PEFPEOckW6URBfxisp9nNpNeon1GuctuHehqk_6Q@mail.gmail.com> <939b6744-6556-2733-b83e-bf14e848dabd@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KXTeEx6IisqAOCmfPVwDlnFlnDkJiSAj9MRHccmyI/s=;
        b=f1O7lCLc9F+EoW79NTRjesPk5eQ7p4Q7MnxAp+szu+ekyG67HHuZaHvrobdUzOqBlb
         yxPAcF6Rs6WCFXCs4xqx5LEJ4GGkKVujqbgVq9W4LCfPYWNecwVz+m0SBfRVrXYINYKo
         yLmS5ygJkWMdj3uUMxFXDwwSobIvM4pzAw1+2UFB5+XOnVwN0y9pLSOq4yTLfyX4xxav
         1BzzHnHZ096oMNL+SaMPBB0D7qGRTnxD13SNoNHNIILeSzitLEO2SFfMC1sVuuY8RJT+
         UZ58sL0B1Mzmxy6NSJbmzTax5111MpmwldblyZhlWiaGY/fMAkXVTB5bSCMQ4i9oDf3B
         nGPQ==
In-Reply-To: <939b6744-6556-2733-b83e-bf14e848dabd@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Mon, May 4, 2020 at 7:20 AM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> On 2020/05/04 22:54, Shakeel Butt wrote:
> > It may not be a problem for an individual or small scale deployment
> > but when "sweep before tear down" is the part of the workflow for
> > thousands of machines cycling through hundreds of thousands of cgroups
> > then we can potentially flood the logs with not useful dumps and may
> > hide (or overflow) any useful information in the logs.
>
> I'm proposing a patch which allows configuring which OOM-related messages
> should be sent to consoles at
> https://lkml.kernel.org/r/20200424024239.63607-1-penguin-kernel@I-love.SAKURA.ne.jp .
> Will that approach help you?

From what I understand, that patch is specifically for controlling
messages to consoles. The messages will still be in logs, right?
