From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v5] cgroup: Add new capability to allow a process to
 migrate other tasks between cgroups
Date: Tue, 13 Dec 2016 09:48:40 -0800
Message-ID: <4c60e1be-c00a-5f26-f5de-7d32b9cb0f62@schaufler-ca.com>
References: <1481593143-18756-1-git-send-email-john.stultz@linaro.org>
 <CAKgNAkhGSYmtqLnCyXH8-dbmBJreo9mbVGRMyd_9hZ5D1F7q4g@mail.gmail.com>
 <221e80bd-3d99-6c35-dcd3-b2547f0abb11@schaufler-ca.com>
 <CALAqxLWaJT=a1Cc2Ja8ZuazjJYi3a2WW9ATB0NFP8670Dyq6bg@mail.gmail.com>
 <f7ccb39f-bad8-4a78-c796-90927b839494@schaufler-ca.com>
 <CALAqxLUgmeNxt5B5k720YRM=pUh=a-b2cg+mCM1n1QG-un2ofQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1481651331; bh=AvVmcqtOQ2sZSL0xvzgKaOKujFRnnAK+wZP7kdQUQt4=; h=Subject:To:References:Cc:From:Date:In-Reply-To:From:Subject; b=rt3Jvhn6LaPcN9bS9JwtiKP/LKwqukz63bJeXyYJby8XOwZdp52shlDi2VTs5UVs0KdzsHaHhScbAZSGlRfwyJom8VFxI6g0X1yGi7AfnJ5ToR6ovDuS2kq6z0fQvdDAkaHgijaKl3vJMJWNziO3izGP43xw52orgVvv+H2TR99Uus2tQH8+ePZuh+e1pi8VZW1G3NDbSU80O8PP10bGZuSYuusOpPm7IVbakAi7kzCEFJeuzx3s/Aa4GfMiFN9GX1OnKiUua9tCM00WshwkYxILuGZnNp+85DzKwlQvomzlgew7S+/bFQdOcN2rGFPElXYPkk9NMh2A21YYV9FuBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1481651331; bh=AvVmcqtOQ2sZSL0xvzgKaOKujFRnnAK+wZP7kdQUQt4=; h=Subject:To:References:Cc:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding; b=1FTdvol/uvsGwaX0/FptkgspSAf1fpGEjD3SICa/+gq6mBRrCwn470xBHk/0a6m5X1rnufdG2pKIDtYwX2Trhbe6LbUkRfjuLVZhOaP3pI+56QVk9fLm7sC5Hhii8pbqAYsfW2Hj3+mCnZ1D5j+5IcvAE7Lm6qz5Yj38ePPSwzo=
In-Reply-To: <CALAqxLUgmeNxt5B5k720YRM=pUh=a-b2cg+mCM1n1QG-un2ofQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: John Stultz <john.stultz@linaro.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, lkml <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, Colin Cross <ccross@android.com>, Dmitry Shmidt <dimitrysh@google.com>, Todd Kjos <tkjos@google.com>, Christian Poetzsch <christian.potzsch@imgtec.com>, Amit Pundir <amit.pundir@linaro.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Kees Cook <keescook@chromium.org>, "Serge E . Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Linux API <linux-api@vger.kernel.org>

On 12/13/2016 9:24 AM, John Stultz wrote:
> On Tue, Dec 13, 2016 at 9:17 AM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 12/13/2016 8:49 AM, John Stultz wrote:
>>> On Tue, Dec 13, 2016 at 8:39 AM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>> On 12/13/2016 1:47 AM, Michael Kerrisk (man-pages) wrote:
>>>>> How about CAP_CGROUP_CONTROL or some such, with the idea that this
>>>>> might be a capability that allows the holder to step outside usual
>>>>> cgroup rules? At the moment, that capability would allow only one such
>>>>> step, but maybe there would be others in the future.
>>>> I agree, but want to put it more strongly. The granularity of
>>>> capabilities can never be fine enough for some people, and this
>>>> is an example of a case where you're going a bit too far. If the
>>>> use case is Android as you say, you don't need this. As my friends
>>>> on the far side of the aisle would say, "just write SELinux policy"
>>>> to correctly control access as required.
>>> So.. The trouble is that while selinux is good for restricting
>>> permissions, the in-kernel permission checks here are already too
>>> restrictive.
>> Why did the original authors of cgroups make it that restrictive?
>> If there isn't a good reason, loosen it up. If there is a good
>> reason, then pay heed to it.
> That's what this patch is proposing. And I agree with Michael that the
> newly proposed cap was a bit to narrowly focused on my immediate use
> case, and broadening it to CGROUP_CONTROL is smart. Then that
> capability could be further restricted w/ selinux policy, as you
> suggest.

Adding a new capability is unnecessary. The current use of CAP_SYS_NICE,
while arguably obscure, provides as much "security" as a new capability
does. While cgroups are a wonderful thing, they don't need a separate
capability.

>
> thanks
> -john
>

