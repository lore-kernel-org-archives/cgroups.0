From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup: BUG: unable to handle kernel NULL pointer dereference
Date: Sat, 2 Jan 2016 18:59:16 -0600
Message-ID: <20160103005916.GA5956@mail.hallyn.com>
References: <20160101234028.GA1750@hudson.localdomain>
 <20160102115437.GE3660@htj.duckdns.org>
 <20160102182416.GA3957@mail.hallyn.com>
 <20160102215049.GA18564@hudson.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160102215049.GA18564-ZO/ZziT/ZXRSq9BJjBFyUp/QNRX+jHPU@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeremiah Mahler <jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Sat, Jan 02, 2016 at 01:50:49PM -0800, Jeremiah Mahler wrote:
> Serge,
> 
> On Sat, Jan 02, 2016 at 12:24:16PM -0600, Serge E. Hallyn wrote:
> [...]
> > 
> > Tried to reproduce with setting CONFIG_CFQ_GROUP_IOSCHED=y, but did not
> > succeed.  Could you send me the .config?  Also, if someone could send
> > the objdump -d output that might help.  Though really, it seems clear
> > that current->nsproxy must be NULL.  Hm, that's right -  we used to have
> > that issue in pidns (or was it netns) during process exit.  I don't know
> > that I'll get time this afternoon, but I'll look into it asap.
> > 
> > thanks.
> 
> Attached is the .config I used.  I can send an objdump, but do you want
> a dump of the kernel, where the cgroup code is?
> 
> -- 
> - Jeremiah Mahler

Thanks - Shoulda looked at the exit path before - exit_io_context is called
after exit_task_namespaces().

I'll have to figure out the best way to handle this.  In the past we've
restructured exit code to ensure that anything wanting to dereference
nsproxy happened before exit_task_namespaces().  However, this is only
happening in a debug stmt at blkg_path() in
http://lxr.free-electrons.com/source/include/linux/blk-cgroup.h#L344
so simply returning the init_cgroup_namespace is actually the right thing
to do.  I'm tempted to add a init_cgroup_path() which ignores namespaces,
for use in debugging statements.
