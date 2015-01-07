From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHSET v2 block/for-next] writeback: prepare for cgroup
 writeback support
Date: Wed, 7 Jan 2015 06:19:45 -0800
Message-ID: <20150107141945.GA29680@infradead.org>
References: <1420572557-11572-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1420572557-11572-1-git-send-email-tj@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz

This needs a rebase over my "backing_dev_info cleanups" series, which
starts to sort out the bdi lifetime issues.  I think this series is
fine to go over just that, but before any bigger bdi changes we'll
also need to sort out the rest of the lifetime issues.  I have some
WIP patches for that which I'll be able to post soon.
