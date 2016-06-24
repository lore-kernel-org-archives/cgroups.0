From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Fri, 24 Jun 2016 11:59:10 -0500
Message-ID: <20160624165910.GA9675@mail.hallyn.com>
References: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
 <20160623213819.GP3262@mtj.duckdns.org>
 <53377cda-9afe-dad4-6bbb-26affd64cb3a@gmail.com>
 <20160624154830.GX3262@mtj.duckdns.org>
 <20160624155916.GA8759@mail.hallyn.com>
 <20160624163527.GZ3262@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160624163527.GZ3262@mtj.duckdns.org>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Topi Miettinen <toiwoton@gmail.com>, linux-kernel@vger.kernel.org, luto@kernel.org, keescook@chromium.org, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, David Woodhouse <David.Woodhouse@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

Quoting Tejun Heo (tj@kernel.org):
> Hello,
> 
> On Fri, Jun 24, 2016 at 10:59:16AM -0500, Serge E. Hallyn wrote:
> > Quoting Tejun Heo (tj@kernel.org):
> > > But isn't being recursive orthogonal to using cgroup?  Why not account
> > > usages recursively along the process hierarchy?  Capabilities don't
> > > have much to do with cgroup but everything with process hierarchy.
> > > That's how they're distributed and modified.  If monitoring their
> > > usages is necessary, it makes sense to do it in the same structure.
> > 
> > That was my argument against using cgroups to enforce a new bounding
> > set.  For tracking though, the cgroup process tracking seems as applicable
> > to this as it does to systemd tracking of services.  It tracks a task and
> > the children it forks.
> 
> Just monitoring is less jarring than implementing security enforcement
> via cgroup, but it is still jarring.  What's wrong with recursive
> process hierarchy monitoring which is in line with the whole facility
> is implemented anyway?

As I think Topi pointed out, one shortcoming is that if there is a short-lived
child task, using its /proc/self/status is racy.  You might just miss that it
ever even existed, let alone that the "application" needed it.

Another alternative we've both mentioned is to use systemtap.  That's not
as nice a solution as a cgroup, but then again this isn't really a common
case, so maybe it is precisely what a tracing infrastructure is meant for.

-serge
