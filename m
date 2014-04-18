From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: memcg with kmem limit doesn't recover after disk i/o causes limit
 to be hit
Date: Fri, 18 Apr 2014 22:37:09 +0400
Message-ID: <535170D5.9090006@parallels.com>
References: <20140416154650.GA3034@alpha.arachsys.com> <20140418155939.GE4523@dhcp22.suse.cz> <5351679F.5040908@parallels.com> <20140418182033.GA22235@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20140418182033.GA22235@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: Richard Davies <richard@arachsys.com>, cgroups@vger.kernel.org, linux-mm@kvack.org

18.04.2014 22:20, Michal Hocko:
> On Fri 18-04-14 21:57:51, Vladimir Davydov wrote:
>> In short, kmem limiting for memory cgroups is currently broken. Do not
>> use it. We are working on making it usable though.
> 
> Maybe we should make this explicit in both
> Documentation/cgroups/memory.txt and config MEMCG_KMEM help text.

Yeah, definitely. I'll send the patch.

Thanks.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
