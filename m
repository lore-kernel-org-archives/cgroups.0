From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING in try_charge
Date: Mon, 6 Aug 2018 13:58:25 +0200
Message-ID: <CACT4Y+ZY6u9qqx6FofECrAZ6TmbcqZ=b4GVwHsxV6hZtNsypgQ@mail.gmail.com>
References: <884de816-671a-44d4-a6a1-2ad7eff53715@I-love.SAKURA.ne.jp>
 <00000000000070698b0572c28ebc@google.com> <20180806113212.GK19540@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=M0pPiB+CXXU1AblPzfly4vNNV69SoNgZgh1tMpOFBNI=;
        b=PNhOGu+8J534MszwauV9KKOiOaiIYnsBH3jtIvTNvV8ZGFIPRZRozi4KRzGQu5N6lK
         bhmG/Y01OhpTP8FKabwPPU4CLrnHfucQZa/ovwwtelxHyPJ4CkQObK579Uj8z/BjhyCS
         yMKxGj6mRy0ZZ9PcFHCQIcDzIdKo/ccgrN9VJuMGshyO2TZj2NEkSVavs9EwqebaP8cw
         AuBYsskDq51COgUClAEJWul1Zx1QL1GCI76fELC7KwGaFG5HAMe1LiCfpiI2IsEjO64V
         PbXR4+ZI/u4uhU17QL6PPi+B8wHuiOK+ofTpmaHY59R8chu5DtX3jJiRNsr+0+Okrows
         D5gA==
In-Reply-To: <20180806113212.GK19540@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vladimir Davydov <vdavydov.dev@gmail.com>

On Mon, Aug 6, 2018 at 1:32 PM, Michal Hocko <mhocko@kernel.org> wrote:
> On Mon 06-08-18 04:27:02, syzbot wrote:
>> Hello,
>>
>> syzbot has tested the proposed patch and the reproducer did not trigger
>> crash:
>>
>> Reported-and-tested-by:
>> syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com
>>
>> Tested on:
>>
>> commit:         8c8399e0a3fb Add linux-next specific files for 20180806
>> git tree:       linux-next
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=1b6bc1781e49e93e
>> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>> patch:          https://syzkaller.appspot.com/x/patch.diff?x=14fe18e2400000
>>
>> Note: testing is done by a robot and is best-effort only.
>
> OK, so this smells like a problem in the previous group oom changes. Or
> maybe it is not very easy to reproduce?

It's possible to ask syzbot to test on a particular tree/commit too.
