From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [RFC][PATCH] oom: Be less verbose if the oom_control event fd
 has listeners
Date: Thu, 5 Jun 2014 17:00:26 +0200
Message-ID: <20140605150025.GB15939@dhcp22.suse.cz>
References: <1401976841-3899-1-git-send-email-richard@nod.at>
 <1401976841-3899-2-git-send-email-richard@nod.at>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1401976841-3899-2-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Weinberger <richard@nod.at>
Cc: hannes@cmpxchg.org, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, vdavydov@parallels.com, tj@kernel.org, handai.szj@taobao.com, rientjes@google.com, oleg@redhat.com, rusty@rustcorp.com.au, kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Thu 05-06-14 16:00:41, Richard Weinberger wrote:
> Don't spam the kernel logs if the oom_control event fd has listeners.
> In this case there is no need to print that much lines as user space
> will anyway notice that the memory cgroup has reached its limit.

But how do you debug why it is reaching the limit and why a particular
process has been killed?

If we are printing too much then OK, let's remove those parts which are
not that useful but hiding information which tells us more about the oom
decision doesn't sound right to me.

> Signed-off-by: Richard Weinberger <richard@nod.at>
[...]
-- 
Michal Hocko
SUSE Labs
