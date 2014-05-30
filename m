From: Paolo Valente <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
Subject: Re: [PATCH RFC - TAKE TWO - 02/12] block, bfq: add full hierarchical scheduling and cgroups support
Date: Fri, 30 May 2014 23:49:18 +0200
Message-ID: <F08B1868-1355-40DF-B432-722FE0A3F9CC@unimore.it>
References: <20140528221929.GG1419@htj.dyndns.org> <1401354343-5527-1-git-send-email-paolo.valente@unimore.it> <1401354343-5527-3-git-send-email-paolo.valente@unimore.it> <20140530153718.GB24871@htj.dyndns.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140530153718.GB24871-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Fabio Checconi <fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Il giorno 30/mag/2014, alle ore 17:37, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> ha scritto:

> On Thu, May 29, 2014 at 11:05:33AM +0200, Paolo Valente wrote:
>> diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
>> index 768fe44..cdd2528 100644
>> --- a/include/linux/cgroup_subsys.h
>> +++ b/include/linux/cgroup_subsys.h
>> @@ -39,6 +39,10 @@ SUBSYS(net_cls)
>> SUBSYS(blkio)
>> #endif
>> 
>> +#if IS_ENABLED(CONFIG_CGROUP_BFQIO)
>> +SUBSYS(bfqio)
>> +#endif
> 
> So, ummm, I don't think this is a good idea.  Why aren't you plugging
> into the blkcg infrastructure as cfq does?  Why does it need to be a
> separate controller?
> 

It does not, actually. It is just that when we implemented that part, there was no blkcg infrastructure. After that, I have gone on experimenting with the low-latency heuristics and all the other stuff. Finally I have decided to first propose this new version of bfq, and then deal also with blkcg integration in case of a positive welcome.

Thanks,
Paolo

> Thanks.
> 
> -- 
> tejun


--
Paolo Valente                                                 
Algogroup
Dipartimento di Fisica, Informatica e Matematica		
Via Campi, 213/B
41125 Modena - Italy        				  
homepage:  http://algogroup.unimore.it/people/paolo/
