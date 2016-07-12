From: Shayan Pooya <shayan@liveve.org>
Subject: Re: bug in memcg oom-killer results in a hung syscall in another
 process in the same cgroup
Date: Tue, 12 Jul 2016 08:35:06 -0700
Message-ID: <CABAubTg91qrUd4DO7T2SiJQBK9ypuhP0+F-091ZxtmonjaaYWg@mail.gmail.com>
References: <CABAubThf6gbi243BqYgoCjqRW36sXJuJ6e_8zAqzkYRiu0GVtQ@mail.gmail.com>
 <20160711064150.GB5284@dhcp22.suse.cz> <CABAubThHfngHTQW_AEuW71VCvLyD_9b5Z05tSud5bf8JKjuA9Q@mail.gmail.com>
 <CABAubTjGhUXMeAnFgW8LGck1tgvtu12Zb9fx5BRhDWNjZ7SYLQ@mail.gmail.com> <20160712071927.GD14586@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=liveve-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=91rX/u5/g0h99r2I8RRyrSLSa1ULMk2Q/t+Gh+fuRt0=;
        b=Bmvo1bOIsTbVvAVO0ACCZSS8Zl63UvmvV7m+bhvMH98Zq8edVKdglN0QLPQu1HovqO
         6dj/IJjyXurvi7VuBfEsdlEBgrnTiLdXqL+Rq32HFF9TNVMBUCnfCuE0jCH9VFEhr514
         e32Pr5g2tH9yGlJ6KYPe31xR4fUg5bCtF3GKff58xOD6YHUqZdtutGybmZBVH7DMenri
         KHvhngvg45ofoVKfeVHxtOoos1bHjwxZaTbECInoCMhH50wVZWHWkrfytOkvpiwtlHf1
         9LPn6Y0QxMGZMA/JVfrqPwrYgIeiqYnCdUUDmBo1/m3CwrlpR76QJKBVn+THoqP5vrFy
         zL2w==
In-Reply-To: <20160712071927.GD14586@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, koct9i@gmail.com
Cc: cgroups mailinglist <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org

>> With strace, when running 500 concurrent mem-hog tasks on the same
>> kernel, 33 of them failed with:
>>
>> strace: ../sysdeps/nptl/fork.c:136: __libc_fork: Assertion
>> `THREAD_GETMEM (self, tid) != ppid' failed.
>>
>> Which is: https://sourceware.org/bugzilla/show_bug.cgi?id=15392
>> And discussed before at: https://lkml.org/lkml/2015/2/6/470 but that
>> patch was not accepted.
>
> OK, so the problem is that the oom killed task doesn't report the futex
> release properly? If yes then I fail to see how that is memcg specific.
> Could you try to clarify what you consider a bug again, please? I am not
> really sure I understand this report.

It looks like it is just a very easy way to reproduce the problem that
Konstantin described in that lkml thread. That patch was not accepted
and I see no other fixes for that issue upstream. Here is a copy of
his root-cause analysis from said thread:

Whole sequence looks like: task calls fork, glibc calls syscall clone with
CLONE_CHILD_SETTID and passes pointer to TLS THREAD_SELF->tid as argument.
Child task gets read-only copy of VM including TLS. Child calls put_user()
to handle CLONE_CHILD_SETTID from schedule_tail(). put_user() trigger page
fault and it fails because do_wp_page()  hits memcg limit without invoking
OOM-killer because this is page-fault from kernel-space.  Put_user returns
-EFAULT, which is ignored.  Child returns into user-space and catches here
assert (THREAD_GETMEM (self, tid) != ppid), glibc tries to print something
but hangs on deadlock on internal locks. Halt and catch fire.



Regards

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
