From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup: BUG: unable to handle kernel NULL pointer dereference
Date: Mon, 4 Jan 2016 13:15:53 -0600
Message-ID: <20160104191553.GA21384@mail.hallyn.com>
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
Cc: Jeremiah Mahler <jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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

Hi Tejun,

an updated set is at https://git.kernel.org/cgit/linux/kernel/git/sergeh/linux-security.git/commit/?h=cgroupns.v9
Would you like a new patchset send to the list, or is the github
tree ok?

This branch:
  1. puts lookup_one_len() under inode lock
  2. makes cgroup_path non-namespaced, so only calls to
     cgroup_path_ns() are namespaced.
  3. makes cgroup_path{,_ns} take the needed locks, since
     external callers cannot do so.
  4. Fixes the bisectability problem of to_cg_ns() being
     defined after use (patch 4 -> patch 3)

thanks,
-serge
