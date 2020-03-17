From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 0/3] psi: cpu.pressure cgroup fix & MAINTAINERS update
Date: Tue, 17 Mar 2020 20:15:47 +0100
Message-ID: <20200317191547.GB20713@hirez.programming.kicks-ass.net>
References: <20200316191333.115523-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yPxwtY4LfExVxpDzfHXr7GQEO/vgYWIH/zIZe2qoAOE=; b=umHTDXgkFaTB4OqwY4d55ClRiP
        Kr99DlC04qMyaYow6Laz7AiSN4FjdZyNkfWzKp6nm2oi5EUMHs4Byxk6Dku2ViS5kTaaeZWDNQQXQ
        6NsF3RB36or1y5k1+EEtgIRE+o9bNX1QLFuFvx6l49SWQXBRo8nKWUklznS1e6a/PK+/LakU5jlvq
        INspuMGW4b8YFa4BC9YljnVd5cd+fZNRbdAUnq7Yeg3k6gqWx+SQI/1ZxfqqMcTbu89iKH234fbEl
        eK6EANKPelJ4+Dm+WKHPa4mth1Ro8weiIHEl/AwpMB4QWRcOmS9oPZw60wvQHZrWGtR94lttdycVJ
        mveQDAFw==;
Content-Disposition: inline
In-Reply-To: <20200316191333.115523-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Mar 16, 2020 at 03:13:30PM -0400, Johannes Weiner wrote:
> Hello Peter,
> 
> Patch 1 implements the cpu.pressure fix for cgroups we were looking at
> recently, 2 is the cgroup hierarchy walk optimization you proposed.
> 
> Patch 3 adds a MAINTAINER entry for psi, as at least one person tried
> looking for it and couldn't find it.
> 
> If they look alright to you, it'd be great to get them into 5.7.
> 
> Based on 5.6-rc6.

Thanks!
