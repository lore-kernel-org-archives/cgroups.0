From: Cong Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix unbalanced locking
Date: Thu, 18 Sep 2014 09:14:37 -0700
Message-ID: <CAM_iQpV0LykCy1GpZUmaAse_niNPnabLKTkW=LdoBjKhqkyx0Q@mail.gmail.com>
References: <541AA5CE.8040006@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=/Yx19dgbchUZXJUCiafWzsrC5qgBMwLTzNszQNBAYvM=;
        b=XjJgQH0KD70PO7nAiX4s22Zhq7MLSUmBmFKGa95n2/LILZZyAPqLliectVvqFMoSmV
         XgK13da6RHspjrwMArjz+7NS+f44Dn3fcAIy2PyDHTeONqDvfzC2+yKVXKpzeqblD7lk
         YRmQK2R/nDA2Z/pJoPw6aYN3haVXTkMkum+Zzz5YxFPmKN3foGnnK+pn36RqoqmdDaJq
         8F8t6aMs4Lk2mTwPujhSv2Uz8DcWTBywSW0VTEoK1KH1k+xAlzzNkuSgKixZJhNFFNei
         aRT47ztVyla+SRFz17PD5u3dDqSed3ltpM6hp5AjX6LBDCCoQLanDiCskQGGmcDDp21z
         OYgQ==
In-Reply-To: <541AA5CE.8040006-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Sep 18, 2014 at 2:28 AM, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> cgroup_pidlist_start() holds cgrp->pidlist_mutex and then calls
> pidlist_array_load(), and cgroup_pidlist_stop() releases the mutex.
>
> It is wrong that we release the mutex in the failure path in
> pidlist_array_load(), because cgroup_pidlist_stop() will be called
> no matter if cgroup_pidlist_start() returns errno or not.
>

I found same thing yesterday and tried to analysis if this could
be the cause of the the NULL ptr def bug I saw, it seems not.

Anyway, this fix is definitely correct,

Acked-by: Cong Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
