From: Tejun Heo <tj@kernel.org>
Subject: Re: KASAN: null-ptr-deref Read in css_task_iter_advance
Date: Mon, 10 Jun 2019 11:19:01 -0700
Message-ID: <20190610181901.GC3341036@devbig004.ftw2.facebook.com>
References: <00000000000055aba7058af4d378@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Rd7jWnbbAp4RfevQw78c7K7px6JtJUHSgmHkrc6gVU4=;
        b=NoqhzsNrSi7dYNU8yAmO1tRvsVK2jYNpAak6UvyF+UpISCg7sKKp+j/LODUeyNnGGM
         hB7/cEOSqt99ksyAvEbmXLwW8gjf7zgNTpXKPcsWgHJE4LXlXBTkZJGO863W9xk+Vfat
         bVgUYj+I5DTk0xpfsYwKEFMzHbBQ25NIZlsNGltPdj8av7Iu80Z3ZEndzt9anwoXuCJg
         w9DHDLsr4c9Shkn8cu5DWwZD9OGLwo8vPBxuBGW+Dso5njoo8SXGL4M9eyzxFV0sZd+c
         pIqDtQM6P93Q2vkFkzEs75Hx4V++tpJfhxoXy6X8hAERs+zTcnH3Ww+l4K093n0sdlZm
         G5qA==
Content-Disposition: inline
In-Reply-To: <00000000000055aba7058af4d378@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hillf Danton <hdanton@sina.com>
Cc: syzbot <syzbot+d4bba5ccd4f9a2a68681@syzkaller.appspotmail.com>, ast@kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, daniel@iogearbox.net, hannes@cmpxchg.org, kafai@fb.com, linux-kernel@vger.kernel.org, lizefan@huawei.com, netdev@vger.kernel.org, songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com

Hello, Hillf.

On Tue, Jun 11, 2019 at 12:59:23AM +0800, Hillf Danton wrote:
> >syzbot will keep track of this bug report. See:
> >https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> Ignore my noise if you have no interest seeing the syzbot report.

They're awesome.

> The following tiny diff, made in the hope that it may help you perhaps
> reproduce the crash, waits css lock holders and then pick task off
> the list of dying tasks.

I already posted a fix.  Well, at least I think it's the fix.

  https://www.spinics.net/lists/cgroups/msg22468.html

Thanks.

-- 
tejun
