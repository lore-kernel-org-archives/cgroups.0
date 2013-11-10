From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET v2 cgroup/for-3.12] cgroup: make cgroup_event specific
 to memcg
Date: Sun, 10 Nov 2013 13:48:11 +0900
Message-ID: <20131110044811.GA25112@mtj.dyndns.org>
References: <1376582550-12548-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=aIomojl0SSrO4Dczh4frHYd0D8La1GrgfNT4sdwXI6A=;
        b=D1oxfckXITc8uqlwEHx2VRCdt4uxqwFZ/DmeEkgIpRCYRbA7gyXPZ//G44aIzYN4Qc
         NJm2DseTpFgRYZKP0A538QLN75JaTlVTCjztdONWVoCG+7++GWuWNiJ+uS1/MVK2pcYX
         wZhQ5TDNWQfmVHJepa2y6ggP6MP/HH/XVi23Ckjhux9xe3Esco3o84W+o7OCanRpzIlB
         f+J9rZxN7RsS9e3ZpNxlMMl8hDigLvgZt77RXFS8mvG/GJwlk5z1HUUNINnXq/UHJopB
         nQ/12ddfNx3N1jHtQZGP93haKyyWmLJAnojtPe7F+xrVth+h/U18adDHWpIBJZim6n1J
         vUgg==
Content-Disposition: inline
In-Reply-To: <1376582550-12548-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hey, guys.

I'll route this series through the cgroup tree with the acks added
once v3.13-rc1 drops.

Thanks.

-- 
tejun
