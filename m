From: Aristeu Rozanski <aris@redhat.com>
Subject: Re: [PATCH 3/5] device_cgroup: keep track of local group settings
Date: Thu, 29 Nov 2012 15:11:42 -0500
Message-ID: <20121129201142.GX32112@redhat.com>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193502.482004744@napanee.usersys.redhat.com>
 <20121129192945.GD26104@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121129192945.GD26104@mail.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>, cgroups@vger.kernel.org

On Thu, Nov 29, 2012 at 07:29:45PM +0000, Serge E. Hallyn wrote:
> thanks for doing this.  I've got one concern though.  I don't see
> any place where devcgroup_create() was updated to create the
> local exceptions list.  I think we need a guarantee that at
> any time the local exceptions list will contain all the entries
> contained in the cgroup->exceptions list.  Otherwise you cannot
> use the exception_add() the way you do (or you can't use RCU),
> since there could be a window between the successful addition
> of a rule to cgroup->local.exceptions and the failed addition to
> cgroup->exceptions, during which a task (since it won't need
> the mutex for devcg_allow()) could exceed allowed permissions.
> 
> It's possible I'm misunderstanding.  If you think that's the case
> just kick me and I'll take a fresh look.
> 
> (Btw is there a git tree or gitweb view I could look at alongside
> the patchset?)

ah, yes, the missing thing you're not seeing is
4b1c7840b7d01b14a1a00fa0e61b761d4391ba67 from Tejun's tree
('device_cgroup: add lockdep asserts')

-- 
Aristeu
