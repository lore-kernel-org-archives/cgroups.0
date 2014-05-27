From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Date: Tue, 27 May 2014 08:49:12 -0400
Message-ID: <20140527124912.GC10994@redhat.com>
References: <20140415135359.GA13033@redhat.com>
 <20140415140650.GI1863@htj.dyndns.org>
 <20140415141826.GB17018@redhat.com>
 <20140423170141.GJ4781@htj.dyndns.org>
 <20140423171720.GF24651@redhat.com>
 <20140423185231.GA4163@mtj.dyndns.org>
 <20140423185835.GD22755@redhat.com>
 <20140423190043.GB4163@mtj.dyndns.org>
 <20140423192108.GF22755@redhat.com>
 <20140523173957.GA31780@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140523173957.GA31780@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

On Fri, May 23, 2014 at 01:39:57PM -0400, Tejun Heo wrote:
> Hello, Vivek.
> 
> On Wed, Apr 23, 2014 at 03:21:09PM -0400, Vivek Goyal wrote:
> > What about sync/async differentiation? Throttling layer seems to flag a request sync
> > only if bio->bi_rw flag has REQ_SYNC set. While CFQ seems to consider
> > request sync if bio is either read or bio->bi_rw has REQ_SYNC flag set.
> 
> Working on this again, AFAICS, both treat REQ_SYNC the same way as far
> as stats are concerned.  If SYNC is set, it's sync; otherwise, it's
> accounted as async whether read or write.

Ok, that seems to be the case.

static inline void blkg_rwstat_add(struct blkg_rwstat *rwstat,
                                   int rw, uint64_t val)
{
        u64_stats_update_begin(&rwstat->syncp);

        if (rw & REQ_SYNC)
                rwstat->cnt[BLKG_RWSTAT_SYNC] += val;
        else
                rwstat->cnt[BLKG_RWSTAT_ASYNC] += val;

        u64_stats_update_end(&rwstat->syncp);
}


So sync will represent not policy specific interpretation of sync but
based on sync flag on request.

I guess it is fine. So far nobody seems to be complaining.

Thanks
Vivek
