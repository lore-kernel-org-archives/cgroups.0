From: Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>
Subject: Re: [PATCH] cgroup: deprecate remount option changes and "name="
  mount option
Date: Thu, 15 Mar 2012 20:33:32 +0100
Message-ID: <20120315193330.GC32661@tango.0pointer.de>
References: <20120314215228.GI7349@google.com>
 <20120314232925.GA16973@tango.0pointer.de>
 <20120315165402.GC32137@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120315165402.GC32137-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, 15.03.12 09:54, Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org) wrote:

> 
> Hello,
> 
> On Thu, Mar 15, 2012 at 12:29:25AM +0100, Lennart Poettering wrote:
> > Hmm, this is not clear to me. Are you intending to remove the name=
> > mount option entirely, or just intend to remove that you can change it
> > in remounts?
> > 
> > systemd uses name=systemd to get its own private cgroup tree, that has
> > no controller bound, hence we kinda need this option. Or are you
> > suggesting there was an other way to get a private cgroup tree that
> > systemd can use for grouping and labelling things?
> 
> Eh, you're right.  I want to remove support for duplicate mounting by
> name or subsys as it just isn't necessary, so what I want is,
> 
> * "mount -t cgroupfs -o SUBSYS" will fail if SUBSYS is already mounted
>   somewhere else.
> 
> * "mount -t cgroupfs -o none" will always create a new cgroup
>   hierarchy w/o any controller attached.
> 
> I didn't realize that the mount code didn't allow none w/o name and
> now I don't see a non-intrusive way to remove the name option. :( Eh
> well, I'll drop that part.

Insisting on a name or controller (i.e. not allowing completely
anonymous cgroupfs mounts) is probably a good idea since otherwise the
data in /proc/$PID/cgroup might be a bit useless since you couldn't
sensible match up the data in there with your mount point.

Multiple mounts of the same tree can go, as long as bind mounting is
still supported so that we can make the cgroup tree available in limited
form to containers and such.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
