From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: memcg memory accounting in vmalloc is broken
Date: Thu, 7 Oct 2021 10:13:23 +0200
Message-ID: <YV6sIz5UjfbhRyHN@dhcp22.suse.cz>
References: <b3c232ff-d9dc-4304-629f-22cc95df1e2e@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633594403; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6kWPeAL5YdhKOgGiPm0d0ACf2LYS8mjdOECzh1wZutw=;
        b=SwzZDw98grNFIGy/1P65glPZG+dWl9idjalCyIqFu2qTCnRYtiatBwG3vqjPjLctW7ORql
        bbPf5k2lOY29DT+MUNU+fq9PAEA84G+KTQyuqB8/VUKqtedYbR7SCDZvfnMWKXc+lh2BIp
        /VEESlmkT/m7HLy9D2jbyCv3z5reyvE=
Content-Disposition: inline
In-Reply-To: <b3c232ff-d9dc-4304-629f-22cc95df1e2e-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Thu 07-10-21 11:04:40, Vasily Averin wrote:
> vmalloc was switched to __alloc_pages_bulk but it does not account the memory to memcg.
> 
> Is it known issue perhaps?

No, I think this was just overlooked. Definitely doesn't look
intentional to me.
-- 
Michal Hocko
SUSE Labs
