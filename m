From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: Set the correct memcg swappiness
 restriction
Date: Tue, 3 Aug 2021 13:25:55 -0700
Message-ID: <20210803132555.51b95495b453180060526cab@linux-foundation.org>
References: <d77469b90c45c49953ccbc51e54a1d465bc18f70.1627626255.git.baolin.wang@linux.alibaba.com>
        <YQOekWWgtZUfim4M@dhcp22.suse.cz>
        <6e6570d2-44a2-1da1-6c2a-38766786c40c@suse.cz>
        <02826fde-43a8-e20d-37f5-55416ba0c773@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628022356;
        bh=4UYyWRfegSMj4Y3aIRE3t+wlvCWreIb2YkpXno8GWJ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NpkXsJyLuV8Rto+fPBp/xHoG9B7ruK6eYb8Z7oC7u8GRdLsJ8QBsTlea5Zu7XVjQm
         3pQLDu6NvFJw5H/xSqZhv9tZxnC1zJjfwMf+lA5rOsFGOpIjr6s79ctI9TkBeCcLMW
         U29HEHnj0fUYAJCegoW4d70q9xfFl6TPyJZ8fn1I=
In-Reply-To: <02826fde-43a8-e20d-37f5-55416ba0c773-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 3 Aug 2021 23:45:20 +0800 Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:

> > So, also Fixes: c843966c556d ("mm: allow swappiness that prefers reclaiming anon
> > over the file workingset")
> > ?
> 
> Sure. Andrew, do I need resend it with adding fixes tag, or you can help 
> to add it? Thanks.

I added the Fixes tag, thanks.
