From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v3 2/3] sched: add macros to define bitops for task atomic flags
Date: Tue, 23 Sep 2014 09:58:23 -0700
Message-ID: <CAGXu5jLjAtHUZsLW0S4SPaKtx__P-fgeCQqD6naKYVtJ_9b9Eg@mail.gmail.com>
References: <542124D3.9000007@huawei.com>
	<542124FB.4030109@huawei.com>
	<20140923100127.GE3312@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=/21Y7wWE6oVUkFrBX4aG5I1XDYpY8tnLuP8uKWus10E=;
        b=o5zG6WiU69C22KBYAyh/zPZ8yTFU0djA6SCnnoFmfl5lbajQjf25gnV4ePL6fhJcy3
         Dx4JjX4Uq2LCB1MOLI1AJyCPBzgxJ6sgAr8+W1zDBciYGW+y0OyjpfbaPnOLKEjLgukK
         UjuHGUrHQyg/IQ1BQLUgKhY3dlcMIUhtoAhSJ0754YLmsWFGDRtXUTuJ1DQO0krxsDwC
         ObfQaoZgaCJ3kyta1fQAnSjlASFuAJc12nHt8HpnOajkpivibRu5OUDQlhsEvC23q7pk
         n0MiC2x/wVRN2VC2Nu55xmpKx5ZZwCfnax3wfrQafAdLCTkBSne92cWUyU+xldxj/+8m
         UQwQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=/21Y7wWE6oVUkFrBX4aG5I1XDYpY8tnLuP8uKWus10E=;
        b=HZogTEISUrll+RDYsPxY/V0ji4ZxfG4tfMGFoGzX45Pc6aZ4smG6CSbR85nFuwdBhp
         ME6qtXx4Gm2g6vo0bhjJO+eUf71frmL1Lhb5ikqoXBa5mSu7FJj7GIdQZMqhT21mmz42
         SBUStt7hyzFbdJpM+SpMBirqtNsOypXg596vc=
In-Reply-To: <20140923100127.GE3312-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Miao Xie <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Sep 23, 2014 at 3:01 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Tue, Sep 23, 2014 at 03:44:59PM +0800, Zefan Li wrote:
>> This will simplify code when we add new flags.
>>
>> v3:
>> - Kees pointed out that no_new_privs should never be cleared, so we
>> shouldn't define task_clear_no_new_privs(). we define 3 macros instead
>> of a single one.

Thanks! This looks good to me.

>>
>> v2:
>> - updated scripts/tags.sh, suggested by Peter.
>>
>> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>> Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Cc: Miao Xie <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
>> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> Cc: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
>> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> Acked-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

-Kees

-- 
Kees Cook
Chrome OS Security
