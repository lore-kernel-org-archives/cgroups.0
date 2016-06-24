From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Fri, 24 Jun 2016 10:59:16 -0500
Message-ID: <20160624155916.GA8759@mail.hallyn.com>
References: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
 <20160623213819.GP3262@mtj.duckdns.org>
 <53377cda-9afe-dad4-6bbb-26affd64cb3a@gmail.com>
 <20160624154830.GX3262@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160624154830.GX3262@mtj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Topi Miettinen <toiwoton@gmail.com>, linux-kernel@vger.kernel.org, luto@kernel.org, serge@hallyn.com, keescook@chromium.org, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, David Woodhouse <David.Woodhouse@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

Quoting Tejun Heo (tj@kernel.org):
> Hello,
> 
> On Fri, Jun 24, 2016 at 12:22:54AM +0000, Topi Miettinen wrote:
> > > This doesn't have anything to do with resource control and I don't
> > > think it's a good idea to add arbitrary monitoring mechanisms to
> > > cgroup just because it's easy to add interface there.  Given that
> > > capabilities are inherited and modified through the process hierarchy,
> > > shouldn't this be part of that?
> > 
> > With per process tracking, it's easy to miss if a short-lived process
> > exercised capabilities. Especially with ambient capabilities, the parent
> > process could be a shell script which might not use capabilities at all,
> > but its children do the heavy lifting.
> 
> But isn't being recursive orthogonal to using cgroup?  Why not account
> usages recursively along the process hierarchy?  Capabilities don't
> have much to do with cgroup but everything with process hierarchy.
> That's how they're distributed and modified.  If monitoring their
> usages is necessary, it makes sense to do it in the same structure.

That was my argument against using cgroups to enforce a new bounding
set.  For tracking though, the cgroup process tracking seems as applicable
to this as it does to systemd tracking of services.  It tracks a task and
the children it forks.
