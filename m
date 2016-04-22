From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: relocate charge moving from ->attach to
 ->post_attach
Date: Fri, 22 Apr 2016 15:57:18 +0200
Message-ID: <20160422135718.GA19702@pathway.suse.cz>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160414175055.GA6794@cmpxchg.org>
 <20160415191719.GK12583@htj.duckdns.org>
 <20160417120747.GC21757@dhcp22.suse.cz>
 <20160421230648.GI4775@htj.duckdns.org>
 <20160421230902.GJ4775@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160421230902.GJ4775-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 2016-04-21 19:09:02, Tejun Heo wrote:
> Hello,
> 
> So, this ended up a lot simpler than I originally expected.  I tested
> it lightly and it seems to work fine.  Petr, can you please test these
> two patches w/o the lru drain drop patch and see whether the problem
> is gone?

The LTP test is running several hours without any problem with these
two patches. I double checked that I did not have the lru drain drop
patch. Therefore, these two patches solved the problem as well, so:

Tested-by: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>

Best Regards,
Petr
