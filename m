From: richard -rw- weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Announce] Checkpoint-restore tool v0.1
Date: Mon, 30 Jul 2012 12:42:54 +0200
Message-ID: <CAFLxGvwUhEPNdQvUnue2QFu_EipmBKD3nf0MfMWkqwLTf7jd5Q@mail.gmail.com>
References: <500D09C9.7060903@parallels.com>
	<500D1116.7070301@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=KFb0Chzv53faPCb99Q0rdF9UnT6Iw+tcpwDDBUb/NAY=;
        b=cD9d1orkm2tzkVeVCyuLysBq7OY0wdOcIzal94cMBYsv6EqgQwZQmPL3DQ7cflp0Y9
         lxlFflCv7zGXEu8w8yjDfVZBC8wyz+aLVhEmamnKQBQyL82QkV7S6yeomSQHqW3TYgKh
         4Lv7mHVZ52AkwjvtdyTx7OUgf+KLFPceIrK64tiXMmtHe292dPBoZcZfdFM4UwR9vLmV
         vfIpcwblx+l4EZBJdNN2KjNcxUoXPpwSrbhMgwnBroDKxS1PuoQFCt5meYyY8FCYINtZ
         +48F1qtIohvWF8m1IUvmq2xO5p+oLefMZV921UdwQakZ5iyrLXbBf9FO4kt8HBTF4Ie+
         7QmQ==
In-Reply-To: <500D1116.7070301-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lwn-T1hC0tSOHrs@public.gmane.org, "criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, users-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jul 23, 2012 at 10:53 AM, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> This project is an attempt to implement the checkpoint-restore functionality
> for processes and containers without driving too much code into the kernel tree,
> but putting there "various oddball helper code" instead.

Is CRIU able to checkpoint a process tree where one or more processes
are traced using ptrace()?
crtools seem to use ptrace() to execute parasite system calls.
AFAIK this will only work if the target process is currently not
ptraced() by another process.

-- 
Thanks,
//richard
