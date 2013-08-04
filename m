From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH V5 5/8] memcg: add per cgroup writeback pages accounting
Date: Sun, 4 Aug 2013 12:08:55 +0200
Message-ID: <20130804100855.GD24005@dhcp22.suse.cz>
References: <1375357402-9811-1-git-send-email-handai.szj@taobao.com>
 <1375358051-10306-1-git-send-email-handai.szj@taobao.com>
 <20130801145302.GJ5198@dhcp22.suse.cz>
 <CAFj3OHV-VCKJfe6bv4UMvv+uj4LELDXsieRZFJD06Yrdyy=XxA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=KcEtgfuTVzuzYixoiGGRTWCvZ6n2CQ0r2PY0MmgahIM=;
        b=n64rhKD8iQGkWrWpROGyrsJaRAv/Yl2kRqB11twctiOxZHwDY4Yy4lmEnfdGsXJfRT
         WEUMI2grXOYVZVXQH2c/bRfMC2MYcsSrwgDwxnHPq1kiJas29RiEsQe1VMGTrsqUJLT8
         ti0nZOaXU3yyy4UNVnoXaB7Gl4gGNBoLt7sZsK7CBYJEL4eEYGSPbG2OUInXt6ekYoMU
         RQH+tdnNZpmbRQ9Dcy/SjGtycofAKd3ZKUP8vS5TFoBG4qWddZK/uAI0rNhObWBwtWLE
         3UVR54m/5vTPvYosvk6qcdMwAwMSGRphe1kXO+YfPMRZPN3/T5geGTo1090/ghAaRFst
         53nQ==
Content-Disposition: inline
In-Reply-To: <CAFj3OHV-VCKJfe6bv4UMvv+uj4LELDXsieRZFJD06Yrdyy=XxA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Sat 03-08-13 17:25:01, Sha Zhengju wrote:
> On Thu, Aug 1, 2013 at 10:53 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> > On Thu 01-08-13 19:54:11, Sha Zhengju wrote:
> >> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> >>
> >> Similar to dirty page, we add per cgroup writeback pages accounting. The lock
> >> rule still is:
> >>         mem_cgroup_begin_update_page_stat()
> >>         modify page WRITEBACK stat
> >>         mem_cgroup_update_page_stat()
> >>         mem_cgroup_end_update_page_stat()
> >>
> >> There're two writeback interfaces to modify: test_{clear/set}_page_writeback().
> >> Lock order:
> >>       --> memcg->move_lock
> >>         --> mapping->tree_lock
> >>
> >> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> >
> > Looks good to me. Maybe I would suggest moving this patch up the stack
> > so that it might get merged earlier as it is simpler than dirty pages
> > accounting. Unless you insist on having the full series merged at once.
> 
> I think the following three patches can be merged earlier:
>       1/8 memcg: remove MEMCG_NR_FILE_MAPPED
>       3/8 memcg: check for proper lock held in mem_cgroup_update_page_stat
>       5/8 memcg: add per cgroup writeback pages accounting
> 
> Do I need to resent them again for you or they're enough?

This is a question for Andrew. I would go with them as they are.
 
> One more word, since dirty accounting is essential to future memcg
> dirty page throttling and it is not an optional feature now, I suspect
> whether we can merge the following two as well and leave the overhead
> optimization a separate series.  :p

I wouldn't hurry it. We need numbers for serious testing to see the
overhead. It is still just a small step towards dirty throttling.

>       4/5 memcg: add per cgroup dirty pages accounting
>       8/8 memcg: Document cgroup dirty/writeback memory statistics
> 
> The 2/8 ceph one still need more improvement, I'll separate it next version.
> 
> >
> > Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> 
> Thank you.
[...]
-- 
Michal Hocko
SUSE Labs
