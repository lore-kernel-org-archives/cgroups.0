From: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [syzbot] possible deadlock in throtl_pending_timer_fn
Date: Wed, 30 Mar 2022 10:52:38 +0800
Message-ID: <CAFj5m9+Gc-t6vD17yWBNos-fk9vmhUTLsXYGrSx4Bdzn7R67JQ@mail.gmail.com>
References: <000000000000921fd405db62096a@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648608773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ma0cdZKvD2y8q033msWkRp2PLEzhGQ/8y/lyYzyaHeg=;
        b=Mx0ieUTdU+kloR8uaNZpzoFCKpCyeUTDNFRCywoyz0HjglZ96A7Ji6/f6/EgZqwPhSfWKC
        7bty6q6dNbU7xnnAaWvJGfoeC6zM12a5MJ5pKuCc4YUHvA3Ul6oEk3A8qhoyNQqmHm1mFJ
        bS5euydr777E/LfkH6EsnoRtuohv0MQ=
In-Reply-To: <000000000000921fd405db62096a-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+934ebb67352c8a490bf3-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Wed, Mar 30, 2022 at 5:23 AM syzbot
<syzbot+934ebb67352c8a490bf3-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    cb7cbaae7fd9 Merge tag 'drm-next-2022-03-25' of git://anon..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17ef8b43700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7094767cefc58fb9
> dashboard link: https://syzkaller.appspot.com/bug?extid=934ebb67352c8a490bf3
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+934ebb67352c8a490bf3-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
for-5.18/block

It should be fixed by:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=for-5.18/block&id=d578c770c85233af592e54537f93f3831bde7e9a

Thanks,

