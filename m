From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 3/5] device_cgroup: keep track of local group settings
Date: Thu, 29 Nov 2012 19:29:45 +0000
Message-ID: <20121129192945.GD26104@mail.hallyn.com>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193502.482004744@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121127193502.482004744@napanee.usersys.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>, cgroups@vger.kernel.org

Quoting Aristeu Rozanski (aris@redhat.com):
> In preparation for better hierarchy support, it's needed to retain the local
> settings in order to try to reapply them after a propagated change if they're
> still valid.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
>  
> ---
>  security/device_cgroup.c |  108 ++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 80 insertions(+), 28 deletions(-)

Hi,

thanks for doing this.  I've got one concern though.  I don't see
any place where devcgroup_create() was updated to create the
local exceptions list.  I think we need a guarantee that at
any time the local exceptions list will contain all the entries
contained in the cgroup->exceptions list.  Otherwise you cannot
use the exception_add() the way you do (or you can't use RCU),
since there could be a window between the successful addition
of a rule to cgroup->local.exceptions and the failed addition to
cgroup->exceptions, during which a task (since it won't need
the mutex for devcg_allow()) could exceed allowed permissions.

It's possible I'm misunderstanding.  If you think that's the case
just kick me and I'll take a fresh look.

(Btw is there a git tree or gitweb view I could look at alongside
the patchset?)

thanks,
-serge
