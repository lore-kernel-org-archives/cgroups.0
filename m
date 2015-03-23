From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 18/18] mm: vmscan: remove memcg stalling on writeback
 pages during direct reclaim
Date: Mon, 23 Mar 2015 01:27:22 -0400
Message-ID: <20150323052722.GB8991@htj.duckdns.org>
References: <1427087267-16592-1-git-send-email-tj@kernel.org>
 <1427087267-16592-19-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=0zOEk+WtE6DHxs7HM0d3EITbpJ84MWi6PFD6UAj7ZeA=;
        b=ijQeYJWWGLYco8ESp7M/R4EJaEgUU5lSLpg81gujnAKNueqNXB51jGVqqKquAuubsc
         xozc659n/rZYen+xs9IQnXQM2uZ15FoZB3aA4JFS51yZlySjELEkTfSI2+5SIkfeOY+K
         1K8v74vsZFZNNr+6F1ujf0D3sK9msH75vSdIWLfnFRDYfbilEqWznWCFbQQG2RD9lXbA
         ogdim+pezayClBdL9hgqIJleliQPrmGb07CV1PsEwQqTgH7GP3DVHFIDOLsGEIQ3/bwQ
         pZ024PPOaYwLN1LtFPIdR/+cI1fNw0a2JRy26bgwu+DqbrcOJwNU+Ce756JFchPM8coH
         6+5A==
Content-Disposition: inline
In-Reply-To: <1427087267-16592-19-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Vladimir Davydov <vdavydov@parallels.com>

On Mon, Mar 23, 2015 at 01:07:47AM -0400, Tejun Heo wrote:
> Because writeback wasn't cgroup aware before, the usual dirty
> throttling mechanism in balance_dirty_pages() didn't work for
> processes under memcg limit.  The writeback path didn't know how much
> memory is available or how fast the dirty pages are being written out
> for a given memcg and balance_dirty_pages() didn't have any measure of
> IO back pressure for the memcg.
> 
> To work around the issue, memcg implemented an ad-hoc dirty throttling
> mechanism in the direct reclaim path by stalling on pages under
> writeback which are encountered during direct reclaim scan.  This is
> rather ugly and crude - none of the configurability, fairness, or
> bandwidth-proportional distribution of the normal path.
> 
> The previous patches implemented proper memcg aware dirty throttling
> and the ad-hoc mechanism is no longer necessary.  Remove it.

Oops, just realized that this can't be removed, at least yet.
!unified path still depends on it.  I'll update the patch to disable
these checks only on the unified hierarchy.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
