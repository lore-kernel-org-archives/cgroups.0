From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH for-linus 1/2] writeback, cgroup: fix premature wb_put()
 in locked_inode_to_wb_and_lock_list()
Date: Sun, 20 Mar 2016 09:44:44 -0600
Message-ID: <56EEC56C.3030709@kernel.dk>
References: <CAAeU0aMYeM_39Y2+PaRvyB1nqAPYZSNngJ1eBRmrxn7gKAt2Mg@mail.gmail.com>
 <20160318175003.GA20028@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=e1+xSZor4HdWPcsbKabBvS0J2BkNL9rRa72oXfwf8Lw=;
        b=JWocQPj7EBLVt0XFdIJrgerV1DSSciVtH7EhIx+o8az7ENZshv0vhBYzFknmUlQZem
         jB0Sk1xnt2ikU1emJ39JwbsHHAxgIaq1UQAPhQN7tfLs2tqfcDXJ5ijpPT2WlaGEUdm9
         BAS0Ojg5GTvRYji7mjgRBzYlMgvfY5ShdhZfgWmxP0rg1ILV1Nwz1mWLqoCrVfxyRA+a
         zeJTGz8kqtdg3ru4S3qxmmszDWqR4DC7+amAjow+cRPYKwWuFkP3JfkXufDxC5WYC5bY
         gn70gqp+E0I3Q8d6p5BMBCUe3cab6VJhn0wmxBz0+YPGmCd4YU7ggmL+ncnNhQZLodE/
         0A2Q==
In-Reply-To: <20160318175003.GA20028-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 03/18/2016 11:50 AM, Tejun Heo wrote:
> locked_inode_to_wb_and_lock_list() wb_get()'s the wb associated with
> the target inode, unlocks inode, locks the wb's list_lock and verifies
> that the inode is still associated with the wb.  To prevent the wb
> going away between dropping inode lock and acquiring list_lock, the wb
> is pinned while inode lock is held.  The wb reference is put right
> after acquiring list_lock citing that the wb won't be dereferenced
> anymore.
>
> This isn't true.  If the inode is still associated with the wb, the
> inode has reference and it's safe to return the wb; however, if inode
> has been switched, the wb still needs to be unlocked which is a
> dereference and can lead to use-after-free if it it races with wb
> destruction.
>
> Fix it by putting the reference after releasing list_lock.

Applied for current series, thanks Tejun.

-- 
Jens Axboe
