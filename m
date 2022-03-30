From: syzbot <syzbot+934ebb67352c8a490bf3@syzkaller.appspotmail.com>
Subject: Re: [syzbot] possible deadlock in throtl_pending_timer_fn
Date: Tue, 29 Mar 2022 19:52:57 -0700
Message-ID: <0000000000009518f205db66a47a@google.com>
References: <CAFj5m9+Gc-t6vD17yWBNos-fk9vmhUTLsXYGrSx4Bdzn7R67JQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAFj5m9+Gc-t6vD17yWBNos-fk9vmhUTLsXYGrSx4Bdzn7R67JQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ming.lei@redhat.com, syzkaller-bugs@googlegroups.com, tj@kernel.org

> On Wed, Mar 30, 2022 at 5:23 AM syzbot
> <syzbot+934ebb67352c8a490bf3@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    cb7cbaae7fd9 Merge tag 'drm-next-2022-03-25' of git://anon..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=17ef8b43700000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=7094767cefc58fb9
>> dashboard link: https://syzkaller.appspot.com/bug?extid=934ebb67352c8a490bf3
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+934ebb67352c8a490bf3@syzkaller.appspotmail.com
>
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git

This crash does not have a reproducer. I cannot test it.

> for-5.18/block
>
> It should be fixed by:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=for-5.18/block&id=d578c770c85233af592e54537f93f3831bde7e9a
>
> Thanks,
>
