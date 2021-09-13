From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] support cgroup pool in v1
Date: Mon, 13 Sep 2021 06:24:28 -1000
Message-ID: <YT97PAm6kaecvXLX@slm.duckdns.org>
References: <cover.1631102579.git.escape@linux.alibaba.com>
 <YTiugxO0cDge47x6@kroah.com>
 <a0c67d71-8045-d8b6-40c2-39f2603ec7c1@linux.alibaba.com>
 <YTuMl+cC6FyA/Hsv@slm.duckdns.org>
 <20210913142059.qbypd4vfq6wdzqfw@wittgenstein>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7iNVw3gDtbqcmJuxqzAp5MJgiBGuJVVVMEOeEc9LwQI=;
        b=KMn3oOOQ7z+gZHnSi7tKwT8HQswrmQXWn3lkFw+yHY0rKS9MNHhd4wHGCJKSgBUW+n
         T9tyboH4kQf5n8hqLQ+QVZjkSSb3UmHmDfhwVZGsusChykPhGMmDVApFEBhgyaEKxcqF
         nQx/BCeW80UOUgD50aLnXPiX4V3x1A3k2VOFzTxgJQqUhtnAXDX5LCWind7N0Ph7r5JS
         YIiLJlvawJQq8N+/L4ad49VBtsL/uFJZK9EarxpeaZCD8dgARJnrDmUwzUoTfpYQ/chd
         wHvBmuxhJWuabByUsiQ+4Bj5XEDk3RaSHUx98oQLvBABSE9710epxsKIwebP8rwgN8I+
         YMNQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210913142059.qbypd4vfq6wdzqfw@wittgenstein>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: "taoyi.ty" <escape-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shanpeic-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org

Hello,

On Mon, Sep 13, 2021 at 04:20:59PM +0200, Christian Brauner wrote:
> Afaict, there is currently now way to prevent the deletion of empty
> cgroups, especially newly created ones. So for example, if I have a
> cgroup manager that prunes the cgroup tree whenever they detect empty
> cgroups they can delete cgroups that were pre-allocated. This is
> something we have run into before.

systemd doesn't mess with cgroups behind a delegation point.

> A related problem is a crashed or killed container manager 
> (segfault, sigkill, etc.). It might not have had the chance to cleanup
> cgroups it allocated for the container. If the container manager is
> restarted it can't reuse the existing cgroup it found because it has no
> way of guaranteeing whether in between the time it crashed and got
> restarted another program has just created a cgroup with the same name.
> We usually solve this by just creating another cgroup with an index
> appended until we we find an unallocated one setting an arbitrary cut
> off point until we require manual intervention by the user (e.g. 1000).
> 
> Right now iirc, one can rmdir() an empty cgroup while someone still
> holds a file descriptor open for it. This can lead to situation where a
> cgroup got created but before moving into the cgroup (via clone3() or
> write()) someone else has deleted it. What would already be helpful is
> if one had a way to prevent the deletion of cgroups when someone still
> has an open reference to it. This would allow a pool of cgroups to be
> created that can't simply be deleted.

The above are problems common for any entity managing cgroup hierarchy.
Beyond the permission and delegation based access control, cgroup doesn't
have a mechanism to grant exclusive managerial operations to a specific
application. It's the userspace's responsibility to coordinate these
operations like in most other kernel interfaces.

Thanks.

-- 
tejun
