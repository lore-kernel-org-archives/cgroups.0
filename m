From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: deprecate remount option changes and "name="
 mount option
Date: Thu, 15 Mar 2012 09:54:02 -0700
Message-ID: <20120315165402.GC32137@google.com>
References: <20120314215228.GI7349@google.com>
 <20120314232925.GA16973@tango.0pointer.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7bhY4d7WG48FvqVN5zlDvBXZyqu11GztXj/7FT1WRNg=;
        b=v7ZzKTYugfcI02ebX+eOngZo2RCXZVPeS5Kz+Jk6mOzWa4rr/dH80sEatt0jRbiQRK
         vrJSSEMV9CTJ465Rk2/uz+QhdaoY5ss6IDgJOinBIM1R05+cb9Lh95FSLZBhWMy65HR8
         GWiOu9SLd2MUqfjTftLiWF7oaSmzA3wXZcjz+1W44TibRglwVGuagRtxjXd0q4oWX2lC
         iMFVKBt+VPYX8er1zho1Sy73LFzQ6k789Uf4yP3RHKTywUf7KIc4NP3ibbKTcnnoexpo
         DZIEFC3z2DEtQDcAthd4djm8vtk9zAfdZUsCVeIXoo3bHayGc0Je4KO5+Yz8S5RU0lUk
         QBEg==
Content-Disposition: inline
In-Reply-To: <20120314232925.GA16973-kS5D54t9nk0aINubkmmoJbNAH6kLmebB@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello,

On Thu, Mar 15, 2012 at 12:29:25AM +0100, Lennart Poettering wrote:
> Hmm, this is not clear to me. Are you intending to remove the name=
> mount option entirely, or just intend to remove that you can change it
> in remounts?
> 
> systemd uses name=systemd to get its own private cgroup tree, that has
> no controller bound, hence we kinda need this option. Or are you
> suggesting there was an other way to get a private cgroup tree that
> systemd can use for grouping and labelling things?

Eh, you're right.  I want to remove support for duplicate mounting by
name or subsys as it just isn't necessary, so what I want is,

* "mount -t cgroupfs -o SUBSYS" will fail if SUBSYS is already mounted
  somewhere else.

* "mount -t cgroupfs -o none" will always create a new cgroup
  hierarchy w/o any controller attached.

I didn't realize that the mount code didn't allow none w/o name and
now I don't see a non-intrusive way to remove the name option. :( Eh
well, I'll drop that part.

Thanks.

-- 
tejun
