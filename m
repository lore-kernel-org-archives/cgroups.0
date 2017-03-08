From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: counting file descriptors with a cgroup controller
Date: Tue, 7 Mar 2017 20:59:39 -0600
Message-ID: <CAG53R5VQrm-c-F8GdqJ9fx4n+=QU5n3gT-9adx4HqRO_R8BOaw@mail.gmail.com>
References: <CGME20170217093725eucas1p12478baf297d25303f3020f4973fbf3b0@eucas1p1.samsung.com>
 <87poihtaya.fsf%l.stelmach@samsung.com> <9a57890c-d9e9-5719-e155-ce1161795a02@samsung.com>
 <20170306185820.GA19696@htj.duckdns.org> <7fbd9c4c-76ca-4073-9afa-1ab54364ec79@samsung.com>
 <20170307194134.GE31179@htj.duckdns.org> <9ee62e45-6645-454b-11b5-85be746bc81a@samsung.com>
 <20170307204825.GH31179@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=4O/8zKmmnHjAhYmjJye7q1ey9EMn7pmWXs16j6E3qyE=;
        b=QvjhvyUdpzCmigbdLHoheDylUt02iKJNk2PoNyy0kouC9VLYYOz/J4N1cTH8frgErq
         YXMF5Zw8RbTPOSfqE/sbF3sPIrUsIC/HczT/JHQ0JcOW+f+vlPkSgm/46v3Zs5psJ4ax
         F3pOM0FOpt4ZYRHo23JRVgE8ulIRZJjzXvto8KHxyH9x1eajLyrdCJMUXWR146Z2yTBw
         O4FYyeWgLkiiQv7ZVfoDJUStU01RTFOnv2gdR2Sz9u6WWlUjH8eafZriKQDguEdkibvw
         fNKoUXrXHXlGoZC0tQfwbcpyrTXfG80VGfv+17i+iiyWMSygkDtRM2erwmd12OeamVUs
         kzQg==
In-Reply-To: <20170307204825.GH31179-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Tue, Mar 7, 2017 at 2:48 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Tue, Mar 07, 2017 at 09:06:49PM +0100, Krzysztof Opasiak wrote:
> > Personally, I don't want to use rlimit for this as it ends up returning
> > error code from for example open() when we hit the limit. This may lead to
> > some unpredictable crashes in  services (esp. those poor proprietary binary
> > blobs). Instead of injecting errors to service we would like to just get
> > notification that this service has more opened fds than it should and ask it
> > to restart in a polite way.
> >

How does those poor proprietary binary blobs remain polite after restart?
Do you mean you want to keep restarting them when it reaches the limit?

> > For memory seems to be quite easy to achieve as we can just get eventfd
> > notification when application passes given memory usage using memory cgroup
> > controller. Maybe you know some efficient method to do the same for fds?
>
> So, if all you wanna do is reliably detecting open(2) failures, can't
> you do that with bpf tracing?
>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
