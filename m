From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/9] cgroup: cosmetic follow-up cleanups
Date: Fri, 28 Jun 2013 17:09:05 -0700
Message-ID: <20130629000905.GG18889@mtj.dyndns.org>
References: <1372463145-4245-1-git-send-email-tj@kernel.org>
 <1372463145-4245-8-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=YIpNOsCyW6BIzDSD9p7oSOwsF8Ik6NVNW6eMhneLT3I=;
        b=QQkFS7kqLvcxMTBZNmJ/KlrIk0QhWAhR+z6QnXFY/TqgLePCxsNbG/1FLj9dAQRZyD
         E7oTynWqGsJZ9tpWqJFNOyt87/lYgFFfnLBp7udFK6gcyp41jK60pzZeHlKu1duPWiHJ
         o2ijssfqEV2WP3YpZsWSGCBETmysco5I0rk5on6f3gKPWNrdg3Hi1d7ri6rAyi3HlS7W
         6EFQ0JhB87bN5wkcP4TaBUInBinhSaHS+HFx0x8egXlCQ53N6UdO1d/DW4sMJP4tl1GW
         A5qetxUcU+aP7eV197DSNQkTwWvuxzT+NXJWPPx8faYYDOtoQN4Sa8osnka0apQML7QX
         eHrA==
Content-Disposition: inline
In-Reply-To: <1372463145-4245-8-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jun 28, 2013 at 04:45:43PM -0700, Tejun Heo wrote:
> * Busy subsystem check in rebind_subsystems() is unnecessarily
>   verbose.  Restructure it for brevity.
> 
> * The init_cred dancing in cgroup_mount() has a very high WTF factor.
>   Add a comment explaining what's going on and point to the original
>   commit.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

I'm dropping this patch.  I ended up adding more logic to the
collapsed loop in rebind_subsystems() right after this.  I'll fold the
addition of the comment into the previous patch.  git branch has been
updated accordingly.

Thanks.

-- 
tejun
