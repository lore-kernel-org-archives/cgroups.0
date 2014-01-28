From: Dermot McGahon <dmcgahon-mOLzCpKykOlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: CGroups and pthreads
Date: Tue, 28 Jan 2014 17:00:19 +0000
Message-ID: <CALaYU_AGFVdo1jaaNmN=KDH2Nr3=_Ud8WXzTXdgxpmJuwL_FAQ@mail.gmail.com>
References: <CALaYU_BZ8iuHnAgkss1wO7BK3qULgotYSpmX4nqX=uC+aTnddA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waratek.com; s=waratek;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type;
        bh=GwLETr74gh4+69Gxu/+FfjYa4mZV/Q43e6kgrWaDe4Y=;
        b=SGGZ2opUJ1qJZindSkVJ7Q7VNBADeLwY4X2tAj70MuydIdWIYKGfK6J19T1wVkHWtN
         r2n3493ha+4X2FRBVGfOuMhCwQDqLoH4YlZFDGO1YavCu9wCduyWsD3Fp+nY0IAR6UtP
         IwLpdTTDLkza6RWHdRADgcYhKPtYBXIm74uo0=
In-Reply-To: <CALaYU_BZ8iuHnAgkss1wO7BK3qULgotYSpmX4nqX=uC+aTnddA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Kernel version is 2.6.32 stock kernel for Red Hat Enterprise Linux 6.

Is there anyone on this list with good knowledge of how the memory subsystem
behaves?


On 27 January 2014 16:36, Dermot McGahon <dmcgahon-mOLzCpKykOlBDgjK7y7TUQ@public.gmane.org> wrote:
> Is it possible to apply cgroup memory subsystem controls to threads created
> with
> pthread_create() / clone or only tasks that have been created using fork and
> exec?
>
> In testing, we seem to be seeing that all allocations are accounted for
> against the
> PPID / TGID and never the pthread_create()'d TID, even though the TID is an
> LWP
> and can be seen using top (though RSS is aggregate and global of course).
>
> Attached is a simple test program used to print PID / TID and allocate
> memory
> from a cloned TID. After setting breakpoints in child and parent and setting
> up a
> cgroups hierarchy of 'parent' and 'child', apply memory.limit_in_bytes and
> memory.memsw.limit_in_bytes to the child cgroup only and adding the PID to
> the parent group and the TID to the child group we see that behaviour.
>
> Is that expected? I realise that the subsystems are all different but what
> is confusing
> us slightly is that we have previously used the CPU subsystem to set
> cpu_shares
> and adding LWP / TID's to individual cgroups worked just fine for that
>
> Am I misconfiguring somehow or is this a known difference between CPU and
> MEMORY subsystems?
>
