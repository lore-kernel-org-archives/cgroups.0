From: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [syzbot] possible deadlock in throtl_pending_timer_fn
Date: Wed, 30 Mar 2022 11:01:40 +0800
Message-ID: <YkPIFKn0osBGOgma@T590>
References: <CAFj5m9+Gc-t6vD17yWBNos-fk9vmhUTLsXYGrSx4Bdzn7R67JQ@mail.gmail.com>
 <0000000000009518f205db66a47a@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648609323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xxzvoUYwD8SSYfs6qQXKCiAwI4oUDxgTEMP9uTO4mCk=;
        b=KFyV9WEfOFVEh2fyBt/2wDS2gnGK3LWjZYYCUu10rQ6kPP2iBMQVjnlQDyw1PqYK0nigwZ
        7XrumxjBl6LxVhvm1wm0z3hdKK5ZHD39XKx9RYgTbafwMDoaVSrZWzDQgIKq6Y+Dq8ZamS
        uMG5Aou5sQN5Ss9K6DZvrpA/TmN1v3A=
Content-Disposition: inline
In-Reply-To: <0000000000009518f205db66a47a-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+934ebb67352c8a490bf3-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Tue, Mar 29, 2022 at 07:52:57PM -0700, syzbot wrote:
> > On Wed, Mar 30, 2022 at 5:23 AM syzbot
> > <syzbot+934ebb67352c8a490bf3-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org> wrote:
> >>
> >> Hello,
> >>
> >> syzbot found the following issue on:
> >>
> >> HEAD commit:    cb7cbaae7fd9 Merge tag 'drm-next-2022-03-25' of git://anon..
> >> git tree:       upstream
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=17ef8b43700000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=7094767cefc58fb9
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=934ebb67352c8a490bf3
> >> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> >>
> >> Unfortunately, I don't have any reproducer for this issue yet.
> >>
> >> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >> Reported-by: syzbot+934ebb67352c8a490bf3-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
> >
> > #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
> 
> This crash does not have a reproducer. I cannot test it.

This one is triggered in case of memory allocation failure, especially blkg_free()
is called from blkg_alloc() directly. That is why it is hard to reproduce, and it
is one old issue.


Thanks,
Ming

