From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] writeback, blkio: add documentation for cgroup
 writeback support
Date: Mon, 15 Jun 2015 14:23:45 -0400
Message-ID: <20150615182345.GB18517@mtj.duckdns.org>
References: <1434146254-26220-1-git-send-email-tj@kernel.org>
 <1434146254-26220-4-git-send-email-tj@kernel.org>
 <20150615172823.GA5783@redhat.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=q0vbJbV3mxQZiRgxtdj99vUMEBnJmWglKLMXQuguiKM=;
        b=ea6FqNRdaL0P56VhO9jrzvEsHgjz1UE5mUF+TKg/LliVwiQzrh8GfWUQpv7UFtwY6E
         ZCTlyIcmDeSYD4uoxMOOlNIATVt02mRc+i3XhJPjqnzoBL8bum4ALuFqjfloMFyAYcuB
         6/GKxTZ957uvX4Sh++YeZRxdoLTYmkxneUre8v+lTpH42B0ufUbU6NLb7KPbVN9HRMWu
         2Yn1dombJb3LuS8yP+qUy9jpJyVMr7BSjQMw8g1aHodsRO/VUc6HhCHzSggsGa8OYO29
         pLb0QibETZiJCu8yJEb4ecGDhqlnGNyJTFlqB9t33fIV57MIvMewc5N2H4ahT2Rea77u
         eDFA==
Content-Disposition: inline
In-Reply-To: <20150615172823.GA5783@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org

Hey, Vivek.

On Mon, Jun 15, 2015 at 01:28:23PM -0400, Vivek Goyal wrote:
> IIRC, I had run into the issues with two fsync running into two cgroups.
> One cgroup was of really small limit and other was unlimited. At that
> point of time I think conclusion was that multiple transactions could
> not make progress at the same time. So slower cgroup had blocked unlimited
> cgroup process from opening a transaction (as IO from slower group was
> stuck inside throttling later). 
>
> For some reason, in my limited testing I have not noticed it with your
> branch. May be things have changed since or I am just hazy on details.
> I will do some more testing.

On ext2, there's nothing interlocking each other.  My understanding of
ext4 is pretty limited but as long as the journal head doesn't
overwrap and gets bloked on the slow one, it should be fine, so for
most use cases, this shouldn't be a problem.

Thanks.

-- 
tejun
