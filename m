From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] fs: allow mknod in user namespaces
Date: Fri, 15 Mar 2013 10:14:15 -0500
Message-ID: <20130315151415.GA24305@sergelap>
References: <1363338823-25292-1-git-send-email-glommer@parallels.com>
 <1363338823-25292-4-git-send-email-glommer@parallels.com>
 <20130315143741.GE3782@sergelap>
 <51433511.1020808@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51433511.1020808-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Quoting Glauber Costa (glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org):
> On 03/15/2013 06:37 PM, Serge Hallyn wrote:
> > Quoting Glauber Costa (glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org):
> >> Since we have strict control on who access the devices, it should be
> >> no problem to allow the device to appear.
> >>
> >> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> >> Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> Cc: Eric Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> >> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> >> ---
> >>  fs/namei.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/fs/namei.c b/fs/namei.c
> >> index 8a34d79..d0b4549 100644
> >> --- a/fs/namei.c
> >> +++ b/fs/namei.c
> >> @@ -3126,7 +3126,7 @@ int vfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t dev)
> >>  	if (error)
> >>  		return error;
> >>  
> >> -	if ((S_ISCHR(mode) || S_ISBLK(mode)) && !capable(CAP_MKNOD))
> >> +	if ((S_ISCHR(mode) || S_ISBLK(mode)) && !nsown_capable(CAP_MKNOD))
> > 
> > I realize you're arguing that devicens is enough, but how about
> > doing inode_capable(dir, CAP_MKNOD) instead?
> > 
> I see no reason not to do it.

Cool, with that

Acked-by: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

thanks.

-serge
