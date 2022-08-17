From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 6/9] mm/memcontrol: Replace the PREEMPT_RT conditionals
Date: Wed, 17 Aug 2022 12:59:14 -0400
Message-ID: <Yv0eYncQsOUpDZTn@cmpxchg.org>
References: <20220817162703.728679-1-bigeasy@linutronix.de>
 <20220817162703.728679-7-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=WgHvQWKtUk86nWWmj+kI8ABwb1icz9Fb44Hg1eLDOm8=;
        b=i0SAuQsKmPP0r4pTH16fQeqknam9+o/10fqWW30EL4nCBPXL779fGqyA8NRZNGCTkZ
         WfbnW65WxsqXerYMpkxbiMhm6XM1PI7FxXfeHc4CY06X9K05ptCeoq/IT9/HbNvnea/U
         v5DxsDBjBV5PtsP+Fj+JzUD05XdGBIpOR2Ai+7D+4T+FI+HBBg78Cmu+3KdjMkSykY6N
         3N5FrmiyjnyIbIYn1HBXF8fsk+LuKKXzs+QQCF8s3M9lcUunC/Sdr/XEW62NpNZrdVjh
         mZnWqSfao6avLdINn+/BdQyb/Fn0cRjbRaM67aNVItl7KpD9+4JbAnyEH/EikgTYz7zg
         C1MA==
Content-Disposition: inline
In-Reply-To: <20220817162703.728679-7-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Aug 17, 2022 at 06:27:00PM +0200, Sebastian Andrzej Siewior wrote:
> From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> 
> Use VM_WARN_ON_IRQS_ENABLED() and preempt_disable/enable_nested() to
> replace the CONFIG_PREEMPT_RT #ifdeffery.
> 
> Signed-off-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
