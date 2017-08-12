From: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: kmemleaks reports a lot of cases around memcg_create_kmem_cache
Date: Sat, 12 Aug 2017 21:09:29 +0300
Message-ID: <20170812180929.6ht4pbnymrrd5dq7@esperanza>
References: <CANaxB-x=xgLq116VReo4Og+jFsAB+ehx3xThnXoCx8pR3YXPSA@mail.gmail.com>
 <20170702185017.ew5cn4altyw7nomi@esperanza>
 <20170705144743.GA19330@htj.duckdns.org>
 <CANaxB-xaHyyn=c8mJ8R8=k-kFJvW1a04MAuAdmS+V4KsjU84AQ@mail.gmail.com>
 <20170811173040.GB3005423@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l507NTdMxYShf65oJIL3g8zejDTdvz9uqT9FQSWZ38s=;
        b=r1shB0wPj/4vzyUfQXMK7mloCOzcIr/6hZ7ctXYoUOZ48RmvliqbSSx5nibOpM6TGJ
         CncE66GREJBKSQXO+GV/WHdiB5zhJoy/2W6/ThcsHcl2PFIJ61JZv6Ec4WkVQtQmq06m
         zMHnOKwT/bjHP9cqDfkkuP8T4RwDTntIkCMUWssUJCB3eCTII4OrRbd7IXd6sKTCksi0
         gQ5Jk3VUF1e+qJ4pmOKL+BidhL5FDDJidNE+JQ9StZMgXFXWjJTY61/eNsdZKMcZeciJ
         nL1kX+J0WdJ1jUm04NHBT/la2hmO8rz21ItLJ1JgBwWz0ywXipKyWhEczHM5v3PKeum1
         r1zg==
Content-Disposition: inline
In-Reply-To: <20170811173040.GB3005423-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Fri, Aug 11, 2017 at 10:30:40AM -0700, Tejun Heo wrote:
> On Mon, Aug 07, 2017 at 04:37:52PM -0700, Andrei Vagin wrote:
> > Hello Vladimir and Tejun,
> > 
> > This patch isn't in the Linus' tree. Could you do something to push it
> > into the upstream tree.
> 
> Vladimir, can you please resend the patch to Andrew Morton?

Sure.
