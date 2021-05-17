From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] init/Kconfig: Fix BLK_CGROUP help text indentation
Date: Mon, 17 May 2021 11:36:09 +0100
Message-ID: <YKJHGbmRMcs/e+pm@infradead.org>
References: <20210516145731.61253-1-juergh@canonical.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5WpWqsmHNLWQc70bpUWhJIPOVl6gzN2zEoMJ15ENTac=; b=euTLqySvTY1oLnU3ssO7tDoule
        IstShSS2L0Gqd0ZjEr5FUbN1Q/Q+oVSqeI0hMwjHuqoH69qU7df/ui9pkiYtPQzMnd1+rF9qQ+pF0
        KSwW4ETdHVcVfMypNXly5zS0ncKO8GlfDu0Ng3Um5Ls9pzJqt9pval+I4O7j41gGVQQx4ViMaP9jE
        xEBByybdpEAsZrYa2bgOhTJN2Tf1u/kYTcFem6ybxSv9JvkXrJiMbsuictEXvnz2KDOXRNB0a/y4S
        J/Wu1WnpwnWZAOsrH+xRPbjvLZu14HxJ1v8tQWcaQF/J2nt+b15+t7gOvhBa6Baqoe57vIFjtp7iA
        Cz5GssVA==;
Content-Disposition: inline
In-Reply-To: <20210516145731.61253-1-juergh@canonical.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juerg Haefliger <juerg.haefliger@canonical.com>
Cc: tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Juerg Haefliger <juergh@canonical.com>

While you're at it, please move the symbol to block/Kconfig.
