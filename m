From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix dentry still in use bug when dropping css
 refs after umount
Date: Tue, 3 Jul 2012 10:03:17 -0700
Message-ID: <20120703170317.GB555@google.com>
References: <4FEEA5CB.8070809@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=s+lzMD183mtgnnVXJMLVU318nEEzmYZvbaElbE6nN6A=;
        b=Y+TjgaUckNvueIAgJahkJnqWf7hhl2k75Mr40CwLAIpMhU6AZPfGVu/86uuANuu3FM
         bsiwqOUsSgeQbzH23bhsB/R5wl22jtpbgCbnu1dpTsHIvbCXgUIcteIYH3x+ilGumm8V
         x8Ss6NTI+W8yNMeAgb2PKsvPxBjallJUiw1/bJEGj06JyRqJy3asUp7ZfNBNxF70VE32
         HiPclsBBOzyoANXmTzPsKtHAcHBB4dM3Htrt2T5nFmooMh9SbSiZ9CmYqXye+1pjE6gb
         +h4slKtOUvNLaWqJSiSyZU4WIvw+MkmPYu/6ir4oqx7wt825uV7z0tdnMxME0lD4tQrC
         RmKQ==
Content-Disposition: inline
In-Reply-To: <4FEEA5CB.8070809-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org

Hello, Li.

On Sat, Jun 30, 2012 at 03:07:55PM +0800, Li Zefan wrote:
> If there's a css ref dangling after umount, when the ref goes down
> to 0, dput will drop the cgroup's dentry and then drop the root
> dentry. But kill_sb will be called inbetween, as dropping cgroup dentry
> unpinned sb, and now vfs will find the root dentry's refcnt is not 0.

Ah, okay, the window is between dput of child and parent.  Now I can
reproduce. :)  Dunno why your case didn't work here.

> @@ -78,8 +79,8 @@ struct cgroup_subsys_state {
>  	/* ID for this css, if possible */
>  	struct css_id __rcu *id;
>  
> -	/* Used to put @cgroup->dentry on the last css_put() */
> -	struct work_struct dput_work;
> +	/* Used to put @cgroup->css_refs on the last css_put() */
> +	struct work_struct put_work;
>  };
>  
>  /* bits in struct cgroup_subsys_state flags field */
> @@ -170,6 +171,9 @@ struct cgroup {
>  	 */
>  	atomic_t count;
>  
> +	/* We won't destroy the cgroup when there are css refs */
> +	struct kref css_refs;
> +
>  	/*
>  	 * We link our 'sibling' struct into our parent's 'children'.
>  	 * Our children link their 'sibling' into our 'children'.

Hmm... adding another layer of refcnting.  Now we end up with three
layers of refcnting - the active usage via cgroup->count, cgroup
lifetime via cgroup->dentry->d_count and this extended lifecycle
refcnt.  In addition, we now have to deal with partially destroyed
cgroups - e.g. running cgroup_path() will oops on lingering cgroups.
Hating this tangling of dentries and cgroups more and more.  :(

So, the reason why the d_release() change caused this problem was
because it decoupled super deactivation from rmdir.  Before, dentries
were holding onto super the same but as rmdir also holds onto super
via normal vfs access, the whole recurssion was protected.  ie.

	1. rmdir(2) - gets s_active

	2. cgroup waits for css drain

	3. dput() happens on cgroup synchronously.  This ends up
	   calling deactivate_super() via d_iput() and then may
	   recursively put parent dentries but that's safe thanks to
	   s_active ref from rmdir(2).

	4. rmdir(2) is done, super deactivated.

After super deactivation is moved to d_release(), the last dput may
happen outside rmdir(2) or any other vfs syscall, so between dput of
child and root, which doesn't hold s_active, super can try to die.

Ugh....... I don't know.  I'll think more about it.

Thanks a lot.

-- 
tejun
