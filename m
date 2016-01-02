From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup: BUG: unable to handle kernel NULL pointer dereference
Date: Sat, 2 Jan 2016 12:24:16 -0600
Message-ID: <20160102182416.GA3957@mail.hallyn.com>
References: <20160101234028.GA1750@hudson.localdomain>
 <20160102115437.GE3660@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160102115437.GE3660-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jeremiah Mahler <jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Sat, Jan 02, 2016 at 06:54:37AM -0500, Tejun Heo wrote:
> On Fri, Jan 01, 2016 at 03:40:28PM -0800, Jeremiah Mahler wrote:
> > all,
> > 
> > When running the latest linux-next (20151231) two of my machines
> > hang early in the boot sequence.  The initial message is for a
> > NULL pointer dereference.
> > 
> >   BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
> > 
> > And the RIP line refers to cgroup_path.
> > 
> >   RIP [<ffffffff810eb178>] cgroup_path+0x30/0x80
> > 
> > Attached are pictures of the back trace.
> > 
> > Let me know if I can do anything else to help.  I will investigate the
> > problem further if I get a chance.
> 
> This is most likely from the recent changes from cgroup ns support.
> Reverted the patchset for now as it also introduced a bisectability
> issue.  Serge, can you please look into this one?

Tried to reproduce with setting CONFIG_CFQ_GROUP_IOSCHED=y, but did not
succeed.  Could you send me the .config?  Also, if someone could send
the objdump -d output that might help.  Though really, it seems clear
that current->nsproxy must be NULL.  Hm, that's right -  we used to have
that issue in pidns (or was it netns) during process exit.  I don't know
that I'll get time this afternoon, but I'll look into it asap.

thanks.
