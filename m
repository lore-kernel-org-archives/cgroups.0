From: syzbot <syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com>
Subject: Re: BUG: corrupted list in insert_work
Date: Mon, 15 Aug 2022 22:58:08 -0700
Message-ID: <000000000000c518d505e6556ed8@google.com>
References: <000000000000aaac8505dc135b07@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <000000000000aaac8505dc135b07@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, brauner@kernel.org, cgroups@vger.kernel.org, daniel@iogearbox.net, dvyukov@google.com, hannes@cmpxchg.org, hdanton@sina.com, john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, lizefan.x@bytedance.com, lkp@intel.com, lkp@lists.01.org, mkoutny@suse.com, netdev@vger.kernel.org, oliver.sang@intel.com, songliubraving@fb.com, stable@vger.kernel.org, syzkaller-android-bugs@googlegroups.com, syzkaller-bugs@googlegroups.com, tadeusz.struk@linaro.org, tj@kernel.org, yhs@fb.com

syzbot suspects this issue was fixed by commit:

commit d007f49ab789bee8ed76021830b49745d5feaf61
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed May 18 06:13:40 2022 +0000

    percpu_ref_init(): clean ->percpu_count_ref on failure

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10c66b6b080000
start commit:   ebc9fb07d294 ANDROID: random: fix CRC issues with the merge
git tree:       android12-5.10-lts
kernel config:  https://syzkaller.appspot.com/x/.config?x=32c952ff4a8ff8c1
dashboard link: https://syzkaller.appspot.com/bug?extid=e42ae441c3b10acf9e9d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=172a9074080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10456caa080000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: percpu_ref_init(): clean ->percpu_count_ref on failure

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
