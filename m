From: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] memcg: refactor mem_cgroup_resize_limit()
Date: Sun, 4 Jun 2017 13:31:16 -0700
Message-ID: <20170604203116.GA19053@google.com>
References: <20170601230212.30578-1-yuzhao@google.com>
 <20170604200437.17815-1-yuzhao@google.com>
 <20170604200942.GA23523@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5SZf+IdvpHizblnjKIjVMlcx87YLF+nb68GEL3nYbag=;
        b=LuN2TAyimWYF4xoC9kAFHbGJRLStodfcbEeQPOLhrRb+S+vjehigLUitUzQDAG0SqP
         cURpYw/eR64XXHyc4/YDZlRSIVWaARoTXGiFusLr0XxzDoCBpx1RFuM7ptYNJdLDM+Gi
         8OG3i/mYYW/eBctEQGce7Uv7UIJrHQ4C4BMN2ssWIokONnPlCqLVPD7LOj/gBrgabj8B
         WPXPDJuLOO63R6tR0xGNKEE7L2PNS4ItYNPNe82xvcMBKNmxLd798eHJn4OLpnZR0VlV
         SJ5f6e5wYBa0UevAkcAXcOarAXMUpPyIesY2zXpM5LHWtYZ+9cdiJmVEdWdjrkvd5A/v
         T+5g==
Content-Disposition: inline
In-Reply-To: <20170604200942.GA23523@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, n.borisov.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Sun, Jun 04, 2017 at 11:09:42PM +0300, Vladimir Davydov wrote:
> On Sun, Jun 04, 2017 at 01:04:37PM -0700, Yu Zhao wrote:
> > @@ -2498,22 +2449,24 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
> >  		}
> >  
> >  		mutex_lock(&memcg_limit_mutex);
> > -		if (limit < memcg->memory.limit) {
> > +		inverted = memsw ? limit < memcg->memory.limit :
> > +				   limit > memcg->memsw.limit;
> > +		if (inverted)
> >  			mutex_unlock(&memcg_limit_mutex);
> >  			ret = -EINVAL;
> >  			break;
> >  		}
> 
> For some reason, I liked this patch more without this extra variable :-)
Well, I'll refrain myself from commenting more because we are now at
the risk of starting a coding style war over this.
