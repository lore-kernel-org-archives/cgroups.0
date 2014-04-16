From: Michal Hocko <mhocko@suse.cz>
Subject: Re: Kernel scanning/freeing to relieve cgroup memory pressure
Date: Wed, 16 Apr 2014 11:11:22 +0200
Message-ID: <20140416091122.GC12866@dhcp22.suse.cz>
References: <533C0BB4.4070009@gopivotal.com>
 <20140402180019.GL16631@htj.dyndns.org>
 <534B982D.8060106@gopivotal.com>
 <20140414205034.GA6443@cmpxchg.org>
 <534CEFF2.7090207@gopivotal.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <534CEFF2.7090207@gopivotal.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glyn Normington <gnormington@gopivotal.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Tue 15-04-14 09:38:10, Glyn Normington wrote:
> On 14/04/2014 21:50, Johannes Weiner wrote:
> >On Mon, Apr 14, 2014 at 09:11:25AM +0100, Glyn Normington wrote:
> >>Johannes/Michal
> >>
> >>What are your thoughts on this matter? Do you see this as a valid
> >>requirement?
> >As Tejun said, memory cgroups *do* respond to internal pressure and
> >enter targetted reclaim before invoking the OOM killer.  So I'm not
> >exactly sure what you are asking.
> We are repeatedly seeing a situation where a memory cgroup with a given
> memory limit results in an application process in the cgroup being killed
> oom during application initialisation. One theory is that dirty file cache
> pages are not being written to disk to reduce memory consumption before the
> oom killer is invoked. Should memory cgroups' response to internal pressure
> include writing dirty file cache pages to disk?

This depends on the kernel version. OOM with a lot of dirty pages on
memcg LRUs was a big problem. Now we are waiting for pages under
writeback during reclaim which should prevent from such spurious OOMs.
Which kernel versions are we talking about? The fix (or better said
workaround) I am thinking about is e62e384e9da8 memcg: prevent OOM with
too many dirty pages.

I am still not sure I understand your setup and the problem. Could you
describe your setup (what runs where under what limits), please?
-- 
Michal Hocko
SUSE Labs
