From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: Racy manipulation of task_struct->flags in cgroups code causes
 hard to reproduce kernel panics
Date: Sat, 20 Sep 2014 10:15:50 -0700
Message-ID: <CAGXu5j+P_kcgZuqYsemgL0KU_zRhz5HGJ6seh2oLyyst=cZP6g@mail.gmail.com>
References: <201409192053.IHJ35462.JLOMOSOFFVtQFH@I-love.SAKURA.ne.jp>
	<541D16EA.70407@huawei.com>
	<20140920143012.GL2832@worktop.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=t17ZEW2TFxIAmsScR/bAufRBp+qi1SQqHA7g7qb6zQ8=;
        b=G8gQBj8qab6/HQTsxkKqWnvw8xKghEsggr2ecCkDskLUfzQXO6iJlm8SnB0e8LHOmZ
         ZL58Zb8Tsr+4CPCTue5N69dcqQ0oE3M+TMmF0vJePmlGPGzuv5ackJ9Z14ZiBfyxS31j
         pRA3Zc6Ftj+6wd+kyQylun1HtgDgTqbJwYbZabN2Ysps6EsjRybUrSdkkTtBJvDtTwgm
         rCLhFnQkQQBTyXxKHzysQ2D/nmvauGkEqrWpgg17bb4+PPee9kINc/6TXfBQplUUpRLf
         4XkQsoZSmukzQ52k11lHMbPce3SRtF6EKDDYzwd+AyjLiry1XF0t0EcdTxFMux3NYTNS
         Q4jw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=t17ZEW2TFxIAmsScR/bAufRBp+qi1SQqHA7g7qb6zQ8=;
        b=GMB6QKe5Ov0rMIfCpgETQfltiTjyL896YUBv9ugqNZXLjRP5nNm7M/cbwVJ6X/g5Y9
         /cxh9jA+N7sU94HpE8m2cE/qGZqHSMjGoLXNs781fX7bcQjLihJnQ6ZKk0kihtUisVPo
         /RFC20kknVgn5F3kJZ153bFsS+4b/FaUWnCGs=
In-Reply-To: <20140920143012.GL2832-IIpfhp3q70wB9AHHLWeGtNQXobZC6xk2@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fernando_b1-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Sat, Sep 20, 2014 at 7:30 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Sat, Sep 20, 2014 at 01:55:54PM +0800, Zefan Li wrote:
>> We should make the updating of this flag atomic.
>
>>  /* Per-process atomic flags. */
>>  #define PFA_NO_NEW_PRIVS 0x00000001  /* May not gain new privileges. */
>> +#define PFA_SPREAD_PAGE  0x00000002  /* Spread page cache over cpuset */
>> +#define PFA_SPREAD_SLAB  0x00000004  /* Spread some slab caches over cpuset */
>
> Ooh, I was not ware we had those.. /me checks where that came from. Hmm
> weird, while I did get that patch it had a seccomp prefix when landing
> in my inbox so I ignored it. However the commit has a sched prefix
> (which I would not have ignored). Dubious things happened here.

The series went through a lot of revisions, so it probably gained the
sched prefix later in its life. Is there anything that needs changing
about how this has been implemented?

-Kees

-- 
Kees Cook
Chrome OS Security
