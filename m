From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Wed, 1 Feb 2023 13:41:16 +0100
Message-ID: <Y9pd7AxAILUSHrpe@dhcp22.suse.cz>
References: <20230125073502.743446-1-leobras@redhat.com>
 <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
 <Y9IvoDJbLbFcitTc@dhcp22.suse.cz>
 <Y9LDAZmApLeffrT8@tpad>
 <Y9LQ615H13RmG7wL@dhcp22.suse.cz>
 <0122005439ffb7895efda7a1a67992cbe41392fe.camel@redhat.com>
 <Y9j9BnMwfm4TJks7@tpad>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675255277; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pgarzvo5Cio7GL8GEMMFzzwnzoa+QoIct7DEsSsHtqA=;
        b=MWzo9/68aPfyUUKt0sBZONEVCQnB5Rnc7js3asZl1hGklDyD/kUD3l3yb52I05gyiwCGwJ
        FkltqazCB0qBi1IKYo4fWm7hphLeefGDPXjfrTgp8Qe/444/6AfB68SNhBTUfZhen1TiXu
        2Go0U87UliFst4DLvBn7AcwTkPETxhg=
Content-Disposition: inline
In-Reply-To: <Y9j9BnMwfm4TJks7@tpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 31-01-23 08:35:34, Marcelo Tosatti wrote:
[...]
> So it would be good to point out a specific problematic 
> testcase/scenario with using the spinlock in this particular case?

Please think about it some more. The sole purpose of the pcp charge
caching is to avoid atomics because the normal fast path (i.e. no limit
hit) is a page counter which is an atomic counter. If you go with a spin
lock for the pcp cache you are just losing some of the advantage of the
caching. Sure that would be a smaller atomics use than a deeper memcg
hierarchy but still.

Not to mention a potential contention which is hard to predict and it
will depend on the specific runtime very much. So not something that
would be easy to test for other than artificial testcases. Full cpu
pcp draining is not a very common operation and one could argue that
the problem will be limited but so far I haven't really heard any strong
arguments against the proposal to avoid scheduling the work on isolated
cpus which is a much more simpler solution and achieves the same
effect.
-- 
Michal Hocko
SUSE Labs
