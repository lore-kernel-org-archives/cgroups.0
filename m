From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC PATCH] memcg: use root_mem_cgroup when css is inherited
Date: Thu, 25 Aug 2022 09:35:00 -0400
Message-ID: <Ywd6hN1Q9MtQWZCp@cmpxchg.org>
References: <YwS/S9Sd1OWnT81Q@dhcp22.suse.cz>
 <CAGWkznGYLyF+njUB0gFF3JVdThnK9JaNsqxXYFhbdSwEQpCxvA@mail.gmail.com>
 <YwXYVjRpXQjQMsxr@dhcp22.suse.cz>
 <CAGWkznEqX3DwHW_owiK+HuuQ-HsUYK4vKmLhSxgzGn20Vzid2A@mail.gmail.com>
 <YwX89JCQCKMMYdG9@dhcp22.suse.cz>
 <CAGWkznF+dBjLzAxMMXWYSZ_5q3KA-ou0P7XM7jSYN7JSRp8N0w@mail.gmail.com>
 <YwcZctA2S3Sd0LBN@dhcp22.suse.cz>
 <CAGWkznH5gQXigdLx=fwdL0uqdGx4WE9QP8b8cbWFxr=Rdg-CZQ@mail.gmail.com>
 <Ywc34ci5XUMXOSYA@dhcp22.suse.cz>
 <CAGWkznHL_G3OoAc5gJ+iwxqxonr21-fU+F4T2gkpXH68keLpuQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=maHy+RdG1bfZFcMYc9WoBOBgcyZgJzrvT/br9of5/VU=;
        b=ki59yMmI7FCk8x3aODpep64NKP8t1/4KYxMTUMMmwXZzS7FTFF7NyXtV3OQEzwBO8i
         ixy2Ie3yBDN6MY9J6oh5ohKreOhyo4exnqAFtyDKyGIlmMEoYYKv5UvuVW3BpzpK3A8u
         A+7XL429LMEIxpIIwyJTOz0NA8se0/inNDugUuas2ut7vqjWuB5zrL1DUwzw8tv87ahu
         2nJ5bjWNidheTYWOAkK5DgmkK9F9z7cyBalUhH9epPhy73xf2ROJwaJA5xylPX1yvZrl
         l+q1P0cdFMUVBHTnZXGgW0s8vq3N5rLVszPhTP+7mm1iaK128FV3V6UVbyj1gmG9ENDu
         JRJg==
Content-Disposition: inline
In-Reply-To: <CAGWkznHL_G3OoAc5gJ+iwxqxonr21-fU+F4T2gkpXH68keLpuQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Thu, Aug 25, 2022 at 06:11:09PM +0800, Zhaoyang Huang wrote:
> Sorry for any misunderstanding among the discussion. My purpose is
> real and simple as I have stated from the very beginning that I would
> like to have per-app cgroup hierarchy to charge memory to root if it
> is not enabled explicitly for memory. The reason has also been stated
> like reclaim and workingset regression in suren's report. I don't
> think my proposal will do any harm to current v2's mechanism besides
> asking for the admin echo "+memory" to their desire group.

It would permit children to escape parental control, completely
breaking the hierarchy and delegation guarantees currently in
place. That just isn't going to happen.

Nacked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

I would suggest focusing on finding the root cause for the reclaim
problem you are describing. It's possible all we need is a fix to
reclaim or the workingset code.
