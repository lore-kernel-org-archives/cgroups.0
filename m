From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: Fix rootcg cpu.stat guest double counting
Date: Fri, 29 Oct 2021 13:21:29 -0400
Message-ID: <20211029172129.smeyk5adocjrwtlb@oracle.com>
References: <20211028221528.2174284-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=2sWDVwzigqWs7t7Psm7fio//xf8iT/GtRo+3ZSvQHgI=;
 b=Znme2SpqqAQwGf7LQlpr6mPwhCcPxkNPBdJHjTTA7iW9T9Nq7n3k0yEGiTUEJ4FmZ5rx
 a9vjfrS17zcIw3vq0VZ+oKSB84xpR2tGVUbkqMnD5fdYEdcTdML8FPKUeFMYT73+vBpZ
 UpB5qcBkIO5XrmtxRB16ZSZN9KjKZszCacLH+K32xGxYP3MVi91kMKZAXUw7ELDYa5Se
 Wvd2nkYtg7zuulGx4wiF42V6IalI7CIUPHdblEn05n5dj8EMS26VgwN3oMwm+O5ctqDR
 Wfn/17u+tu2ORzwrpDuQr/pVtLwPopPI8yj17zi9phryORncvAlDu4NBo71EBXelM6eY Ig== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2sWDVwzigqWs7t7Psm7fio//xf8iT/GtRo+3ZSvQHgI=;
 b=FtOLzYP6rzKZ5pM0O0yxkToDVvcTGN3tkIuxKxls6eKG4pnVPDlmHd8SwOxoo8/PYiMQwJnQcoru85UdGW+CQNgwULhFXy8OAia49QlF34OK2i+KNJXQLs4dQLURMWpkNTcPPkMFcNyyjuHLuGZMkhLfqrmAbLEnK9p5YJMjtHQ=
Content-Disposition: inline
In-Reply-To: <20211028221528.2174284-1-schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>

On Thu, Oct 28, 2021 at 03:15:27PM -0700, Dan Schatzberg wrote:
> In account_guest_time in kernel/sched/cputime.c guest time is
> attributed to both CPUTIME_NICE and CPUTIME_USER in addition to
> CPUTIME_GUEST_NICE and CPUTIME_GUEST respectively. Therefore, adding
> both to calculate usage results in double counting any guest time at
> the rootcg.

Yes, definitely a bug.  The same fix was posted a couple months ago as
part of a series but never picked up:

  https://x-lore.kernel.org/all/20210820094005.20596-3-arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org/

The series also touched cputime, so we might be waiting for scheduler
folks?   +Ingo +Peter +Andrey
