From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] oom, memcg: handle sysctl oom_kill_allocating_task while
 memcg oom happening
Date: Fri, 19 Oct 2012 12:11:52 +0800
Message-ID: <5080D308.1020805@gmail.com>
References: <1350382328-28977-1-git-send-email-handai.szj@taobao.com> <20121016133439.GI13991@dhcp22.suse.cz> <CAFj3OHVW-betpEnauzk-vQEfw_7bJxFneQb2oWpAZzOpZuMDiQ@mail.gmail.com> <20121018115640.GB24295@dhcp22.suse.cz> <5080097D.5020501@gmail.com> <20121018153256.GC24295@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=uRMkOvM2X+daHCX7RNi9eBGc4mB/pgEvyPixjhoRwtY=;
        b=dst3D1gL/zG0PmzY12s4xv+coPtNSoItjJGx465dx4zAYtwi1BxWecLq/uMqh2v+dm
         nzBaRq1ZFujJNm2192grTBa/D41p3BNZ6MzPh46vYojNDPfiseFdWOfcx21fDOAvpsf9
         PFeF5AtuBfnDu5CmueN1NbSqWOPHNIdz2/tr4diC6LeqWlQctgUVuaAQqGfp01lxJWe7
         1zqj7YPCy9LpL68UKeNJ6XVCWzb+kkOY7xTWoE3wcAkxMJyzElJQgbbEZp5r7ut9lr64
         Exm3xgXfSQSxWzD95G/4sQTwwNUjXajZrS9idx2MQ15G3Lq3nHJ2vOLni6Za6UbXFpqn
         /NGQ==
In-Reply-To: <20121018153256.GC24295-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org" <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 10/18/2012 11:32 PM, Michal Hocko wrote:
> On Thu 18-10-12 21:51:57, Sha Zhengju wrote:
>> On 10/18/2012 07:56 PM, Michal Hocko wrote:
>>> On Wed 17-10-12 01:14:48, Sha Zhengju wrote:
>>>> On Tuesday, October 16, 2012, Michal Hocko<mhocko-AlSwsSmVLrQ@public.gmane.org>   wrote:
>>> [...]
>>>>> Could you be more specific about the motivation for this patch? Is it
>>>>> "let's be consistent with the global oom" or you have a real use case
>>>>> for this knob.
>>>>>
>>>> In our environment(rhel6), we encounter a memcg oom 'deadlock'
>>>> problem.  Simply speaking, suppose process A is selected to be killed
>>>> by memcg oom killer, but A is uninterruptible sleeping on a page
>>>> lock. What's worse, the exact page lock is holding by another memcg
>>>> process B which is trapped in mem_croup_oom_lock(proves to be a
>>>> livelock).
>>> Hmm, this is strange. How can you get down that road with the page lock
>>> held? Is it possible this is related to the issue fixed by: 1d65f86d
>>> (mm: preallocate page before lock_page() at filemap COW)?
>> No, it has nothing with the cow page. By checking stack of the process A
>> selected to be killed(uninterruptible sleeping), it was stuck at:
>> __do_fault->filemap_fault->__lock_page_or_retry->wait_on_page_bit--(D
>> state).
>> The person B holding the exactly page lock is on the following path:
>> __do_fault->filemap_fault->__do_page_cache_readahead->..->mpage_readpages
>> ->add_to_page_cache_locked ---->(in memcg oom and cannot exit)
> Hmm filemap_fault locks the page after the read ahead is triggered
> already so it doesn't call mpage_readpages with any page locked - the
> add_to_page_cache_lru is called without any page locked.

It's not the page being fault in filemap_fault that causing the problem, 
but those
pages handling by readhead. To clarify the point, the more detailed call 
stack is:
filemap_fault->do_async/sync_mmap_readahead->ondemand_readahead->
__do_page_cache_readahead->read_pages->ext3/4_readpages->*mpage_readpages*

It is because mpage_readpages that bring the risk:
for each of readahead pages
      (1)add_to_page_cache_lru (--> *will lock page and go through memcg 
charging*)
      add the page to a big bio
submit_bio (So those locked pages will be unlocked in end_bio after swapin)

So if a page is being charged and cannot exit from memcg oom successfully
(following I'll explain the reason) in step (1), it will cause the 
submit_bio indefinitely
postponed while holding the PageLock of previous pages.

> This is at least the current code. It might be different in rhel6 but
> calling memcg charging with a page lock is definitely a bug.
>

The current code (mm repo since-3.6) here remains unchanged. Through we 
may need
to take care of page lock and memcg charging in mpage_readpages, it 
dives to fs level.
Besides 37b23e05 have already fixed the deadlock from the other side: 
process still can be
killed even waiting for pagelock. But considering other potential 
problem, we may as well do
something in mpage_readpages to avoid calling add_to_page_cache_lru with 
any page locked.

>> In mpage_readpages, B tends to read a dozen of pages in: for each of
>> page will do
>> locking, charging, and then send out a big bio. And A is waiting for
>> one of the pages
>> and stuck.
>>
>> As I said, 37b23e05 has made pagefault killable by changing
>> uninterruptible sleeping to killable sleeping. So A can be woke up to
>> exit successfully and free the memory which can in turn help B pass
>> memcg charging period.
>>
>> (By the way, it seems commit 37b23e05 and 7d9fdac need to be
> 79dfdaccd1d5 you mean, right? That one just helps when there are too
> many tasks trashing oom killer so it is not related to what you are
> trying to achieve. Besides that make sure you take 23751be0 if you
> take it.
>

Here is the reason why I said a process may go though memcg oom and cannot
exit. It's just the phenomenon described in the commit log of 79dfdaccd:
the old version of memcg oom lock can lead to serious starvation and make
many tasks trash oom killer but nothing useful can be done.


It is for these two reasons that cause the bug and can make the memcg 
unusable
(sys up to almost 100%)for hours even days... Once we give some extra memory
to the memcg(such as increase hardlimit a little), the processes tending 
into oom killer
will pass the charging and send bio out eventually, which will unlock 
those pages and
wake up the D sleeper.


>> backported to --stable tree to deliver RHEL users. ;-) )
> I am not sure the first one qualifies the stable tree inclusion as it is
> a feature.
>

When debugging the problem, we indeed found 37b23e05 is the key
enemy of the deadlock bug.


>>>> Then A can not exit successfully to free the memory and both of them
>>>> can not moving on.
>>>> Indeed, we should dig into these locks to find the solution and
>>>> in fact the 37b23e05 (x86, mm: make pagefault killable) and
>>>> 7d9fdac(Memcg: make oom_lock 0 and 1 based other than counter) have
>>>> already solved the problem, but if oom_killing_allocating_task is
>>>> memcg aware, enabling this suicide oom behavior will be a simpler
>>>> workaround. What's more, enabling the sysctl can avoid other potential
>>>> oom problems to some extent.
>>> As I said, I am not against this but I really want to see a valid use
>>> case first. So far I haven't seen any because what you mention above is
>>> a clear bug which should be fixed. I can imagine the huge number of
>>> tasks in the group could be a problem as well but I would like to see
>>> what are those problems first.
>>>
>> In view of consistent with global oom and performance benefit, I suggest
>> we may as well open it in memcg oom as there's no obvious harm.
> I am not sure about "no obvious harm" part. The policy could be
> different in different groups e.g. and the global knob could be really
> misleading. But the question is. Is it worth having this per group? To
> be honest, I do not like the global knob either and I am not entirely
> keen on spreading it out into memcg unless there is a real use case for
> it.
>

Okay...then let's lie it on the table. We may use it as a in-house 
patch. :-)


Thanks,
Sha

>> As refer to the bug I mentioned, obviously the key solution is the above two
>> patchset, but considing other *potential* memcg oom bugs, the sysctl may
>> be a role of temporary workaround to some extent... but it's just a
>> workaround.
> We shouldn't add something like that just to workaround obvious bugs.
