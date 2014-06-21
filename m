From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Date: Fri, 20 Jun 2014 21:03:50 -0400
Message-ID: <53A4D9F6.6090504@oracle.com>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>	<1403124045-24361-14-git-send-email-hannes@cmpxchg.org>	<53A4D323.5080808@oracle.com> <20140620175648.666cae72.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20140620175648.666cae72.akpm@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 06/20/2014 08:56 PM, Andrew Morton wrote:
> On Fri, 20 Jun 2014 20:34:43 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> I'm seeing the following when booting a VM, bisection pointed me to this
>> patch.
>>
>> [   32.830823] BUG: using __this_cpu_add() in preemptible [00000000] code: mkdir/8677
> 
> Thanks.  This one was fixed earlier today.

Thank Andrew. My first bisection attempt went sideways and ended up
pointing at "fs/mpage.c: forgotten WRITE_SYNC in case of data integrity write"
for some reason.

My attempt to understand what data integrity has to do cgroups was unfruitful :(


Thanks,
Sasha

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
