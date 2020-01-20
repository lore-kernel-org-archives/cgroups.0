From: David Rientjes <rientjes@google.com>
Subject: Re: [Patch v4] mm: thp: remove the defer list related code since
 this will not happen
Date: Mon, 20 Jan 2020 13:10:56 -0800 (PST)
Message-ID: <alpine.DEB.2.21.2001201307520.259466@chino.kir.corp.google.com>
References: <20200117233836.3434-1-richardw.yang@linux.intel.com> <20200118145421.0ab96d5d9bea21a3339d52fe@linux-foundation.org> <alpine.DEB.2.21.2001181525250.27051@chino.kir.corp.google.com> <20200120072237.GA18451@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=SSadIyR7qVLBxGpfBtC2uRk5NBC+TncNZKu7gCEZ7pA=;
        b=e4c5GH3yb99tS4U3zqHkIHT5zq1PHemkzbJQ92TpbvDrMbCVfVqwabuhKEcIkWE7Bh
         sAr74tq9kNLnOcxliIkDllPWCaggxJJZHdNJcM7gieitVYuq2XQac8TrMmY8lQYtifoJ
         3QdaLVI/+OJNhSQZkv23hZAWELVCl/TWUfHLdHReQ9zLjUChBhD2GiFsjtiw9au6skhY
         eubc51eHF6ddYbcLVSGjVrF7psbbypJu8Dwzowo7/2+/6Qi2qGHcc8qzwzr9fbRFURgC
         0WwM1o+ZzL4xpJj1ZwnQdbzV5CXuKZXYVga+2FGM+yTAH2tV5ATQAvhA1SCDU3CUqqH7
         Kuvg==
In-Reply-To: <20200120072237.GA18451@dhcp22.suse.cz>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org, vdavydov.dev@gmail.com, ktkhai@virtuozzo.com, kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, alexander.duyck@gmail.com, stable@vger.kernel.org

On Mon, 20 Jan 2020, Michal Hocko wrote:

> > When migrating memcg charges of thp memory, there are two possibilities:
> > 
> >  (1) The underlying compound page is mapped by a pmd and thus does is not 
> >      on a deferred split queue (it's mapped), or
> > 
> >  (2) The compound page is not mapped by a pmd and is awaiting split on a
> >      deferred split queue.
> > 
> > The current charge migration implementation does *not* migrate charges for 
> > thp memory on the deferred split queue, it only migrates charges for pages 
> > that are mapped by a pmd.
> > 
> > Thus, to migrate charges, the underlying compound page cannot be on a 
> > deferred split queue; no list manipulation needs to be done in 
> > mem_cgroup_move_account().
> > 
> > With the current code, the underlying compound page is moved to the 
> > deferred split queue of the memcg its memory is not charged to, so 
> > susbequent reclaim will consider these pages for the wrong memcg.  Remove 
> > the deferred split queue handling in mem_cgroup_move_account() entirely.
> 
> I believe this still doesn't describe the underlying problem to the full
> extent. What happens with the page on the deferred list when it
> shouldn't be there in fact? Unless I am missing something deferred_split_scan
> will simply split that huge page. Which is a bit unfortunate but nothing
> really critical. This should be mentioned in the changelog.
> 

Are you referring to a compound page on the deferred split queue before a 
task is moved?  I'm not sure this is within the scope of Wei's patch.. 
this is simply preventing a page from being moved to the deferred split
queue of a memcg that it is not charged to.  Is there a concern about why 
this code can be removed or a suggestion on something else it should be 
doing instead?
