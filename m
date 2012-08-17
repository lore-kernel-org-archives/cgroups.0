From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v2 09/11] memcg: propagate kmem limiting information to
 children
Date: Fri, 17 Aug 2012 14:36:00 +0400
Message-ID: <502E1E90.1080805@parallels.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-10-git-send-email-glommer@parallels.com> <20120817090005.GC18600@dhcp22.suse.cz> <502E0BC3.8090204@parallels.com> <20120817093504.GE18600@dhcp22.suse.cz> <502E17C4.7060204@parallels.com> <20120817103550.GF18600@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120817103550.GF18600@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>, Suleiman Souhlal <suleiman@google.com>

On 08/17/2012 02:35 PM, Michal Hocko wrote:
>> > But I never said that can't happen. I said (ok, I meant) the static
>> > branches can't be disabled.
> Ok, then I misunderstood that because the comment was there even before
> static branches were introduced and it made sense to me. This is
> inconsistent with what we do for user accounting because even if we set
> limit to unlimitted we still account. Why should we differ here?

Well, we account even without a limit for user accounting. This is a
fundamental difference, no ?


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
