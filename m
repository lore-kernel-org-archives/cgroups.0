From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 3/3] memcg: simplify lock of memcg page stat account
Date: Tue, 14 May 2013 17:13:07 +0800
Message-ID: <CAFj3OHW=FCGu6rhChLV2HgUFSRxDur4e8bmugXnq++c-P8mNRg@mail.gmail.com>
References: <1368421410-4795-1-git-send-email-handai.szj@taobao.com>
	<1368421545-4974-1-git-send-email-handai.szj@taobao.com>
	<20130513131251.GB5246@dhcp22.suse.cz>
	<20130513133809.GC5246@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=QZkSHcUpvIsxermDsX56O/zOlurcbnmjqMdWvBR7wFI=;
        b=WISfFqq8kLe85bcOVNtnYgWz1+uKLUduDfaByhjWOa1BiSVIkUVLcF/87m1ejW1B5f
         VKxtFc144qTeZL8QTra1ZV1FscBj7SAz+OxLQMRXjX8ZtJmhC+VY4wu7995OqKILvGPo
         VKOB+4t7anO/R1Vqs+6CP+LVanrzA8gBSThl61wTpbFH2j+o4qurQJR5fGFGKwCA4EkW
         uYH3P328rkDZblTKKzpcYlpADR/1r7vJT378oJbZ1l+7LHPIm3B+A6wH4xHAHmQp6/T6
         cOEUv8kfRTysntUYjw9/7Fahwge0Ny/kk76MYqWdVVVDCHbGwN0UDjVYKKjTTVTBNZs5
         BZPA==
In-Reply-To: <20130513133809.GC5246-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Mon, May 13, 2013 at 9:38 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
>
> On Mon 13-05-13 15:12:51, Michal Hocko wrote:
> [...]
> > I am sorry but I do not think this is the right approach. IMO we should
> > focus on mem_cgroup_begin_update_page_stat and make it really recursive
> > safe - ideally without any additional overhead (which sounds like a real
> > challenge)
>
> Or maybe we should just not over complicate this and simply consider
> recursivness when it starts being an issue. It is not a problem for
> rmap accounting anymore and dirty pages accounting seems to be safe as
> well and pages under writeback accounting was OK even previously.
> It doesn't make much sense to block dirty pages accounting by a
> non-existing problem.
>

Yes, the dirty/writeback accounting seems okay now. I sent this patch
out to see if I can do something to simplify the locks but this
approach seems to have its own drawbacks. Since you and Kame are NAK
to this, in the order of importance I'll put the patch aside and
continue the work of dirty page accounting. :)

Thanks for the teaching!


--
Thanks,
Sha
