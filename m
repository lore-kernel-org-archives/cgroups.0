From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] memcg: limit the number of thresholds per-memcg
Date: Wed, 7 Aug 2013 09:22:10 -0400
Message-ID: <20130807132210.GD27006@htj.dyndns.org>
References: <1375874907-22013-1-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jefXM4hjuPCAw3eQnr55F62dQ8eY53RzcYQRHKhx40U=;
        b=BmtjMLBReI797F+zBJ0X2/W3kG/7y8HmI7UEAgJ9TcuDm3SnPb/NjQCTHlAacnl902
         x5CF/m1w60tJzG60hu22DLuszrTD+iYyMi9R8gkhDeGieL5ZLOQYhB7w/9dX03RNOL/T
         ja/IwMZtP2S88/0Ga11NBqO7nbD2R+wjtVI2sHdJy5ZlavpnVjy8QcJvuRSLQUJAy9av
         Oww9rXYsWW9r+56UQTM7s55M8ToD1N2E6pb1Qu8XjthL30VVqRqGURTFek4CDd4jc/Lj
         UNNczPlFbyjhxtWcZ1qucqq/PnJUGnVPxQaMpIGLj5DSNWyXqQDcRQA6yWyXnlCXb18j
         gQ6w==
Content-Disposition: inline
In-Reply-To: <1375874907-22013-1-git-send-email-mhocko-AlSwsSmVLrQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Hello,

On Wed, Aug 07, 2013 at 01:28:25PM +0200, Michal Hocko wrote:
> There is no limit for the maximum number of threshold events registered
> per memcg. This might lead to an user triggered memory depletion if a
> regular user is allowed to register on memory.[memsw.]usage_in_bytes
> eventfd interface.
> 
> Let's be more strict and cap the number of events that might be
> registered. MAX_THRESHOLD_EVENTS value is more or less random. The
> expectation is that it should be high enough to cover reasonable
> usecases while not too high to allow excessive resources consumption.
> 1024 events consume something like 16KB which shouldn't be a big deal
> and it should be good enough.

I don't think the memory consumption per-se is the issue to be handled
here (as kernel memory consumption is a different generic problem) but
rather that all listeners, regardless of their priv level, cgroup
membership and so on, end up contributing to this single shared
contiguous table, which makes it quite easy to do DoS attack on it if
the event control is actually delegated to untrusted security domain,
which BTW kinda makes all these complexities kinda pointless as it
nullifies the only use case (many un-coordinated listeners watching
different thresholds) which the event mechanism can actually do
better.

A proper fix would be making it build sorted data structure, be it
list or tree, and letting each listener insert its own probe at the
appropriate position and updating the event generation maintain cursor
in the tree and fire events as appropriate, but given that the whole
usage model is being obsoleted, it probably isn't worth doing that and
this fixed limit is better than just letting things go and allow
allocation to fail at some point, I suppose.

Can you please update the patch description to reflect the actual
problem?

Thanks.

-- 
tejun
