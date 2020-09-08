From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: no one use charge_type
Date: Tue, 8 Sep 2020 09:13:58 +0100
Message-ID: <20200908081358.GA1219116@chrisdown.name>
References: <1599552727-60003-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=P9yS5F51D4ggPT5sO3CXtYZY7IS+3p8Fe7sC8hbp+FY=;
        b=WipNcCelKnPDX+MMC+RhYHhyl2r7Y/UQRpi+V6LeVgin7a8cii5jfnN1pOriG87xvp
         zGerNJ7TN0DiXyTm35s5RAKC+V3DizCPWXKhYU4HVpzcX2wLYDu5uMsY+yLElR5lBrcq
         Jh20reQOD0kigW2bW13BcgxQ8ldtiMwY6OxYo=
Content-Disposition: inline
In-Reply-To: <1599552727-60003-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Alex Shi writes:
>After commit 0a31bc97c80c3f mm: memcontrol: rewrite uncharge API, no one
>using MEM_CGROUP_CHARGE_TYPE_xxx, let's remove them.
>
>Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
>Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
>Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Acked-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
