From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: reset memory.low on css offline
Date: Mon, 29 Feb 2016 15:55:09 -0500
Message-ID: <20160229205509.GW3965@htj.duckdns.org>
References: <1456766193-16255-1-git-send-email-vdavydov@virtuozzo.com>
 <20160229200255.GA32539@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0IBQRvSz2anXkXOBm4dVHWLZBLnsgumDnGkCgD3D+hk=;
        b=01jWgT0ADrBSKZT1L2/MJ4wb6vQdDvIisC+U38TGxIgm4bMQSrHfJ0sArFipD/Jubn
         7ZuUuCJ5MSpE8fWqIotGZL9/T09HjdzesUdSqzxxhiJ50Dsu038/OhtXULCarDu7+tzl
         /ll6ZdVzJcsxY82lTOqkC5GM2q9zr3wEjIxxIKp1mG7rEU0Jat9CDi0vtuuZ4dRpDtjE
         xwEOkVnqVNwRTXUFY/0HwlQsaPV6KdnVve+OH79wlrO1B+hcWtIi0B7oMDtfA21FQYCN
         0xk44gBrcmoi7jD7xQA3WH7+adUUKKzhnv/KMIoQ/Sax5f3hdHGlUllu4J/HvELRarNq
         A8Hg==
Content-Disposition: inline
In-Reply-To: <20160229200255.GA32539-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Feb 29, 2016 at 03:02:55PM -0500, Johannes Weiner wrote:
> > To fix this, let's reset memory.low on css offline.
> 
> We already have mem_cgroup_css_reset() for soft-offlining a css - when
> the css is asked to be disabled but another subsystem still uses it.
> Can we just call that function during offline as well? The css can be
> around for quite a bit after the user deleted it. Eliminating *any*
> user-supplied configurations and zapping it back to defaults makes
> sense in general, so that we never have to worry about any remnants.

Hmmm... I wonder whether the behavior can be a bit surprising and it
could be better to simply let memcg offline callback to call the reset
function explicitly.  No big deal either way tho.  Please feel free to
send a patch.

Thanks.

-- 
tejun
