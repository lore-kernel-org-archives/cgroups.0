From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH block/for-linus] block: blkg_destroy_all() should clear
 q->root_blkg and ->root_rl.blkg
Date: Tue, 8 Sep 2015 09:35:04 -0600
Message-ID: <55EF0028.30203@kernel.dk>
References: <CA+5PVA5rzQ0s4723n5rHBcxQa9t0cW8BPPBekr_9aMRoWt2aYg@mail.gmail.com>
 <20150902145307.GG22326@mtj.duckdns.org>
 <20150902153255.GH22326@mtj.duckdns.org> <20150904104602.GN29283@redhat.com>
 <20150904171302.GE25329@mtj.duckdns.org> <20150904204244.GQ29283@redhat.com>
 <20150905153439.GA18461@redhat.com> <20150905154840.GA19460@redhat.com>
 <20150905183801.GA8231@mtj.duckdns.org>
 <20150905194736.GB8231@mtj.duckdns.org>
 <20150908153132.GD13749@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150908153132.GD13749@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Jeff Moyer <jmoyer@redhat.com>, msnitzer@redhat.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, "Richard W.M. Jones" <rjones@redhat.com>

On 09/08/2015 09:31 AM, Tejun Heo wrote:
> On Sat, Sep 05, 2015 at 03:47:36PM -0400, Tejun Heo wrote:
>> While making the root blkg unconditional, ec13b1d6f0a0 ("blkcg: always
>> create the blkcg_gq for the root blkcg") removed the part which clears
>> q->root_blkg and ->root_rl.blkg during q exit.  This leaves the two
>> pointers dangling after blkg_destroy_all().  blk-throttle exit path
>> performs blkg traversals and dereferences ->root_blkg and can lead to
>> the following oops.
>
> Jens, can you please route this one w/ Richard's tested-by added?

Yup, added, thanks.

-- 
Jens Axboe
