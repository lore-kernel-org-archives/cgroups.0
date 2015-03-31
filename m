From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET 1/3 v2 block/for-4.1/core] writeback: cgroup writeback
 support
Date: Tue, 31 Mar 2015 11:26:22 -0400
Message-ID: <20150331152622.GD9974@htj.duckdns.org>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=twCPchvoDI7o/EJqcn02C0doywfRSQ0ahxR5QWEhA0w=;
        b=UT1rAt7W4Jz3jaVOAhJ+j6lq6kYbaSbpDxDkJ75nuwwNN2VyLcFoYX8iX0ry8IfhIJ
         DRD4b3ujn4AzxtILsPPN4DQKZEu8qaTrjWWZfkfywO41+DEO2bGW6WWAXLTWT4B7uFke
         N80dlMgORxg4WdT4H8vt8MEcGJvHLYPwofv69J4CFSzSjL1fGb2+AsLDCZu6NeVhKxTP
         mMxfOrX5+1Q9qNoju0R1WzdFKmVIFjZcX4BwWT4gh6/LRvbebtG8tQ3OjGjO4/WAN7yn
         cSBAB7wOY+hgr/kp2cyhs6oHHyu8XRm4lOV03IpcypeLs0cIF7EdIgjwaBfRczFccBce
         8jCw==
Content-Disposition: inline
In-Reply-To: <1427086499-15657-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com

Hello, guys.

I updated all three patchsets to reflect the accumulated fixes and the
mapping_congested() change pointed out by Vivek, which BTW is now
inode_congested() - the whole function was a bit botched from
conversion from the multi-wb dirtying support, should be fine now.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-writeback-20150331
 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-writeback-backpressure-20150331
 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-writeback-switch-20150331

Jan, filesystem ppl, if you have any comments, please let me know;
otherwise, I'll post the next version of the patchset in a couple
days.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
