From: Richard Davies <richard@arachsys.com>
Subject: Re: Kernel crash triggered by dd to file with memcg, worst on btrfs
Date: Thu, 24 Apr 2014 11:59:33 +0100
Message-ID: <20140424105933.GD32011@alpha.arachsys.com>
References: <20140416174210.GA11486@alpha.arachsys.com>
 <20140423215852.GA6651@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140423215852.GA6651@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, Vladimir Davydov <vdavydov@parallels.com>

Michal Hocko wrote:
> Richard Davies wrote:
> > I have a test case in which I can often crash an entire machine by running
> > dd to a file with a memcg with relatively generous limits. This is
> > simplified from real world problems with heavy disk i/o inside containers.
...
> > [I have also just reported a different but similar bug with untar in a memcg
> > http://marc.info/?l=linux-mm&m=139766321822891 That one is not btrfs-linked]
...
> Does this happen even if no kmem limit is specified?

No, it only happens with a kmem limit.

So it is due to the kmem limiting being broken, as we discussed in the other
"untar" thread lined above.

> The kmem limit would explain allocation failures for ext3 logged below
> but I would be interested about the "Thread overran stack, or stack
> corrupted" message reported for btrfs. The stack doesn't seem very deep
> there. I would expect some issues in the writeback path during the limit
> reclaim but this looks quite innocent. Rulling out kmem accounting would
> be a good first step though . (I am keepinng the full email for Vladimir)

The btrfs problems only occur with a kmem limit. So this is also kmem-linked
even if that is surprising.

Richard.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
