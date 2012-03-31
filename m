From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: cftype based file interface, take #2
Date: Sat, 31 Mar 2012 09:47:25 -0700
Message-ID: <20120331164725.GE2557@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332368265-21586-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=nnPvKHgV3/BEibNuGzVW2q72Yi81dsJdOuI3X+M/4io=;
        b=OJ8zd7iS71a3KmT7hEfRJrhLlke3GRrhn2KKSs5DTMGGuz0a+fUQaSFfkdWTy5tWu6
         D49j28XvPYQf3qRYfsZcUP4c4erLQawqOmJXzXvU8xzZKIavCdnsUCpCLSXUnipDM+xs
         nArb1b7w/hg1F3JZRx2FQyPPhIRE+y4SghgM/rl7Yx6xm+jvchZ9NiUBPOG43vk9OWfG
         4FGGxvmiuKNxu7OAsdqhFjjpYZyRn0WJE/Om9Wtxr6fmeWFhNtP+hfy0U9r6ewk7Dpft
         b0liDP1No+j9d2KInETwTiVY+EV6bbpPIWxAgCk2kmbcUATPOqrZ9KuR6f6hngiYH3da
         eX0A==
Content-Disposition: inline
In-Reply-To: <1332368265-21586-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Wed, Mar 21, 2012 at 03:17:33PM -0700, Tejun Heo wrote:
> This is the second take at improving cgroup file addition/removal
> interface.  Changes from the last take[L] are,

Applied to cgroup/for-3.5 w/ Li's acks added.

Thanks.

-- 
tejun
