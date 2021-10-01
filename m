From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: unify memcg stat flushing
Date: Fri, 1 Oct 2021 10:29:13 -0400
Message-ID: <YVcbOZTQOTAKXzol@cmpxchg.org>
References: <20210930044711.2892660-1-shakeelb@google.com>
 <20210930044711.2892660-2-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DJs75BQaCW/g7pooRRj+6YO0ULlwMz3u2sNV5tiA/bM=;
        b=12f9ZN14mCgZ+mea7F6AapeGsomq5b/qDbcNfxZe76D96JIWEGlDkLQclucjiNxCER
         Pykd8tU79SFQM8L6xrigX5TEUjdEKChTRdTwmB6OPH6gCCIU9NVtzIzu0eZLv3xkLHCV
         uNuuIADIN040sWB1WYlgO5d4s+YLUIqo0SfGu/I4iP50M63j6rHIsaNJn4PFAwznaq1C
         oa60iWCS7UzYVFhUk0swK39HZ94r8v6wFNilzivbnZoyQhJ6or+govTF2UC3OIbYVsts
         AiZN/0uso7kEG44pjbDzm/rw6Kkd0agK1pN7/arZvdjziYQwcNlNvR0PqWpFKylS7sco
         0Ygw==
Content-Disposition: inline
In-Reply-To: <20210930044711.2892660-2-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Sep 29, 2021 at 09:47:11PM -0700, Shakeel Butt wrote:
> The memcg stats can be flushed in multiple context and potentially in
> parallel too. For example multiple parallel user space readers for memcg
> stats will contend on the rstat locks with each other. There is no need
> for that. We just need one flusher and everyone else can benefit. In
> addition after aa48e47e3906 ("memcg: infrastructure to flush memcg
> stats") the kernel periodically flush the memcg stats from the root, so,
> the other flushers will potentially have much less work to do.
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
