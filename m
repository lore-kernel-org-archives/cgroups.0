From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] kernfs: attach uuid for every kernfs and report it in
 fsid
Date: Mon, 31 Jul 2023 15:46:15 +0200
Message-ID: <20230731134615.delje45enx3tkyco@quack3>
References: <20230710183338.58531-1-ivan@cloudflare.com>
 <2023071039-negate-stalemate-6987@gregkh>
 <CABWYdi39+TJd1qV3nWs_eYc7XMC0RvxG22ihfq7rzuPaNvn1cQ@mail.gmail.com>
 <CAOQ4uxiFhkSM2pSNLCE6cLz6mhYOvk5D7vDsghVTqy9cDqeqew@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1690811175; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s2MEuuBImPy2nJn6tjPuFhxEPNMc8/iZBGaeB7cr/BY=;
        b=I/U9PFyRf25n0g70iuzCPxQS3YMkIlal3GeA99nV+He8epYVZMSqJ21tj7yu/AVMl71IF6
        8LnE0Wp6VHCOVQhTqUe5oDeyRGxfT6UsLVTeJHqJezpcyQyUmp3udzU40xCfoXlS/6raSm
        DESHZWjCvZUE3R6ZPogtmDipiDajz7o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1690811175;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s2MEuuBImPy2nJn6tjPuFhxEPNMc8/iZBGaeB7cr/BY=;
        b=WJ8ftMaODqenx4pyPkV8FuPqcxqqGbUIBcQd79o+ZZu+DVwe/2zbhY+QxABBDnG5ovwEZC
        OulBdKsuXDlSjWCA==
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiFhkSM2pSNLCE6cLz6mhYOvk5D7vDsghVTqy9cDqeqew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Tue 11-07-23 12:49:05, Amir Goldstein wrote:
> On Tue, Jul 11, 2023 at 12:21 AM Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org> wrote:
> >
> > On Mon, Jul 10, 2023 at 12:40 PM Greg Kroah-Hartman
> > <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> > >
> > > On Mon, Jul 10, 2023 at 11:33:38AM -0700, Ivan Babrou wrote:
> > > > The following two commits added the same thing for tmpfs:
> > > >
> > > > * commit 2b4db79618ad ("tmpfs: generate random sb->s_uuid")
> > > > * commit 59cda49ecf6c ("shmem: allow reporting fanotify events with file handles on tmpfs")
> > > >
> > > > Having fsid allows using fanotify, which is especially handy for cgroups,
> > > > where one might be interested in knowing when they are created or removed.
> > > >
> > > > Signed-off-by: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
> > > > ---
> > > >  fs/kernfs/mount.c | 13 ++++++++++++-
> > > >  1 file changed, 12 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> > > > index d49606accb07..930026842359 100644
> > > > --- a/fs/kernfs/mount.c
> > > > +++ b/fs/kernfs/mount.c
> > > > @@ -16,6 +16,8 @@
> > > >  #include <linux/namei.h>
> > > >  #include <linux/seq_file.h>
> > > >  #include <linux/exportfs.h>
> > > > +#include <linux/uuid.h>
> > > > +#include <linux/statfs.h>
> > > >
> > > >  #include "kernfs-internal.h"
> > > >
> > > > @@ -45,8 +47,15 @@ static int kernfs_sop_show_path(struct seq_file *sf, struct dentry *dentry)
> > > >       return 0;
> > > >  }
> > > >
> > > > +int kernfs_statfs(struct dentry *dentry, struct kstatfs *buf)
> > > > +{
> > > > +     simple_statfs(dentry, buf);
> > > > +     buf->f_fsid = uuid_to_fsid(dentry->d_sb->s_uuid.b);
> > > > +     return 0;
> > > > +}
> > > > +
> > > >  const struct super_operations kernfs_sops = {
> > > > -     .statfs         = simple_statfs,
> > > > +     .statfs         = kernfs_statfs,
> > > >       .drop_inode     = generic_delete_inode,
> > > >       .evict_inode    = kernfs_evict_inode,
> > > >
> > > > @@ -351,6 +360,8 @@ int kernfs_get_tree(struct fs_context *fc)
> > > >               }
> > > >               sb->s_flags |= SB_ACTIVE;
> > > >
> > > > +             uuid_gen(&sb->s_uuid);
> > >
> > > Since kernfs has as lot of nodes (like hundreds of thousands if not more
> > > at times, being created at boot time), did you just slow down creating
> > > them all, and increase the memory usage in a measurable way?
> >
> > This is just for the superblock, not every inode. The memory increase
> > is one UUID per kernfs instance (there are maybe 10 of them on a basic
> > system), which is trivial. Same goes for CPU usage.
> >
> > > We were trying to slim things down, what userspace tools need this
> > > change?  Who is going to use it, and what for?
> >
> > The one concrete thing is ebpf_exporter:
> >
> > * https://github.com/cloudflare/ebpf_exporter
> >
> > I want to monitor cgroup changes, so that I can have an up to date map
> > of inode -> cgroup path, so that I can resolve the value returned from
> > bpf_get_current_cgroup_id() into something that a human can easily
> > grasp (think system.slice/nginx.service). Currently I do a full sweep
> > to build a map, which doesn't work if a cgroup is short lived, as it
> > just disappears before I can resolve it. Unfortunately, systemd
> > recycles cgroups on restart, changing inode number, so this is a very
> > real issue.
> >
> > There's also this old wiki page from systemd:
> >
> > * https://freedesktop.org/wiki/Software/systemd/Optimizations
> >
> > Quoting from there:
> >
> > > Get rid of systemd-cgroups-agent. Currently, whenever a systemd cgroup runs empty a tool "systemd-cgroups-agent" is invoked by the kernel which then notifies systemd about it. The need for this tool should really go away, which will save a number of forked processes at boot, and should make things faster (especially shutdown). This requires introduction of a new kernel interface to get notifications for cgroups running empty, for example via fanotify() on cgroupfs.
> >
> > So a similar need to mine, but for different systemd-related needs.
> >
> > Initially I tried adding this for cgroup fs only, but the problem felt
> > very generic, so I pivoted to having it in kernfs instead, so that any
> > kernfs based filesystem would benefit.
> >
> > Given pretty much non-existing overhead and simplicity of this, I
> > think it's a change worth doing, unless there's a good reason to not
> > do it. I cc'd plenty of people to make sure it's not a bad decision.
> 
> I agree. I think it was a good decision.
> I have some followup questions though.
> 
> I guess your use case cares about the creation of cgroups?
> as long as the only way to create a cgroup is via vfs
> vfs_mkdir() -> ... cgroup_mkdir()
> fsnotify_mkdir() will be called.
> Is that a correct statement?
> Because if not, then explicit fsnotify_mkdir() calls may be needed
> similar to tracefs/debugfs.
> 
> I don't think that the statement holds for dieing cgroups,
> so explicit fsnotify_rmdir() are almost certainly needed to make
> inotify/fanotify monitoring on cgroups complete.

Yeah, as Ivan writes, we should already have all that is needed to
generate CREATE and DELETE events for the cgroup filesystem. In theory
inotify or fanotify for inodes could be already used with cgroupfs now.
Thus I have no objection to providing fsid for it so that filesystem-wide
notifications can be used for it as well. Feel free to add:

Acked-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

to your patch.

> On an unrelated side topic,
> I would like to point your attention to this comment in the patch that
> was just merged to v6.5-rc1:
> 
> 69562eb0bd3e ("fanotify: disallow mount/sb marks on kernel internal pseudo fs")
> 
>         /*
>          * mount and sb marks are not allowed on kernel internal pseudo fs,
>          * like pipe_mnt, because that would subscribe to events on all the
>          * anonynous pipes in the system.
>          *
>          * SB_NOUSER covers all of the internal pseudo fs whose objects are not
>          * exposed to user's mount namespace, but there are other SB_KERNMOUNT
>          * fs, like nsfs, debugfs, for which the value of allowing sb and mount
>          * mark is questionable. For now we leave them alone.
>          */
> 
> My question to you, as the only user I know of for fanotify FAN_REPORT_FID
> on SB_KERNMOUNT, do you have plans to use a mount or filesystem mark
> to monitor cgroups? or only inotify-like directory watches?

Yeah, for situations file cgroupfs the filesystem-wide watches do make
sense and are useful at times as Ivan describes so I guess we'll leave
those alone...

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
