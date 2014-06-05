From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [RFC][PATCH] oom: Be less verbose if the oom_control event fd
 has listeners
Date: Thu, 5 Jun 2014 18:18:07 +0200
Message-ID: <20140605161807.GD15939@dhcp22.suse.cz>
References: <1401976841-3899-1-git-send-email-richard@nod.at>
 <1401976841-3899-2-git-send-email-richard@nod.at>
 <20140605150025.GB15939@dhcp22.suse.cz>
 <5390930A.8050504@nod.at>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <5390930A.8050504@nod.at>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Weinberger <richard@nod.at>
Cc: hannes@cmpxchg.org, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, vdavydov@parallels.com, tj@kernel.org, handai.szj@taobao.com, rientjes@google.com, oleg@redhat.com, rusty@rustcorp.com.au, kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Thu 05-06-14 17:55:54, Richard Weinberger wrote:
> Am 05.06.2014 17:00, schrieb Michal Hocko:
> > On Thu 05-06-14 16:00:41, Richard Weinberger wrote:
> >> Don't spam the kernel logs if the oom_control event fd has listeners.
> >> In this case there is no need to print that much lines as user space
> >> will anyway notice that the memory cgroup has reached its limit.
> > 
> > But how do you debug why it is reaching the limit and why a particular
> > process has been killed?
> 
> In my case it's always because customer's Java application gone nuts.
> So I don't really have to debug a lot. ;-)
> But I can understand your point.

If you know that handling memcg-OOM condition is easy then maybe you can
not only listen for the OOM notifications but also handle OOM conditions
and kill the offender. This would mean that kernel doesn't try to kill
anything and so wouldn't dump anything to the log.
 
> > If we are printing too much then OK, let's remove those parts which are
> > not that useful but hiding information which tells us more about the oom
> > decision doesn't sound right to me.
> 
> What about adding a sysctl like "vm.oom_verbose"?
> By default it would be 1.
> If set to 0 the full OOM information is only printed out if nobody listens
> to the event fd.

If we have a knob then I guess it should be global and shared by memcg
as well. I can imagine that somebody might be interested only in the
tasks dump, while somebody would like to see LRU states and other memory
counters. So it would be ideally a bitmask of things to output. I do not
think that a memcg specific solution is good, though.

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
