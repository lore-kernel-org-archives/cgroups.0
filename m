From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [syzbot] WARNING in cgroup_finalize_control
Date: Sun, 21 Nov 2021 11:22:56 -0500
Message-ID: <97cf8c1f-2a1d-d505-9216-37a3da0fc7f6@redhat.com>
References: <000000000000d6442705d143337a@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637511813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5o6/wBGbGY6DcbOKW8sJZyFNOEtnCAysm1b68CJVM+g=;
        b=f/eRZKAZxiYr1bJyNUD6VP71vaIeslR83uXJaYAL8ZO5u/adAvn3HMZDe9v/dH1v5eW/Kj
        i9cC0C7ZMz5HteVfceDbmUIgBIPaIBLughU7YYJ/0cZbWiFrBTCOxY0izitnj5P5YfOZgD
        FeDoVj+GOkiikG6r6KFSHmaYHQuDnaw=
Content-Language: en-US
In-Reply-To: <000000000000d6442705d143337a-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: syzbot <syzbot+9c08aaa363ca5784c9e9-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, andriin-b10kYP2dOMg@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org, coreteam-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org, kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, kpsingh-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org

#syz fix: cgroup: Make rebind_subsystems() disable v2 controllers all at once


On 11/20/21 21:24, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
>
> commit 7ee285395b211cad474b2b989db52666e0430daf
> Author: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date:   Sat Sep 18 22:53:08 2021 +0000
>
>      cgroup: Make rebind_subsystems() disable v2 controllers all at once
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12232c06b00000
> start commit:   442489c21923 Merge tag 'timers-core-2020-08-04' of git://g..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b3f0df8558780a7d
> dashboard link: https://syzkaller.appspot.com/bug?extid=9c08aaa363ca5784c9e9
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14148c62900000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: cgroup: Make rebind_subsystems() disable v2 controllers all at once
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>

