From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH] memcg: make threshold index in the right position
Date: Thu, 2 Feb 2012 14:27:47 +0200
Message-ID: <20120202122747.GA12575@shutemov.name>
References: <1328175919-11209-1-git-send-email-handai.szj@taobao.com>
 <20120202101410.GA12291@shutemov.name>
 <4F2A6B5F.3090303@gmail.com>
 <4F2A6EBC.5090207@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4F2A6EBC.5090207-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Thu, Feb 02, 2012 at 07:08:44PM +0800, Sha Zhengju wrote:
> On 02/02/2012 06:54 PM, Sha Zhengju wrote:
> >On 02/02/2012 06:14 PM, Kirill A. Shutemov wrote:
> >>On Thu, Feb 02, 2012 at 05:45:19PM +0800, Sha Zhengju wrote:
> >>>From: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> >>>
> >>>Index current_threshold may point to threshold that just equal to
> >>>usage after __mem_cgroup_threshold is triggerd.
> >>I don't see it. Could you describe conditions?
> >>
> >It is because of the following code path in __mem_cgroup_threshold:
> >{
> >    ...
> >        i = t->current_threshold;
> >
> >        for (; i >= 0 && unlikely(t->entries[i].threshold > usage); i--)
> >                eventfd_signal(t->entries[i].eventfd, 1);
> >        i++;
> >
> >        for (; i < t->size && unlikely(t->entries[i].threshold <=
> >usage); i++)
> >                eventfd_signal(t->entries[i].eventfd, 1);
> >
> >        t->current_threshold = i - 1;
> >    ...
> >}
> >
> >For example:
> >now:
> >    threshold array:  3  5  7  9   (usage = 6)
> >                                   ^
> >                                index
> >
> >next turn:
> >    threshold array:  3  5  7  9   (usage = 7)
> >                                       ^
> >                                    index
> >
> >after registering a new event(threshold = 10):
> >    threshold array:  3  5  7  9  10 (usage = 7)
> >                                   ^
> >                                index
> Err.. Sorry for showing inaccurate index position... (may because of
> the mail format)
> 
> now:
>     threshold array:  3  [5]  7  9   (usage = 6, index = 5)
> 
> next turn:
>     threshold array:  3  5  [7]  9   (usage = 7, index = 7)
> 
> after registering a new event(threshold = 10):
>     threshold array:  3  [5]  7  9  10 (usage = 7, index = 5)

Good catch! Thank you.

Reviewed-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

-- 
 Kirill A. Shutemov
