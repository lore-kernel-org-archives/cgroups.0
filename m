From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH block/for-linus] cgroup,writeback: don't switch wbs
 immediately on dead wbs if the memcg is dead
Date: Mon, 11 Nov 2019 17:34:37 +0100
Message-ID: <20191111163437.GC1017642@kroah.com>
References: <20191108201829.GA3728460@devbig004.ftw2.facebook.com>
 <20191111131544.GJ1396@dhcp22.suse.cz>
 <20191111161816.GA4163745@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573490082;
        bh=71g3I8FN9cKyEIsTndR2DMxU6WI8XxUlHgrraLIGuIc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RG0jimVqcUHNqvIGSi0ZuhfVzx3U/k5T+fSzVjs169asXkuXgHPGiSEIKIiu87KzV
         1NcMwuP43uXMR93i3orZiBpWHQ9idYHFO9DepuS1z/wgpebwepoiU+Sy+OJs/DSL9E
         /Pjwt2k/i97uJKWLfBa8VFDvgXgt160ihfoeIfW8=
Content-Disposition: inline
In-Reply-To: <20191111161816.GA4163745@devbig004.ftw2.facebook.com>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Dennis Zhou <dennis@kernel.org>, Michal Hocko <mhocko@kernel.org>

On Mon, Nov 11, 2019 at 08:18:16AM -0800, Tejun Heo wrote:
> Hello, Michal.
> 
> On Mon, Nov 11, 2019 at 02:15:44PM +0100, Michal Hocko wrote:
> > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > Cc: Dennis Zhou <dennis@kernel.org>
> > > Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> > > Fixes: e8a7abf5a5bd ("writeback: disassociate inodes from dying bdi_writebacks")
> > 
> > Is this a stable material?
> 
> c3aab9a0bd91 ("mm/filemap.c: don't initiate writeback if mapping has
> no dirty pages") likely addresses larger part of the problem, but yeah
> it prolly makes sense to backport both for -stable.
> 
> Greg, Sasha, can you pick the following two commits for -stable?
> 
> * c3aab9a0bd91 ("mm/filemap.c: don't initiate writeback if mapping has
>   no dirty pages")
> 
> * 65de03e25138 ("cgroup,writeback: don't switch wbs immediately on
>   dead wbs if the memcg is dead")
> 
> Both are fixes for e8a7abf5a5bd ("writeback: disassociate inodes from
> dying bdi_writebacks") - v4.2+.

Now queued up, thanks.

greg k-h
