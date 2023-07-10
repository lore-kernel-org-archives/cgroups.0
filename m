From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] kernfs: attach uuid for every kernfs and report it in
 fsid
Date: Mon, 10 Jul 2023 21:41:02 +0200
Message-ID: <2023071046-paramount-climatic-31cb@gregkh>
References: <20230710183338.58531-1-ivan@cloudflare.com>
 <2023071039-negate-stalemate-6987@gregkh>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1689018065;
        bh=4JghVo9ntVNo5eow2Va+8PEDtvw9T3mWBVw4q3zNsuI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wjxjdxwy8939dFbsEfTW/y4r4/FPIAMEe5+YtOiWABsy3aE9uptN/GNiWKzmHAoPq
         DJvfGpgFffG/ZEvc60Rx3ATbNnciqmW36W4CrJOMvHCKGSwfF1eUaHUQD/9fJEnOos
         CsPWfrUnXzLouSyf4k+sRmvtRunIgOXxZIAO2zOQ=
Content-Disposition: inline
In-Reply-To: <2023071039-negate-stalemate-6987@gregkh>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Mon, Jul 10, 2023 at 09:40:23PM +0200, Greg Kroah-Hartman wrote:
> On Mon, Jul 10, 2023 at 11:33:38AM -0700, Ivan Babrou wrote:
> > The following two commits added the same thing for tmpfs:
> > 
> > * commit 2b4db79618ad ("tmpfs: generate random sb->s_uuid")
> > * commit 59cda49ecf6c ("shmem: allow reporting fanotify events with file handles on tmpfs")
> > 
> > Having fsid allows using fanotify, which is especially handy for cgroups,
> > where one might be interested in knowing when they are created or removed.
> > 
> > Signed-off-by: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
> > ---
> >  fs/kernfs/mount.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> > index d49606accb07..930026842359 100644
> > --- a/fs/kernfs/mount.c
> > +++ b/fs/kernfs/mount.c
> > @@ -16,6 +16,8 @@
> >  #include <linux/namei.h>
> >  #include <linux/seq_file.h>
> >  #include <linux/exportfs.h>
> > +#include <linux/uuid.h>
> > +#include <linux/statfs.h>
> >  
> >  #include "kernfs-internal.h"
> >  
> > @@ -45,8 +47,15 @@ static int kernfs_sop_show_path(struct seq_file *sf, struct dentry *dentry)
> >  	return 0;
> >  }
> >  
> > +int kernfs_statfs(struct dentry *dentry, struct kstatfs *buf)
> > +{
> > +	simple_statfs(dentry, buf);
> > +	buf->f_fsid = uuid_to_fsid(dentry->d_sb->s_uuid.b);
> > +	return 0;
> > +}
> > +
> >  const struct super_operations kernfs_sops = {
> > -	.statfs		= simple_statfs,
> > +	.statfs		= kernfs_statfs,
> >  	.drop_inode	= generic_delete_inode,
> >  	.evict_inode	= kernfs_evict_inode,
> >  
> > @@ -351,6 +360,8 @@ int kernfs_get_tree(struct fs_context *fc)
> >  		}
> >  		sb->s_flags |= SB_ACTIVE;
> >  
> > +		uuid_gen(&sb->s_uuid);
> 
> Since kernfs has as lot of nodes (like hundreds of thousands if not more
> at times, being created at boot time), did you just slow down creating
> them all, and increase the memory usage in a measurable way?
> 
> We were trying to slim things down, what userspace tools need this
> change?  Who is going to use it, and what for?
> 
> There were some benchmarks people were doing with booting large memory
> systems that you might want to reproduce here to verify that nothing is
> going to be harmed.

Oh wait, is this just a per-superblock thing?

confused,

greg k-h
