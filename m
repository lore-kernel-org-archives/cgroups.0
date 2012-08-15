From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v2 06/11] memcg: kmem controller infrastructure
Date: Wed, 15 Aug 2012 18:27:45 +0400
Message-ID: <502BB1E1.5080403@parallels.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-7-git-send-email-glommer@parallels.com> <20120814172540.GD6905@dhcp22.suse.cz> <502B6F00.8040207@parallels.com> <20120815130952.GI23985@dhcp22.suse.cz> <502BABCF.7020608@parallels.com> <20120815142338.GL23985@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120815142338.GL23985@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>


>>
>> I see now, you seem to be right.
> 
> No I am not because it seems that I am really blind these days...
> We were doing this in mem_cgroup_do_charge for ages:
> 	if (!(gfp_mask & __GFP_WAIT))
>                 return CHARGE_WOULDBLOCK;
> 
> /me goes to hide and get with further feedback with a clean head.
> 
> Sorry about that.
> 
I am as well, since I went to look at mem_cgroup_do_charge() and missed
that.

Do you have any other concerns specific to this patch ?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
