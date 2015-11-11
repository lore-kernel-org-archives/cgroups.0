From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 4/6] slab: add SLAB_ACCOUNT flag
Date: Wed, 11 Nov 2015 10:54:50 -0500
Message-ID: <20151111155450.GB6246@mtj.duckdns.org>
References: <cover.1447172835.git.vdavydov@virtuozzo.com>
 <1ce23e932ea53f47a3376de90b21a9db8293bd6c.1447172835.git.vdavydov@virtuozzo.com>
 <20151110183808.GB13740@mtj.duckdns.org>
 <20151110185401.GW31308@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=lV6HFFd5YDxaizDi4gRxhOdKafA7Nz4sDIA/383FV8A=;
        b=TybDFdvzGuuoilIJxWVkgUNqmO8Veii7oAfBj0Cqft51yTdiWya63YR89Zrt+rAGz4
         DIu4M1wFd9q1USeVoxv/n0o5t6jHCQ1V/BqtQ9ZYTFcEkB+7KkYoG8dS/9hVkhorJVLq
         GFoPnb76MeQ9m1zIexNbCR8nTOcfCMfbL0iE/rKraqxiTwWtTu28SlUVMrJgUGIzlOb0
         mfTh3fqOUNCr+xvZGJSj/s0kINEDTd4nd6mH1JFt9ibNhIXUSeaumsHM8Vmj60ccxrYT
         7qVb6Y896E1L9VjbZK1Qc5lqzz/0s9pS+sP1nLY2x5eDTCPObpP8/pQx8lTnHmls8etq
         G5MA==
Content-Disposition: inline
In-Reply-To: <20151110185401.GW31308@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Nov 10, 2015 at 09:54:01PM +0300, Vladimir Davydov wrote:
> > Am I correct in thinking that we should eventually be able to removed
> > __GFP_ACCOUNT and that only caches explicitly marked with SLAB_ACCOUNT
> > would need to be handled by kmemcg?
> 
> Don't think so, because sometimes we want to account kmalloc.

I'm kinda skeptical about that because if those allocations are
occassional by nature, we don't care and if there can be a huge number
of them, splitting them into a separate cache makes sense.  I think it
makes sense to pin down exactly which caches are memcg managed.  That
has the potential to simplify the involved code path and shave off a
small bit of hot path overhead.

Thanks.

-- 
tejun
