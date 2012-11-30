From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/4] cgroup: warn about broken hierarchies only after
 css_online
Date: Fri, 30 Nov 2012 07:45:04 -0800
Message-ID: <20121130154504.GD3873@htj.dyndns.org>
References: <1354282286-32278-1-git-send-email-glommer@parallels.com>
 <1354282286-32278-2-git-send-email-glommer@parallels.com>
 <20121130151158.GB3873@htj.dyndns.org>
 <50B8CD32.4080807@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jmArzvexld//GZHZG2fztk0d566FhQpHOEvaIJj03iw=;
        b=DpsySHgU0uV4beRkjBhFp1sG9TvpVUbVnK2IuwtBHXEGvC28sjkq5xHZsD2xmu+Nns
         IJbcTqepJPnsw1n+Q5i5fIs62VuSXTNPemwqtywt8JZ4JDpFGvnSoeVqonIaHkqWPcjS
         G+Q/oODUE+8E71ZM/iwyLZgU0t9ar4lPBVHHXwcUbP3SaV0Ra/M7NG0+atH4vOwOLk5G
         gYdZxeshCayrHcA3A8zVbDGWYkDrwLC3z/xes57nu77/MpucKDf8BFUez3HapS5h0jYG
         53knNim594+Kkf2hldLRs9L/OBMV+AKi3VhJW711gqguzDfRLfeDx1dMl/pt9cfkYhWC
         rAiw==
Content-Disposition: inline
In-Reply-To: <50B8CD32.4080807-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Hello, Glauber.

On Fri, Nov 30, 2012 at 07:13:54PM +0400, Glauber Costa wrote:
> > Applied to cgroup/for-3.8.  Thanks!
> > 
> 
> We just need to be careful because when we merge it with morton's, more
> bits will need converting.

This one is in cgrou proper and I think it should be safe, right?
Other ones will be difficult.  Not sure how to handle them ATM.  An
easy way out would be deferring to the next merge window as it's so
close anyway.  Michal?

Thanks.

-- 
tejun
