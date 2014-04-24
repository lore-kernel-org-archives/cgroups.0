From: Michal Hocko <mhocko@suse.cz>
Subject: Re: Kernel crash triggered by dd to file with memcg, worst on btrfs
Date: Thu, 24 Apr 2014 14:26:07 +0200
Message-ID: <20140424122607.GA7644@dhcp22.suse.cz>
References: <20140416174210.GA11486@alpha.arachsys.com>
 <20140423215852.GA6651@dhcp22.suse.cz>
 <20140424105933.GD32011@alpha.arachsys.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140424105933.GD32011@alpha.arachsys.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Davies <richard@arachsys.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, Vladimir Davydov <vdavydov@parallels.com>

On Thu 24-04-14 11:59:33, Richard Davies wrote:
> Michal Hocko wrote:
> > Richard Davies wrote:
> > > I have a test case in which I can often crash an entire machine by running
> > > dd to a file with a memcg with relatively generous limits. This is
> > > simplified from real world problems with heavy disk i/o inside containers.
> ...
> > > [I have also just reported a different but similar bug with untar in a memcg
> > > http://marc.info/?l=linux-mm&m=139766321822891 That one is not btrfs-linked]
> ...
> > Does this happen even if no kmem limit is specified?
> 
> No, it only happens with a kmem limit.
> 
> So it is due to the kmem limiting being broken,

It still might be interesting to debug, because it suggests that some
caller doesn't cope with an allocation failure.

That being said, kmem accounting is broken for real life usage but
crashes produced in the limitted environment is still good to debug.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
