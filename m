From: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Subject: Re: [Resend PATCH 1/6] mm/memcg: warning on !memcg after readahead
 page charged
Date: Fri, 21 Aug 2020 10:01:43 -0400
Message-ID: <20200821140134.GA8147@lca.pw>
References: <1597144232-11370-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200820145850.GA4622@lca.pw>
 <20200821080127.GD32537@dhcp22.suse.cz>
 <20200821123934.GA4314@lca.pw>
 <20200821134842.GF32537@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cA1F72P9Gm2cautm1YaokGwNbN8rzVJerys9S7kz+dY=;
        b=nkPVH+Ovq+PbJXglpdeME9hid7vf1PM4g5XbkjiJo5EratmsU7t9cUuws/8svKmlrP
         EeJLdQjFqqNF2PsTU39YI7W6UsK8DFi1Nsy2Fsed4IO48Km3gUAjJBL70SSYLIFiXjHT
         apFxLWdt25F9C+P6lXRwJOvayqJmLTXwaQtRh7tn1NVJ1G7xJKl4g02yk1IOhlgJXpgE
         uhu72bWnmxOnt+jHNENMYLGGBUgmEqijytDjIXanSn7EPu572k+I6lEd46ZQ5uvzCaUz
         QOGQUAuwpZeIzffQ1NmA823BQb4J5ZlOOb2aQbwOMLeV5GUlsqBpF4j6iEl1YEtNCXX0
         Dl+A==
Content-Disposition: inline
In-Reply-To: <20200821134842.GF32537-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nao.horiguchi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, osalvador-l3A5Bk7waGM@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org

On Fri, Aug 21, 2020 at 03:48:42PM +0200, Michal Hocko wrote:
> On Fri 21-08-20 08:39:37, Qian Cai wrote:
> > On Fri, Aug 21, 2020 at 10:01:27AM +0200, Michal Hocko wrote:
> > > On Thu 20-08-20 10:58:51, Qian Cai wrote:
> > > > On Tue, Aug 11, 2020 at 07:10:27PM +0800, Alex Shi wrote:
> > > > > Since readahead page is charged on memcg too, in theory we don't have to
> > > > > check this exception now. Before safely remove them all, add a warning
> > > > > for the unexpected !memcg.
> > > > > 
> > > > > Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> > > > > Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> > > > 
> > > > This will trigger,
> > > 
> > > Thanks for the report!
> > >  
> > > > [ 1863.916499] LTP: starting move_pages12
> > > > [ 1863.946520] page:000000008ccc1062 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1fd3c0
> > > > [ 1863.946553] head:000000008ccc1062 order:5 compound_mapcount:0 compound_pincount:0
> > > 
> > > Hmm, this is really unexpected. How did we get order-5 page here? Is
> > > this some special mappaing that sys_move_pages should just ignore?
> > 
> > Well, I thought everybody should be able to figure out where to find the LTP
> > tests source code at this stage to see what it does. Anyway, the test simply
> > migrate hugepages while soft offlining, so order 5 is expected as that is 2M
> > hugepage on powerpc (also reproduced on x86 below). It might be easier to
> > reproduce using our linux-mm random bug collection on NUMA systems.
> 
> OK, I must have missed that this was on ppc. The order makes more sense
> now. I will have a look at this next week.

Sorry about not mentioning powerpc in the first place. I don't know since when
powerpc will no longer print out hardware information like x86 does in those
warning reports. I'll dig.
