From: Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH 1/4] dev_cgroup: keep track of which cgroup is the root
 cgroup
Date: Fri, 15 Mar 2013 09:55:06 -0500
Message-ID: <20130315145506.GB20109@sergelap>
References: <1363338823-25292-1-git-send-email-glommer@parallels.com>
 <1363338823-25292-2-git-send-email-glommer@parallels.com>
 <20130315140743.GC3782@sergelap>
 <514333A2.5060408@parallels.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <514333A2.5060408@parallels.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, mtk.manpages@gmail.com, "Eric W. Biederman" <ebiederm@xmission.com>, Serge Hallyn <serge.hallyn@canonical.com>, linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org, Aristeu Rozanski <aris@redhat.com>, Li Zefan <lizefan@huawei.com>

Quoting Glauber Costa (glommer@parallels.com):
> On 03/15/2013 06:07 PM, Serge Hallyn wrote:
> > Quoting Glauber Costa (glommer@parallels.com):
> >> Most of the other subsystems already keep track of that in some way.  We
> >> will do that internally and provide a test to determine whether or not
> >> our task is in a device cgroup that is not the root one. We can relax
> >> some of our checks in that case, trusting that whoever set device cgroup
> >> rules will be responsible to control access to their devices.
> >>
> >> Signed-off-by: Glauber Costa <glommer@parallels.com>
> >> Cc: Aristeu Rozanski <aris@redhat.com>
> >> Cc: Eric Biederman <ebiederm@xmission.com>
> >> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> > 
> > Patch looks fine.  AFAIK we're still waiting on Aristeu's patchset to
> > hit upstream.  As your patches are simpler I'd prefer, if there is
> > churn, for yours to be refactored than his.
> > 
> I have no problem with that. There is also a small build issue here that
> needs to be fixed. If you allow me, with my guarantees that the patch
> will be preserved in spirit I will keep your ack after any refactoring =)
> 

Of course :)  Please keep my ack on it so long as you don't feel any
substantive changes were needed :)

-serge
