From: Chen Gang <dsg_gchen_5257@sohu.com>
Subject: Re: [PATCH] mm: memcontrol: Let mem_cgroup_move_account() have effect
 only if MMU enabled
Date: Wed, 04 Mar 2015 04:01:04 +0800
Message-ID: <54F61300.1070409@sohu.com>
References: <54F4E739.6040805@qq.com> <20150303134524.GE2409@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150303134524.GE2409@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-mm@kvack.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chen Gang <762976180@qq.com>

On 3/3/15 21:45, Michal Hocko wrote:
> On Tue 03-03-15 06:42:01, Chen Gang wrote:
>> When !MMU, it will report warning. The related warning with allmodconfig
>> under c6x:
> 
> Does it even make any sense to enable CONFIG_MEMCG when !CONFIG_MMU?
> Is anybody using this configuration and is it actually usable? My
> knowledge about CONFIG_MMU is close to zero so I might be missing
> something but I do not see a point into fixing compile warnings when
> the whole subsystem is not usable in the first place.
> 

For me, only according to the current code, the original author assumes
CONFIG_MEMCG can still have effect when !CONFIG_MMU: "or, he/she needn't
use CONFIG_MMU switch macro in memcontrol.c".

Welcome any other members' ideas, too.

Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
