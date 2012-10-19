From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] oom, memcg: handle sysctl oom_kill_allocating_task while
 memcg oom happening
Date: Fri, 19 Oct 2012 11:52:33 +0200
Message-ID: <20121019095233.GB799@dhcp22.suse.cz>
References: <1350382328-28977-1-git-send-email-handai.szj@taobao.com>
 <20121016133439.GI13991@dhcp22.suse.cz>
 <CAFj3OHVW-betpEnauzk-vQEfw_7bJxFneQb2oWpAZzOpZuMDiQ@mail.gmail.com>
 <20121018115640.GB24295@dhcp22.suse.cz>
 <5080097D.5020501@gmail.com>
 <20121018153256.GC24295@dhcp22.suse.cz>
 <5080D308.1020805@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5080D308.1020805-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org" <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri 19-10-12 12:11:52, Sha Zhengju wrote:
> On 10/18/2012 11:32 PM, Michal Hocko wrote:
> >On Thu 18-10-12 21:51:57, Sha Zhengju wrote:
> >>On 10/18/2012 07:56 PM, Michal Hocko wrote:
> >>>On Wed 17-10-12 01:14:48, Sha Zhengju wrote:
> >>>>On Tuesday, October 16, 2012, Michal Hocko<mhocko-AlSwsSmVLrQ@public.gmane.org>   wrote:
> >>>[...]
> >>>>>Could you be more specific about the motivation for this patch? Is it
> >>>>>"let's be consistent with the global oom" or you have a real use case
> >>>>>for this knob.
> >>>>>
> >>>>In our environment(rhel6), we encounter a memcg oom 'deadlock'
> >>>>problem.  Simply speaking, suppose process A is selected to be killed
> >>>>by memcg oom killer, but A is uninterruptible sleeping on a page
> >>>>lock. What's worse, the exact page lock is holding by another memcg
> >>>>process B which is trapped in mem_croup_oom_lock(proves to be a
> >>>>livelock).
> >>>Hmm, this is strange. How can you get down that road with the page lock
> >>>held? Is it possible this is related to the issue fixed by: 1d65f86d
> >>>(mm: preallocate page before lock_page() at filemap COW)?
> >>No, it has nothing with the cow page. By checking stack of the process A
> >>selected to be killed(uninterruptible sleeping), it was stuck at:
> >>__do_fault->filemap_fault->__lock_page_or_retry->wait_on_page_bit--(D
> >>state).
> >>The person B holding the exactly page lock is on the following path:
> >>__do_fault->filemap_fault->__do_page_cache_readahead->..->mpage_readpages
> >>->add_to_page_cache_locked ---->(in memcg oom and cannot exit)
> >Hmm filemap_fault locks the page after the read ahead is triggered
> >already so it doesn't call mpage_readpages with any page locked - the
> >add_to_page_cache_lru is called without any page locked.

And I was probably blind yesterday because if I have looked inside
add_to_page_cache_lru then I would have found out that we lock the page
before charging it. /me stupid. Sorry about the confusion.
That one is OK, though, because the page is fresh new and not visible
when we charge it. This is not related to your problem, more on that
below.

> It's not the page being fault in filemap_fault that causing the
> problem, but those pages handling by readhead. To clarify the point,
> the more detailed call stack is:
> filemap_fault->do_async/sync_mmap_readahead->ondemand_readahead->
> __do_page_cache_readahead->read_pages->ext3/4_readpages->*mpage_readpages*
> 
> It is because mpage_readpages that bring the risk:
> for each of readahead pages
>      (1)add_to_page_cache_lru (--> *will lock page and go through
> memcg charging*) add the page to a big bio submit_bio (So those locked
> pages will be unlocked in end_bio after swapin)
> 
> So if a page is being charged and cannot exit from memcg oom
> successfully (following I'll explain the reason) in step (1), it will
> cause the submit_bio indefinitely postponed while holding the PageLock
> of previous pages.

OK I think I am seeing what you are trying to say, finally. But you
are wrong here. Previously locked&charged pages were already submitted
(every do_mpage_readpage submits the given page) so the IO will finish
eventually so those pages get unlocked.
 
[...]
> >>As I said, 37b23e05 has made pagefault killable by changing
> >>uninterruptible sleeping to killable sleeping. So A can be woke up to
> >>exit successfully and free the memory which can in turn help B pass
> >>memcg charging period.
> >>
> >>(By the way, it seems commit 37b23e05 and 7d9fdac need to be
> >79dfdaccd1d5 you mean, right? That one just helps when there are too
> >many tasks trashing oom killer so it is not related to what you are
> >trying to achieve. Besides that make sure you take 23751be0 if you
> >take it.
> >
> 
> Here is the reason why I said a process may go though memcg oom and cannot
> exit. It's just the phenomenon described in the commit log of 79dfdaccd:
> the old version of memcg oom lock can lead to serious starvation and make
> many tasks trash oom killer but nothing useful can be done.

Yes the trashing on oom is certainly possible without that patch and it
seems that this is what the culprit of the problem you are describing.

[...]
-- 
Michal Hocko
SUSE Labs
