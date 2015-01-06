From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET RFC block/for-next] writeback: cgroup writeback support
Date: Tue, 6 Jan 2015 16:44:26 -0500
Message-ID: <20150106214426.GA24106@htj.dyndns.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=9uTAxKahJwScas1QCC8FjAW/lxqREfhJ1ToN9TDcdwQ=;
        b=V0KrGWxo/UY4Yhu1WkevFlAWtzLOFHIqu2p+Vy33b/4QM6f7Qae2yPHV2ue5xYRoZk
         JqWnj/OjDx7uRMMCGieGkATNHC1xiDEW3QB63RBKh9mVyfTzRqPDGjArr+J7iE0HFeFB
         pL5P3wyVc34TvhitqD1CfyPo9O/x+sIYoEz71YkLOC6dFaCpeRUXr2OXEtYiTJuBCLj3
         dvl8xZV4CEKdcXuMNK2xCNffwNWWlZRSY1NtbWhroEKOgWdFq9yMEaqS71x4beUuQaiq
         RoTpuQ4GjHrbOXTmjW3SQfVov9qKJhr8t+d+l3eJq97j682Y2pE+SCGKVLa+nCJh+6VD
         sjNg==
Content-Disposition: inline
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com

Hello, again.  A bit of addition.

On Tue, Jan 06, 2015 at 04:25:37PM -0500, Tejun Heo wrote:
...
> Overall design
> --------------

What's going on in this patchset is fairly straight forward.  The main
thing which is happening is that a bdi is being split into multiple
per-cgroup pieces.  Each split bdi, represented by bdi_writeback,
behaves mostly identically with how bdi behaved before.

Complications mostly arise from filesystems and inodes having to deal
with multiple split bdi's instead of one, but those are mostly
straight-forward 1:N mapping issues.  It does get tedious here and
there but doesn't complicate the overall picture.  This
straight-forwardness pays off when dealing with interaction issues
which would have been extremely hairy otherwise.  More on this while
discussing balance_dirty_pages.

...
> Missing pieces
> --------------
...
> * balance_dirty_pages currently doesn't consider the task's memcg when
>   calculating the number of dirtyable pages.  This means that tasks in
>   memcg won't have the benefit of smooth background writeback and will
>   bump into direct reclaim all the time.  This has always been like
>   this but with cgroup writeback support, this is also finally
>   fixable.  I'll work on this as the earlier part gets settled.

This has always been a really thorny issue but now that each wb
behaves as an independent writeback domain, this can be solved nicely.
Each cgroup can carry the fraction of writebandwidth against the whole
system and each task can carry its fraction against its memcg.
balance_dirty_pages can now stagger these two ratios and then apply it
against the memory which *may* be dirtyable to the task's memcg and
then throttle the dirtier accordingly.  This works out exactly as a
straight-forward extension of the global logic which is proven to
work.  This really is pieces falling into places.

Thanks.

-- 
tejun
