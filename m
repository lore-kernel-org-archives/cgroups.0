From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 0/5] mm/memcg: Reduce kmemcache memory accounting
 overhead
Date: Thu, 15 Apr 2021 18:10:35 +0100
Message-ID: <20210415171035.GB2531743@casper.infradead.org>
References: <20210414012027.5352-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YwgbDheT+MJJ4trDHQZMYorZHJyXvzB0bzY8L8H53Zg=; b=pqDZ5QWhUwnCMzzTpH+57MdG8e
        g0vSEvFaeMGsKZ8bh0uo5UlIzHiiUgtJXiYwSvzacGqhh6T6NUMa7H0FmZtHyRyC3p6SM9J82c7nt
        wJ42qJWzFe26oOKJIu3NFrFYbbArdbYa6HooTaeAKc+NP3I6rczNl963yeZNi4aDr08izYDfRM3GD
        lb8BDY8K66PWBgEDvI5KTaFM7dI7gmB3dxzh0jphKMJR33jYTh5zvGwlqJWJriDwVOvk8EUzYHs4K
        WlLbiUz0IBvw1/FZNpfVY943UN1CCV+CB9CaByZSj9Jt8m13uHY+rBW34SoQuSqLRa7q6/dbT68+r
        T9a1b7tg==;
Content-Disposition: inline
In-Reply-To: <20210414012027.5352-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.x>

On Tue, Apr 13, 2021 at 09:20:22PM -0400, Waiman Long wrote:
> With memory accounting disable, the run time was 2.848s. With memory
> accounting enabled, the run times with the application of various
> patches in the patchset were:
> 
>   Applied patches   Run time   Accounting overhead   Overhead %age
>   ---------------   --------   -------------------   -------------
>        None          10.800s         7.952s              100.0%
>         1-2           9.140s         6.292s               79.1%
>         1-3           7.641s         4.793s               60.3%
>         1-5           6.801s         3.953s               49.7%

I think this is a misleading way to report the overhead.  I would have said:

			10.800s		7.952s		279.2%
			 9.140s		6.292s		220.9%
			 7.641s		4.793s		168.3%
			 6.801s		3.953s		138.8%

