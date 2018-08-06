From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING in try_charge
Date: Mon, 6 Aug 2018 12:39:09 +0200
Message-ID: <CACT4Y+ZEAoPWxEJ2yAf6b5cSjAm+MPx1yrk70BWHRrnDYdyb_A@mail.gmail.com>
References: <0000000000005e979605729c1564@google.com> <20180806091552.GE19540@dhcp22.suse.cz>
 <CACT4Y+Ystnwv4M6Uh+HBKbdADAnJ6otfR0GoA20crzqV+b2onQ@mail.gmail.com> <20180806094827.GH19540@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0000000000007a019c0572c1e4c7"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=3YXuO62zqnigkAN0aa5Es4B/dz6ofYWKyyPaB8qwyBg=;
        b=p9++obN7bsuMznBuY9mt+9yKa53K0fh+f6X2nNEhsxuJDbj6Vlz3z0cgSvaqKAbpZu
         Dz3RUBTvI/EGw052s6VJtCIgIX8PbGY0PnxrH4BzaruFXW+eLzT9r13Du1ALrJUiJe8q
         utYw9DCvPX2EGGCppcazaAOTNJ/QFrA+m3D/LvGhy1FI2ybImn5V6VvdvqQ1G7GbMBqp
         BxK3kviY8Avh7FSs8HOWSGd4/S6Twv3O2PsvH/5mcpXfRQ7GnAc4DUzwYvJB9b9Hyu/p
         Gs00JnDoSQlMaAzjyg5A63glE5wXypda2D35Xq2Yjpjqt1N9sFLj6gL4j7u8r33nT9QG
         hEeg==
In-Reply-To: <20180806094827.GH19540@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Michal Hocko <mhocko@kernel.org>
Cc: syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vladimir Davydov <vdavydov.dev@gmail.com>

--0000000000007a019c0572c1e4c7
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 6, 2018 at 11:48 AM, Michal Hocko <mhocko@kernel.org> wrote:
> On Mon 06-08-18 11:30:37, Dmitry Vyukov wrote:
>> On Mon, Aug 6, 2018 at 11:15 AM, Michal Hocko <mhocko@kernel.org> wrote:
> [...]
>> > More interesting stuff is higher in the kernel log
>> > : [  366.435015] oom-kill:constraint=CONSTRAINT_MEMCG,nodemask=(null),cpuset=/,mems_allowed=0,oom_memcg=/ile0,task_memcg=/ile0,task=syz-executor3,pid=23766,uid=0
>> > : [  366.449416] memory: usage 112kB, limit 0kB, failcnt 1605
>> >
>> > Are you sure you want to have hard limit set to 0?
>>
>> syzkaller really does not mind to have it.
>
> So what do you use it for? What do you actually test by this setting?
>
> [...]
>> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> > index 4603ad75c9a9..852cd3dbdcd9 100644
>> > --- a/mm/memcontrol.c
>> > +++ b/mm/memcontrol.c
>> > @@ -1388,6 +1388,8 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>> >         bool ret;
>> >
>> >         mutex_lock(&oom_lock);
>> > +       pr_info("task=%s pid=%d invoked memcg oom killer. oom_victim=%d\n",
>> > +                       current->comm, current->pid, tsk_is_oom_victim(current));
>> >         ret = out_of_memory(&oc);
>> >         mutex_unlock(&oom_lock);
>> >         return ret;
>> >
>> > Anyway your memcg setup is indeed misconfigured. Memcg with 0 hard limit
>> > and basically no memory charged by existing tasks is not going to fly
>> > and the warning is exactly to call that out.
>>
>>
>> Please-please-please do not mix kernel bugs and notices to user into
>> the same bucket:
>
> Well, WARN_ON used to be a standard way to make user aware of a
> misbehavior. In this case it warns about a pottential runaway when memcg
> is misconfigured. I do not insist on using WARN_ON here of course. If
> there is a general agreement that such a condition is better handled by
> pr_err then I am fine with it. Users tend to be more sensitive on
> WARN_ONs though.
>
> Btw. running with the above diff on top might help us to ideantify
> whether this is a pre-mature warning or a valid one. Still useful to
> find out.

The bug report has a reproducer, so you can run it with the patch. Or
ask syzbot to test your patch:
https://github.com/google/syzkaller/blob/master/docs/syzbot.md#testing-patches
Which basically boils down to saying:

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
master

Note that a text patch without a base tree/commit can be useless, I
used torvalds/linux.git but I don't know if it will apply there or
not. Let's see.

--0000000000007a019c0572c1e4c7
Content-Type: text/x-patch; charset="US-ASCII"; name="cgroup.patch"
Content-Disposition: attachment; filename="cgroup.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jki54m7q0

ZGlmZiAtLWdpdCBhL21tL21lbWNvbnRyb2wuYyBiL21tL21lbWNvbnRyb2wuYwppbmRleCA0NjAz
YWQ3NWM5YTkuLjg1MmNkM2RiZGNkOSAxMDA2NDQKLS0tIGEvbW0vbWVtY29udHJvbC5jCisrKyBi
L21tL21lbWNvbnRyb2wuYwpAQCAtMTM4OCw2ICsxMzg4LDggQEAgc3RhdGljIGJvb2wgbWVtX2Nn
cm91cF9vdXRfb2ZfbWVtb3J5KHN0cnVjdCBtZW1fY2dyb3VwICptZW1jZywgZ2ZwX3QgZ2ZwX21h
c2ssCiAJYm9vbCByZXQ7CiAKIAltdXRleF9sb2NrKCZvb21fbG9jayk7CisJcHJfaW5mbygidGFz
az0lcyBwaWQ9JWQgaW52b2tlZCBtZW1jZyBvb20ga2lsbGVyLiBvb21fdmljdGltPSVkXG4iLAor
CQkJY3VycmVudC0+Y29tbSwgY3VycmVudC0+cGlkLCB0c2tfaXNfb29tX3ZpY3RpbShjdXJyZW50
KSk7CiAJcmV0ID0gb3V0X29mX21lbW9yeSgmb2MpOwogCW11dGV4X3VubG9jaygmb29tX2xvY2sp
OwogCXJldHVybiByZXQ7Cgo=
--0000000000007a019c0572c1e4c7--
