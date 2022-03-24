From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: introduce proportional protection on memcg
Date: Thu, 24 Mar 2022 10:27:43 -0400
Message-ID: <Yjx/3yi7BfH7wLPz@chrisdown.name>
References: <1648113743-32622-1-git-send-email-zhaoyang.huang@unisoc.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qyHFfaKBiNo+/JYUdPZLsqKFQcJgYWqH70R3hhuOnaE=;
        b=qgoHbDGhJ13cJiR+oXZgVdrFHi6Zu/n9ZKB9HjZBjfyUHv5uKHtqMCrKRxjCMjYl5Q
         8dbe+R9r0IZX3IPjqQuKEwkrxvty1wAhDHJSTXM3131i0GKN8+E8x9379OqRC1IH8b8x
         FEiX/fW2f4M9t7MsvjacIgGvlG6mk9ntoYg28=
Content-Disposition: inline
In-Reply-To: <1648113743-32622-1-git-send-email-zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ke wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I'm confused by the aims of this patch. We already have proportional reclaim 
for memory.min and memory.low, and memory.high is already "proportional" by its 
nature to drive memory back down behind the configured threshold.

Could you please be more clear about what you're trying to achieve and in what 
way the existing proportional reclaim mechanisms are insufficient for you?
