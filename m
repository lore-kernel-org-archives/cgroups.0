From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] memcg: remove unused mem_cgroup_from_obj()
Date: Sat, 27 May 2023 05:00:49 +0100
Message-ID: <ZHGAcaqOx/e8lqwV@casper.infradead.org>
References: <20230527103126.398267-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=a2xCe7O7+yP7S2jBW94Ky2TVFSCOtAAD8aGSKVZyuo8=; b=vtTBlbTiGVU/kW7m0r2iZikpWF
        uHBfF2vaPo90m14jsnj8E/gfDUNom13R2UQzaU9KK8HjdYfF+YfzCOsLAD/7giYmZfBf4Opg6+RpV
        kopdXnQtBJdG+sH/CJDrY0A5IYTbRoxymJVHlmEZVHQtSxyJ8cc6dwVIPuxkQkjfhyir+UY1GB9/3
        Bm1GXtLYPJhxL55jGH4HFVOO3u2Wm4u1QKsr2ZZs+hp4LQTCttR4KEecxjjypBV7hyDknRnrVIL0O
        7c8ufJqP4v2QyS/LZtTwwYojlqhYIBiX84U0Rf40AjON56IPWAfOj8X1EL8J2xsQCulIkFRstpunW
        1qhvegUg==;
Content-Disposition: inline
In-Reply-To: <20230527103126.398267-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, May 27, 2023 at 06:31:26PM +0800, Miaohe Lin wrote:
> The function mem_cgroup_from_obj() is not used anymore. Remove it and
> clean up relevant comments.

You should have looked at the git history to see why it was created
and who used it.

Shakeel, Vasily, are you going to retry adding commit 1d0403d20f6c?

