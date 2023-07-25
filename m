From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: use rstat for non-hierarchical stats
Date: Tue, 25 Jul 2023 10:43:10 -0700
Message-ID: <20230725104310.ac652a03ab92357a162b1f92@linux-foundation.org>
References: <20230719174613.3062124-1-yosryahmed@google.com>
        <20230725140435.GB1146582@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690306992;
        bh=fu3IBUmM1hIiTky2e88ZAQ1t8ZP4sqKPRBI5GS1mp2k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xoVJF9/q0IT6pL9/yc5wwBX7EHfCwvlEl4/DiYssHgWeqQNMhcfXcGDzScpcyCIMd
         tlnZ8bZIOgFu+gE3EABqIhknibOnNkJ9hjO7Qa23BWJSdiOehqY3no7LPHsYODoLUE
         rXXfP+4vkrQHN/YDiIx2d2B+GU/qfbLduSUExjYY=
In-Reply-To: <20230725140435.GB1146582-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, 25 Jul 2023 10:04:35 -0400 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> But I want to be clear: this isn't a regression fix. It's a new
> performance optimization for the deprecated cgroup1 code. And it comes
> at the cost of higher memory footprint for both cgroup1 AND cgroup2.

Thanks.

Yosry, could you please send along a suitably modified changelog?
