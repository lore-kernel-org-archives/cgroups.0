From: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: WARNING in handle_mm_fault
Date: Wed, 25 Nov 2015 18:44:00 +0100
Message-ID: <CACT4Y+Y0EESD_HhgGE2pWPqfJsDgvSny=ZMfP1ewaSzd6z_bLg@mail.gmail.com>
References: <CACT4Y+ZCkv0BPOdo3aiheA5LXzXhcnuiw7kCoWL=b9FcC8-wqg@mail.gmail.com>
 <20151125084403.GA24703@dhcp22.suse.cz> <565592A1.50407@I-love.SAKURA.ne.jp>
 <CACT4Y+Zn+mK37-mvqDQTyt1Psp6HT2heT0e937SO24F7V1q7PA@mail.gmail.com>
 <201511260027.CCC26590.SOHFMQLVJOtFOF@I-love.SAKURA.ne.jp>
 <CACT4Y+ZdF09hOnb_bL4GNjytSMMGvNde8=9pdZt6gZQB1sp0hQ@mail.gmail.com> <20151125173730.GS27283@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=a5WHKEc4rS7fSliR/8iujIlIJyBWS2J5ARDgQCs79rc=;
        b=Zvo8+n2C7B6t30WXcJqjNfhfnJLHpT+mMetm+sc9HBjf1NqNxKJAowgJFI9Mo4bqgx
         lvUM4KSqcs/zZ6D0uc1BfNDjC8DtFUUB/grY7jMJZ1R6BQuKS2y39xrOSvdMQcfdkkFO
         TbqY1Kf8cbFZzKhwUKFNyICbblIzJfp4xA+hBrZ/3er4iBHHYBecm0lYEKVHnerJOLLa
         jYDFVa4mhr4n+VoZ7LSwirb8cZ7wTZn8V+moEUfwDH8r6n2Wg3uUVSqYV/KgkPtnTQJA
         Md/RU4jNsbGAbn4mYVK6WHnNbbE10rpgeb/SFWdpY+eroWW6/CcM+61WY3dRGw+FMjMs
         LaEw==
In-Reply-To: <20151125173730.GS27283-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzkaller <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Cc: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kostya Serebryany <kcc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Wed, Nov 25, 2015 at 6:37 PM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Wed 25-11-15 18:21:02, Dmitry Vyukov wrote:
> [...]
>> I have some progress.
>
> Please have a look at Peter's patch posted in the original email thread
> http://lkml.kernel.org/r/20151125150207.GM11639-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org

Yes, I've posted there as well. That patch should help.
