From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 28/48] writeback: implement and use mapping_congested()
Date: Fri, 27 Mar 2015 17:46:13 -0400
Message-ID: <20150327214613.GF638@htj.duckdns.org>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
 <1427086499-15657-29-git-send-email-tj@kernel.org>
 <20150327180626.GA19117@redhat.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=JgzG8/U+vPk++npAZ3OvEPNFsRWRwdcsZPFxK4cQFJA=;
        b=iPjNXimRtoeNPj4mImuV9w7QihorgpMrwKNqVkPQ52zKSWLtmopPv6eJnuUI6FGF1R
         nZz2Dltbo2zG/BxKHKguPVwQb9UFSirtIXS9jtgrhb2KmWZoE29s+jYLNg1uMwKAcTDU
         vC8aosIZXR+TsT6Y0S8zknyIloMjOu6I1P+Ei3k3SgngVPEpFkVCEWfrpXJl3HdnX0/I
         FdMdH5XEywQqGRopxw6HAsBdOu08xqEOTTL5yXTZlDCucWbp6/OM1MgqyN8pm1DpW9tO
         L0k1enPlngFJTBvBuGnRBcHtak7tQ/2rXR+ATWcxjdQCP507ukFVoQ/8bVN7732dvgc/
         horQ==
Content-Disposition: inline
In-Reply-To: <20150327180626.GA19117@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com

Hello, Vivek.

On Fri, Mar 27, 2015 at 02:06:26PM -0400, Vivek Goyal wrote:
...
> > +int mapping_congested(struct address_space *mapping,
> > +		      struct task_struct *task, int cong_bits)
> > +{
> > +	struct inode *inode = mapping->host;
> > +	struct backing_dev_info *bdi = inode_to_bdi(inode);
> > +	struct bdi_writeback *wb;
> > +	int ret = 0;
> > +
> > +	if (!inode || !inode_cgwb_enabled(inode))
> > +		return wb_congested(&bdi->wb, cong_bits);
> > +
> > +	rcu_read_lock();
> > +	wb = wb_find_current(bdi);
> 
> I am wondering that why do we lookup bdi_writeback using blkcg of
> task and why not use the bdi_writeback associated with inode?
> 
> IIUC, whole idea is to attach an inode to bdi_writeback (and
> change it later if need be) and that writeback is used for
> controlling IO to that inode. And blkcg associated with the
> writeback will be put in bio which in turn will be used
> by block layer.
> 
> IOW, blkcg of a bio gets decided by the bdi_writeback
> attached to inode and current writer does not seem to
> matter. So I am not sure why mapping_congested() should
> take task's blkcg into consideration instead of just
> taking bdi_writeback from inode and see if it is congested
> or not.

Yeap, I agree that attributing to the inode's blkcg makes more sense.
I need to think more about it but will prolly change it to use
inode->i_wb instead.

Thanks.

-- 
tejun
