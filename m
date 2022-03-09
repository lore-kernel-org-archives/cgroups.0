From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/3] mm/memcg: add next_mz back if not reclaimed yet
Date: Wed, 9 Mar 2022 14:48:45 +0100
Message-ID: <YiiwPaCESiTuH22a@dhcp22.suse.cz>
References: <20220308012047.26638-1-richard.weiyang@gmail.com>
 <20220308012047.26638-3-richard.weiyang@gmail.com>
 <YicRNofU+L1cKIQp@dhcp22.suse.cz>
 <20220309004620.fgotfh4wsquscbfn@master>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646833726; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NmqS7ZxhbO47ovim+J2EyZsGVX8eOAA0CiaG2u3dAcc=;
        b=BSZiI8/V+gSeLNp9LUeQx5MnXFEY6ewbJlggU5HYnG40WdE7XcXePudKhmbmRTbtygeJC9
        iOBVRhuFi5Q4rgyxUSkYX8rD8+bYWIZ9UC3MahrzjLke+daGGuNFP5y9OnIUEbvN83izCC
        i+LQ38tRFvPwAYrdkfijL5a9j/s3VPU=
Content-Disposition: inline
In-Reply-To: <20220309004620.fgotfh4wsquscbfn@master>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

[Cc Tim - the patch is http://lkml.kernel.org/r/20220308012047.26638-3-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]

On Wed 09-03-22 00:46:20, Wei Yang wrote:
> On Tue, Mar 08, 2022 at 09:17:58AM +0100, Michal Hocko wrote:
> >On Tue 08-03-22 01:20:47, Wei Yang wrote:
> >> next_mz is removed from rb_tree, let's add it back if no reclaim has
> >> been tried.
> >
> >Could you elaborate more why we need/want this?
> >
> 
> Per my understanding, we add back the right most node even reclaim makes no
> progress, so it is reasonable to add back a node if we didn't get a chance to
> do reclaim on it.

Your patch sounded familiar and I can remember now. The same fix has
been posted by Tim last year
https://lore.kernel.org/linux-mm/8d35206601ccf0e1fe021d24405b2a0c2f4e052f.1613584277.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org/
It was posted with other changes to the soft limit code which I didn't
like but I have acked this particular one. Not sure what has happened
with it afterwards.
-- 
Michal Hocko
SUSE Labs
